---
layout: garden
title: "A History of the 'ls' command"
tags:
  - history
  - ls
  - unix
---

Inspired by the question: "Who wrote `ls`?"

TL;DR

{%linkcard
	https://www.linuxdoc.org/LDP/LG/issue48/fischer.html
	"A Brief History of the 'ls' command"
	archive:https://web.archive.org/web/20251219000000/https://www.linuxdoc.org/LDP/LG/issue48/fischer.html
%}

## The Primal Act of Digital Orientation

In the vast, intangible geography of the digital universe, the act of orientation is paramount. Before a user can manipulate data, execute a program, or modify a system, they must first understand their location and their surroundings. In the command-line interface (CLI) paradigm, which has dominated computing for over half a century, the primary instrument of this orientation is the command `ls`.

The utility `ls` (an abbreviation for "list"), serves a function analogous to the visual scan of a physical room. It enumerates the contents of a directory, revealing the names, attributes, and hierarchies of the file system. While it appears deceptively simple - a mere printing of strings - the history of `ls` is a microcosm of the history of the operating system itself. Its evolution tracks the migration from batch processing to time-sharing, from 18-bit minicomputers to 64-bit cloud instances, and from the paper-based [teletype](https://en.wikipedia.org/wiki/Teleprinter) to the high-resolution graphical terminal emulator.

Answering the question of the authorship of the first instance of the `ls` utility necessitates a bifurcated answer, separating the *conceptual* origin from the *genetic* origin of the modern tool. While the concept of listing files predates the Unix operating system, having roots in the [Compatible Time-Sharing System (CTSS)](https://en.wikipedia.org/wiki/Compatible_Time-Sharing_System) at MIT, the specific utility named `ls` that sits in the /bin directory of billions of devices today was forged in the laboratories of the [Bell System](https://en.wikipedia.org/wiki/Bell_System).

The first instance of the Unix `ls` utility was written by [Ken Thompson](https://en.wikipedia.org/wiki/Ken_Thompson) in the summer of 1969 at [Bell Labs](https://en.wikipedia.org/wiki/Bell_Labs) in Murray Hill, New Jersey. However, this assertion is layered with complexity. Thompson did not invent the name `ls` - he inherited it from the [Multics](https://en.wikipedia.org/wiki/Multics) project, specifically from a naming convention established by Don Widrig[^4]. Nor did he invent the functionality; that credit belongs to the developers of CTSS and their [`listf` command](https://www.linuxdoc.org/LDP/LG/issue48/fischer.html).

## The Pre-Unix Era: The Genesis of Interactive Listing

To understand the birth of `ls`, one must first understand the world that existed before it. In the early days of computing, the "file system" was physical. Data existed on punch cards or magnetic tapes that were mounted and dismounted by operators. The programmer did not "list" files; they walked over to a cabinet and looked at the labels on card decks.

The transition to **Time-Sharing** - the ability for multiple users to access a computer simultaneously and interactively - necessitated a virtual abstraction of storage. If users were not physically present to handle their card decks, the computer had to manage data retention on their behalf. This gave rise to the "file," and consequently, the need to list those files.

### The Compatible Time-Sharing System (CTSS)

The spiritual ancestor of `ls` lies in the Compatible Time-Sharing System (CTSS), developed at the MIT Computation Center. Operational by 1961, CTSS was the first system to demonstrate the viability of general-purpose time-sharing. It ran on an [IBM 7094 mainframe](https://en.wikipedia.org/wiki/IBM_7090#IBM_7094)[^5], a machine that dominated scientific computing in the early 1960s.

In this environment, the command `listf` (List Files) was born. Historical records indicate that `listf` was available to CTSS users by July 1961. This utility is the cladistic ancestor of `ls`. It performed the exact same core function: querying the system's master file directory and printing the entries associated with the current user.

#### The Syntax of `listf`

The syntax of CTSS commands reflected the era's lack of standardized abbreviation. Commands were often full words, and arguments were parsed in a manner that would seem alien to a modern Unix user. By 1963, the `listf` command had matured into a versatile tool with several options that prefigure the flags of `ls`.

| CTSS Command | Function | Modern `ls` Equivalent |
| :---- | :---- | :---- |
| `listf` | List files, newest first | `ls -t` |
| `listf` rev | List files, oldest first | `ls -tr` |
| `listf` (long) | List in long format (metadata) | `ls -l` |
| `listf` (srec) | List by size (records) | `ls -S` |
| `listf` (smad) | List by date of last modification | `ls -t` |
| `listf` (auth) user | List files created by a specific user | `ls -l (filtered)` |

The existence of `listf` (long) is particularly significant. It demonstrates that the distinction between a "simple" list (names only) and a "rich" list (names plus metadata) was established almost a decade before [Unix V1](https://gunkies.org/wiki/UNIX_First_Edition)[^11].

#### Authorship of `listf`

The authorship of `listf` is collective, attributed to the staff of the MIT Computation Center.[^5] Key figures in the development of CTSS included [Fernando Corbató](https://en.wikipedia.org/wiki/Fernando_J._Corbat%C3%B3) (the project lead), [Robert Fano](https://en.wikipedia.org/wiki/Robert_Fano), and [Jerome Saltzer](https://en.wikipedia.org/wiki/Jerry_Saltzer). While it is difficult to pinpoint the specific individual who typed the first assembly instruction for `listf`, the conceptual framework was laid by this team.

### The Multics Project: Complexity and Naming

CTSS was a resounding success, but it was a retrofit on existing hardware. Its successor, **Multics** (Multiplexed Information and Computing Service), was designed from a blank slate to be the ultimate computing utility. Started in 1964 as a collaboration between MIT, General Electric, and Bell Labs, Multics aimed to provide continuous, reliable computing to a massive user base.

It is in the [Multics project](https://en.wikipedia.org/wiki/Multics) that the string "ls" first appears as a command name.

#### The Invention of Short Names

Multics was an ambitious, high-level system written primarily in [PL/I](https://en.wikipedia.org/wiki/PL/I) (Programming Language One). It introduced a hierarchical file system, segments, and rings of protection. It also introduced a command language that sought to balance descriptiveness with efficiency. The command to list directory contents in Multics was named `list`. However, Multics designers recognized that typing list repeatedly was inefficient for expert users. The system introduced a standardized facility for command abbreviations. The convention for these short names - taking the initial letter of the command words - is attributed to Don Widrig, a key developer on the project. As the [Multics glossary entry on "additional names"](https://multicians.org/mga.html) notes:

> The original convention for short names, 'initial letter of each word in a command, augmented by succeeding consonants for a one-word command,' is attributed to Don Widrig.

Under this convention:

* `list` was abbreviated to `ls`.
* `copy` was abbreviated to `cp`.
* `move` was abbreviated to `mv`.
* `rename` was abbreviated to `rn`.

This decision was driven by the ergonomics of the teletype. The standard interface for Multics (and later Unix) was the Teletype [Model 37](https://en.wikipedia.org/wiki/Teletype_Model_37) or [Model 33](https://en.wikipedia.org/wiki/Teletype_Model_33). These devices were mechanical typewriters that communicated over phone lines. They were loud, slow (~10 characters per second), and required significant physical force to actuate the keys. Every character saved was not just a time optimization; it was a physical labor optimization.

> ...But is the attribution to Don Widrig correct? See [Appendix B: Don Widrig & Short Names](#appendix-b-don-widrig--short-names)

#### The Multics `list` Implementation

The Multics `list` command was significantly more complex than its CTSS predecessor. It had to navigate the Multics storage system hierarchy, handling Access Control Lists (ACLs), segments, and the concept of the "working directory" which could be changed via the `change_wdir` or `cwd` command.[^6]
The authorship of the Multics list command and the associated file system utilities involved researchers who would later become legends of computing, including Ken Thompson.[^7] They used the system, wrote code for it, and internalized its design philosophies - both the ones they liked (the hierarchical file system, the shell) and the ones they disliked (the complexity, the PL/I overhead).
When Bell Labs withdrew from the Multics project in 1969, citing the project's slow progress and high costs, Thompson and Ritchie left with a clear mental model of what a file system *should* look like, and a clear preference for the short command names `ls`, `cp`, and `mv`.

## The Unix Genesis: Bell Labs, 1969

The withdrawal from Multics created a vacuum. Ken Thompson, [Dennis Ritchie](https://en.wikipedia.org/wiki/Dennis_Ritchie), and fellow researchers like [Doug McIlroy](https://en.wikipedia.org/wiki/Douglas_McIlroy) and [Joe Ossanna](https://en.wikipedia.org/wiki/Joe_Ossanna) found themselves back in the Bell Labs Computing Science Research Center with no interactive time-sharing system. They were relegated to the [GECOS batch system on a GE-635](https://www.multicians.org/ge635.html), a significant regression in their workflow.
This deprivation was the catalyst for Unix.

### The Hardware: The PDP-7

The machine that hosted the first true `ls` utility was a [Digital Equipment Corporation](https://en.wikipedia.org/wiki/Digital_Equipment_Corporation) (DEC) [**PDP-7**](https://en.wikipedia.org/wiki/PDP-7). This machine was already obsolete by 1969 standards. It had a word size of 18 bits and a memory of 8K words (roughly 14.4 kilobytes). It lacked the hardware memory management unit required for true Multics-style time-sharing, but it had a decent display processor.

### The Motivation: Space Travel

The proximate cause for the development of the system was a game called *Space Travel*. Thompson had written it on the GE mainframe, but it was expensive to run and the "jerky" performance of the time-sharing system made the simulation poor.[^3]
Thompson found an "little-used" PDP-7 and set about porting the game. To do this, he needed a development environment. He wrote a floating-point package (found in the source listings as fops), an assembler, and eventually, a kernel to manage the hardware resources.

### The Authorship: Ken Thompson

The historical record is unanimous: **Ken Thompson** wrote the core of the PDP-7 operating system, including the file system and the initial set of utilities, during the summer of 1969.
Dennis Ritchie, in his retrospective "The Evolution of the Unix Time-sharing System"[^3] states: 

> Thompson... began implementing the paper file system... Then came a small set of user-level utilities: the means to copy, print, delete, and edit files"

While Ritchie was a close collaborator, contributing to the assembler and later the C language, the initial implementation of the file system tools on the PDP-7 was Thompson's work. The source code recovered from this era bears the distinct fingerprints of Thompson's coding style - terse, efficient assembly language.

### The "First" `ls`: Technical Analysis

In 2016, and supplemented by a further discovery in 2019, notebooks containing the printed source code of the PDP-7 Unix system were found. These listings, scanned and analyzed by the Unix Heritage Society (TUHS), provide the "ground truth" for the first `ls`.
The file is typically identified in the reconstruction as `ls.s`[^1] (the `.s` suffix denoting assembly source).

{%linkcard
	https://github.com/DoctorWkt/pdp7-unix/blob/master/src/cmd/ls.s
	"ls.s" on GitHub
	archive:none
%}

#### Implementation Details

The PDP-7 `ls` was written in PDP-7 assembly. The logic was radically simple compared to the Multics PL/I implementation.

- **System Calls:** The code utilized the primitive system calls of the PDP-7 kernel. It didn't have the high-level opendir / readdir abstraction we have today. Instead, it opened the directory as a file.
- **Directory Structure:** In this early version of Unix, a directory was a special file containing a sequence of fixed-length entries. Each entry consisted of:
	* 2 bytes: The inode number (index node).
	* 14 bytes: The filename.
- **The Loop:** The `ls` utility would:
	* open the directory (often . or the argument provided).
	* read 16 bytes into a buffer.
	* Check if the inode number was zero. (A zero inode indicated a deleted file slot).
	* If non-zero, it printed the 14-byte filename to the standard output (the teletype).
	* Repeat until End-of-File (EOF).

#### The "Dot" Problem

One of the most fascinating insights from the restoration of the PDP-7 Unix is the handling of the current directory. The early file system did not automatically create the `.` (current) and `..` (parent) entries in new directories.
To make `ls` work without arguments (listing the current directory), the user (Thompson) had to manually create a link named . pointing to the directory itself. The command sequence, reconstructed by the project team, involved using the link command ln to create these navigation anchors.
Eventually, mk (the predecessor to mkdir) was updated to create these entries automatically. However, this created a new problem: `ls` would list `.` and `..` in every single directory, clogging the output. This led to the introduction of the check to skip files starting with a dot, which inadvertently gave rise to "hidden files" (dotfiles) in Unix.

## The First Edition (V1): The Canonical Unix `ls` (1971)

While the PDP-7 version was the *first*, it was never released to the public. The first version of Unix to be formally documented and installed on other machines was the [**First Edition (V1)**](https://gunkies.org/wiki/UNIX_First_Edition), running on the [**PDP-11**](https://en.wikipedia.org/wiki/PDP-11).
By 1971, the system had been ported to the PDP-11/20, a 16-bit minicomputer. The [V1 Programmer's Manual](https://www.nokia.com/bell-labs/about/dennis-m-ritchie/1stEdman.html), dated November 3, 1971, provides the first public citation for `ls`, and attributes it to Dennis Ritchie (`dmr`) and Ken Thompson (`ken`):

{% polaroid
	ls-in-unix-v1-manual.jpg
	link="https://www.nokia.com/bell-labs/about/dennis-m-ritchie/pdfs/man12.pdf"
	title="V1 Programmer's Manual - Commands (man12.pdf)"
	archive:none
%}

### The Manual Entry

The V1 manual page for `ls` is a model of technical brevity.
The document confirms the existence of the core flags that define `ls` usage today:

* `-l`: Long format. It listed the mode, number of links, owner, size, and time.
* `-t`: Sort by time modified.
* `-a`: List all entries, including those starting with `..`
* `-s`: Give size in blocks.

### The Implementation in Assembly

Like its PDP-7 predecessor, the [V1 `ls` was written in assembly language](https://gunkies.org/wiki/UNIX_First_Edition). The PDP-11 architecture was byte-addressable and little-endian, which influenced how `ls` handled the directory data structures.

## The Great Rewrite: C and Portability (1973)

The next major evolutionary leap for `ls` occurred in 1973 with [**Version 4 Unix**](https://gunkies.org/wiki/UNIX_Fourth_Edition). This was the version where the kernel and utilities were rewritten in the **C programming language**. This rewrite was transformative. `ls` ceased to be a PDP-specific assembly program and became a portable C program.

### The `struct direct`

In C, the directory entry was defined as a structure, typically found in [sys/dir.h](https://www.tuhs.org/cgi-bin/utree.pl?file=V7/usr/include/sys/dir.h):

```c
struct	direct
{
	ino_t	d_ino;
	char	d_name[DIRSIZ];
};
```

The C implementation of `ls` used the standard I/O library (stdio) or low-level read calls to iterate over these structures. This decoupled the utility from the hardware.

### Authorship Continuity

Ken Thompson remained the primary architect of these core utilities during the V4-V6 era. While the C language was Ritchie's creation,[^8] the application of C to system utilities was a collaborative effort driven by Thompson's desire to make the system self-hosting and portable.

## Divergence: The BSD vs. System V Schism

As Unix escaped the labs and spread to universities, specifically the University of California, Berkeley, the `ls` command underwent a fork that effectively split the Unix world into two camps: [**BSD**](https://en.wikipedia.org/wiki/Berkeley_Software_Distribution) (Berkeley Software Distribution) and [**System V**](https://en.wikipedia.org/wiki/UNIX_System_V) (AT&T).

### The Screen Real Estate Problem

In the late 1970s, universities began replacing teletypes with video terminals. These screens had limited height but substantial width. The traditional `ls` output - one file per line - was inefficient on these screens.
In May and August 1977, [Bill Joy](https://en.wikipedia.org/wiki/Bill_Joy) made modifications to `ls` at the University of California, Berkeley, which he subsequently distributed as part of the First Berkeley Software Distribution (1BSD).

> ... Or Did He? See [Appendix A: Bill Joy & Multi-Column `ls`](#appendix-a-bill-joy--multi-column-ls)

The most dramatic difference with this version of `ls` was that it listed files in multiple columns rather than only listing one name per line. This allowed users to see dozens of files at once without scrolling.

* **BSD ls:** Defaulted to multi-column output if the output was a terminal (`isatty()`).
* **System V ls:** Stuck to the traditional single-column format for longer, requiring a flag (often `-C`) to enable columns.

### Flag Inflation

During this period, the number of flags supported by `ls` exploded.

* **Recursive Listing (`-R`):** Added to allow traversing subdirectories.
* **File Type Indicators (`-F`):** BSD introduced the `-F` flag,[^9] which appended characters to filenames to indicate their type (`/` for directories, `*` for executables).

## The Modern Era: GNU `ls` and Linux

The `ls` command most users interact with today is neither the original Thompson assembly code nor the BSD C code. It is the [**GNU coreutils**](https://www.gnu.org/software/coreutils/) version, running on [Linux](https://en.wikipedia.org/wiki/Linux).

### The GNU Project

In the mid-1980s, [Richard Stallman](https://stallman.org/) launched the [GNU Project](https://www.gnu.org/) to create a free Unix-compatible operating system. Because the original Unix source code was proprietary (owned by AT&T), GNU could not use it. They had to rewrite every utility from scratch.
The GNU version of `ls` was written primarily by Richard Stallman and David MacKenzie.[^10]

### Features of GNU ls

GNU `ls` introduced several features that are now standard in the Linux world but were controversial or absent in traditional Unix:

* **Color (`--color`):** GNU `ls` can colorize output based on file type and extension.
* **Long Options:** GNU introduced double-dash options (e.g., `--all`).
* **Human Readable Sizes (`-h`):** Displaying sizes in KB, MB, GB rather than bytes or blocks.

## Detailed Comparison of Historical Implementations

To visualize the evolution of the utility, we can compare the feature sets across the eras.

| Feature | 1963<br>CTSS listf | 1967<br>Multics list | 1969<br>Unix PDP-7 ls | 1971<br>Unix V1 ls | c. 1980<br>BSD ls | Modern<br>GNU ls |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- |
| **Command Name** | listf | list (alias ls) | ls | ls | ls | ls |
| **Default View** | List (sorted new) | List | List | List | Columns | Columns/Color |
| **Long View** | (long) | -long | N/A | -l | -l | -l |
| **Hidden Files** | No | No | No | -a | -a | -a / -A |
| **Sort by Time** | (smad) | -dtm | N/A | -t | -t | -t |
| **Sort Reverse** | (rev) | -reverse | N/A | (Manual) | -r | -r |
| **Recursion** | No | (via walk) | No | No | -R | -R |
| **Primary Author** | MIT Staff | Project MAC | Ken Thompson | Ken Thompson | Bill Joy et al. | Stallman/MacKenzie |
| **Language** | MAD/Asm | PL/I | PDP-7 Asm | PDP-11 Asm | C | C |

## Insights and Implications

### The Persistence of the "Teletype Mindset"

The most profound insight from the history of `ls` is how constraints of the 1960s dictate the workflow of the 2020s. We still use `ls` (2 characters) instead of list because the early Unix developers worked on teletypes - the standard interactive device on the earliest timesharing systems was the ASR-33 teletype[^12], a slow, noisy device that printed upper-case-only on big rolls of yellow paper. These devices were heavy, stiff, and slow. Listing a directory with `ls` instead of list saved three keystrokes. Over a million invocations, those keystrokes add up to days of human life. This "worse is better" or "minimalist" philosophy is the genetic code of Unix.

### The "Everything is a File" Abstraction

The evolution of `ls` mirrors the evolution of the Unix abstraction "Everything is a file." In PDP-7 Unix, `ls` read the directory *as a file*. It didn't need a special API because the directory was just data on the disk. While modern filesystems are complex databases that require readdir calls, the mental model provided by `ls` remains the flat file list.

## Conclusion

The answer to the question is both singular and plural.

**The Singular Answer:**

> The first instance of the Unix `ls` CLI utility was written by Ken Thompson in Murray Hill, New Jersey, in 1969. It was written in assembly language for the DEC PDP-7 to facilitate the development of the operating system that would host the game Space Travel.

**The Plural Context:**

* **The Name:** The name `ls` was adopted from the Multics operating system, where **Don Widrig** established the convention of two-letter abbreviations (`ls`, `cp`, `mv`).
* **The Concept:** The functionality of listing files interactively originated with the `listf` command at MIT (circa 1961).
* **The Modern Tool:** The version of `ls` used by most people today (on Linux) is the **GNU** version, authored by Richard Stallman and David MacKenzie.

The `ls` command is a [palimpsest](https://en.wikipedia.org/wiki/Palimpsest) - a manuscript written over previous manuscripts. Beneath the color output of a modern Linux terminal lies the columnation of the BSD hackers, beneath that lies the C structure of Version 4, beneath that the assembly logic of Version 1, and at the very bottom, the keystrokes of Ken Thompson on a PDP-7 teletype, trying to save a few milliseconds of typing in a hot summer in New Jersey... himself recalling the progenitorial `listf` that first appeared some seven years earlier on the CTSS at MIT.


## Appendix A: Bill Joy & Multi-Column `ls`

It was claimed earlier in this document:

> In May and August 1977, [Bill Joy](https://en.wikipedia.org/wiki/Bill_Joy) made modifications to `ls` at the University of California, Berkeley, which he subsequently distributed as part of the First Berkeley Software Distribution (1BSD). The most dramatic difference with this version of `ls` was that it listed files in multiple columns rather than only listing one name per line. 

A minor claim... but, is it true? The Bill Joy attribution is bandied about in blog posts and forum comments, but authoritative sources on who actually added the multi-column capability to `ls` are hard to come by.

The original `Brief history of the 'ls' command` article by [Eric Fischer](https://github.com/e-n-f) the closest to an authoritative source: the host publication - the "[Linux Documentation Project](https://www.linuxdoc.org/)" - is authoritative-enough but the author's provenance isn't easily established. It appears that Fischer was just an enthusiast - it isn't clear how much, if any, of the knowledge is first-hand.

Most of the other "sources," if they attribute their knowledge to anything, attribute it to that article.

So, then, is the attribution of columnns to Bill Joy pure heresay? Technically yes, but I think it's a plausible attribution.

> Bill Joy, acting as distribution secretary, sent out about 30 "free" copies of BSD in 1978. But the arrival of a few ADM-3a terminals with
> addressable cursors made it possible for him to create vi (visual editor).
> But this led him to something else: optimizing code for several different types of terminals. Joy decided to consolidate screen management
> by using an interpreter to redraw the screen. The interpreter was driven by the terminal's characteristics—termcap was born.
> <br><br>
> ["Salus, Peter H. *A Quarter Century of UNIX*. Reading, Mass., Addison-Wesley Pub. Co, 1995, p. 143."](https://ia800304.us.archive.org/35/items/aquartercenturyofunixpeterh.salus_201910/A%20Quarter%20Century%20of%20UNIX%20-%20Peter%20H.%20Salus.pdf)

That establishes that Bill Joy was optimizing the system and utilities at that time - but with a focus on work he's much better-known for: `vi`, the visual editor - an explicit optimization for *screen*-based interfaces vs. Teletype. The multi-column `ls` *would* fit in with that kind of work.

In a [1999 interview with Linux Magazine titled "The Joy of Unix"](https://web.archive.org/web/20020209231859/http://www.linux-mag.com/1999-11/joy_04.html), Bill Joy recounts his experience building `vi`, in particular:

> **BJ:** What happened is that Ken Thompson came to Berkeley and brought this broken Pascal system, and we got this summer job to fix it. While we were fixing it, we got frustrated with the editor we were using which was named ed. ed is certainly frustrating.
> <br><br>
> We got this code from a guy named George Coulouris at University College in London called em -- Editor for Mortals -- since only immortals could use ed to do anything. By the way, before that summer, we could only type in uppercase. That summer we got lowercase ROMs for our terminals. It was really exciting to finally use lowercase.
> <br><br>
> **LM:** What year was that?
> <br><br>
> **BJ:** '76 or '77. It was the summer Carter was president

and

> It was really hard to do because you've got to remember that I was trying to make it usable over a 300 baud modem. That's also the reason you have all these funny commands. It just barely worked to use a screen editor over a modem. It was just barely fast enough.

Which further lends credence to Bill Joy being in an "optimize for the screen displays we have" mindset.

Finally, [Diomidis Spinellis](https://en.wikipedia.org/wiki/Diomidis_Spinellis) synthesized `git` history of the early Unix versions based on extensive research, publicly available at [dspinellis/unix-history-repo](https://github.com/dspinellis/unix-history-repo). The scholarly article about it is, unfortunately, paywalled, but a draft is available in which we can find the following:

> Table 4: Manually-Allocated Contributions in BSD Unix Releases
> <br>...<br>
> Bill Joy        analyze, apropos, ashell, cat3a, chessclock, chownall, colcrt, collpr, cptree, cr3, csh, cshms, cxref, dates, diffdir, double, dribble, edit, ex, ex-1, expand, exrecover, exrefm, eyacc, fold, from, glob2, head, htmp, htmpg, htmps, iul, list, lntree, locore, `ls`, makeTtyn, man, manwhere, mkstr, msgs, nm, num, number, osethome, pascal, pascals, pcc, pi, pi0, pi1, pix, print, Print, puman, px, pxp, pxref, rout, see, sethome, sh, sidebyside, size, soelim, squash, ssp, strings, strip, termcap, termlib, tests, tra, transcribe, ttycap, ttycap2, Ttyn, ttytype, typeof, ulpr, vgrind, vi, vm, vmstat, vmunix, wc, whatis, whereis, whoami, whoison, xstr 

{%linkcard
	https://www.spinellis.gr/pubs/jrnl/2016-EMPSE-unix-history/html/unix-history.html
	"A Repository of Unix History and Evolution"
	archive:https://web.archive.org/web/20250730014336/https://www.spinellis.gr/pubs/jrnl/2016-EMPSE-unix-history/html/unix-history.html
%}

Further reinforcing that Bill Joy *did* work on `ls` in some capacity. Given that he was in the right place at the right time, with an apparently right mindset, I judge the attribution *plausible* and perhaps even *likely*... However, I cannot say with certainty that Bill Joy actually added the multi-column display to `ls`. Just that it was more-likely him than anyone else I can figure.

## Appendix B: Don Widrig & Short Names

It was claimed earlier in this document:

> > The original convention for short names, 'initial letter of each word in a command, augmented by succeeding consonants for a one-word command,' is attributed to Don Widrig.
>
> -- `Multics Glossary`[^4]

Multicians.org would be an authoritative source on Multics-era history, one would hope.

But... Who was Don Widrig? Is he *really* the person who deserves credit for the hugely-impactful design decision of short names for Unix commands?

{% polaroid
	don-widrig-04-1968.jpg
	title="Donald R. Widrig, April 1968"
	link="https://multicians.org/phase-one.html"
	image_link="don-widrig-04-1968.jpg"
%}

That's him, according to some Multics history - again from `Multicians.org` - authored by [Tom Van Vleck](https://en.wikipedia.org/wiki/Tom_Van_Vleck). Tom worked on [Project MAC](https://en.wikipedia.org/wiki/Project_MAC) at MIT starting in 1965. Project MAC brought about the CTSS where our `ls` story starts.

Don *may* have co-authored [Managing Software Requirements: A Unified Approach](https://www.goodreads.com/book/show/582860.Managing_Software_Requirements) - a book on [UML](https://en.wikipedia.org/wiki/Unified_Modeling_Language) -  with [Dean Leffingwell](https://www.linkedin.com/in/deanleffingwell/). There are other Don Widrigs out there and I can't find anything conclusive to pin authorship on *our* Don. Leffingwell also doesn't have a dedicated Wikipedia page or many photos, but does have an up-to-date LinkedIn profile... But we're getting sidetracked.

Don Widrig appears to have not been as famous - or at least as *public* - a figure as some of the other names involved in the history of `ls`: there's precious little historical information available beyond what we've already seen. We do have:

- occasional references from contemporaries of him working on Multics at the right time
- his name scattered throughout surviving Multics documentation, including as a co-author of [PRLNK](https://www.multicians.org/mspm/be-5-14.671117.prlnk-saved.pdf) along with Tom Van Vleck (PRLNK feels adjacent to `ls`'s functionality)
- **nothing conclusive** about the short naming convention

The only source we've got is the word of a contemporary Multician, posted on a website dedicated to Multics history. A thoroughly suitable source, but also our *only* one.

For lack of ability to refute the claim and in deference to the authority of the claimant, we'll let the credit stand with Don for now.

## References

[^1]: Computer History Museum. "The Earliest Unix Code: An Anniversary Source Code Release." *Computer History Museum Blog*, 17 Oct. 2019, <https://computerhistory.org/blog/the-earliest-unix-code-an-anniversary-source-code-release/>. ([archive](https://web.archive.org/web/20250817171549/https://computerhistory.org/blog/the-earliest-unix-code-an-anniversary-source-code-release/))

[^3]: Ritchie, Dennis M. "The Evolution of the Unix Time-sharing System." Bell Laboratories, Murray Hill, NJ. Originally presented at the Language Design and Programming Methodology conference, Sydney, Australia, Sept. 1979. Reprinted in *AT&T Bell Laboratories Technical Journal*, vol. 63, no. 6, part 2, Oct. 1984, pp. 1577-93. <https://www.nokia.com/bell-labs/about/dennis-m-ritchie/hist.html>. ([archive](https://web.archive.org/web/20250928024606/https://www.nokia.com/bell-labs/about/dennis-m-ritchie/hist.html))

[^4]: Multics Glossary. "Multics Glossary -A-." *Multicians.org*, <https://multicians.org/mga.html>. ([archive](https://web.archive.org/web/20251007073951/https://multicians.org/mga.html))

[^5]: "Compatible Time-Sharing System." *Wikipedia*, <https://en.wikipedia.org/wiki/Compatible_Time-Sharing_System>. ([archive](https://web.archive.org/web/20250930135216/https://en.wikipedia.org/wiki/Compatible_Time-Sharing_System))

[^6]: "Multics." *Wikipedia*, <https://en.wikipedia.org/wiki/Multics>. ([archive](https://web.archive.org/web/20251104211910/https://en.wikipedia.org/wiki/Multics))

[^7]: "Ken Thompson." *Wikipedia*, <https://en.wikipedia.org/wiki/Ken_Thompson>. ([archive](https://web.archive.org/web/20250928002215/https://en.wikipedia.org/wiki/Ken_Thompson))

[^8]: "Dennis Ritchie." *Wikipedia*, <https://en.wikipedia.org/wiki/Dennis_Ritchie>. ([archive](https://web.archive.org/web/20251209212050/https://en.wikipedia.org/wiki/Dennis_Ritchie))

[^9]: Singh, Karandeep. "The Evolution of 'ls': From Early Unix to Modern Linux - A Five-Decade Journey." *Karandeep Singh - DevOps in Calgary*, 10 Mar. 2025, <https://karandeepsingh.ca/posts/evolution-ls-command-unix-linux-history/>. ([archive](https://web.archive.org/web/20250910204747/https://karandeepsingh.ca/posts/evolution-ls-command-unix-linux-history/))

[^10]: "Ls (Unix)." *Wikipedia*, <https://en.wikipedia.org/wiki/ls>. ([archive](https://web.archive.org/web/20250918023259/https://en.wikipedia.org/wiki/Ls))

[^11]: "Research Unix." *Wikipedia*, <https://en.wikipedia.org/wiki/Research_Unix>. ([archive](https://web.archive.org/web/20251113073548/https://en.wikipedia.org/wiki/Research_Unix))

[^12]: "Genesis: 1969–1971" *Origins and History of Unix, 1969-1995*, <http://www.catb.org/esr/writings/taoup/html/ch02s01.html>. ([archive](https://web.archive.org/web/20251012111631/http://www.catb.org/esr/writings/taoup/html/ch02s01.html))

