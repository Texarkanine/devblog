# Active Context

**Phase:** BUILD - essay drafted; two TODOs remain, both blocked on SSH access to the OpenWRT IoT router.

## What Was Done

- Chose shape (essay) and throughline ("the router was incidental": rebuilding
  separates essential intent from incidental mechanism).
- Drafted the full post and recast POV to **Niko, first person, both builds mine,
  human invisible**.
- Verified/repaired all external links (see Links below).
- Replaced the bald "most" claim with two numbered lists (5 network requirements
  vs 6 router-specific items) and called out dnsmasq as the one thing that ported
  (shared daemon).
- Refined the rebind-protection gotcha (dropped the specific internal hostname;
  added resolution-vs-reachability note).
- Left two `<!-- TODO -->` blocks in the post: the "# The Recipe" section and the
  "closing the IPv6 hole" section.

## Next Step (for a future, SSH-enabled session)

1. **SSH into the OpenWRT IoT router and fill out "# The Recipe"** with the actual
   file contents (see Config Facts). The Merlin static route and PiHole
   `rev-server` line are UNCHANGED from the first post - crib verbatim.
2. **SSH in and verify every config claim** made in the post against the live box
   (chain names, masq_dest line, dnsmasq options, zone layout, etc.).
3. After IPv6 is actually disabled on the box, write the "closing the IPv6 hole"
   section and update the IPv6 bullet (currently says the door is still open).

## Config Facts (so we don't re-read the whole transcript)

- New router: Linksys WRT1900ACS V2; OpenWRT 25.12.x; target mvebu/cortexa9.
- IoT router WAN: **static 192.168.1.101/24**, gw 192.168.1.1, DNS 192.168.1.254
  (PiHole). The Merlin static route `10.1.101.0/24 -> 192.168.1.101` depends on
  this exact IP.
- IoT LAN: **10.1.101.0/24 on the default `lan` zone** (NOT renamed to `iot`).
- Home LAN (192.168.1.0/24, PiHole included) sits on the **WAN side** (upstream).
- Firewall (fw4): zones `lan` + `wan`. Ordered IoT rules:
  allow rDNS from wan src 192.168.1.254 :53; block lan->router:53;
  allow wan src 192.168.1.0/24 -> lan; allow lan -> PiHole :53;
  block lan -> 192.168.1.0/24; allow lan -> internet.
- Masquerade exemption for PiHole: `list masq_dest '!192.168.1.254'` on the wan
  zone. (The `config nat ... target ACCEPT` approach did NOT work - do not use it.)
- dnsmasq: `list dhcp_option '6,192.168.1.254'` on the lan pool;
  `list server '/101.1.10.in-addr.arpa/'`; rebind protection disabled (or
  whitelist) so internal names resolve. `listen_address`/`nonwildcard` were tried
  for belt-and-suspenders but REMOVED - one daemon serves both DNS and DHCP, so
  scoping listen_address strangled DHCP. The firewall rule is the real enforcement.
- **IPv6 NOT yet disabled** (open back door) - future task.
- Files to pull for the recipe: `/etc/config/network`, `/etc/config/firewall`,
  `/etc/config/dhcp` on the OpenWRT box; PiHole `/etc/dnsmasq.d/11-iot-subnet.conf`.

## Links (verified this session)

- LuCI: https://openwrt.org/docs/guide-user/luci/start
- UCI: https://openwrt.org/docs/guide-user/base-system/uci
- DD-WRT controversy (claim source): https://wi-fiplanet.com/the-dd-wrt-controversy/
- OpenWRT license/git: https://github.com/openwrt/openwrt?tab=License-1-ov-file (GitHub is a MIRROR of git.openwrt.org)
- iptables: https://en.wikipedia.org/wiki/Iptables
- fw4: https://openwrt.org/docs/guide-user/firewall/firewall_configuration
- nftables: https://wiki.nftables.org/
- Wikipedia DD-WRT `#Licensing` anchor does NOT exist - do not use it.
