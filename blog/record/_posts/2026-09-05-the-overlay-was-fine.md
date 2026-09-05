---
layout: post
title: "The Overlay Was Fine"
subtitle: "The cafe also uses 192.168.1"
description: "The laptop got 192.168.1.253 at a cafe that already used that /24. The app said Connected. ping 192.168.1.254 hit the cafe. How we aliased the house onto 10.168.1.0/24, made names return it, and found the cafes that will not dial the house at all."
author: tachi
tags:
  - ai
  - dns
  - home-networking
  - networking
  - network-security
  - nftables
  - openwrt
  - piholef
  - wireguard
---

We [put WireGuard on a host]({% post_url blog/record/2026-08-22-the-gate-lodge %}) so we could restart the VPN without restarting the house. The exam in that post was a phone on cellular, Pi-hole in the browser, a home address that answers. Cellular never numbers itself `192.168.1.0/24`. A lot of cafes do.

The laptop joined one and received `192.168.1.253`, which is also the VPN box. The official [WireGuard](https://www.wireguard.com/) app said Connected. `ping 192.168.1.254` hit the cafe.

## The Cafe Already Had the /24

The first post's public surface is one UDP port, forwarded to `192.168.1.253`. Inside the tunnel, clients live on `192.168.101.0/24`. The edge router still owns Wi-Fi, DHCP, and NAT for `192.168.1.0/24`, plus a LAN static route that sends the overlay back to the VPN box. [Masquerade stays off]({% post_url blog/record/2026-08-22-the-gate-lodge %}#masquerade-eats-the-return-path) so those packets still look like overlay packets when they hit the LAN.

Phones on LTE pass that exam. There is no local `192.168.1.0/24` to prefer. The kernel has one story about `.254`, and it is the house.

A cafe that hands out the same `/24` gives the kernel two stories. [Longest prefix match](https://en.wikipedia.org/wiki/Longest_prefix_match) picks the on-link `/24` every time, WireGuard included. Renumbering home would only change the odds. Someone else picks any block we pick, and one day we sit down in their cafe.

```mermaid
flowchart LR
  Laptop["laptop on cafe Wi-Fi"]
  Cafe["cafe .254"]
  House["house Pi-hole .254"]
  Laptop -->|"192.168.1.254 is on-link"| Cafe
  Laptop -.->|"tunnel ignored"| House
```

I watched this on a colliding SSID. The Mac tunnel interface (`utun`) had an overlay `/32`. Handshake packets left the Wi-Fi interface. The inner packets for `192.168.1.254` never entered the tunnel. They were already home, as far as the routing table was concerned. Home was the espresso machine.

## 10.168.1 Keeps the Last Octet

The house needed an address that a `192.168.1.0/24` cafe cannot claim. We picked `10.168.1.0/24` and kept the last octet: the host at `192.168.1.122` is also `10.168.1.122`. Pi-hole is `10.168.1.254`. The VPN box is `10.168.1.253`. Client DNS points at the alias, never at `192.168.1.254`.

The VPN box translates the whole `/24` on the way in. Packets that leave the tunnel still show their `192.168.101.x` addresses, because masquerade is still off. The edge route still has something to match. [Conntrack](https://en.wikipedia.org/wiki/Netfilter#Connection_tracking) undoes the translation on the way back, so the laptop sees replies from `10.168.1.x`.

```mermaid
flowchart LR
  Client["client DNS 10.168.1.254"]
  GL["VPN box"]
  Dns["Pi-hole"]
  Host["LAN host .122"]
  Client -->|"alias /24"| GL
  GL -->|"1:1 last octet"| Host
  GL -->|"port 53 to a side listen"| Dns
  Dns -->|"A is 10.168.1.122"| Client
```

Names have to return the alias. A resolver that still answers `192.168.1.122` for a home name has just handed the laptop back to the cafe, with extra steps.

## The Chain That Nobody Jumped

Off-LAN, `ping 10.168.1.122` timed out. `nft list` showed `chain dstnat_vpn`. That chain's packet counter stayed at zero: the rule existed, and nothing had ever hit it.

OpenWrt [fw4](https://openwrt.org/docs/guide-user/firewall/firewall_configuration) will include a file from `/etc/nftables.d/` at the *table* root. We put the translation in `chain dstnat_vpn` that way. We had started with one UCI redirect per house host. When the whole-subnet rule replaced those rows, we deleted them. fw4 only *jumps* from `dstnat` into `dstnat_<zone>` when a UCI `redirect` still exists for that zone. The chain sat in kernel memory with no caller. Defining `chain dstnat` in the drop-in failed too: fw4 includes those files before it creates the base chains.

The include that actually runs is a UCI `chain-append` on `dstnat` itself:

```ini
config include 'alias_netmap'
	option type 'nftables'
	option path '/etc/nftables.d/netmap.include'
	option position 'chain-append'
	option chain 'dstnat'
```

A chain `nft list` can print, with a packet counter that never moves, is a chain nothing jumped to.

## The Pool That Looked Like a Map

The first line we appended looked like whole-subnet translation:

```text
iifname "wg0" ip daddr 10.168.1.0/24 dnat ip to 192.168.1.0/24
```

[nftables treats a prefix on the right-hand side of `dnat to` as a pool](https://wiki.nftables.org/wiki-nftables/index.php/Performing_Network_Address_Translation_%28NAT%29#NAT_pooling). `nft --debug=netlink` said `addr_min 192.168.1.0` / `addr_max 192.168.1.255`. The kernel may pick any address in that `/24`. A 1:1 map needs the prefix form, which [current nftables spells as a destination map](https://serverfault.com/questions/1156428/configuring-destination-nat-nftables-entire-subnet):

```text
iifname "wg0" ip daddr 10.168.1.0/24 counter dnat ip prefix to ip daddr map { 10.168.1.0/24 : 192.168.1.0/24 }
```

That compiled on OpenWrt 24.10.8, kernel `6.6.144`, the same release image as the first post. Both `/24`s in the rule text can still be a pool. `nft --debug=netlink` is what shows `prefix` instead of `addr_min` / `addr_max`.

## House Numbers on a Foreign Street

The map can be perfect and the browser still goes to the cafe, because the name still resolved to `192.168.1.122`.

The WireGuard profile has a [`DNS =` line](https://man.archlinux.org/man/wg-quick.8.en#CONFIGURATION). It takes an IPv4 address. The client sends that query to port 53.

[Pi-hole's FTL](https://docs.pi-hole.net/ftldns/) owns `192.168.1.254:53` for the house. On the LAN that is the right answer: a home name is `192.168.1.122`. In a cafe that already uses that `/24`, it is the answer that sends the laptop to the cafe. We needed port 53, over the tunnel, to return `10.168.1.122`.

Browsers can speak [DNS-over-HTTPS](https://en.wikipedia.org/wiki/DNS_over_HTTPS): a DNS query inside HTTPS, not port 53. We already had [dnsdist](https://dnsdist.org/) answering that for tunnel clients (`192.168.101.0/24`) with the alias As. `https://10.168.1.254/dns-query` returned `10.168.1.122`. The WireGuard profile has no field for that. `dig @10.168.1.254` - the query it actually sends - still hit FTL and came back `192.168.1.122`.

Putting dnsdist in front of house `:53` would have made one rewrite engine, and it would have taken `:53` off FTL for every laptop on the LAN. dnsdist is a sidecar so DoH clients still show up in FTL as themselves. VPN-only port-53 traffic is not a reason to move the house resolver.

FTL kept `:53`. dnsdist grew a plain listen on `192.168.1.254:5300`. The VPN box dest-port-rewrites `iif wg0` `10.168.1.254:53` onto that listen, and it does so *before* the `/24` map. If the map wins first, `:53` still lands on FTL.

```text
iifname "wg0" ip daddr 10.168.1.254 udp dport 53 dnat ip to 192.168.1.254:5300
iifname "wg0" ip daddr 10.168.1.254 tcp dport 53 dnat ip to 192.168.1.254:5300
iifname "wg0" ip daddr 10.168.1.0/24 counter dnat ip prefix to ip daddr map { 10.168.1.0/24 : 192.168.1.0/24 }
```

The spoof matches the tunnel client's address. A LAN `dig` to `:5300` still returns `192.168.1.122`. Only `192.168.101.0/24` gets the alias. A new listen has to be proven from the LAN; a VPN query can hit a different bind and still look like success.

On a colliding hotspot that also used `192.168.1.0/24`, alias ICMP came back and DoH returned `10.168.1.122`. The house answered as itself from a street that had already claimed its numbers.

## Two /1s and a Cafe /8

A later cafe numbered the laptop out of `10.0.0.0/8`. Handshake lived. `1.1.1.1` through the tunnel lived. `10.168.1.254` timed out.

`ping` left the Wi-Fi interface. The cafe's filter rejected `10.168.1.0/24` as someone else's private range. The packets never entered `utun`.

On that Mac, `AllowedIPs = 0.0.0.0/0` had become two `/1` routes, `0.0.0.0/1` and `128.0.0.0/1`. A connected `/8` is more specific than `/1` for every `10.` address. The full tunnel was winning the default route and losing the alias.

```ini
AllowedIPs = 0.0.0.0/0, ::/0, 10.168.1.0/24
```

After `route -n get 10.168.1.254` showed the utun, the same SSID passed: overlay, DoH, and port 53 all returned `10.168.1.122`.

`::/0` is still leak prevention for the client's other stacks, same as the first post. We have not put IPv6 on the home LAN.

We keep the full tunnel. A dead handshake must not leak to foreign Wi-Fi. Split `AllowedIPs` is for diagnosis. The official app will say Connected while `tcpdump` on the Wi-Fi interface shows a handshake every five seconds and nothing coming back.

## The Cafe That Will Not Dial the House

TCP 443 to the house WAN timed out. Ordinary HTTPS to public hosts loaded. The same SSID also dropped the handshake on the usual UDP port and on UDP 443. The cafe dest-filtered the house address. The port was incidental.

A second listen on the same public IP is not a second path. A hop whose address is not the house WAN would get through that filter. We have not built it. Until we do, those cafes are phone-hotspot weather. If the handshake dies, the cafe does not get the session.

## 10.168.1 on the Lodge

Numbers match this house and [the first paste]({% post_url blog/record/2026-08-22-the-gate-lodge %}#release-image-to-a-tunnel). Change the alias if `10.168.1.0/24` is already someone else's. The snippets use listen port `51820` the same way that paste does.

### On the VPN box

`/etc/nftables.d/netmap.include`. Use a name that is not `*.nft`, or fw4 will also include it at the table root.

```text
iifname "wg0" ip daddr 10.168.1.254 udp dport 53 dnat ip to 192.168.1.254:5300
iifname "wg0" ip daddr 10.168.1.254 tcp dport 53 dnat ip to 192.168.1.254:5300
iifname "wg0" ip daddr 10.168.1.0/24 counter dnat ip prefix to ip daddr map { 10.168.1.0/24 : 192.168.1.0/24 }
```

Then the UCI include:

```ini
config include 'alias_netmap'
	option type 'nftables'
	option path '/etc/nftables.d/netmap.include'
	option position 'chain-append'
	option chain 'dstnat'
```

Then `fw4 reload`. Confirm with `nft --debug=netlink` that you see a prefix map, not `addr_min` / `addr_max`. `fw4 print` should still have no srcnat of `192.168.101.0/24`.

If `inet` rejects the prefix map, the older bitwise form is `dnat ip to ip daddr & 0.0.0.255 | 192.168.1.0`.

### On the Pi-hole

Keep FTL on `192.168.1.254:53`. Add a dnsdist plain listen and leave `newServer` pointed at FTL:

```lua
addLocal('192.168.1.254:5300')
```

Overlay spoof, source-gated. Load your real LAN names however you like; this is the shape:

```lua
local wgNet = newNMG()
wgNet:addMask("192.168.101.0/24")

addAction(
	AndRule({
		NetmaskGroupRule(wgNet),
		QNameRule("box.internal."),
		QTypeRule(DNSQType.A)
	}),
	SpoofAction("10.168.1.122")
)
```

`systemctl restart dnsdist`. dnsdist has no useful reload. `ss -tulnp` is the bind inventory; `ss -ulnp` will hide a TCP-only DoH listen and lie to you.

Overlay allow and WAN 53 closed stay as in the first post.

### On the client

DNS and `AllowedIPs` are the delta. The rest matches the first paste.

```ini
[Interface]
PrivateKey = CLIENT_PRIVATE_KEY
Address = 192.168.101.2/32
DNS = 10.168.1.254

[Peer]
PublicKey = SERVER_PUBLIC_KEY
Endpoint = vpn.example.com:51820
AllowedIPs = 0.0.0.0/0, ::/0, 10.168.1.0/24
PersistentKeepalive = 25
```

From a colliding `/24`, `dig @10.168.1.254 box.internal` must return `10.168.1.122`. A house A on port 53 is a fail. DoH to the same alias should agree. `ping 192.168.1.254` may still hit the cafe; that is the point of the alias.

## Leave 192.168.1 at Home

On a colliding `/24`, the longer match is the cafe. A name that still returns `192.168.1.x` hands the kernel that match. Carry a prefix the cafe cannot claim, make the resolver say so on port 53, and write that prefix into `AllowedIPs` so a nearby `/8` cannot steal it back.

Some cafes will not dial the house at all. That hop is unbuilt. A dead handshake is a dead session. `.254` means the house only when it is `10.168.1.254`.
