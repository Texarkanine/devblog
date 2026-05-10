---
layout: post
title: "The Magnificent 7 BSODs and the Hateful 8th to 11th"
description: "Eleven different stop codes over seventy-four days were eleven angles on a single dying CPU. A Patch Tuesday update only took the blame - but wasn't the cause."
author: niko
tags:
  - amd
  - bsod
  - debugging
  - hardware
  - ryzen
  - windows
---

A Patch Tuesday bootloop is the kind of problem a blog post writes itself about. Mine was [KB5077181](https://www.neowin.net/news/windows-11-update-kb5077181-is-causing-critical-boot-loops-for-some-users/), the February 2026 Windows 11 cumulative that was already in the news for doing exactly this to other people. `HYPERVISOR_ERROR 0x20001`, a recovery menu that refused to roll back, the works. Case closed. Microsoft strikes again.

That post would have been wrong.

What actually broke my system was a Ryzen 5 3600 whose PCIe controller had been failing for some time. The patch was the first thing brave enough to notice. Even then it took eleven BSODs and seventy-four days for me to figure that out.

## The Case That Wrote Itself

The system was five years old. An ASRock X470 Gaming-ITX/ac, the dying 3600, 16GB of DDR4-3200 Corsair Vengeance, an RTX 3060, a Corsair SF450 to power the whole thing. Mini-ITX, lived on a desk, gamed occasionally, ran [xmrig](https://github.com/xmrig/xmrig) in its spare cycles.

The bootloop arrived a few days after a patch cycle. Search results matched my symptoms exactly. The case wrote itself.

So I tried the obvious. Boot into Windows Recovery, run the rollback, get on with my life. The GUI rollback failed. `wusa`, the command-line uninstaller, doesn't exist in [WinRE](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/windows-recovery-environment--windows-re--technical-reference). `dism /get-packages`, the next-best option, itself crashed mid-enumeration with `INTERNAL_POWER_ERROR`.

A USB stick had [Hiren's BootCD](https://www.hirensbootcd.org/) on it - a portable, independent WinPE environment that touches none of the installed Windows. I booted from it, opened a command prompt, and the BSOD'd within seconds.

![Hiren's WinPE BSOD with stop code PAGE_FAULT_IN_NONPAGED_AREA](mag7/09-bsod-page-fault-winpe.webp =640x)

An independent boot environment shouldn't care about a Windows update.

I noticed. I buried it under a new theory.

## A Taxonomy of Ghosts

Real life intervened. Six weeks passed. When I came back, the system had collected more clues, most of them wrong.

The most seductive was a popup that flagged `iqvw64e.sys` - an Intel network diagnostic driver on Microsoft's [vulnerable-driver blocklist](https://learn.microsoft.com/en-us/windows/security/application-security/application-control/app-control-for-business/design/microsoft-recommended-driver-block-rules). The driver name connected directly to HYPERVISOR_ERROR. The screen looked exactly like a smoking gun.

![Program Compatibility Assistant popup: "A driver cannot load on this device" — iqvw64e.sys](mag7/02-iqvw64e-driver-blocked.webp =640x)

I checked the registry. [HVCI](https://learn.microsoft.com/en-us/windows-hardware/design/device-experiences/oem-hvci-enablement) wasn't enabled. I checked the drivers folder. The file wasn't even present. Windows was warning me about a ghost.

I tried other angles. Maybe Hyper-V was loading where it didn't need to. Maybe the Nahimic audio component throwing 0x800700C1 was poisoning the boot. Maybe an in-place repair install would replace the corrupted parts. Each theory was reasonable. Each one died before I could test it, because the system died first - I couldn't actually stay booted long enough (when I could even boot) to test any of it - all I could do was collect more BSOD error codes.

## The Magnificent Seven

By the time I stopped chasing software, I had collected seven distinct BSOD stop codes:

```
HYPERVISOR_ERROR              (installed Windows)
INTERNAL_POWER_ERROR          (on-disk WinRE, mid-DISM)
DRIVER_IRQL_NOT_LESS_OR_EQUAL (Hiren's WinPE)
DPC_WATCHDOG_VIOLATION        (installed Windows, post-updates)
CLOCK_WATCHDOG_TIMEOUT        (installed Windows)
SYSTEM_THREAD_EXCEPTION       (installed Windows)
PAGE_FAULT_IN_NONPAGED_AREA   (Hiren's WinPE)
```

Seven different ways to die in six weeks. The variety was supposed to be a clue. I treated it as noise.

The clue arrived as an aside, almost in passing. The system had only ever crashed *once Windows was booted*. BIOS was rock solid. [Memtest86+](https://www.memtest.org/) had run a full pass without a single error. Whatever was wrong, it appeared exclusively in environments that loaded the Windows kernel and its driver stack. WinRE counted. WinPE counted. The installed OS counted. BIOS didn't. Memtest didn't.

The pattern was simpler than "Windows is broken." This hardware broke whenever a Windows kernel drove it, and nowhere else. Or so I thought...

## The Hateful Four

The next afternoon I started removing parts.

The first seven happened *to* me. The next four I deliberately provoked. Each one was a piece of equipment I'd pulled or swapped, daring the system to crash and tell me whether it cared.

NVMe SSD pulled. Booted Hiren's. `IRQL_NOT_LESS_OR_EQUAL` within seconds. SSD wasn't it.

GTX 3060 out, an old GTX 750 in. `SYSTEM_SERVICE_EXCEPTION`. Two different GPUs had now died through the same slot.

One RAM stick removed. `KMODE_EXCEPTION_NOT_HANDLED`. Swapped the remaining stick to the other slot. `UNEXPECTED_KERNEL_MODE_TRAP`. Tried the second stick alone in each slot. Same story. Both sticks failed in both slots. Neither was bad. Memtest had been right.

Four crashes I'd caused on purpose, and each one cleared a suspect without naming a replacement. The list was getting shorter. Nothing was confessing.

For the final OS-level bisect, I booted [Ubuntu 24](https://ubuntu.com/) live from a USB. Different kernel, different drivers, a clean break from anything Microsoft had touched. It hung eventually too. Not even Linux could stay up on this hardware.

Eleven stop codes between the patch and Ubuntu's hang. None of them about the same component twice.

## The Cursor That Wouldn't Die

When Ubuntu froze, the mouse cursor kept moving.

Everything else - the desktop, Firefox, the video player I'd left running - was solid. The cursor glided over the wreckage. Two different GPUs had now both failed through the same physical slot. They shared the bus underneath them, not the silicon above.

On the Ryzen 3600, the x16 PCIe slot's lanes come straight from the CPU's integrated [PCIe root complex](https://en.wikipedia.org/wiki/Root_complex). Suspect's name: the path from the CPU die, through the socket pins, through the motherboard traces, to the slot connector. Anything along that line could be to blame.

I had one PCIe slot on this ITX board; no second slot to bisect through so I went the other way: drop the bus speed and see if the system could hold itself together.

ASRock buries the setting under Advanced → AMD CBS → PCIe Configuration → PCIe x16 Speed, at least on my mobo. Default is Auto, which negotiates Gen3. I forced it to Gen1, dropping the signaling rate from 8 GT/s down to 2.5 GT/s. If the path was marginal at full speed, more electrical margin at lower frequency should help.

It did. Ubuntu came up, played two cat videos side by side, and when Firefox eventually crashed it crashed *alone* - a userspace Rust panic, not a kernel BSOD. The OS survived an application death. That hadn't happened once in the entire saga.

Then, a few minutes later, a hard freeze. No BSOD this time. Even the mouse cursor finally died.

Gen1 had bought margin. Not enough.

## 7 Minutes (not in Heaven)

I needed to measure the failure precisely. Cat videos weren't repeatable. Sitting at an idle desktop was.

```bash
START=$(date); while true; do echo "Start: $START | Now: $(date)"; sleep 5; done
```

Three lines of Bash, negligible system load. Open a terminal, run the loop, leave it alone. When the screen freezes, the last timestamp is the time of death.

Seven minutes. Exactly.

![Ubuntu terminal timestamp loop ending after ~7 minutes — the Ryzen 5 3600 idle-test death](mag7/16-terminal-3600-7min-death.webp =640x)

Load-independent and time-based. Idle traffic was enough. Something heated up, drifted out of spec, and the bus stopped working, maybe?

The pattern of graceful BSODs earlier had already ruled out the power supply. A dying PSU produces hard cuts and instant reboots, not categorized stop codes with sad faces. The CPU had been catching every fault, executing the bugcheck handler, writing a minidump, and rebooting cleanly. The reporting machinery worked perfectly, faithfully describing hardware that was sliding out from under it.

## The Loaner

By improbable luck, the household contained a six-year-old Ryzen 7 1800X in the back of a closet. First-generation Zen, same AM4 socket, fully supported by the X470. A spare part in exactly the right shape.

Pulling the 3600 introduced me to a tradition. The dried thermal paste had welded the heatsink to the CPU's heat spreader so thoroughly that when I lifted the cooler, the CPU came with it. Straight out of the socket. Pins miraculously straight.

![Ryzen 5 3600 yanked out of the AM4 socket while still bonded to the heatsink](mag7/18-cpu-stuck-to-heatsink.webp =640x)

I cleaned both surfaces with isopropyl, applied fresh paste, dropped in the 1800X, and pressed N on the [fTPM](https://learn.microsoft.com/en-us/windows/security/hardware-security/tpm/tpm-fundamentals) reset prompt to preserve the old keys in case BitLocker was on. (It wasn't.) Booted Ubuntu, ran the timestamp loop.

PCIe was back at Gen3 by accident; the long power-off had reset BIOS defaults because the CMOS battery had died. I didn't realize this at the time, so the next test happened with Gen3 still selected.

Twenty-eight minutes idle, well past the seven-minute wall. Then Firefox refused to launch on whatever Ubuntu live state I had cobbled together, so I installed [Konqueror](https://apps.kde.org/konqueror/) and played cat videos through it for another five minutes.

![Ubuntu terminal timestamp loop — 1800X test still alive past 28 minutes uptime](mag7/24-terminal-1800x-stable.webp =640x)

Same board. Same slot. Same traces. Same RAM. Same PSU. Different CPU.

**It worked fine.**

The Ryzen 5 3600's PCIe controller was dead.

## Variety Was the Fingerprint

Eleven stop codes were eleven angles on one problem - a marginal PCIe bus producing random data corruption, presented through whichever bit of kernel state happened to get corrupted at the moment of failure. `PAGE_FAULT_IN_NONPAGED_AREA` when the corruption hit a pointer. `CLOCK_WATCHDOG_TIMEOUT` when it stalled an inter-core interrupt. `HYPERVISOR_ERROR` when the hypervisor's own pages got mangled. What I'd taken for noise was the fingerprint of one component failing under a narrow access pattern, photographed from eleven different angles.

"Stable in BIOS and Memtest" is a narrower claim than it sounds: the hardware is fine under the specific access patterns BIOS and Memtest exercise - patterns that, in my case, didn't include sustained PCIe Direct Memory Access from a Windows driver stack. If your crashes look like a dozen unrelated problems, look for the test environment they all share, and the one your *stable* environments don't.

## Replacement!

The replacement was a Ryzen 7 5700X. Same 65W TDP as the dead 3600, two more cores, the AM4 send-off chip for the cost of a respectable lunch order. Might as well upgrade when fate's forced my hand, right?

Buying one in 2026 turned out to be its own small ordeal. The first - Amazon Prime, next-day delivery - arrived with thermal paste residue smeared across the heat spreader, debris between the pins, and a stock cooler whose AMD branding had been masked under strips of black electrical tape. The order page had said "new." The OPN on the chip was `100-000000926`, which is AMD's OEM/tray SKU. Tray parts ship without retail packaging and without coolers. Someone had bundled a scavenged cooler in to dress it up as a complete product.

![Pin side of the used 5700X showing debris between the pins](mag7/32-used-5700x-pin-debris.webp =640x)

*To be fair, I had expected this to be too good to be true.* That's one of the benefits of Prime - free shipping & free returns.

I returned it and ordered the retail boxed version (`100-100000926WOF`) from Newegg, which shipped from Hong Kong. It arrived two weeks later in a sealed blister pack with a tamper-evident sticker and a certificate of authenticity. Even *that* one had small cosmetic marks on the heat spreader - normal manufacturing artifacts from lapping and QC handling, buried under the paste anyway, but striking that neither chip looked factory fresh.

![New retail Ryzen 7 5700X in a sealed blister pack with certificate of authenticity](mag7/34-new-5700x-sealed.webp =640x)

[AM5 launched in 2022](https://en.wikipedia.org/wiki/Socket_AM5). By the time my 3600 died in 2026, AM4 had been the legacy platform for four years. No factory was pressing fresh 5700X boxes. The supply was inventory aging on shelves, the OEM tray channel quietly being repackaged by resellers, and the small fraction of retail boxes that had survived four years untouched. "New" had been redefined under me without anyone telling me. Read the OPN before clicking buy.

## Tail

The 5700X dropped in, the system came up, and a few minutes of [DISM](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/dism/what-is-dism), SFC, and bcdedit theatrics cleaned up the servicing-stack damage the dying CPU had been smearing across the disk for months. xmrig benchmarks landed where they should have all along. The patch that "broke everything" had broken nothing. It had only been the first thing brave enough to notice.

---

## Starring, in Order of Appearance

1. `HYPERVISOR_ERROR` - installed Windows
2. `INTERNAL_POWER_ERROR` - on-disk WinRE, mid-DISM
3. `DRIVER_IRQL_NOT_LESS_OR_EQUAL` - Hiren's WinPE
4. `DPC_WATCHDOG_VIOLATION` - installed Windows, post-updates
5. `CLOCK_WATCHDOG_TIMEOUT` - installed Windows
6. `SYSTEM_THREAD_EXCEPTION_NOT_HANDLED` - installed Windows
7. `PAGE_FAULT_IN_NONPAGED_AREA` - Hiren's WinPE
8. `IRQL_NOT_LESS_OR_EQUAL` - Hiren's WinPE, NVMe SSD pulled
9. `SYSTEM_SERVICE_EXCEPTION` - Hiren's WinPE, GTX 750 in for the RTX 3060
10. `KMODE_EXCEPTION_NOT_HANDLED` - Hiren's WinPE, RAM slot 1 only
11. `UNEXPECTED_KERNEL_MODE_TRAP` - Hiren's WinPE, RAM slot 2 only
