---
layout: post
title: "sorting systemd ordering for mempool explorer"
author: niko
tags: [systemd, mempool-explorer, bitcoind, bitcoin, dependencies]
---

## The Problem

My [mempool explorer](https://github.com/mempool/mempool) would periodically lose its ability to show transactions. The symptoms were maddeningly specific: it could see blocks just fine, but the mempool itself became invisible. Restarting the mempool explorer did nothing. Restarting the Bitcoin node used by the explorer fixed it every time.

This is the kind of bug that makes you question your sanity. If restarting Bitcoin fixes it, surely the problem is in Bitcoin? But Bitcoin was working perfectly - other clients could connect to it without issue. The mempool explorer, running in Docker, simply couldn't reach it.

## The Misleading Clue

The most interesting bugs hide behind what looks like the answer. When I checked the logs, I saw connection refused errors from the mempool trying to reach `172.17.0.1:8332` - Bitcoin's RPC port on the Docker bridge network. "Aha!" I thought. "A network configuration issue."

But network issues don't fix themselves when you restart Bitcoin. That suggested something more fundamental was wrong.

## The Smoking Gun

The answer was buried in the systemd journal:

```
Nov 11 05:53:39 bitcoind[1260]: Binding RPC on address 172.17.0.1 port 8332
Nov 11 05:53:39 bitcoind[1260]: Binding RPC on address 172.17.0.1 port 8332 failed.
```

Bitcoin tried to bind to the Docker bridge IP at startup and failed. It then continued running, successfully bound to localhost and the LAN IP, but silently missing the Docker bridge binding. Three seconds later, Docker started and created the bridge network.

The race condition was subtle: Bitcoin started fractionally before Docker, tried to bind to an interface that didn't exist yet, failed gracefully, and continued operating. When I manually restarted Bitcoin later, Docker was already running, so the bind succeeded. The bug only manifested on system boot.

## The Fix

The solution is admirably simple:

```ini
[Unit]
After=docker.service
Wants=docker.service
```

Two lines in a systemd override file. `After=` ensures Bitcoin waits for Docker to start. `Wants=` expresses a preference for Docker to be running, without making it a hard requirement.

I deliberately avoided `BindsTo=` or `PartOf=`, which would create tighter coupling. Those would restart Bitcoin whenever Docker restarted, which is unnecessary - once the bind succeeds, it persists regardless of Docker's state. The problem was purely about initialization order, not runtime coupling. More at the [systemd.unit man page](https://www.freedesktop.org/software/systemd/man/systemd.unit.html).

## The Lesson

This bug exemplifies what I call "success-in-the-wrong-order" problems. Bitcoin didn't fail catastrophically when it couldn't bind to the Docker bridge - that would have been easy to diagnose. Instead, it partially succeeded, binding to two out of three interfaces, and ran happily in this degraded state.

Silent partial failures are dangerous precisely because they look like success. The application starts, health checks pass, logs show normal operation. The failure only manifests when a specific code path tries to use the missing capability.

These bugs are also challenging because they combine multiple systems (systemd, Docker, Bitcoin) in ways that aren't immediately obvious. The symptoms appeared in the mempool software, the logs pointed to network issues, but the fix required understanding how systemd manages service initialization order.

## Why This Matters

Containerization has made these race conditions more common. We now routinely run applications that depend on container runtime networking, but our init systems weren't designed with this dependency model in mind. Systemd provides the tools to handle it (`After=`, `Wants=`, `Requires=`, etc.), but you have to know they exist and understand when to use each one.

The broader lesson is about diagnostic discipline. When a problem has an easy fix (restart the service), it's tempting to treat that as the solution rather than investigating the root cause. But "restart it when it breaks" isn't actually a solution - it's a workaround that masks deeper issues and trains you to accept degraded reliability.

The fix took two lines. Finding those two lines required understanding the entire system architecture, from Docker networking to systemd service dependencies to Bitcoin's RPC binding model. That's often how it goes with interesting bugs: the fix is trivial once you truly understand the problem.
