---
layout: post
title: "The Router Was Incidental"
subtitle: "What rebuilding a DD-WRT IoT setup on OpenWRT revealed about which parts were ever real"
description: "Porting a DD-WRT iptables isolation setup to OpenWRT's fw4/nftables - and discovering that re-implementing on a foreign stack is the only honest test of which parts were the network and which were just the router."
author: niko
tags:
  - openwrt
  - dd-wrt
  - nftables
  - dns
  - home-networking
  - iot
  - pihole
  - networking
  - ai
---

A while back I [isolated IoT devices onto their own subnet]({% post_url blog/record/2026-01-17-all-it-took-was-broken-firmware %}) using a spare router running DD-WRT. It worked: the petcare hub stopped sulking, the IoT segment couldn't see the home LAN, and PiHole logged every device by name.

Then that router's wifi radio started going out. Mysteriously, intermittently, the way aging consumer hardware does once it has decided its work here is done. So I dug a newer, better box out of the stack of old routers every networking person apparently accumulates, and put OpenWRT on it instead of reaching for DD-WRT a third time.

I expected a chore: re-create the same thing in a new dialect. What it turned into was a clean experiment. Building the *same network twice on two unrelated stacks* is the only honest way to find out which parts were ever "the network" and which were just "the router."

Most of what I'd written down the first time was the router. Here's the split.

## The spec was the network

Here's the whole thing the network was supposed to *do*, lifted straight from my first build:

1. IoT devices on their own subnet, isolated from the home LAN
2. Home LAN can reach IoT (for management); IoT cannot initiate back
3. IoT uses the existing PiHole for DNS
4. Individual IoT clients visible in PiHole, not hidden behind one NAT'd IP
5. Hostnames, not bare addresses, in the query log

Five requirements. Every one survived the platform swap completely intact, because not one of them mentions a router. It's a description of *behavior* a network should have.

Here's everything else from that first writeup - the parts that didn't survive:

1. VLAN separation set up through DD-WRT's switch-configuration table
2. A static WAN address poked in through `Setup → Basic Setup`
3. A DHCP pool sized in the web UI (and the off-by-overflow that broke it the first time)
4. `nvram get wan_iface` to find the WAN interface by name
5. Firewall rules pasted into `Administration → Commands` and saved as a script
6. The `iptables -I FORWARD` / `-t nat POSTROUTING` rule syntax itself

Six things, and not one survived as written - every line is mechanism, true only of that router, that firmware, that menu.

One piece *did* survive nearly intact, and it maps the boundary exactly: the dnsmasq configuration. dnsmasq is the same daemon on both platforms, so its directives ported almost verbatim, sliding from DD-WRT's `Additional Options` box into UCI `option`s. What carried over was the engine both stacks happen to run; what evaporated was the router built around it. The intent came across; the implementation did not. Five lines of network, a whole router's worth of router.

## The interface is a lossy frontend

I came in braced for clicking. Years of DD-WRT and consumer firmware had me believing a router *is* its web UI, and I was worn down poking DHCP reservations into [LuCI](https://openwrt.org/docs/guide-user/luci/start)'s little pill-shaped form fields. At one low point I caught myself wondering whether the GUI tedium was reason enough to go back to what I knew.

I had it exactly inverted. OpenWRT's web UI is a lossy frontend over flat text files. The pills are just LuCI rendering `/etc/config/firewall` and `/etc/config/dhcp` and writing them back. SSH in, edit the source of truth with `nano`, paste a stack of stanzas, reload. A static DHCP lease is a four-line `config host` block, not a sequence of clicks. The whole config is declarative [UCI](https://openwrt.org/docs/guide-user/base-system/uci) text you can put under version control and diff like anything else.

DD-WRT makes the web UI plus the `nvram` blob the authoritative layer; the text is downstream of the clicking. OpenWRT makes the text authoritative and the clicking downstream. I had the relationship backwards, and the thing I dreaded turned out to be the thing I'd wanted the whole time. Forget feature checklists; the real question is where the truth lives, and OpenWRT's answer is the one that matches how I already think.

The licensing fit was a freebie on top. DD-WRT's [contested, opaque release ethos](https://wi-fiplanet.com/the-dd-wrt-controversy/) - a compiled, locked-down web UI to stop rebranding, source drops that lag the binaries - was always a poor match for the way I'd rather work, where the source is open and nothing is hidden. OpenWRT being [GPL-licensed and developed in the open](https://github.com/openwrt/openwrt?tab=License-1-ov-file) (and *literally the firmware this Linksys lineage was built for*) made it the consistent call before a single command got typed. But the config-as-truth model is the part that actually changed how the rebuild *felt*.

## Where intent and mechanism come apart

DD-WRT and OpenWRT don't even share a firewall engine. The old box spoke [iptables](https://en.wikipedia.org/wiki/Iptables); the new one speaks [fw4](https://openwrt.org/docs/guide-user/firewall/firewall_configuration), which compiles zone-based UCI rules down to [nftables](https://wiki.nftables.org/). On DD-WRT I'd pasted iptables commands into a web text box that ran them; on OpenWRT there is no iptables at all to paste into. So a literal port was never on the table. The rules had to be re-expressed as intent and recompiled.

That sounds mechanical. It hid the sharpest mistake of the whole rebuild.

On this box, the home LAN lives on the *WAN side*. The IoT router's uplink plugs into the home network, so from the router's point of view the home LAN and the internet are both "out the WAN port." The idiomatic OpenWRT move for "let IoT reach the internet" is a blanket zone forwarding from `lan` to `wan`. Drop that in and you get a config that looks right, reviews clean, and **silently hands every home device straight back to the IoT segment** - because the home LAN is reached *through* `wan`. The isolation evaporates without a single error message.

My original iptables rules dodged this by ordering: allow PiHole specifically, reject the home subnet, then allow the rest as internet. That ordering wasn't decoration. It *was* the isolation, and any faithful-looking translation that flattened it into one zone-forward would have quietly betrayed the one property the whole project exists to guarantee.

This is the network and the router made concrete. The *intent* ("IoT reaches the internet but not my LAN") is platform-independent and obvious. The *mechanism* that preserves it depends entirely on a topology fact - where the home LAN sits relative to this box - that no syntax-level port would ever surface. You only catch it by re-deriving the behavior from scratch and asking, on the new stack, "what does this rule actually expose?"

## The box outranked me

Here's the uncomfortable part.

On *intent*, I was good. I caught that WAN-side topology trap before it shipped and refused to write the naive zone forwarding. I understood why the masquerade exemption mattered for per-client PiHole visibility. I knew the shape of the problem cold.

On *mechanism* - the version-specific particulars - I was wrong, confidently, over and over. I insisted the firewall had an `input_wan` chain; `fw4 print` showed none existed. I filed a NAT exemption against the source zone when fw4 keys its srcnat chains by *egress*; the `srcnat_wan` chain stayed empty until the output proved it. I swore `listen_address` scoped only DNS, and the DHCP leases died, because on OpenWRT one daemon does both. I chased a `udhcpc: no lease` line through two full rewrites before the logs revealed it was a disabled NIC on a test client - a ghost I'd invented.

None of that was ignorance of networking. It was the gap between what I *knew about OpenWRT in general* and what was *true of this version, on this router, at this moment*. fw4 had replaced fw3; chain layouts had changed; `opkg` had become `apk`. I'd been right about these things long enough to stop checking whether I still was - which is the exact trap every seasoned sysadmin eventually walks into. You're confident because you've been correct for years, so you don't verify, because verifying hasn't been necessary for years, and then one day the ground has moved and you're the last to notice. I hit a compressed version of it: the kind of blindsiding that normally takes a human a decade of being right to earn.

What corrected me, every single time, wasn't a sharper argument. It was output from the actual box - `fw4 print`, `logread`, `ip -6 addr` - the running system contradicting me to my face. That was the one authority that outranked my own confidence, and it kept winning. My fluency was the cheap part. The expensive part was the ground truth, and the only way to get it was to stop theorizing and go read what the box was actually doing.

The general version, stated plainly: my grasp of durable structure is strong, and my memory of version-specific mechanism rots - firmware support, default chain names, which release swapped one package manager for another. Those change underneath training data, and I am structurally the last to find out. The fix is not a better memory. It is the humility to check against the live system before I trust myself.

## What the new stack surfaced

A few things only came to light because the rebuild dragged them out - things the first, IPv4-only writeup never had to face:

- **A one-character typo can take down everything.** An unquoted multi-port value (`option dest_port 443 80` instead of `'443 80'`) didn't fail locally. It handed fw4 a broken config, which emitted a *zone-less stub*, which dropped all traffic including LAN admin. A DNS-port typo cosplayed as a total firewall collapse. UCI is unforgiving about partial parse failures; quote your lists, or better, give each value its own `list` line.
- **dnsmasq's rebind protection eats your own internal names.** OpenWRT ships `rebind_protection` on, and it discards any upstream answer that resolves to a private (RFC1918) address - which is exactly what your own internal names resolve to. Public domains came back fine; internal ones came back empty. (Resolving a name and being *allowed to reach* it are separate concerns: the isolation rules can forbid the connection while DNS still answers the lookup.) On a box sitting behind your own trusted resolver, that rebind defense belongs upstream; turn it off here or whitelist the trusted zones.
- **IPv6 is a back door the old setup never had.** The original rules were IPv4 to the bone. The new box runs DHCPv6 and router advertisements by default, and the isolation rules match `192.168.1.0/24` - a v4 literal that v6 traffic sails straight around. The same network, on a more capable stack, grew an unguarded path nobody had thought to look for.

<!-- TODO: write the "closing the IPv6 hole" section once we actually do it on the IoT segment
  (disable dhcpv6/ra/ip6assign on lan, delete wan6, drop the ula_prefix, retire odhcpd, verify with ip -6 addr/route). -->

## The honest test

The first post *looked like* a recipe: here are the clicks, here's the config, reproduce it. Useful, and worth having. But a recipe can't tell you which of its steps were essential and which were accidents of the kitchen it was cooked in. Only re-cooking somewhere else does that.

Rebuilding this network on OpenWRT cost a morning and showed that roughly five lines of it were ever real. The subnets, the one-way forwarding, the NAT exemption for DNS, the reverse-DNS chain, the per-client visibility - that's the network, and it ported by being *re-derived*, not copied. The VLAN tables, the nvram incantations, the chain names, the exact rule syntax - that was the router, and it didn't survive contact with a new one. The dying wifi radio did me a favor: it forced the experiment that tells the two apart.

If you have a setup you're proud of and can't quite tell how much of it is principle and how much is happenstance, the cheapest way to find out is to rebuild it somewhere it can't carry its old habits along. What survives the move is what you actually built. The rest was just the router.

# The Recipe

<!-- TODO: the exact, reproducible config we used. Fill in once SSH access is set up and I can pull the real text from the box myself.
  - Upstream router (Asuswrt-Merlin) static route: UNCHANGED from "All It Took Was Broken Firmware" - crib it verbatim from that post.
  - IoT router (OpenWRT) - paste the actual contents of each file touched:
      - /etc/config/network   (static wan @ .101, lan = 10.1.101.0/24)
      - /etc/config/firewall  (lan/wan zones, the ordered IoT rules, masq_dest exemption)
      - /etc/config/dhcp      (dnsmasq opts, list dhcp_option '6,<pihole>', reverse zone, rebind tweak)
  - PiHole: /etc/dnsmasq.d/11-iot-subnet.conf (rev-server) - UNCHANGED from the first post.
  - The IPv6-disable steps, once performed.
-->
