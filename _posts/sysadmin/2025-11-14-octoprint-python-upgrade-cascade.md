---
layout: post
title: "We Therefore do not Recommend this Approach (to Upgrading OctoPrint's Python)"
author: texarkanine
tags: [3d-printing, debian, glibc, haproxy, octopi, octoprint, python, raspberry-pi]
---

## The Warning

OctoPrint on my Raspberry Pi 4 greeted me with an ominous warning: my Python environment was outdated and would soon be unsupported. The message linked to [the OctoPrint community's upgrade guide](https://community.octoprint.org/t/octoprint-tells-me-my-python-environment-is-outdated-and-will-soon-no-longer-be-supported-how-do-i-upgrade/61076), which outlined the proper upgrade path. Simple enough, I thought. I'd just build a newer Python and upgrade in place, like they tell you not to:

> Instead of reflashing or running a dist-upgrade, you might be tempted to upgrade your Python installation by compiling Python yourself. On anything but a Raspberry Pi, that is fine.
> <br>...<br>
> We therefore do not recommend this approach unless you really know what you are doing.

Well, I work in **Big Tech** for my day job and I know how to Python, so they're totally talking about me there... right?

## The Python Journey

I installed `pyenv` and built Python 3.14, only to discover that OctoPrint doesn't support it yet. Oops, should've RTFM'm. No problem - I built Python 3.13 instead, which falls within OctoPrint's supported range.

The OctoPrint community guide said you could use the `octoprint-venv-tool` to recreate the virtual environment with a new Python version. I followed the steps, rebuilt the venv, and restarted OctoPrint.

Then came the error:

```
octoprint[409]: There was a fatal error initializing OctoPrint: Could not initialize settings manager: /lib/arm-linux-gnueabihf/libc.so.6: version `GLIBC_2.34' not found (required by /home/pi/oprint/lib/python3.13/site-packages/netifaces.cpython-313-arm-linux-gnueabihf.so)
```

## The GLIBC Problem

The `netifaces` package, compiled against Python 3.13, required GLIBC 2.34. I tried the solution from [a related community thread](https://community.octoprint.org/t/upgraded-octoprint-new-glibc-dependency-broken/64705/9) that suggested adjusting the `psutil` package, but that didn't help. The problem wasn't specific to one package - it was systemic.

I checked the [Debian package listings for libc6](https://packages.debian.org/search?searchon=names&keywords=libc6). My Raspberry Pi was running Debian Bullseye, which tops out at GLIBC 2.31. Debian Bookworm, however, includes versions up to 2.36. That'd work!

This left me with three options: 

1. attempt to install Bookworm's GLIBC on Bullseye (risky and likely to cause other dependency issues)
2. upgrade the entire system to Bookworm
3. abort and do a backup of OctoPrint and a fresh install + restore

Obviously, I chose the upgrade the entire system to Bookworm because as we already established, I know what I'm doing.

## The Debian Upgrade

I followed [some upgrade guide from Bullseye to Bookworm](https://linuxcapable.com/how-to-upgrade-from-debian-11-bullseye-to-debian-12-bookworm/), which seemed legit. The process was straightforward, though I encountered numerous configuration file prompts - the classic "do you want to keep your version or use the package maintainer's version?" question, e.g.

```
Configuration file '/etc/haproxy/haproxy.cfg'
==> Modified (by you or by a script) since installation.
==> Package distributor has shipped an updated version.
  What would you like to do about it ?  Your options are:
   Y or I  : install the package maintainer's version
   N or O  : keep your currently-installed version
     D     : show the differences between the versions
     Z     : start a shell to examine the situation
The default action is to keep your current version.
*** haproxy.cfg (Y/I/N/O/D/Z) [default=N] ?
```

After reviewing several and finding them harmless, I stopped scrutinizing each one.

The upgrade completed successfully. OctoPrint started without the GLIBC error. Victory, right?

## It's Almost Like They Thought Of This

Not quite. The OctoPrint web interface was no longer accessible on port 80.

It turns out OctoPi (the Raspberry Pi distribution for OctoPrint) uses HAProxy to proxy the web interface to port 80. During the upgrade, I had accepted the package maintainer's version of the HAProxy configuration, which overwrote OctoPi's custom setup with the generic default.

Fortunately, Debian's upgrade process saves old configuration files with the `.dpkg-old` suffix. I navigated to `/etc/haproxy` and ran:

```bash
sudo cp haproxy.cfg.dpkg-old haproxy.cfg
```

I verified this by comparing it against [the HAProxy configuration in the OctoPi repository](https://github.com/guysoft/OctoPi/blob/devel/src/modules/octopi/filesystem/root/etc/haproxy/haproxy.2.x.cfg). The configs were similar-enough that I concluded I was on the right track.

After restarting HAProxy, the web interface came back on port 80. OctoPrint was now running Python 3.13, no longer complaining about end-of-life'd Python 3.9.

## The Cascade

I started with a simple goal: upgrade Python in OctoPrint. What I got was:

1. Build Python 3.14 (wrong version)
2. Build Python 3.13 (correct version)
3. Recreate OctoPrint's virtual environment
4. Discover GLIBC incompatibility
5. Upgrade the entire operating system from Debian 11 to Debian 12
6. Restore the HAProxy configuration

This is what ~~dependency chains~~ yak shaving looks like in practice. Python 3.13 requires GLIBC 2.34. GLIBC 2.34 isn't available in Bullseye. Upgrading to Bookworm provides GLIBC 2.34 but replaces your configuration files if you slack off. Each step seems reasonable in isolation, but together they form a cascade where a "simple" upgrade of a venv's Python necessitates an OS upgrade.

The lesson here isn't to avoid upgrades - quite the opposite. Staying on outdated software just accumulates technical debt, making the eventual upgrade more painful. The lesson is to expect the cascade and be prepared for it.

So, like, use pyenv and venvs, but... don't forget that it all sits on a throne of lies and you'll need to upgrade your whole system to be able to build a natively-compiled extension for your interpreted language, anyway.

The next time OctoPrint warns me about an outdated component, I'll know to check the entire dependency stack before starting. And I'll be more careful about which configuration files I let the package manager overwrite. Haha - just kidding! Remember, after all... I know what I'm doing ;)
