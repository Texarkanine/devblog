# The Genealogy of Enumeration: A Historiographical and Technical Analysis of the ls Utility

## Introduction: The Primal Act of Digital Orientation

In the vast, intangible geography of the digital universe, the act of orientation is paramount. Before a user can manipulate data, execute a program, or modify a system, they must first understand their location and their surroundings. In the command-line interface (CLI) paradigm, which has dominated computing for over half a century, the primary instrument of this orientation is the command ls.  
The utility ls, an abbreviation for "list," serves a function analogous to the visual scan of a physical room. It enumerates the contents of a directory, revealing the names, attributes, and hierarchies of the file system. While it appears deceptively simple—a mere printing of strings—the history of ls is a microcosm of the history of the operating system itself. Its evolution tracks the migration from batch processing to time-sharing, from 18-bit minicomputers to 64-bit cloud instances, and from the paper-based teletype to the high-resolution graphical terminal emulator.  
The query regarding the authorship of the first instance of the ls utility necessitates a bifurcated answer, separating the *conceptual* origin from the *genetic* origin of the modern tool. While the concept of listing files predates the Unix operating system, having roots in the Compatible Time-Sharing System (CTSS) at MIT, the specific utility named ls that sits in the /bin directory of billions of devices today was forged in the laboratories of the Bell System.  
This report establishes that the first instance of the Unix ls utility was written by [Ken Thompson](https://computerhistory.org/blog/the-earliest-unix-code-an-anniversary-source-code-release/) in the summer of 1969 at Bell Labs in Murray Hill, New Jersey. However, this assertion is layered with complexity. Thompson did not invent the name "ls"—he inherited it from the Multics project, specifically from a naming convention established by Don Widrig. As documented in the Multics glossary: "The original convention for short names, 'initial letter of each word in a command, augmented by succeeding consonants for a one-word command,' is attributed to Don Widrig." Nor did he invent the functionality; that credit belongs to the developers of [CTSS and their listf command](https://www.linuxdoc.org/LDP/LG/issue48/fischer.html).

## The Pre-Unix Era: The Genesis of Interactive Listing

To understand the birth of ls, one must first understand the world that existed before it. In the early days of computing, the "file system" was physical. Data existed on punch cards or magnetic tapes that were mounted and dismounted by operators. The programmer did not "list" files; they walked over to a cabinet and looked at the labels on card decks.  
The transition to **Time-Sharing**—the ability for multiple users to access a computer simultaneously and interactively—necessitated a virtual abstraction of storage. If users were not physically present to handle their card decks, the computer had to manage data retention on their behalf. This gave rise to the "file," and consequently, the need to list those files.

### The Compatible Time-Sharing System (CTSS)

The spiritual ancestor of ls lies in the Compatible Time-Sharing System (CTSS), developed at the MIT Computation Center. Operational by 1961, CTSS was the first system to demonstrate the viability of general-purpose time-sharing. It ran on an [IBM 7094 mainframe](https://multicians.org/mga.html), a machine that dominated scientific computing in the early 1960s.  
In this environment, the command listf (List Files) was born. Historical records indicate that listf was available to CTSS users by July 1961\. This utility is the cladistic ancestor of ls. It performed the exact same core function: querying the system's master file directory and printing the entries associated with the current user.

#### The Syntax of listf

The syntax of CTSS commands reflected the era's lack of standardized abbreviation. Commands were often full words, and arguments were parsed in a manner that would seem alien to a modern Unix user. By 1963, the listf command had matured into a versatile tool with several options that prefigure the flags of ls.  
source: [https://www.linuxdoc.org/LDP/LG/issue48/fischer.html](https://www.linuxdoc.org/LDP/LG/issue48/fischer.html)

| CTSS Command | Function | Modern ls Equivalent |
| :---- | :---- | :---- |
| listf | List files, newest first | ls \-t |
| listf rev | List files, oldest first | ls \-tr |
| listf (long) | List in long format (metadata) | ls \-l |
| listf (srec) | List by size (records) | ls \-S |
| listf (smad) | List by date of last modification | ls \-t |
| listf (auth) user | List files created by a specific user | ls \-l (filtered) |

The existence of listf (long) is particularly significant. It demonstrates that the distinction between a "simple" list (names only) and a "rich" list (names plus metadata) was established almost a decade before Unix V1.

#### Authorship of listf

The authorship of listf is collective, attributed to the [staff of the MIT Computation Center](https://en.wikipedia.org/wiki/Compatible_Time-Sharing_System). Key figures in the development of CTSS included Fernando Corbató (the project lead), Robert Fano, and Jerome Saltzer. While it is difficult to pinpoint the specific individual who typed the first assembly instruction for listf, the conceptual framework was laid by this team.

### The Multics Project: Complexity and Naming

CTSS was a resounding success, but it was a retrofit on existing hardware. Its successor, **Multics** (Multiplexed Information and Computing Service), was designed from a blank slate to be the ultimate computing utility. Started in 1964 as a collaboration between MIT, General Electric, and Bell Labs, Multics aimed to provide continuous, reliable computing to a massive user base.  
It is in the Multics project that the string "ls" first appears as a command name.

#### The Invention of Short Names

Multics was an ambitious, high-level system written primarily in PL/I (Programming Language One). It introduced a hierarchical file system, segments, and rings of protection. It also introduced a command language that sought to balance descriptiveness with efficiency.  
The command to list directory contents in Multics was named list. However, Multics designers recognized that typing list repeatedly was inefficient for expert users. The system introduced a standardized facility for command abbreviations.  
The convention for these short names—taking the initial letter of the command words—is attributed to Don Widrig, a key developer on the project. As the Multics glossary notes: "The original convention for short names, 'initial letter of each word in a command, augmented by succeeding consonants for a one-word command,' is attributed to Don Widrig." Under this convention:

* list was abbreviated to ls.  
* copy was abbreviated to cp.  
* move was abbreviated to mv.  
* rename was abbreviated to rn.

This decision was driven by the ergonomics of the teletype. The standard interface for Multics (and later Unix) was the Teletype Model 37 or Model 33\. These devices were mechanical typewriters that communicated over phone lines. They were loud, slow (10 characters per second), and required significant physical force to actuate the keys. Every character saved was not just a time optimization; it was a physical labor optimization.

#### The Multics list Implementation

The Multics list command was significantly more complex than its CTSS predecessor. It had to navigate the Multics storage system hierarchy, handling Access Control Lists (ACLs), segments, and the concept of the "working directory" which could be changed via the [change\_wdir or cwd command](https://en.wikipedia.org/wiki/Multics).  
The authorship of the Multics list command and the associated file system utilities involved researchers who would later become legends of computing, including [Ken Thompson](https://en.wikipedia.org/wiki/Ken_Thompson). They used the system, wrote code for it, and internalized its design philosophies—both the ones they liked (the hierarchical file system, the shell) and the ones they disliked (the complexity, the PL/I overhead).  
When Bell Labs withdrew from the Multics project in 1969, citing the project's slow progress and high costs, Thompson and Ritchie left with a clear mental model of what a file system *should* look like, and a clear preference for the short command names ls, cp, and mv.

## The Unix Genesis: Bell Labs, 1969

The withdrawal from Multics created a vacuum. Ken Thompson, Dennis Ritchie, and fellow researchers like Doug McIlroy and Joe Ossanna found themselves back in the Bell Labs Computing Science Research Center with no interactive time-sharing system. They were relegated to the GECOS batch system on a GE-635, a significant regression in their workflow.  
This deprivation was the catalyst for Unix.

### The Hardware: The PDP-7

The machine that hosted the first true ls utility was a Digital Equipment Corporation (DEC) **PDP-7**. This machine was already obsolete by 1969 standards. It had a word size of 18 bits and a memory of 8K words (roughly 14.4 kilobytes). It lacked the hardware memory management unit required for true Multics-style time-sharing, but it had a decent display processor and, crucially, a disk drive that [Thompson wanted to exploit](https://www.nokia.com/bell-labs/about/dennis-m-ritchie/hist.html).

### The Motivation: Space Travel

The proximate cause for the development of the system was a game called *Space Travel*. Thompson had written it on the GE mainframe, but it was expensive to run and the "jerky" performance of the time-sharing system made the [simulation poor](https://www.nokia.com/bell-labs/about/dennis-m-ritchie/hist.html).  
Thompson found the unused PDP-7 and set about porting the game. To do this, he needed a development environment. He wrote a floating-point package (found in the source listings as fops), an assembler, and eventually, a kernel to manage the hardware resources.

### The Authorship: Ken Thompson

The historical record is unanimous: **Ken Thompson** wrote the core of the PDP-7 operating system, including the file system and the initial set of utilities, during the summer of 1969\.  
Dennis Ritchie, in his retrospective [The Evolution of the Unix Time-sharing System](https://www.nokia.com/bell-labs/about/dennis-m-ritchie/hist.html) states: "Thompson... began implementing the paper file system... Then came a small set of user-level utilities: the means to copy, print, delete, and edit files".  
While Ritchie was a close collaborator, contributing to the assembler and later the C language, the initial implementation of the file system tools on the PDP-7 was Thompson's work. The source code recovered from this era bears the distinct fingerprints of Thompson's coding style—terse, efficient assembly language.

### The "First" ls: Technical Analysis

In 2016, and supplemented by a further discovery in 2019, notebooks containing the printed source code of the PDP-7 Unix system were found. These listings, scanned and analyzed by the Unix Heritage Society (TUHS), provide the "ground truth" for the first ls.  
The file is typically identified in the [reconstruction as ls.s](https://computerhistory.org/blog/the-earliest-unix-code-an-anniversary-source-code-release/) (the .s suffix denoting assembly source).

#### Implementation Details

The PDP-7 ls was written in [PDP-7 assembly](https://github.com/DoctorWkt/pdp7-unix/blob/master/src/cmd/ls.s). The logic was radically simple compared to the Multics PL/I implementation.

1. **System Calls:** The code utilized the primitive system calls of the PDP-7 kernel. It didn't have the high-level opendir / readdir abstraction we have today. Instead, it opened the directory as a file.  
2. **Directory Structure:** In this early version of Unix, a directory was a special file containing a sequence of fixed-length entries. Each entry consisted of:  
   * 2 bytes: The inode number (index node).  
   * 14 bytes: The filename.  
3. **The Loop:** The ls utility would:  
   * open the directory (often . or the argument provided).  
   * read 16 bytes into a buffer.  
   * Check if the inode number was zero. (A zero inode indicated a deleted file slot).  
   * If non-zero, it printed the 14-byte filename to the standard output (the teletype).  
   * Repeat until End-of-File (EOF).

#### The "Dot" Problem

One of the most fascinating insights from the restoration of the PDP-7 Unix is the handling of the current directory. The early file system did not automatically create the . (current) and .. (parent) entries in new directories.  
To make ls work without arguments (listing the current directory), the user (Thompson) had to manually create a link named . pointing to the directory itself. The command sequence, reconstructed by the project team, involved using the link command ln to create these navigation anchors.  
Eventually, mk (the predecessor to mkdir) was updated to create these entries automatically. However, this created a new problem: ls would list . and .. in every single directory, clogging the output. This led to the introduction of the check to skip files starting with a dot, which inadvertently gave rise to "hidden files" (dotfiles) in Unix.

## The First Edition (V1): The Canonical Unix ls (1971)

While the PDP-7 version was the *first*, it was never released to the public. The first version of Unix to be formally documented and installed on other machines was the **First Edition** (V1), running on the **PDP-11**.  
By 1971, the system had been ported to the PDP-11/20, a 16-bit minicomputer. The [V1 Programmer's Manual](https://www.linuxdoc.org/LDP/LG/issue48/fischer.html), dated November 3, 1971, provides the first public citation for ls.

### The Manual Entry

The V1 manual page for ls is a model of technical brevity.

* **Name:** ls \- list directory contents.  
* **Synopsis:** ls \[ \-ltas \] name...  
* **Description:** "List information about the FILEs (the current directory by default)."

This document confirms the existence of the core flags that define ls usage today:

* **\-l**: Long format. It listed the mode, number of links, owner, size, and time.  
* **\-t**: Sort by time modified.  
* **\-a**: List all entries, including those starting with ..  
* **\-s**: Give size in blocks.

### The Implementation in Assembly

Like its PDP-7 predecessor, the [V1 ls was written in assembly language](https://gunkies.org/wiki/UNIX_First_Edition). The PDP-11 architecture was byte-addressable and little-endian, which influenced how ls handled the directory data structures.

## The Great Rewrite: C and Portability (1973)

The next major evolutionary leap for ls occurred in 1973 with **Version 4 Unix**. This was the version where the kernel and utilities were rewritten in the **C programming language**. This rewrite was transformative. ls ceased to be a PDP-specific assembly program and became a portable C program.

### The struct direct

In C, the directory entry was defined as a structure, typically found in \<sys/dir.h\>. The C implementation of ls used the standard I/O library (stdio) or low-level read calls to iterate over these structures. This decoupled the utility from the hardware.

### Authorship Continuity

Ken Thompson remained the primary architect of these core utilities during the V4-V6 era. While the [C language was Ritchie's creation](https://en.wikipedia.org/wiki/Dennis_Ritchie), the application of C to system utilities was a collaborative effort driven by Thompson's desire to make the system self-hosting and portable.

## Divergence: The BSD vs. System V Schism

As Unix escaped the labs and spread to universities, specifically the University of California, Berkeley, the ls command underwent a fork that effectively split the Unix world into two camps: **BSD** (Berkeley Software Distribution) and **System V** (AT\&T).

### The Screen Real Estate Problem

In the late 1970s, universities began replacing teletypes with video terminals. These screens had limited height but substantial width. The traditional ls output—one file per line—was inefficient on these screens.  
In May and August 1977, [Bill Joy made modifications to ls](https://web.archive.org/web/20240912170203/https://www.linuxdoc.org/LDP/LG/issue48/fischer.html) at the University of California, Berkeley, which he subsequently distributed as part of the First Berkeley Software Distribution (1BSD). The most dramatic difference with this version of ls was that it listed files in multiple columns rather than only listing one name per line. This allowed users to see dozens of files at once without scrolling.

* **BSD ls:** Defaulted to multi-column output if the output was a terminal (isatty()).  
* **System V ls:** Stuck to the traditional single-column format for longer, requiring a flag (often \-C) to enable columns.

### Flag Inflation

During this period, the number of flags supported by ls exploded.

* **Recursive Listing (-R):** Added to allow traversing subdirectories.  
* **File Type Indicators (-F):** BSD introduced the [-F flag](https://karandeepsingh.ca/posts/evolution-ls-command-unix-linux-history/), which appended characters to filenames to indicate their type (/ for directories, \* for executables).

## The Modern Era: GNU ls and Linux

The ls command most users interact with today is neither the original Thompson assembly code nor the BSD C code. It is the **GNU coreutils** version, running on Linux.

### The GNU Project

In the mid-1980s, Richard Stallman launched the GNU Project to create a free Unix-compatible operating system. Because the original Unix source code was proprietary (owned by AT\&T), GNU could not use it. They had to rewrite every utility from scratch.  
The GNU version of ls was written primarily by [Richard Stallman and David MacKenzie](https://en.wikipedia.org/wiki/Ls).

### Features of GNU ls

GNU ls introduced several features that are now standard in the Linux world but were controversial or absent in traditional Unix:

* **Color (--color):** GNU ls can colorize output based on file type and extension.  
* **Long Options:** GNU introduced double-dash options (e.g., \--all).  
* **Human Readable Sizes (-h):** Displaying sizes in KB, MB, GB rather than bytes or blocks.

## Detailed Comparison of Historical Implementations

To visualize the evolution of the utility, we can compare the feature sets across the eras.

| Feature | CTSS listf (1963) | Multics list (1967) | Unix PDP-7 ls (1969) | Unix V1 ls (1971) | BSD ls (c. 1980\) | GNU ls (Modern) |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- |
| **Command Name** | listf | list (alias ls) | ls | ls | ls | ls |
| **Default View** | List (sorted new) | List | List | List | Columns | Columns/Color |
| **Long View** | (long) | \-long | N/A | \-l | \-l | \-l |
| **Hidden Files** | No | No | No | \-a | \-a | \-a / \-A |
| **Sort by Time** | (smad) | \-dtm | N/A | \-t | \-t | \-t |
| **Sort Reverse** | (rev) | \-reverse | N/A | (Manual) | \-r | \-r |
| **Recursion** | No | (via walk) | No | No | \-R | \-R |
| **Primary Author** | MIT Staff | Project MAC | **Ken Thompson** | **Ken Thompson** | Bill Joy et al. | Stallman/MacKenzie |
| **Language** | MAD/Asm | PL/I | PDP-7 Asm | PDP-11 Asm | C | C |

## Insights and Implications

### The Persistence of the "Teletype Mindset"

The most profound insight from the history of ls is how constraints of the 1960s dictate the workflow of the 2020s. We still use ls (2 characters) instead of list because the early Unix developers worked on teletypes—[the standard interactive device on the earliest timesharing systems was the ASR-33 teletype](http://www.catb.org/esr/writings/taoup/html/ch02s01.html), a slow, noisy device that printed upper-case-only on big rolls of yellow paper. These devices were heavy, stiff, and slow. Listing a directory with ls instead of list saved three keystrokes. Over a million invocations, those keystrokes add up to days of human life. This "worse is better" or "minimalist" philosophy is the genetic code of Unix.

### The "Everything is a File" Abstraction

The evolution of ls mirrors the evolution of the Unix abstraction "Everything is a file." In PDP-7 Unix, ls read the directory *as a file*. It didn't need a special API because the directory was just data on the disk. While modern filesystems are complex databases that require readdir calls, the mental model provided by ls remains the flat file list.

## Conclusion

In conclusion, the answer to the user's query is both singular and plural.  
The Singular Answer:  
The first instance of the Unix ls CLI utility was written by (Ken Thompson)(https://computerhistory.org/blog/the-earliest-unix-code-an-anniversary-source-code-release/) in Murray Hill, New Jersey. It was written in assembly language for the (DEC PDP-7)(https://en.wikipedia.org/wiki/Research\_Unix) to facilitate the development of the operating system that would host the game Space Travel.  
**The Plural Context:**

* **The Name:** The name ls was adopted from the Multics operating system, where **Don Widrig** established the convention of two-letter abbreviations (ls, cp, mv). As documented in the Multics glossary: "The original convention for short names, 'initial letter of each word in a command, augmented by succeeding consonants for a one-word command,' is attributed to Don Widrig."  
* **The Concept:** The functionality of listing files interactively originated with the [listf command](https://www.linuxdoc.org/LDP/LG/issue48/fischer.html) at MIT (circa 1961).  
* **The Modern Tool:** The version of ls used by most people today (on Linux) is the **GNU** version, authored by [Richard Stallman and David MacKenzie](https://en.wikipedia.org/wiki/Ls).

The ls command is a palimpsest—a manuscript written over previous manuscripts. Beneath the color output of a modern Linux terminal lies the columnation of the BSD hackers, beneath that lies the C structure of Version 4, beneath that the assembly logic of Version 1, and at the very bottom, the ghostly keystrokes of Ken Thompson on a PDP-7 teletype, trying to save a few milliseconds of typing in a hot summer in New Jersey.