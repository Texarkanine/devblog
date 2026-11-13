# Make in 2026: Has Anyone Built the Successor?

As of 2026-11-09.

No. Nobody has built the successor our essay calls for, and nobody has argued for it on our grounds. The nearest miss is **werk** (Simon Ask Ulsnes). It launched in January 2025, has 319 GitHub stars, and is still "early alpha". It fully meets 8 of our 12 requirements and states its limits as promises ("werk will never be a scripting language"). But it restricts itself for Windows portability and debuggability, not for a shared contract. It also accepts `-D` variable overrides, splits tasks from files with a keyword instead of reserved verbs, and still trusts file modification times. **tup** is closest in spirit: its 2009 rules paper says "There must not be different ways of building the system that the user must remember". Yet tup has no task verbs at all. **Ninja** is closest on a static format with no decisions in it, a choice made for speed. **Plan 9's mk** solved the clash between task names and file names decades ago, with a per-rule attribute. The lifecycle half of the vision lives outside the make world, in GNU's standard targets, Automake, Maven and GitHub's Scripts To Rule Them All. Each fixed the names and left the implementation free. Three things are genuinely unclaimed:

- reserved lifecycle names that replace `.PHONY` (S5);
- a no-parameters rule justified by parity across humans, AI agents, CI and pipeline authors (the reason behind S4);
- change detection designed for short-lived CI runners and cache eviction (S11).

The vision is most contested on two points. The first is parameters, the topic Hacker News comments mention most (on Reddit and Lobsters, three times as many commenters asked for the same verbs in every repo as asked for task arguments). The second is one shell per recipe line, which the make lineage itself, including Bell Labs' own successor, treated as a wart. And any successor gives up the one argument that keeps people on Make: it is already installed.

## Twelve requirements, distilled from the essay's call to build

The essay's concessions and closing challenge describe a tool that keeps Make's load-bearing walls and fixes four rough edges: `--help`, DAG inspection, native Windows, and change detection when filesystems travel. Two design questions are settled and three stay open:

- Settled: reserved names instead of `.PHONY`, and intentional friction instead of impossibility.
- Open: `--help`, DAG inspection, and timestamps versus hashes.

The researchers scored every tool against this checklist.

| ID | Requirement |
|---|---|
| S1 | File-aware DAG: targets are files by default; unchanged work is skipped. |
| S2 | Unordered parallel prerequisites: edges, not step lists. |
| S3 | One command per recipe line in a fresh shell; friction against control flow in recipes. |
| S4 | No parameters or flags on targets; zero-argument lifecycle verbs so a human, an AI agent and CI run the identical thing; environment variables as the one escape hatch. |
| S5 | Reserved, fixed lifecycle phase names (Maven-style) replace `.PHONY`: a reserved name is a task, any other name is a file. |
| S6 | No embedded scripting runtime; logic lives in tested packages; the friction is stated up front. |
| S7 | Local include only; no remote imports or package manager. |
| S8 | Built-in `--help` that shows the project's targets without colliding with the runner's own flags. |
| S9 | Human-readable DAG inspection. |
| S10 | Native Windows. |
| S11 | Change detection that survives short-lived CI runners without surprising caches. |
| S12 | Already everywhere, with nothing to install, and a static format that tools can analyze. |

## Twenty-six tools scored: werk leads, nothing finishes

| Tool | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 | S9 | S10 | S11 | S12 | Verdict |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| werk | yes | yes | yes | partial | partial | yes | yes | yes | yes | yes | partial | partial | Philosophy, partly (restricts for portability and debuggability) |
| tup | yes | yes | partial | partial | opposite | partial | yes | no | yes | yes | partial | no | Philosophy (strictness) |
| Ninja | yes | yes | partial | partial | no | yes | yes | partial | yes | yes | partial | partial | Incidental (speed) |
| Plan 9 mk | yes | yes | opposite | ? | partial | partial | partial | no | partial | no | partial | no | Incidental |
| knit | yes | yes | partial | no | no | opposite | yes | partial | yes | partial | yes | no | Opposite (Lua) |
| GNU Make 4.4.1 | yes | partial | yes | partial | no | partial | yes | no | partial | yes | partial | partial | Baseline |
| remake | yes | partial | yes | partial | no | partial | yes | yes | partial | ? | partial | no | Philosophy on S8 only |
| bmake | yes | yes | opposite | no | ? | no | yes | no | partial | no | partial | partial | Incidental |
| redo family | yes | partial | opposite | yes | no | opposite | partial | partial | partial | no | partial | opposite | Opposite (shares correctness ethos) |
| makepp | yes | partial | ? | no | ? | opposite | partial | no | yes | yes | partial | no | Opposite |
| Shake | yes | partial | opposite | no | no | opposite | opposite | yes | yes | partial | yes | opposite | Opposite |
| mmake | yes | partial | yes | partial | no | partial | opposite | yes | – | – | partial | no | Opposite on S7 |
| mmk3 | – | – | opposite | opposite | partial | opposite | – | yes | yes | – | – | – | Opposite |
| Compi | partial | yes | – | – | no | yes | – | – | partial | yes | partial | partial | Incidental |
| makesure | no | – | – | yes | no | no | partial | yes | – | – | no | – | Philosophy on S4 only |
| run (runtool) | no | partial | opposite | opposite | no | opposite | partial | yes | no | partial | no | no | Opposite (deliberate) |
| just | no | – | – | opposite | no | opposite | ? | yes | – | – | no | – | Opposite |
| Task | partial | – | ? | opposite | no | ? | opposite | yes | no | – | partial | – | Opposite |
| mise tasks | partial | – | – | opposite | no | – | opposite | yes | partial | – | partial | – | Opposite |
| Maven | – | – | – | partial | yes | – | – | partial | – | – | – | – | Philosophy |
| Gradle (incl. Declarative Gradle) | – | – | – | – | partial | partial | – | partial | partial | – | partial | – | Incidental |
| Pants | – | – | – | – | partial | – | – | partial | partial | – | – | – | Philosophy in shape (reason unconfirmed) |
| Bazel (with Starlark) | – | – | – | – | partial | yes | – | – | yes | – | partial | – | Incidental |
| Meson | – | – | – | – | – | yes | – | – | – | – | – | – | Philosophy on S6 |
| GNU standard targets | – | – | – | partial | partial | – | – | – | – | – | – | – | Philosophy (by convention) |
| Scripts To Rule Them All | – | – | – | partial | partial | opposite | – | – | – | – | – | – | Philosophy on names only |

**Key.**

- **yes** meets the item; **partial** meets part of it or with caveats; **no** does not; **opposite** deliberately does the reverse.
- **?** means the researchers looked and could not verify; **–** means not assessed or not applicable.
- **Aligned by philosophy** means same reasons as the essay: one predictable contract for every consumer, and logic in real, tested code.
- **Incidentally aligned** means the same shape for different reasons, such as speed, safety or less duplication.
- **Opposite direction** means the tool moves away from a fixed contract or adds expressiveness.
- GNU Make's S8 is "no" for the 4.4.1 release and "partial" for unreleased master.
- All scores come from documentation and source pages. Nobody ran the tools, except for a few local behavior tests noted below.

Read across, werk has 8 yes and no "no" cells. Ninja has 6 yes and tup has 5. Two columns stay empty among the make-like tools:

- **S5**: only Maven scores yes, and Maven sits outside the make world.
- **S11**: the yes scores (knit, Shake) are for content hashing, not for anything designed around short-lived runners.

No tool scores yes on S12.

## The closest attempts, in their authors' own words

### New successors since 2022: one serious candidate and one deliberate opposite

About 40 projects since 2022 call themselves a make replacement, alternative or successor. Only werk has traction and keeps the file DAG while restricting the language on purpose. Popularity runs the other way. The projects that drew the most attention all drop file targets and add parameters: Makedown (142 HN points), Jeeves (55 points, 84 comments), run, and the out-of-scope just and Task ([Makedown on HN](https://news.ycombinator.com/item?id=41825344); [Jeeves on HN](https://news.ycombinator.com/item?id=38157145)). On werk's launch thread, one commenter named the gap: "I really was surprised to see that there isn't a modern make replacement that actually does what make does … Most appear to be 'just' command runners" ([TheTaytay, Show HN: Werk](https://news.ycombinator.com/item?id=42672863)).

#### werk restricts itself on purpose, but for Windows and debuggability

Simon Ask Ulsnes created the repo in November 2024 and announced werk in ["Introducing Werk"](https://simonask.github.io/introducing-werk/) on 2025-01-11. It has 319 stars and no tagged GitHub releases. The last commit, on 2026-05-11, bumped it to v0.2.0 ([commit](https://github.com/simonask/werk/commit/4560f4091eb39b9ac6e76e93d218df71ce3773c1)). The README warns: "Werk is early alpha software. Use at your own risk." ([simonask/werk](https://github.com/simonask/werk)).

**The restriction is a stated commitment.** The README says: "werk will never be a scripting language. It is strictly declarative with minimal support for logic and expressions, but doesn't have (and won't have) loop constructs". The language reference calls werk "a Turing-incomplete language: there are no loops or functions" ([Language reference](https://simonask.github.io/werk/language.html)).

**Recipes do not run in a shell at all.** werk "performs its own $PATH lookup" and runs each command in order. A `shell` expression exists, but only as an explicit escape hatch ([werk book](https://simonask.github.io/werk/print.html)).

**It ships most of the UI fixes we want:**

- `--list` prints recipes "along with any preceding comment".
- `--dot` writes the plan to Graphviz, and `--explain` says why each target is outdated.
- Windows is "a first-class citizen - no dependency on a POSIX-compliant shell (or any shell)" ([Features](https://simonask.github.io/werk/features.html)).

**The author's reasons are not ours:** "I'm building a video game … Native Windows support is a hard requirement … When it doesn't do what I want, I need to be able to understand why". He also writes: "Make is a very sophisticated tool that solves a bunch of problems I don't have" ([Introducing Werk](https://simonask.github.io/introducing-werk/)). He rejects the Maven model outright: "All the Java tools (gradle, maven, bazel): I'm sorry, I can't."

**Where werk parts from our vision:**

- Tasks and files are split by a task/build keyword, and task names are free-form.
- `-D, --define` overrides global variables, a second channel besides environment variables.
- Freshness is still mtime, plus a `.werk-cache` of globs, paths, environment variables and recipe text. That holds even though the author writes that "file modification times are just insufficient in determining outdatedness". Deleting the cache makes "the next build … rebuild more than necessary" ([Outdatedness](https://simonask.github.io/werk/outdatedness.html)).
- It installs only from source, with Cargo.

The researchers found no stated reason for refusing task arguments. A commenter listed that as "possibly limiting/offputting" ([simonmic, Show HN: Werk](https://news.ycombinator.com/item?id=42672863)). Open issues ask for process piping, a read-json function, dictionaries and array operations ([werk issues](https://github.com/simonask/werk/issues)). The pull toward expressiveness has started even here. On Reddit, the author added that "there are features of werk that are very difficult to achieve in Make, especially reliable globbing" ([simonask_ on r/programming](https://www.reddit.com/r/programming/comments/1hzkwqw/introducing_werk_a_simple_build_tool_and_command/m6qh9d9/)), and that he "actually started out using TOML as the description language, but yeah it became unwieldy very fast" ([simonask_ on r/programming](https://www.reddit.com/r/programming/comments/1hzkwqw/introducing_werk_a_simple_build_tool_and_command/m6qh3g1/)). Its Lobsters thread (69 points) asked for content hashes instead of mtime ([carlana on Lobsters](https://lobste.rs/c/d9jddx)).

**Verdict:** aligned by philosophy on restriction (S3, S6), for different reasons.

#### knit agrees the DAG is right, then adds Lua

Zachary Yedidia's knit shipped v1.0.0 on 2023-04-06 and has been dormant since its last commit on 2023-09-01. It has 196 stars ([releases](https://github.com/zyedidia/knit/releases)). He starts where we do: "This might be surprising but I actually like Make overall. It has a concise syntax for declaring dependencies, and it doesn't make any assumptions about the programs I am building" ([Knit: making a better Make](https://zyedidia.github.io/blog/posts/3-knit-better-make/)). Then he turns the other way: "Make's declarative rule syntax is good, but the meta-programming language around it isn't so good … It just doesn't stack up to a normal scripting language with features like modules, loops, arrays/maps, a standard library etc…"

**What knit does** ([zyedidia/knit](https://github.com/zyedidia/knit)):

- The README calls knit "a modern version of Mk with a Lua meta-programming system built on top of it".
- It takes command-line parameters: "Running `knit hello debug=1` would change the flags and re-run the affected rules".
- It hashes inputs by default.
- It prints the graph as text, tree, dot or pdf.
- Recipe lines run as in Make, each "in a separate process, spawned with `sh -c <cmd>`" ([knit docs](https://github.com/zyedidia/knit/blob/master/docs/knit.md)).

`knit -t commands` exports the build as a Makefile, shell script, Ninja file or JSON, so people without knit can still build. On HN he softened his blog's "hack" wording about `.PHONY`: "Perhaps I shouldn't have characterized phony rules as a hack" ([Knit on HN](https://news.ycombinator.com/item?id=35491590)).

**Verdict:** opposite direction on S6; incidentally aligned on S1, S2, S9 and S11.

#### run is the deliberate opposite, built for agents

nihilok ("Jarv") published the run crate on 2026-01-13 and released 0.8.1 on 2026-11-03. The README calls it "the bridge between human and AI tooling" that lets you run functions "from your terminal, or expose them as MCP tools for AI agents. Shell, Python, Node—whatever fits the task." ([nihilok/run](https://github.com/nihilok/run)). The blog post states the premise: "tasks are functions, not files". It concludes that task runners "must be polyglot, typed, and built for both the human at the keyboard and the agent in the loop" ([The Edge-and-Node Trap](https://blog.jarv.dev/the-edge-and-node-trap)).

**What run does:**

- The site advertises typed parameters (`task(env: str, port = 8080)`) and variables injected into Bash, Python, Node and Ruby ([run home page](https://runtool.dev/)).
- Its own FAQ concedes that in shell functions "types power documentation and MCP schemas only" ([run FAQ](https://runtool.dev/docs/faq.html)).
- Parallelism is opt-in (`-p`), and there is no change detection or graph output ([run CLI](https://runtool.dev/docs/cli.html)).
- When no Runfile is found, run "falls back to ~/.runfile", a task file shared by the whole machine.

**Where it agrees with us:** discoverability is the real need. run answers it with `--list`, `--inspect` and `--serve-mcp`.

**The Discovery Tax figures are illustrations.** The post gives them twice ([The Edge-and-Node Trap](https://blog.jarv.dev/the-edge-and-node-trap)). Its comparison table says "~1,800–2,500 tokens of shell exploration" and "3 to 6 exploratory calls" for Make or just, against "~80 tokens of tool metadata" and "1 atomic call" for run over MCP. Its worked example ends "Total: 4 tool calls, ~2,100 tokens consumed" against "Total: 1 tool call, ~90 tokens consumed". Neither comes with a method. In that example the agent fails on `make test-worker` and succeeds with `make test SERVICE=worker`, so the cost comes from a target that takes a parameter, which S4 forbids.

**An earlier post sets out the reasoning.** Of just, Jarv wrote: "But parameters have no type annotations — they’re positional strings and that’s it. Handy for humans, but AI agents can’t reliably introspect them." His answer: "The function signature is the schema." ([Why I Built Another Task Runner](https://blog.jarv.dev/why-i-built-another-task-runner), 2026-01-17). How little discussion his posts drew is covered in the foil section below.

**Verdict:** opposite direction, deliberately.

#### mmake added help text in 2017, and remote includes with it

TJ Holowaychuk's mmake (1,737 stars; last release v1.4.0 in 2019) wraps GNU Make and "otherwise acts as a pass-through to standard make" ([tj/mmake](https://github.com/tj/mmake)). Its diagnosis matches our S8 concession: "Make is however lacking a built-in mechanism for displaying help information." Its fix is a reserved help pseudo-target that prints each target's leading comment. That fix also shows the collision risk: help and update now occupy names a project might want.

Then it adds what S7 forbids: "Includes may specify a URL (http, https, or github shortcut) … automatically downloaded to /usr/local/include", resolved recursively. Its answer to the security question is: "If you're worried about arbitrary code execution, then simply fork a project and maintain control over it."

**Verdict:** incidentally aligned on S8; opposite on S7. It is a ready-made receipt for the supply-chain argument.

#### makesure is the only runner that refuses task arguments on purpose

makesure (v0.9.26) says: "We deliberately don't support this feature. The idea is that the build file should be self-contained, so have all the information to run in it" ([xonixx/makesure](https://github.com/xonixx/makesure)). Its principles are "Minimalistic. Bare minimum of features that compose good with each other" and "Worse is better". It rejects a custom language as "unjustified complexity". It rejects includes because "This is a considerable complication to the tool". The only override channel is `-D VAR=value`. It is not a build tool: it has no file targets, only conditions checked before a goal runs, and its recipes are Bash.

**Verdict:** aligned by philosophy on S4 only. Its reason, a self-contained build file, is a cousin of ours (one meaning for every caller) but not the same.

### The classic lineage: strictness and speed, rarely our reasons

#### GNU Make is still 4.4.1, with --print-targets waiting in master

**Release status.** The newest release is still 4.4.1, from 2023-02-26 ([GNU make release directory](https://ftp.gnu.org/gnu/make/)). Master is active (latest commit 2026-04-29), and its NEWS file has a "Version 4.4.90" heading ([GNU make NEWS](https://cgit.git.savannah.gnu.org/cgit/make.git/plain/NEWS)).

**4.4 moved toward S2.** `--shuffle` "reorders goals and prerequisites to simulate non-determinism that may be seen using parallel build", so you can fuzz-test a Makefile's edges. `.WAIT` makes explicit ordering possible.

**Master adds** `--print-targets`**.** It "will print all explicit, non-special targets defined in the makefiles, one per line", with names only and no descriptions. Paul Smith committed it on 2024-01-08 ([commit](https://cgit.git.savannah.gnu.org/cgit/make.git/commit/?id=31036e648f4a92ae0cce215eb3d60a1311a09c60)). The request began: "A *lot* of people would like to be able to print all the targets contained in a Makefile" ([bug #64571](https://lists.gnu.org/archive/html/bug-make/2023-08/msg00003.html)). His caution is worth quoting:

- "The hard thing about this request is not the code. The hard thing is the design" ([bug-make, 2023-11-01](https://lists.gnu.org/archive/html/bug-make/2023-11/msg00001.html)).
- "Just... no. I won't introduce an entire family of options that tweak and customize this output in various ways" ([bug-make, 2024-01](https://lists.gnu.org/archive/html/bug-make/2024-01/msg00011.html)).
- He turned down JSON output because it "requires special tools to parse it" ([bug-make, 2024-01](https://lists.gnu.org/archive/html/bug-make/2024-01/msg00014.html)).

**Graph output has never landed.** Requests date to 2009, 2016 and 2019 (Savannah bugs 25751, 47308 and 56204), and Jonas Danielsson's own proposal followed in 2020. None has been merged ([Proposal to add build graph output to GNU Make](http://jonasdn.blogspot.com/2020/10/proposal-to-add-build-graph-output-to.html)).

`--help` **belongs to make, not to your Makefile.** Make's `--help` dates from version 3.63 (1993) ([GNU make NEWS](https://cgit.git.savannah.gnu.org/cgit/make.git/plain/NEWS)). A local test on GNU Make 4.3 confirmed that it prints 47 lines of its own options before reading the Makefile, even when the Makefile calls `$(error)`. `make test --help` does the same.

**Make already embeds runtimes.** Optional Guile, and loaded objects (now "fully-supported" in master), pull the other way from S6 ([Guile Integration](https://www.gnu.org/software/make/manual/html_node/Guile-Integration.html)).

**Verdict:** the baseline. It is moving toward S2 and S8, for reasons compatible with ours.

#### remake documents targets with #: comments, as a fork

remake "patched GNU Make 4.3 sources to add improved error reporting, tracing, target listing, graph visualization, and profiling", plus a debugger ([rocky/remake](https://github.com/rocky/remake)). `--tasks` "gives a list of targets with remake descriptions"; a description is a `#:` comment line above the target. `--targets` lists everything, with a warning that GNU Make's implicit rules make the list "quite large" ([remake Features](https://remake.readthedocs.io/en/latest/features.html)). `--profile` writes Callgrind data that shows "not only timings, but a graph of the target dependencies checked". The researchers could not confirm its 2026 maintenance status or star count.

**Verdict:** aligned by philosophy on S8 and S9, because it aims to make Makefiles understandable. Otherwise it is GNU Make, and it has to be installed.

#### Plan 9 mk separated tasks from files, then fed whole recipes to one shell

Andrew Hume and Bob Flandrena's ["Maintaining Files on Plan 9 with Mk"](https://9p.io/sys/doc/mk.html) describes the oldest explicit successor to Make. It got three things right that we want:

- "Unlike make, mk has no built-in rules".
- It "constructs the entire dependency graph before building any target".
- "Mk does not define the order of execution of independent recipes."

It solved our S5 problem a different way: "The V attribute identifies a virtual target; that is, a target that is not a file". plan9port's man page adds that virtual targets "are distinct from files of the same name" ([mk(1)](https://9fans.github.io/plan9port/man/man1/mk.html)).

Then it removed our S3 fence on purpose: "unlike make, mk feeds the entire recipe to the shell rather than running each line of the recipe separately". Its P attribute lets any program decide what is out of date, and `-e` explains why each target is made. A Go port, dcjones/mk, is "for anyone who loves make, but hates all its stupid bullshit". It adds an attribute that runs recipes in other languages, such as Julia, and has been dormant since 2020 ([dcjones/mk](https://github.com/dcjones/mk)).

**Verdict:** incidentally aligned (its stated aims are "generality" and consistency); opposite on S3.

#### redo kept honest prerequisites and wrote everything in shell

**Bernstein's design notes.** D. J. Bernstein's redo notes (cited as 2003) never shipped as code. They make our "skill issue" point from the correctness side: "make has no idea that the target files depend on the Makefile. This isn't make's fault. ... The author simply has to be honest to make". They also mock "Switch from make to our zake tool" pitches ([Target files depend on build scripts](https://cr.yp.to/redo/honest-script.html)).

**Every implementation then made the shell script the build language.** Avery Pennarun's apenwarr/redo says "declaring a dependency is just another shell command" ([redo documentation](https://redo.readthedocs.io/en/latest/)). It also says "the syntax of redo is exactly the syntax of sh" ([redo FAQ: Semantics](https://redo.readthedocs.io/en/latest/FAQSemantics/)).

**How apenwarr/redo behaves:**

- It runs contentless targets such as test and clean unconditionally under `redo target`, and observes: "In make, things get complicated because it doesn't differentiate between these two modes."
- On rebuilding, it takes the safe side: "Building stuff unnecessarily is much less dangerous than not building stuff that should be built" ([redo FAQ: Implementation](https://redo.readthedocs.io/en/latest/FAQImpl/)).
- It works on Windows only under WSL.
- It has been dormant since 2023 ([apenwarr/redo](https://github.com/apenwarr/redo)).

redo-c and goredo carry the line on. redo-c checks ctime and then a SHA2 hash; goredo uses BLAKE3 plus size and inode ([redo-c](https://github.com/leahneukirchen/redo-c); [goredo](https://goredo.dabase.com/)).

**Verdict:** opposite direction on format; shares our respect for honest prerequisites.

#### tup wrote the strictest rules, with no room for verbs

Mike Shal's ["Build System Rules and Algorithms"](https://gittup.org/tup/build_system_rules_and_algorithms.pdf) (2009) sets out rules "which any useful build system must follow":

1. **Scalability:** an update takes "time that is proportionate to the changes".
2. **Correctness:** undoing a change returns the system to its earlier state.
3. **Usability:** "There must not be different ways of building the system that the user must remember in order to accommodate rules 1) or 2)."

The third rule is the nearest written precedent for our one-command-for-everyone rationale. But it is about clean versus incremental builds, not about humans versus CI. The paper also asks "why developers still rely on outmoded concepts like a 'clean' build."

**tup enforces its rules as errors** ([tup manual](https://gittup.org/tup/manual.html)):

- Reading an undeclared generated file fails, and so does writing an undeclared output.
- "Only one command may write a given file".
- "there is no clean target".

It "will detect if your build description isn't parallel-safe, and tell you". It runs on "Linux, OSX, and Windows" ([tup home page](https://gittup.org/tup/)), prints its graph with `tup graph`, and keeps includes local.

**It departs from us in two ways:** it has no tasks at all (no test, no deploy), and it offers an optional Lua parser ([tup Lua parser](https://gittup.org/tup/lua_parser.html)).

**Verdict:** aligned by philosophy on strictness; opposite on S5.

#### Ninja gave up hand-authoring because "making decisions is slow"

Ninja's manual states its trade openly. "Where other build systems are high-level languages, Ninja aims to be an assembler", and "when convenience and speed are in conflict, prefer speed." Its explicit non-goals include ([The Ninja build system](https://ninja-build.org/manual.html)):

- "convenient syntax for writing build files by hand";
- "build-time customization of the build. Options belong in the program that generates the ninja files";
- "build-time decision-making ability such as conditionals or search paths. Making decisions is slow."

**How it works:**

- It runs everything in parallel, with one command string per edge.
- On Windows it passes the command "directly to CreateProcess", with no shell.
- It tracks mtimes plus each command line in `.ninja_log`.
- It ships the best inspection toolkit in the lineage: `-t graph`, `-t browse`, `-t query` and `-t targets`.
- Since 1.12.0 its scheduler orders jobs along the critical path, using runtime history ([Ninja v1.12.0](https://github.com/ninja-build/ninja/releases/tag/v1.12.0)).

Evan Martin's retrospective puts it plainly: "it allowed me to make Ninja stupid but quick". He also writes: "I regret not spending more time researching before building" ([The Success and Failure of Ninja](https://neugierig.org/software/blog/2020/05/ninja.html)).

**Verdict:** incidentally aligned, for speed. It matches our format goals but gives up on files written by hand.

### The lifecycle lineage: fixed names, free implementations

Every quote in this subsection was re-checked against its raw source page with curl on 2026-11-09.

#### GNU standard targets and Automake wrote the contract down in the 1990s

The GNU Coding Standards say: "All GNU programs should have the following targets in their Makefiles:". The list includes all, install, uninstall, clean, distclean, dist and check, and all "should be the default target" ([Standard Targets for Users](https://www.gnu.org/prep/standards/html_node/Standard-Targets.html); text read from the [gnulib source mirror](https://raw.githubusercontent.com/coreutils/gnulib/master/doc/make-stds.texi)). The chapter's copyright dates back to 1992, and the parent document was updated on November 4, 2026 ([standards source mirror](https://raw.githubusercontent.com/coreutils/gnulib/master/doc/standards.texi)). Parameters travel through make variables such as prefix and DESTDIR, not through target arguments.

Automake states the benefit to consumers: "The Makefile too should follow some established conventions. The result? A unified build system that makes all packages almost indistinguishable by the installer. In its simplest scenario, all the installer has to do is to unpack the package, run `./configure && make && make install`, and repeat with the next package to install" ([Introducing the GNU Build System](https://www.gnu.org/software/automake/manual/html_node/GNU-Build-System.html), Automake manual; [source mirror](https://raw.githubusercontent.com/autotools-mirror/automake/master/doc/automake.texi)).

**Verdict:** aligned by philosophy. Convention enforces it, not the tool.

#### Maven states the thesis verbatim; Maven 4 adds hooks, not verbs

Maven's lifecycle guide states our thesis almost word for word: "For the person building a project, this means that it is only necessary to learn a small set of commands to build any Maven project, and the POM will ensure they get the results they desired" ([Introduction to the Build Lifecycle](https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html)). The default lifecycle has 23 phases, and a plugin goal "may be bound to zero or more build phases". The guide goes on: "A goal not bound to any build phase could be executed outside of the build lifecycle by direct invocation." So Maven fixes the lifecycle entrypoints, not every entrypoint.

**Maven 4 extends the fixed lifecycle with uniform hooks instead of new verbs.** "Every lifecycle phase now has a `before:` and an `after:` phase". The old pre- and post- phases "which were only available for selected phases and had inconsistent naming, are deprecated. They only act as aliases now and might be removed in the future. Don't use them!" ([What's new in Maven 4](https://maven.apache.org/whatsnewinmaven4.html)).

**Maven 4 is still not GA.** The latest is 4.0.0-rc-7 (2026-09-24), after four years of prereleases. Maven 3.10.0 shipped GA on 2026-09-27 ([Maven Releases History](https://maven.apache.org/docs/history.html)).

**Verdict:** aligned by philosophy, and the direct source of S5.

#### Scripts To Rule Them All fixed the names and put the logic in script/

Jon Maddox wrote on the GitHub blog in 2015: "At GitHub, we have normalized on a set of script names for all of our projects". The reasons he gives: "A consistent bootstrapping experience across all our projects reduces friction and encourages contribution", and "Another advantage of consistent script names is language agnosticism" ([Scripts to Rule Them All](https://github.blog/engineering/scripts-to-rule-them-all/)). The verbs are bootstrap, setup, update, server, test, cibuild and console.

**Three choices diverge from ours:**

- CI gets its own verb (cibuild), separate from the human test verb.
- console takes an optional environment argument.
- The logic lives in the script/ directory that our essay calls the untested glue ghetto.

**Verdict:** aligned by philosophy on fixed names; opposite on where the logic lives.

#### 3 Musketeers runs the same commands everywhere through Make and Docker

3 Musketeers (2018 to present) combines Make, Docker and Compose under the tagline "Test, build, and deploy your apps from anywhere, the same way!" It promises "Run the same commands no matter where you are" and "Feel confident that if it works locally, it will work in your CI/CD server" ([3 Musketeers](https://3musketeers.pages.dev/)). It is the closest public match to the essay author's own setup, where `make <x>` on the host runs `make <x>` again inside a container. Its reasons for choosing Make were not retrieved, because its about page returned 404.

**Verdict:** aligned by philosophy on running the same thing everywhere, as far as the landing page goes.

#### Gradle moves toward a declarative surface over tested plugins, not fixed verbs

**Verbs.** Gradle's Base plugin "adds a structure to the build that promotes consistency in how they are run", with assemble, check and build as umbrellas that other plugins attach to ([The Base Plugin](https://docs.gradle.org/current/userguide/base_plugin.html)). Any plugin can register any task name, so these are conventions, not reserved verbs.

**Logic.** On logic, Gradle has moved our way. The docs say "The Gradle runtime does not enforce a specific style for build logic". They also say "The end goal of every build script should be to only contain declarative language elements", with logic moved into plugins that can be tested on their own ([Authoring Maintainable Builds, Gradle 8.2](https://docs.gradle.org/8.2/userguide/authoring_maintainable_build_scripts.html)).

**Declarative Gradle.** Announced on 2023-11-10, it diagnoses the problem in our words: "We've seen projects in the wild that mix declarative and imperative code and make build scripts that are long and complex". It plans "a restricted DSL that separates the software definition and build logic" and disallows "Generic control flow and calls to arbitrary methods" ([Declarative Gradle](https://blog.gradle.org/declarative-gradle)). In 2026 it is still an experimental early-access preview where "no compatibility is guaranteed". It also promises "Complete flexibility for build engineers and advanced users" ([Declarative Gradle project site](https://declarative.gradle.org/)).

**A practitioner receipt.** Square's migration: "we wanted to eliminate all conditional logic", with convention plugins covered by "a thorough suite of integration tests" ([Herding Elephants](https://developer.squareup.com/blog/herding-elephants/)).

**Verdict:** aligned on restricting what most build-file authors touch. Gradle is not converging on fixed verbs, and it never calls its DSL a mistake.

#### Amper, now the Kotlin Toolchain, bets on declarative configuration

The Amper FAQ keeps a door open for "The Kotlin DSL, or a limited form thereof", then says: "Having said that, we believe that the declarative approach to project configuration has significant advantages over the imperative approach. Declarative configuration is easily toolable, recovery from errors is much easier, and interpretation is much faster" ([Amper FAQ](https://github.com/JetBrains/amper/blob/release/0.3/docs/FAQ.md)). The repo was archived on 2026-05-29 with the note "Amper is now part of Kotlin Toolchain" ([JetBrains/amper](https://github.com/JetBrains/amper)). The Kotlin Toolchain describes itself as "a unified entry point into Kotlin" with "a simple declarative configuration" ([JetBrains/kotlin-toolchain](https://github.com/JetBrains/kotlin-toolchain)). Its maturity label in late 2026 was not confirmed. One irony: werk's author "can't" with Java tools, while the Kotlin world moves to the declarative model he shares.

**Verdict:** aligned by philosophy on restriction.

#### Pants lets plugins extend a fixed set of goals

"Pants commands are known as _goals_, such as `test` and `lint`" ([Goals](https://www.pantsbuild.org/stable/docs/using-pants/key-concepts/goals)). Plugin authors are told: "For many plugin tasks, you will be extending existing goals, such as adding a new linter to the `lint` goal". That is Maven's binding of goals to phases in another form. The escape hatch is explicit: "you may instead want to create a new goal, such as a `publish` goal" ([Goal rules](https://www.pantsbuild.org/stable/docs/writing-plugins/the-rules-api/goal-rules)). A sentence about a "consistent user interface" turned up in a search summary but could not be confirmed, so do not quote it.

**Verdict:** aligned in shape; the reason is unconfirmed.

#### Meson and Starlark keep the build language small and push logic elsewhere

**Meson.** The FAQ answers "Why doesn't meson have user defined functions/macros?" with "Build systems should be quick to write and quick to understand, functions muddle this simplicity". To "Why is Meson not just a Python module", it answers by linking a page titled "Against The Use Of Programming Languages in Configuration Files" ([Frequently Asked Questions](https://mesonbuild.com/FAQ.html)).

**Starlark.** Its design principles include "Hermetic execution. Execution cannot access the file system, network, system clock." and "Simplicity. We try to limit the number of concepts needed to understand the code." ([bazelbuild/starlark](https://github.com/bazelbuild/starlark)). Its design notes explain the missing while loop: "Support for unbounded loops (e.g. `while`) would encourage users to write more complex code". They add that "The goal for Starlark is to provide a configuration language", and "CPU-intensive computations are better written in another language" ([Starlark design document](https://github.com/bazelbuild/starlark/blob/master/design.md)).

**Dhall.** It makes the same trade for safety: "Dhall is not a Turing-complete programming language, which is why Dhall's type system can provide safety guarantees" ([Safety guarantees](https://docs.dhall-lang.org/discussions/Safety-guarantees.html)).

None of these says the outside code must be tested. That step is ours.

**A note on Thibaud.** His post praises CMake and Meson for handling header dependencies ("Both CMake and Meson will do that automatically"). On r/cpp he narrowed his claim: "The makefile as an output of a meta-build system (Cmake of meson) is fine." For tasks, the post recommends just ("My personal go-to is just") and praises just's argument checking ([The case against Makefiles](https://thibaud.space/2026/10/the-case-against-makefiles.html); [com_kieffer on r/cpp](https://www.reddit.com/r/cpp/comments/1xiz5ce/the_case_against_makefiles/19s5dg4if2pc2/)).

**Verdict:** aligned by philosophy on S6.

#### cargo-xtask puts logic in a real package and leaves verbs free

matklad's cargo-xtask (2018) describes itself as "way to add free-form automation to a Rust project, a-la `make`, `npm run` or bespoke bash scripts". It "doesn't require any other binaries besides `cargo` and `rustc`", and "Unlike bash, it can more easily be cross platform, as it doesn't use the shell" ([matklad/cargo-xtask](https://github.com/matklad/cargo-xtask)). It is a convention, not a tool: "This repository serves as a specification of such configuration", and it is "not an officially recommended workflow". It puts automation into a real Rust package, which matches our "logic in a real package" rule. But its README makes no claim about testing, and it leaves verbs free-form.

**Verdict:** incidentally aligned on where logic lives; opposite on fixed verbs.

## How the two foil posts landed: Reddit pushed back on Thibaud, and nobody outside discussed Jarv

### Thibaud's own Reddit threads defended Make

Thibaud posted his essay himself, as u/com_kieffer, to [r/cpp](https://www.reddit.com/r/cpp/comments/1xiz5ce/the_case_against_makefiles/) on 2026-10-29 and to [r/programming](https://www.reddit.com/r/programming/comments/1xl5irk/the_case_against_makefiles/) on 2026-11-01. He answers there as the author ("I added a meson example just for you!"), and the post now has a Meson example. On Hacker News it got 5 points and one comment ([HN](https://news.ycombinator.com/item?id=50326532)), and Lobsters has no story from his site. Both Reddit threads were mostly hostile to the post. One reply to its opening line, "Makefiles are archaic technology", was simply "Sigh. Chesterton's fence." ([lalaland4711 on r/programming](https://www.reddit.com/r/programming/comments/1xl5irk/the_case_against_makefiles/19rzrd19aryuc/)).

**Comments that defended Make's restrictions:**

- "What makes make so well suited to this is that it's an utterly horrible tool for anything else. I have no temptation to start making my makefiles clever or complex." ([Shrink_Laureate](https://www.reddit.com/r/programming/comments/1xl5irk/the_case_against_makefiles/19s1gnqmdylnk/))
- "I want them because inevitably I'm going to have to change one of my build tools and I want to still be able to run make format, make build, make test etc. without having to learn new commands." The same commenter adds: "your Makefiles should be as thin as you can get them. Delegate hard." ([fixermark](https://www.reddit.com/r/programming/comments/1xl5irk/the_case_against_makefiles/19s0hdwsmczz6/))
- On r/cpp, a direct answer to "edges, not nodes": "you don't get that the edges are important because they describe relationships and constratints without the need for semnatic knowledge" (sic) ([forknull](https://www.reddit.com/r/cpp/comments/1xiz5ce/the_case_against_makefiles/19s2ttecex1hg/)).
- "It's a shame all anti-Make blogposts tend to be made by people who don't really understand Make." ([double-you](https://www.reddit.com/r/programming/comments/1xl5irk/the_case_against_makefiles/19s0v0qqy0v1f/))

**Comments that wanted Make to change:**

- A wish for task arguments ([JeffLeafFan](https://www.reddit.com/r/programming/comments/1xl5irk/the_case_against_makefiles/19rzppwfualus/)).
- "I absolutely hate that every command line is a separate process" ([rsclient](https://www.reddit.com/r/programming/comments/1xl5irk/the_case_against_makefiles/19rzsvx3x3x2b/)).
- A wish for prerequisites that run only in sequence ([WoodyTheWorker](https://www.reddit.com/r/programming/comments/1xl5irk/the_case_against_makefiles/19rzmdkx476zp/)).
- "These days lots of tools _dont_ write input and output files" ([donalmacc](https://www.reddit.com/r/programming/comments/1xl5irk/the_case_against_makefiles/19rzkf0fme5ur/)).

Thibaud's own reply in that thread names what he values: "Newer version of just even support defining --arguments, and cached rules which track dependencies." and "The killer feature is script rules." ([com_kieffer on r/programming](https://www.reddit.com/r/programming/comments/1xl5irk/the_case_against_makefiles/19s1on141h8o5/)).

**What he changed.** His revision log has two entries that answer Reddit:

- **October:** "Try to clarify the argument in response to the \_gentle\_ critiques from the gentlemen of reddit", followed by the r/cpp address as plain text.
- **November:** "Address some of the criticisms from posting to /r/programming on reddit", with that thread linked.

The page links neither Hacker News nor Lobsters. He added a section that opens: "For the sake of exposition, in the previous sections, I took some shortcuts which were amply dissected by commenters on reddit." ([The case against Makefiles](https://thibaud.space/2026/10/the-case-against-makefiles.html)). On r/cpp he narrowed his claim: "In my bubble (embedded software), make is often used as the build system. ... The makefile as an output of a meta-build system (Cmake of meson) is fine." ([com_kieffer on r/cpp](https://www.reddit.com/r/cpp/comments/1xiz5ce/the_case_against_makefiles/19s5dg4if2pc2/)).

Two lines in the post:

- On broken parallel builds: "This is definitely a skill issue."
- After showing how to bolt help output and argument checks onto a Makefile: "Make is inherently flexible, somebody out there will always have a solution to your problem. You just have to remember to copy them into every new project you do." That is the Makefile effect in his own words (see the end of the next section).

### Jarv's post drew no independent discussion

**No outside discussion anywhere.** No Lobsters story links to blog.jarv.dev or runtool.dev ([Lobsters search](https://lobste.rs/search?q=runtool&what=stories&order=relevance)). No Hacker News submission of "The Edge-and-Node Trap" was found, and the earlier "The Discovery Tax" got 5 points ([HN](https://news.ycombinator.com/item?id=49856008)).

**On Reddit, only his own launch posts.** In late September 2026 he posted run as /u/while_True_meme on [r/SideProject](https://www.reddit.com/r/SideProject/comments/1wsk5zn/i_got_tired_of_being_the_makefile_person_at_work/) (no comments) and [r/crewai](https://www.reddit.com/r/crewai/comments/1wt25eu/i_got_tired_of_being_the_makefile_person_at_work/). The posts promise "Built-in MCP Server: AI agents discover and run your project tools with a strict, typed schema for args/options. Zero hallucinated flags." They also report: "We have a few teams using it at work now (more or less fully replacing Make and npm scripts)". The example task in those posts is `test(filter = "") { cargo test $filter }`, a test verb that takes a parameter. Every outside comment on r/crewai was about the risks of parameters (see S4 below).

**The post itself, checked against the raw page:**

- It says "To make Make work for tasks, you pay The Phony Tax".
- It lists run's advantages, among them "Zero .PHONY declarations."
- In its worked example, the agent's failed call is `make test-worker` and its successful one is `make test SERVICE=worker` ([The Edge-and-Node Trap](https://blog.jarv.dev/the-edge-and-node-trap)).

The tax in his own example comes from a target that takes a parameter.

### Agents: more voices treat the Makefile as the interface than ask for MCP

Among the 2025–2026 voices that the sweeps found, seven treat a Makefile as the agent's interface and two point the other way.

- **Armin Ronacher**, ["Agentic Coding Recommendations"](https://lucumr.pocoo.org/2025/6/12/agentic-coding/) (2025-06-12; 36 points on [Lobsters](https://lobste.rs/s/9hzjeh)):
  - "Example: I place critical tools into a Makefile. A make dev command starts my services via a process manager."
  - On MCP: "Honestly: at this point I barely use it, but I do use it. The reason I barely use it is because Claude Code is very capable of just running regular tools."
  - "Tools need to be protected against an LLM chaos monkey using them completely wrong."
- **u/RandalSchwartz on r/AI_Agents** (probably Randal L. Schwartz; not confirmed), in ["Why I replaced my 20-step AI agent prompt checklist with a 1976 Unix Makefile"](https://www.reddit.com/r/AI_Agents/comments/1x17saa/why_i_replaced_my_20step_ai_agent_prompt/):
  - "LLMs have seen millions of Makefiles in pre-training, so they resolve target: prerequisites way more reliably than prose rules."
  - He also reports a failure mode: "if a target has 5 or more prerequisites on a single line, the model builds up "verification momentum" after checking the first four and blows right past the human approval gate at position 5."
- **On r/devops:** "Keep Makefiles as your per-service entrypoint. ... you can still call `make build` from each service without your AI agents needing to learn a new build dialect." ([ScholarMedical](https://www.reddit.com/r/devops/comments/1v2ppv2/how_are_you_setting_up_build_systems_in_monorepos/oyxs6o5/))
- **The rest:**
  - Anhaia's guide (see S4 below).
  - An iOS developer who found that "the Makefile wrapping xcodebuild and the verification skill did more for output quality than any amount of written guidance" ([Iron-Ham on r/iOSProgramming](https://www.reddit.com/r/iOSProgramming/comments/1rz6h9y/how_i_got_an_ai_coding_agent_to_actually_respect/)).
  - An r/devops commenter whose agent kept suggesting Make ([onbiver9871](https://www.reddit.com/r/devops/comments/1v2ppv2/how_are_you_setting_up_build_systems_in_monorepos/oyxab3g/)).
  - A Mastodon post: "since LLMs take the pain away I can have a single tool that works for all the programming language I use and doesn't need to be installed" ([gotofritz](https://hachyderm.io/@gotofritz/117512827022023754)).

The other side is Jarv's MCP thesis, plus one report that "Claude Code ignored the make targets and struggled until i had to point it to them" ([vincentdesmet on r/devops](https://www.reddit.com/r/devops/comments/1v2ppv2/how_are_you_setting_up_build_systems_in_monorepos/oyzmysh/)). That matches the HN anecdote in correction 16. Agents use Make well once pointed at it, but they do not always find it unprompted.

## Seven requirements have precedent, three are contested, three spots are blank

**What people ask for.** Two tallies measure the wishes. They count different things, so read the columns separately:

- **Hacker News:** comments that mention a topic, on either side, across 22 large threads from 2017 to 2026 (about 3,600 comments).
- **Reddit and Lobsters:** distinct commenters who took a side. The threads are:
  - Lobsters threads from 2017 to 2026;
  - the two 2026 Reddit threads on Thibaud's post;
  - 2025–2026 Reddit threads on werk, the Makefile effect, monorepo builds and agents.

The agent row also includes three blog posts and one Mastodon post.

| Wish | Hacker News: comments mentioning it | Reddit and Lobsters: commenters taking a side | Our spec |
|---|---|---|---|
| Task arguments or parameters | about 141 | 4 for; 2 for few or none | Opposes S4 |
| `.PHONY` friction | about 132 | not tallied | S5 agrees with the diagnosis |
| Windows | about 126 | 5 | S10 agrees |
| Tabs and whitespace | about 124 | not tallied | Silent |
| Content hashes or command-line tracking instead of mtime | about 81 | 9 | S11 agrees; command-line tracking is not yet explicit |
| Graph inspection | about 79 | not tallied | S9 agrees |
| "Already installed" | about 67 | not tallied | Cuts against any new binary |
| Target listing or built-in help | about 55 | 6 | S8 agrees |
| Same verbs in every repo | about 49 | 12 for; 1 against | S4 and S5 agree |
| Makefiles as the agent interface | about 30 (agents, LLMs or MCP, either side) | 7 for; 2 against | Agrees |
| Keep logic out of build files and CI YAML | not tallied | 8 | S6 agrees |
| Convention over configuration | not tallied | 7 | S5 agrees |
| A real language or embedded runtime | not tallied | 4 | Opposes S6 |
| One shell per recipe | not tallied | 3 | Opposes S3 |
| Imports or modules | not tallied | 3 | Partly opposes S7, which forbids only remote imports |
| A sane default job count | not tallied | 4 | Not in the spec |
| Spaces in file names | not tallied | 4 | Not in the spec |
| Prerequisites that run only in sequence | not tallied | 1 | Opposes S2 |

**What the tallies show:**

- On Hacker News, task arguments lead.
- Among Reddit and Lobsters commenters who took a side, the same verbs in every repo (12) and smarter change detection (9) lead, while task arguments trail (4 for, 2 against).
- Outside parameters, both venues agree with the spec far more often than they oppose it.

### Strong precedent: S1, S2, S6, S7, S8, S9 and S10

**S1 and S2: file DAG and unordered parallel prerequisites.** Every tool in the make lineage keeps file targets, and the people who left them say so:

- just's author: "Just doesn't have file-based dependencies, so it's not a build system, just a command runner" ([rodarmor on HN](https://news.ycombinator.com/item?id=34318483)).
- On Lobsters: "These are task runners, not really Make alternatives. None of these things do file dependency tracking" ([Qyriad](https://lobste.rs/c/tezooy)), and "My biggest issue with Just is that it do not supports running tasks in parallel" ([hauleth](https://lobste.rs/c/dmotdx)).

The one objection to prepare: Task and mise now skip work based on file checksums or timestamps ([Task up-to-date checks](https://taskfile.dev/docs/guide/up-to-date); [mise task configuration](https://mise.jdx.dev/tasks/task-configuration.html)). The line between tasks and files is blurring from the task-runner side.

On S2, precedent is wide:

- mk "does not define the order of execution of independent recipes".
- Ninja "always executes commands in parallel", where "Make defaulted to running commands serially" ([The Success and Failure of Ninja](https://neugierig.org/software/blog/2020/05/ninja.html)).
- werk "assumes that all recipes that don't have an edge between them in the dependency graph can be run in parallel" ([werk book](https://simonask.github.io/werk/)).
- GNU Make 4.4 added `--shuffle` to catch exactly what Thibaud complains about: "Most makefiles I have had the misfortune of encountering fail when run in parallel" ([The case against Makefiles](https://thibaud.space/2026/10/the-case-against-makefiles.html)).
- run makes parallelism opt-in.

Two wishes push back:

- Prerequisites that run only in sequence ([WoodyTheWorker on r/programming](https://www.reddit.com/r/programming/comments/1xl5irk/the_case_against_makefiles/19rzmdkx476zp/)).
- A default job count, because "Plain -j on a large project is basically a fork bomb" ([mallardtheduck on r/programming](https://www.reddit.com/r/programming/comments/1xl5irk/the_case_against_makefiles/19rzujwgowkdd/)). The spec says nothing yet about how many jobs to run by default.

**S6: no embedded runtime, friction stated up front.** The precedent is strong: werk, Ninja's non-goals, Meson, Starlark, Dhall, tup's error-enforced rules and makesure. Practitioners back the "logic elsewhere" half:

- "For simplicity, I try to turn any recipe where I would want a control structure into its own script ... and test it independently" ([llimllib on Lobsters](https://lobste.rs/c/6txolc)).
- On CI YAML: "the best way to say, "Run this command" is to let me give the command" ([jlarocco on Lobsters](https://lobste.rs/c/xkbakr)).

No tool adds our next step, that the outside code must be tested. Counter-currents exist even in the lineage:

- GNU Make's Guile and loaded objects;
- tup's and knit's Lua;
- the dcjones/mk polyglot attribute;
- just's "Recipes can be written in arbitrary languages, like Python or Node.js" ([Just Programmer's Manual](https://just.systems/man/en/));
- run's polyglot functions.

**S7: local include only.** This is standard in the make lineage. The tools that moved away make good receipts:

- mmake's URL includes and its "simply fork a project" answer.
- Task's experimental "loading Taskfiles over HTTP or Git and managing trust, checksums and cached copies" ([Task guide](https://taskfile.dev/docs/guide)).
- mise's "`file` also accepts HTTP(S) URLs and `git::` URLs" ([mise task configuration](https://mise.jdx.dev/tasks/task-configuration.html)).
- Lask's imports "pinned by content hash" ([lask-task-runner/lask](https://github.com/lask-task-runner/lask)).

**S8: built-in target help.** Listing targets is the most widely shipped feature in the field. remake, Shake, werk, knit, mmk3, mmake, makext, bmk, pydoit, run, just, Task and mise all have it, and GNU Make master now has names-only `--print-targets`. The "self-documenting Makefile" genre has run for ten years ([Self-Documented Makefile on HN, 2016](https://news.ycombinator.com/item?id=11195539); [How to list all the targets on a Makefile, 2020](https://news.ycombinator.com/item?id=23702756); [No-Code Self-Documenting Makefiles, 2026](https://news.ycombinator.com/item?id=49503962)). On Reddit, one reader called the usual copied help recipe "a little gnarly". The next replied: "A little gnarly? It's unacceptable in any codebase besides absolutely single run shell commands." ([Muhznit](https://www.reddit.com/r/programming/comments/1xl5irk/the_case_against_makefiles/19rzle827dh5s/); [SP-Niemand](https://www.reddit.com/r/programming/comments/1xl5irk/the_case_against_makefiles/19rzlmj0gn7s2/)). What is rare is putting project targets inside `--help` itself. Only Shake does that (see the design questions below).

**S9: DAG inspection.** Many tools offer it: `tup graph`, Ninja's `-t graph`, `-t browse` and `-t query`, werk's `--dot` and `--explain`, knit's text, tree and dot graphs, makepp's makeppgraph, and remake's profile. Make itself does not, though graph requests to GNU go back to 2009. One HN comment sums up the wish: "Considering that all build systems must keep a dependency graph internally, it's surprising how many of them make it incredibly difficult to inspect why things are being rebuilt" ([saagarjha on HN](https://news.ycombinator.com/item?id=29871438)).

**S10: native Windows.** Ninja, tup, werk and GNU Make all run natively. The deeper finding is that **prior art reaches Windows by dropping the shell**, not by porting the binary:

- werk has "no dependency on a POSIX-compliant shell (or any shell)".
- Ninja hands commands to CreateProcess.
- cargo-xtask is cross platform because "it doesn't use the shell".

GNU Make itself builds natively on Windows. Yet commenters still say "Getting make to work on Windows ... the same way as on Linux is basically impossible" ([braggerxyz, Show HN: Werk](https://news.ycombinator.com/item?id=42672863)), because recipes assume sh. On r/programming, the handle that posted "Introducing Werk" answered the portability claim: "Portability? Except of course if you want to use it on by far the most popular desktop operating system." ([simonask_](https://www.reddit.com/r/programming/comments/1xl5irk/the_case_against_makefiles/19s05vurdscgx/)). Another reader replied that "Make works quite well on Windows. You do need to set SHELL to cmd.exe and stuff" ([double-you](https://www.reddit.com/r/programming/comments/1xl5irk/the_case_against_makefiles/19s0w2zpgreoz/)). That bears on how S3 is worded (see the conclusion).

### Contested: parameters, per-line shells and zero-install

**S4 runs against the loudest wish on Hacker News.** Arguments and parameters are the most-mentioned topic in the HN tally above. On Reddit and Lobsters the picture is milder: 4 commenters asked for task arguments and 2 argued for few or none, while 12 asked for the same verbs in every repo. Typical voices:

- "Accepting arguments alone seems to be a pretty big value add" ([bpicolo on HN](https://news.ycombinator.com/item?id=34318833)).
- "`NAME=value make target` is less pleasant than `make target --name=value` would have been" ([staticshock on HN](https://news.ycombinator.com/item?id=41607573)).
- "I’ve used make a lot for aliasing convenient commands but I never could find a way to easily pass in arguments to use in the underlying script/command." ([JeffLeafFan on r/programming](https://www.reddit.com/r/programming/comments/1xl5irk/the_case_against_makefiles/19rzppwfualus/))
- "Most of the build commands are parametrized. But more is getting to the point where the standardized commands are limiting. So I need to move away." ([ali-hussain on r/devops](https://www.reddit.com/r/devops/comments/1v2ppv2/how_are_you_setting_up_build_systems_in_monorepos/oz080kv/))
- Even on werk's thread, commenters asked how to pass CC or task arguments ([Show HN: Werk](https://news.ycombinator.com/item?id=42672863)).

Every popular runner ships parameters. Consider the agent-first guide ["A Makefile Is the Best Agent Doc: 10 Targets Every Repo Needs Before an Agent Touches It"](https://dev.to/gabrielanhaia/a-makefile-is-the-best-agent-doc-10-targets-every-repo-needs-before-an-agent-touches-it-2kbh) (2026-11-02, marked "AI-assisted"). It says "Hermes, a CI job, a Stop hook and you at the terminal all run the same make check". Even so, its test-one target requires a FILE= argument. Its dev target is different: it reads PORT with `PORT ?= 3000`, and the post notes that "PORT=4000 make dev and make dev PORT=4000 both work". That is the environment-variable escape hatch that S4 itself allows. The author also discloses an interest: "I build Hermes IDE, so weigh this section with that in mind."

**The only outside questions about run were about what parameters let an agent do.** On Jarv's r/crewai launch post, one reader asked: "are the declared args validated before they get interpolated into the body, or does the schema just check types and trust the template? A stray ; in filter escaping into the shell would be a bad day for an agent-driven run. And is there a way to mark a task as agent-invisible or read-only - deploy(prod) feels like exactly the kind of task I'd want an agent to be able to list but never actually call." ([kantorcodes1 on r/crewai](https://www.reddit.com/r/crewai/comments/1wt25eu/i_got_tired_of_being_the_makefile_person_at_work/pd15ydr/); he then pitched his own security tool). Another asked how permissions work "in a shared CI environment" ([Baide-Warframe60](https://www.reddit.com/r/crewai/comments/1wt25eu/i_got_tired_of_being_the_makefile_person_at_work/pdo2mcd/)).

Jarv answered that "Arguments are passed natively as separate argv elements to the underlying interpreter". He added that "the current MCP spec treats all registered tools as callable endpoints", and suggested a `[ -t 0 ]` terminal check inside the task body as a guard ([while_True_meme on r/crewai](https://www.reddit.com/r/crewai/comments/1wt25eu/i_got_tired_of_being_the_makefile_person_at_work/pd2xs54/)). A parameterless `make test` has no argument surface to validate. A deploy verb that takes no arguments has nothing to inject.

The no-parameters rule has precedent, but none of it rests on our reason:

- makesure refuses arguments to keep the build file self-contained.
- Ninja says "Options belong in the program that generates the ninja files".
- tup and redo take target names only.

The essay must also decide whether `VAR=value` overrides count as parameters. GNU's standards use them (prefix, DESTDIR), and so do werk and makesure (`-D`).

**S3 is where the lineage itself turned away.** mk sends the whole recipe to one shell. In jobs mode, BSD make does the same and tells users "It is more efficient to correct the scripts rather than turn backwards compatibility on" ([make(1), FreeBSD 15.0](https://man.freebsd.org/cgi/man.cgi?query=make&sektion=1&manpath=FreeBSD+15.0-RELEASE)). GNU Make offers `.ONESHELL`. Jacob Davis-Hansson's widely shared post recommends `.ONESHELL` because it "lets you do things like loops, variable assignments and so on in bash" ([Your Makefiles are wrong](https://tech.davis-hansson.com/p/make/)). redo makes every recipe a full shell script.

On Reddit and Lobsters the split continues:

- **Against:** "And I absolutely hate that every command line is a separate process, so you can't set a variable on one line and use it on the next." ([rsclient on r/programming](https://www.reddit.com/r/programming/comments/1xl5irk/the_case_against_makefiles/19rzsvx3x3x2b/))
- **For, with the clearest technical reason found anywhere:** "separate subshells allows the exit status of each line to be checked independently regardless of whether the shell you've chosen has implicit errexit behaviour. It also allows make to perform better logging of commands and their outputs." The same commenter adds that "using shell loops in Makefiles has been a serious red flag basically every time I've seen it" ([jclulow on Lobsters](https://lobste.rs/c/ylwkv8)).
- **A critic's concession:** in the same thread, a critic granted the alternative we want: "Either Make should have always done the right thing here, or it should have insisted on single-line recipes." ([dkl on Lobsters](https://lobste.rs/c/7yu546))

A stricter version of S3 does have precedent, each for its own reason:

- werk: one command per entry, no shell at all, for Windows.
- Ninja: one command per edge, for speed.
- tup: one `sh -e -c` command per single-line rule, for correctness.

So the "fresh shell per line" detail is contested, while "one command per line, no control flow in recipes" has allies.

**S12 cannot be fully won by any new binary.** Only GNU Make, and bmake on the BSDs, come preinstalled. Every successor thread runs into this:

- "everyone on my team has `make` already and so does our CI environment. The marginal improvement is not worth it for us" ([groomlake on HN](https://news.ycombinator.com/item?id=50326629)).
- "I am never going to abandon a working tool … for something users have to go out of their way to install" ([PittleyDunkin, Show HN: Werk](https://news.ycombinator.com/item?id=42672863)).
- "make has one big advantage: it is universal and I can assume it's already installed. I'm sure just is quite nice but it doesn't have that property." ([BadlyCamouflagedKiwi on r/programming](https://www.reddit.com/r/programming/comments/1xl5irk/the_case_against_makefiles/19rznd6hcse90/))
- On werk's own Reddit launch: "(Really, though, the biggest issue is the chicken-and-egg thing of “pretty much nobody is going to have this installed”, making it useless for onboarding.)" ([chucker23n on r/programming](https://www.reddit.com/r/programming/comments/1hzkwqw/introducing_werk_a_simple_build_tool_and_command/m6vplky/))

Prior art offers three partial answers:

- **Export to plain files.** knit can emit a Makefile or shell script.
- **A single file you can vendor into the repo.** Hancho "fits in a single Python file with no dependencies and no installation required" ([aappleby/hancho](https://github.com/aappleby/hancho)), and fabricate is "a single Python file" ([brushtechnology/fabricate](https://github.com/brushtechnology/fabricate)).
- **A checked-in bootstrap.** dotcmd checks in a script that downloads its own runtime ([dotcmdhq/dotcmd](https://github.com/dotcmdhq/dotcmd)).

The static-format half of S12 is easier. Ninja and werk qualify. Build systems whose dependencies are only discovered while running (redo, Shake) cannot be analyzed statically ([Build Systems à la Carte](https://www.microsoft.com/en-us/research/uploads/prod/2018/03/build-systems.pdf)).

### Not found: reserved verbs, the parity rationale, and CI-aware change detection

**S5: not found.** The researchers searched the make lineage, the 2022–2026 successors, the task runners, about 50 HN queries, the web, Lobsters and the reachable parts of Reddit. None found a tool or proposal that reserves Maven-style lifecycle names in place of `.PHONY`. The nearest relatives solve parts of it:

- **Per-rule markers:** mk's and knit's V attribute.
- **A keyword split:** werk's task/build.
- **Phony rules that share the file namespace:** Ninja's phony, and Shake's phony, which "does not name a file (despite living in the same namespace as file rules)" ([Development.Shake](https://hackage-content.haskell.org/package/shake-0.19.9/docs/Development-Shake.html)).
- **A convention without enforcement:**
  - GNU's standard targets;
  - a shared common.mk where the lifecycle rules are still "just .phony. one-liner rules" ([m_mueller on HN](https://news.ycombinator.com/item?id=21568196));
  - a Lobsters comment on automake: "If you stay within the lines, `automake` provides a convention-over-configuration way to get all of this" ([jackdk on Lobsters](https://lobste.rs/c/p33tef)).
- **Fixed verbs outside the make world, with no file namespace:** Maven, Pants and Bazel.
- **Verbs users can define and parameterize:** mmk3 ([knusbaum/mmk3](https://github.com/knusbaum/mmk3)).

**The closest statements of the reason for S5:**

- **Lobsters, 2022:** "Make run, make build, make dist, make test, etc is pretty straightforward to use." and "The key problem is that Makefiles do not clearly make the distinction between asset-producing rules and automation rules (.PHONY)." ([sebastien on Lobsters](https://lobste.rs/c/yy1447))
- **r/devops, 2026:** the nearest thing to "Maven for Make" quotes a now-deleted comment and seconds it: "First define a uniform contract per service—build, test, package, deploy—and keep Make as a thin developer-facing wrapper." That commenter then recommends just because "it handles Args, Env, Dependent steps, and in-line scripts all very nicely" ([r/devops](https://www.reddit.com/r/devops/comments/1v2ppv2/how_are_you_setting_up_build_systems_in_monorepos/oyztppo/)).
- **Davis-Hansson's case for `.PHONY`** is the collision that reserved names prevent: "Imagine you stashed some data in a file named test." He goes on to show how that ends: "and voila you’ve deployed to prod without running tests" ([Your Makefiles are wrong](https://tech.davis-hansson.com/p/make/)).

**One warning to plan for.** A Lobsters critic of Maven's model wrote: "Maven also created a pretty specific and complex build pipeline and expected you to attach plugins to the fixed steps and order it understood." ([dkl on Lobsters](https://lobste.rs/c/qn0q3p)). The defense came in reply: "Unlike Makefile, I would not be able to write a `pom.xml` from scratch, but I can tell you, why every single plugin or dependency is needed." ([franta on Lobsters](https://lobste.rs/c/o96qj4)). The lesson for S5 is to keep the reserved vocabulary short, with no plugin machinery attached to it.

**npm, the nearest task-runner relative.** It reserves test, start, stop and restart beside free-form `npm run <name>` scripts ([npm scripts](https://docs.npmjs.com/cli/v11/using-npm/scripts)). Our own `npm run test:ci` example shows that reserved verbs alone do not stop names from multiplying. The no-parameters rule and the convention have to do that work.

**The four-consumer parity rationale: not found as an argument for refusing parameters.** "Same verbs in every repo" is a mainstream belief. One practitioner wrote: "Being able to drop into any repo at work and expect that `make init`, `make test` and `make start` will by convention always work … has saved me a lot of time" ([Nexialist on HN](https://news.ycombinator.com/item?id=32442007)). Automake, Maven, GitHub, Shopify ("Consistency is important across development environments", [Dev - Shopify's All Purpose Development Tool](https://devproductivity.github.io/devproductivity.io/dev-shopifys-all-purpose-development-tool/index.html)) and 3 Musketeers all say a version of it.

Parity between humans, agents and CI has now been voiced several times:

- Anhaia's "Hermes, a CI job, a Stop hook and you at the terminal all run the same make check".
- ScholarMedical's agents that need no "new build dialect".
- fixermark's stable `make test` across tool changes.

Nobody in the record derives "refuse parameters" from it. The closest statements on arguments come at it from other directions:

- **Copy-paste drift:** "Tangentially this is why I love to write one click scripts that almost always do the right thing when run with no args (or as few as possible). Otherwise it's just users copy and pasting long command line invocations that none of them seem to understand. I'll reverse search and see three slightly different versions of the same script with one minor change to one of the 10 arguments." ([DeltaBurnt on r/programming](https://www.reddit.com/r/programming/comments/1hyhzdb/be_aware_of_the_makefile_effect_enosuchblog/m6hzkhq/))
- **Environment variables as the escape hatch:** "The more you can do with "just" env args the more straightforward things are." ([rtpg on Lobsters](https://lobste.rs/c/g46nks))
- **Agents:** "give agents simple "tool calls" instead of needing to divine the correct args/flags every time" ([verdverm on HN](https://news.ycombinator.com/item?id=49061116)).

Nobody names the pipeline author as a fourth consumer. Scripts To Rule Them All went the other way, giving CI its own verb. No public "every repo in our org has `make test`" policy was found either.

The nearest older wish for a successor is a 2017 Lobsters comment: "maybe the world needs a modern `make`. Not a *smarter* build tool, but one with less 40-year-old-Unix design sensibilities". It goes on to ask for "a nicer, more robust language" and "a library of common functionality", which pull against S6 and S7 ([inactive-user on Lobsters](https://lobste.rs/c/xxlula)).

**S11 framed around short-lived runners: not found.** Hashing itself has deep precedent:

- Peter Miller's cook used "fingerprints to supplement file modification times" ([cook README](https://ftp.riken.jp/GNU/non-gnu/cook.README)). He is the same Peter Miller who wrote "Recursive Make Considered Harmful".
- Also: makepp's signatures, redo-c, goredo, knit's default hashes, Task's default checksum method, and Shake's digest mode.
- Make's maintainer called hashing "an absolute must-have" in 2003 (quoted below).
- A 2017 HN commenter: "As soon as you move a build system to CI, you need something better than mtime" ([ejholmes on HN](https://news.ycombinator.com/item?id=15045004)).
- On Reddit and Lobsters:
  - "Content-based change detection is the real solution." ([jms_nh on r/programming](https://www.reddit.com/r/programming/comments/1xl5irk/the_case_against_makefiles/19rzry6brsmch/))
  - On werk: "My only suggestion is to have file contents (as tracked by hash) as part of the outdatedness formula instead of mod time per se." ([carlana on Lobsters](https://lobste.rs/c/d9jddx))
  - For a few small services, "stay on make and add content-hash skip logic" ([Floss_Patrol_76 on r/devops](https://www.reddit.com/r/devops/comments/1v2ppv2/how_are_you_setting_up_build_systems_in_monorepos/oyy884g/)).

What was not found:

- any successor designed around short-lived runners or cache eviction;
- any successor whose docs discuss CI cache eviction;
- any tool that guarantees a side effect runs only once;
- any design that ties "never skip this" to reserved lifecycle names.

### The Makefile effect: copying is the symptom that restriction treats

William Woodruff's ["Be aware of the Makefile effect"](https://blog.yossarian.net/2025/01/10/Be-aware-of-the-Makefile-effect) (2025) names the habit: "Tools of a certain complexity or routine unfamiliarity are not run de novo, but are instead copy-pasted and tweaked from previous known-good examples." The post drew 431 points on [Hacker News](https://news.ycombinator.com/item?id=42663231) and 135 on [Lobsters](https://lobste.rs/s/k55ds9). What he says about it:

- **It is a design signal:** "the tool (or system) is too complicated (or annoying) to use from scratch".
- **Some complexity is essential and some is not:** "dependency graphs are an inherent complexity of build systems, but remembering the difference between $< and $^ in Make is not."
- **CI YAML is another case.**
- **His questions for tool authors:** "Does it need to be configurable?" / "Does it need syntax of its own?"

The most-copied snippet in the Reddit thread is the help recipe. One reader called it "generic enough that you can just slap it into a template that gets copy/pasted into every Makefile" ([Muhznit](https://www.reddit.com/r/programming/comments/1xl5irk/the_case_against_makefiles/19rzle827dh5s/)). Thibaud describes the same effect as Make's flaw ("You just have to remember to copy them into every new project you do"). DeltaBurnt's no-arguments comment above came out of the same discussion.

Two replies:

- **People and deadlines, not tools:** "This is simple copy/paste error with a side of cargo cult." ([Garbi on Lobsters](https://lobste.rs/c/ks8k11))
- **The opposite lesson:** "The problem is a lack of support for proper libraries or parameterization, so you end up copying and pasting the previous solution and tweaking it." ([SanityInAnarchy on r/programming](https://www.reddit.com/r/programming/comments/1hyhzdb/be_aware_of_the_makefile_effect_enosuchblog/m6k8vnj/))

## Prior art on the open questions

### --help

**The problem is confirmed.** GNU Make prints its own help before reading the Makefile, and `make test --help` prints make's usage too (local test, GNU Make 4.3; [Options Summary](https://www.gnu.org/software/make/manual/html_node/Options-Summary.html)). None of the task runners checked puts project tasks in its own `--help`. just, Task, mise, cargo-make, Rake, npm, Gradle, Maven and Pants each send `--help` to the runner and use a second command for tasks: `--list`, `-T`, `tasks`, `help goals` or `npm run`. Our Stockroom data says 92.7% of agent help calls use dashed flags. Every one of these designs misses those agents on the first try.

**The one merged precedent is Shake.** Its `--help` lists every registered phony and file-pattern target, with optional docs, in the same output as Shake's own flags. It also has a way to hide internal targets ([Development.Shake](https://hackage-content.haskell.org/package/shake-0.19.9/docs/Development-Shake.html)). That works because a Shake build is a compiled program that owns its own argument parser.

**Supporting precedents:**

- git lists user aliases in `git help -a`, and `git <alias> --help` prints the alias definition before the man page ([git-help](https://git-scm.com/docs/git-help)).
- Gradle's `--help` points users to its help task ([Gradle command-line interface](https://docs.gradle.org/current/userguide/command_line_interface.html)).
- The Command Line Interface Guidelines say "you should be able to add `-h` to the end of anything and it should show help" ([Command Line Interface Guidelines](https://clig.dev/)).
- just's unreleased master prints a recipe's help when given `--help` and stops ([just README](https://github.com/casey/just/blob/master/README.md)).
- Turborepo now documents its task description field as "A human- or agent-readable description of what a task does" ([Turborepo configuration](https://v2-8-8-canary-5.turborepo.dev/docs/reference/configuration.md)).

**No single tool does all of the following.** The pieces that exist:

- npm lists "Lifecycle scripts included in" a package separately from scripts "available via `npm run`" (local test).
- `gradle help --task`, `task --summary`, `rake -D` and just's master branch print a target's description without running it.
- Task (`--list` versus `--list-all`), Rake (`-T` versus `-AT`), Gradle (`tasks` versus `--all`) and just's private recipes can hide undocumented targets.
- just, remake's `#:`, Marmelab's `##` and werk's `--list` take descriptions from comments above targets.
- `task --list --json`, `just --dump --dump-format json`, `mise tasks ls --json` and `pants help-all` emit machine-readable lists. makefile-mcp derives a schema from plain targets ([wdm0006/makefile-mcp](https://github.com/wdm0006/makefile-mcp)).
- A bare invocation lists targets in npm, just's default-list setting and mise's picker. Make runs the first target.

### DAG inspection

Prior art falls into three families:

- **Static terminal trees:** `ninja -t targets depth`, `rake -P`, and Gradle's taskTree plugin and `--task-graph` ([Gradle command-line interface](https://docs.gradle.org/current/userguide/command_line_interface.html)).
- **Exports:** makefile2graph's dot, Mermaid and PlantUML output; `ninja -t graph` and `-t browse`; `bazel query --output graph` ([Bazel query guide](https://bazel.build/query/guide)); `turbo --graph` ([Turborepo run reference](https://turborepo.dev/docs/reference/run)); `nx graph` ([Nx graph](https://nx.dev/docs/features/explore-graph)).
- **Timing views after a run:** Bazel's profile has a "Critical Path" row ([JSON trace profile](https://bazel.build/advanced/performance/json-trace-profile)); `cargo build --timings` helps "visualize the critical path of dependencies" ([Cargo timings](https://doc.rust-lang.org/cargo/reference/timings.html)); Shake has `--profile`; n2 and Ninja produce Chrome traces.

**Only the timing views show a critical path, because a critical path needs durations.** Ninja's 1.12 scheduler gets its durations from `.ninja_log`. **No tool was found that draws parallel tracks as lanes in a terminal from the static graph.**

**Scraping Make's output for a graph is fragile.** makefile2graph needs `make -Bnd`, English debug messages (`LC_ALL=C`) and no sub-makes ([makefile2graph](https://github.com/lindenb/makefile2graph)). That shows the cost of rebuilding a graph from a runner that does not expose one.

**Path queries that do exist:** werk's `--explain`, mk's `-e`, knit's status tool, `bazel query somepath`, `pants paths` and `ninja -t query`. Bazel also has `--output maxrank`. A terminal renderer such as mermaid-ascii can draw layered tracks ([mermaid-ascii](https://github.com/AlexanderGrooff/mermaid-ascii)); no make-like runner was found that does this from the static graph.

### Change detection

["Build Systems à la Carte: Theory and Practice"](https://www.microsoft.com/en-us/research/wp-content/uploads/2020/04/build-systems-jfp.pdf) classifies how build systems decide to rebuild (the paper calls these "rebuilders"):

- **Dirty bit:** Make's file-is-older test is the weakest rebuilder. The paper also confirms our "zero-storage" reading: Make's dirty bit "is not under the control of MAKE; rather it is existing file-system information that has been repurposed".
- **Verifying traces:** the stronger local alternative. The tool records what each input looked like last time and rebuilds "if something has changed". Examples: apenwarr/redo's stat tuple, redo-c, goredo, makepp, Ninja's `.ninja_log`, bmake meta mode, Task's checksum method and mise.
- **Constructive traces:** shipping results between machines. Examples: Bazel, the Gradle build cache, and (by the researchers' inference) Turborepo and Nx.

**What happens on a fresh runner:**

- **Verifying-trace tools degrade safely.** The trace is missing, so everything rebuilds: correct, only slower.
- **Make also rebuilds everything on a fresh clone,** because the outputs do not exist. As one commenter put it, "Any CI I've seen starts from a fresh repo checkout and rebuilds everything every time" ([majewsky on HN](https://news.ycombinator.com/item?id=15044333)).
- **Make goes wrong when outputs travel without their trace.** Checkout stamps every source with the current time, so an output restored from a cache can look stale or fresh depending on order. git restore-mtime patches this, but only with full history ([MestreLion/git-tools](https://github.com/MestreLion/git-tools)).

**Caches are evicted and can be poisoned:**

- GitHub Actions "will remove any cache entries that have not been accessed in over 7 days", deletes by last access once a repository passes its 10 GB default, and since late 2025 sweeps every hour ([dependency caching](https://docs.github.com/en/actions/reference/workflows-and-actions/dependency-caching); [changelog](https://github.blog/changelog/2025-09-29-new-date-for-enforcement-of-cache-eviction-policy/)).
- Cache keys "are set entirely on the client-side", which enables poisoning ([The Monsters in Your Build Cache](https://adnanthekhan.com/2024/05/06/the-monsters-in-your-build-cache-github-actions-cache-poisoning/)).
- Bazel warns that "two users with different compilers installed will wrongly share cache hits" ([Remote Caching](https://bazel.build/remote/caching)).

**No tool promises "runs once".** "Turborepo assumes that your tasks are deterministic" ([Turborepo caching](https://turborepo.dev/docs/core-concepts/caching)). Nx says cacheable tasks, "given the same input... should always result in the same output" ([Nx cache task results](https://nx.dev/docs/features/cache-task-results)). Gradle says "cacheable tasks should have repeatable task outputs" ([build cache concepts](https://docs.gradle.org/current/userguide/build_cache_concepts.html)). The paper names the side-effect case: such tasks are "volatile", and "volatile tasks cannot be cached".

**Commenters expect the recipe itself to count as an input.** On r/cpp this came up again and again:

- "The most important input is always forgotten in those sort of build files: the build files themselves." ([OrphisFlo](https://www.reddit.com/r/cpp/comments/1xiz5ce/the_case_against_makefiles/19rurqzxdph39/))
- "modern build tools will record the command line that generated a target and automatically regenerate it if it's different. ... So in an automated system (for example CI, or even a local developer), you can't just do an incremental build." ([OrphisFlo](https://www.reddit.com/r/cpp/comments/1xiz5ce/the_case_against_makefiles/19rvwfasgvz5t/))

Thibaud's own post has a section on it: "If a build rule in the Makefile changes, the output will not be rebuilt." Prior art already handles it:

- Ninja rebuilds when "the command line changed".
- bmake's meta mode "compares the CMD entries".
- illumos dmake caches "the entire command line used to produce something" in `.make.state` files ([jclulow on Lobsters](https://lobste.rs/c/dqmeew)).
- werk's cache records the recipe.
- Bernstein made the same point in 2003, in a note titled "Target files depend on build scripts".

apenwarr's fast path is a stat tuple ("mtime, size, inode number, file mode, and owner uid and gid") that is never trusted on its own ([mtime comparison considered harmful](https://apenwarr.ca/log/20181113)).

No prior art was found that ties "never skip this" to reserved lifecycle names.

## Corrections to our existing notes

Evidence below was re-checked against raw source pages on 2026-11-09.

1. **Thibaud and Meson**.
   - **Claim:** "Recommends CMake/Meson for C/C++ builds" and "Use CMake/Meson for C and `just` for tasks."
   - **Evidence:**
     - The post praises CMake and Meson for handling header dependencies ("Both CMake and Meson will do that automatically"). It explicitly recommends just for tasks ("My personal go-to is just").
     - On r/cpp he narrowed his claim to Makefiles written by hand: "The makefile as an output of a meta-build system (Cmake of meson) is fine." ([com_kieffer on r/cpp](https://www.reddit.com/r/cpp/comments/1xiz5ce/the_case_against_makefiles/19s5dg4if2pc2/))
     - He added a Meson example after an r/cpp request and revised the post twice in response to Reddit ([The case against Makefiles](https://thibaud.space/2026/10/the-case-against-makefiles.html)).
     - The post says "This is definitely a skill issue."
     - The page was last modified on 2026-11-02.
2. **"You do not invent new top-level entrypoints"**.
   - **Evidence:** Maven's guide says a plugin goal "may be bound to zero or more build phases. A goal not bound to any build phase could be executed outside of the build lifecycle by direct invocation." ([Introduction to the Build Lifecycle](https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html)). The default lifecycle has 23 phases. The guide's main phases are validate, compile, test, package, verify, install and deploy. Maven 4 adds `before:` and `after:` hooks to every phase instead of new verbs.
3. **Gradle "begging users"**.
   - **Claim:** "until Gradle spent a decade begging users to move logic back into precompiled convention plugins (re-inventing Maven Mojos with extra steps)."
   - **Evidence:**
     - Gradle's docs say "The end goal of every build script should be to only contain declarative language elements".
     - The Declarative Gradle announcement (2023) says: "Generic control flow and calls to arbitrary methods will be disallowed. You will be able to write your build logic in any JVM language, such as Java, Kotlin, or Groovy, but that logic will reside in plugins".
     - Its project site says it "is an experimental project, now in its third Early Access Preview (EAP)" and "Currently, no compatibility is guaranteed".
     - Neither source calls the DSL a mistake, and the site promises "Complete flexibility for build engineers and advanced users". Gradle is not adopting fixed verbs.
4. **The Bell Labs circuit breaker**.
   - **Claim:** the friction "is a circuit breaker engineered by smart people at Bell Labs".
   - **Evidence:**
     - The research found no source on the original intent.
     - It did find the Bell Labs successor, Plan 9's mk, removing the rule as an improvement ("unlike make, mk feeds the entire recipe to the shell rather than running each line of the recipe separately"). BSD make in jobs mode and GNU `.ONESHELL` went the same way.
     - A practitioner stated this reason: "separate subshells allows the exit status of each line to be checked independently regardless of whether the shell you've chosen has implicit errexit behaviour. It also allows make to perform better logging of commands and their outputs." ([jclulow on Lobsters](https://lobste.rs/c/ylwkv8))
5. **Paul Smith on hashing** (no claim yet; this one is pre-emptive).
   - **Evidence:** A search-engine summary says he "argued against content-hash rebuilding" in 2003. The primary message says the opposite: "it's actually an absolute must-have if make is to survive too much into the future: systems are getting too fast to rely on timestamps anymore. It's on the TODO list". He also wrote: "Currently make is completely stateless, because we only compare relative timestamps between files" ([bug-make, 2003-03-05](https://lists.gnu.org/archive/html/bug-make/2003-03/msg00004.html)).
   - "Completely stateless" is the primary-source version of the zero-storage point. "Huge leap, because now make must become stateful" is his version of the cache worry.
6. **"50-minute CI builds" and the short-lived-runner framing**.
   - **Evidence:**
     - On a fresh runner with no cache, every tool rebuilds everything, Make included, because the outputs do not exist.
     - File targets therefore shorten CI runs only once outputs travel through a cache, and that travel is exactly where Make's mtime model goes wrong.
     - An r/cpp commenter adds a second gap: without command-line tracking, "in an automated system (for example CI, or even a local developer), you can't just do an incremental build" ([OrphisFlo on r/cpp](https://www.reddit.com/r/cpp/comments/1xiz5ce/the_case_against_makefiles/19rvwfasgvz5t/)).
   - **Corrected claim:** file targets skip the zip on every rerun on your machine, and in CI too once outputs travel between runs. The open problem is what state travels with the filesystem, and what the tool does when that state is missing, stale, or evicted.
7. **BSD make's** `-B`.
   - **Claim:** `-B` means "execute commands sequentially in a single shell for backwards compatibility".
   - **Evidence:** The FreeBSD 15.0 man page says the reverse: "-B Try to be backwards compatible by executing a single shell per command and by making the sources of a dependency line in sequence." Under `-j`, by default, "the entire script for the target is fed to a single instance of the shell" ([make(1), FreeBSD 15.0](https://man.freebsd.org/cgi/man.cgi?query=make&sektion=1&manpath=FreeBSD+15.0-RELEASE)). OpenBSD's make was not checked.
8. **"1988" and "40 lines"**.
   - **Evidence:** GNU Make's `--help` arrived in version 3.63 (1993) ([GNU make NEWS](https://cgit.git.savannah.gnu.org/cgit/make.git/plain/NEWS)). A local test on GNU Make 4.3 printed 47 lines of make's own options, not C-compiler flags. Help prints before the Makefile is read, and `make test --help` does it too.
9. **"No built-in** `--list`**"**.
   - **Evidence:** No released GNU Make lists a project's targets. Master gained `--print-targets` on 2024-01-08, with names only and no descriptions, and that commit was still unreleased as of 2026-11-09. remake lists targets from `#:` comments.
10. **"make lacks a clean human-readable graph printer"**.
    - **Evidence:** Still true of Make itself. Requests go back to 2009. Add-ons exist: makefile2graph, lazymake, makefile-graph, and remake's profile. Some of them scrape make's English debug output.
11. **Build Systems à la Carte**.
    - **Claim:** it "Decomposes all build systems (Make, Maven, …) along … Scheduler (topological vs. restarting) × Rebuilder (dirty bit, mtime, verifying traces, constructive traces)" and "explains why Make and Maven sit in different cells".
    - **Evidence:**
      - The paper's table has three schedulers (topological, restarting, suspending) and four rebuilders (dirty bit, verifying traces, constructive traces, deep constructive traces).
      - mtime is how Make implements its dirty bit, not a separate rebuilder.
      - The table lists Make, Excel, Ninja, Shake, CloudBuild, Bazel, Buck and Nix, and the researchers found no Maven row.
      - The paper also names one system it cannot model, Fabricate ([Build Systems à la Carte](https://www.microsoft.com/en-us/research/uploads/prod/2018/03/build-systems.pdf); [Build Systems à la Carte: Theory and Practice](https://www.microsoft.com/en-us/research/wp-content/uploads/2020/04/build-systems-jfp.pdf)).
    - **Corrected claim:** the grid has no Maven row, and mtime is not its own rebuilder.
12. **Davis-Hansson**.
    - **Evidence:**
      - The post recommends `.ONESHELL` ("ensures each Make recipe is ran as one single shell session, rather than one new shell per line").
      - It lists "Don’t use tabs" among its main takeaways, replacing them with `.RECIPEPREFIX = >` ([Your Makefiles are wrong](https://tech.davis-hansson.com/p/make/)). That cuts against S3 and against keeping the tab.
      - Its top Lobsters reply pushed back: "If you want to heavily invest into GNUisms (bash, RECIPEPREFIX, ...) and make your makefile less portable, go ahead" ([FRIGN on Lobsters](https://lobste.rs/c/auiuln)).
      - He also writes: "The file system is a fundamental part of Make, don’t fight it". His case for `.PHONY` is the deploy-to-prod collision in S5.
13. **McGinnis "does not cover the zero-flag contract"**.
    - **Evidence:**
      - He writes "When I type make test in a project I haven't touched in two years and it just works, that's the value of choosing boring technology" ([You Don't Need a Justfile](https://mcginniscommawill.com/posts/2026-04-17-you-dont-need-a-justfile/)). He does not discuss flags.
      - In February 2026 he also built makefile-mcp, where "every Makefile target becomes an executable tool named `make_<target>`" and the only documented tool parameter is `dry_run` ([wdm0006/makefile-mcp](https://github.com/wdm0006/makefile-mcp)).
14. **Jarv's figures**.
    - **Claim in our notes:** 4 tool calls and about 2,100 tokens, against 1 call and about 90 tokens.
    - **Evidence:** The post gives two sets of figures ([The Edge-and-Node Trap](https://blog.jarv.dev/the-edge-and-node-trap)):
      - **Comparison table, Make or just:** "~1,800–2,500 tokens of shell exploration" and "3 to 6 exploratory calls".
      - **Comparison table, run over MCP:** "~80 tokens of tool metadata" and "1 atomic call".
      - **Worked example:** it ends "Total: 4 tool calls, ~2,100 tokens consumed" against "Total: 1 tool call, ~90 tokens consumed". The notes' numbers are the worked example's.
      - Neither set states a method. The term itself first appears in an earlier post, "The Discovery Tax" (2026-09-19; [HN](https://news.ycombinator.com/item?id=49856008)).
    - **Corrected claim:** the 4-call and ~2,100-token figures are the worked example. The table's ranges are the other set. The 4-call trace sits below the table, and its failed call is to a target that takes a parameter.
15. **Bazel's "fatal flaw"**.
    - **Evidence:** Bazel has a fixed set of built-in commands (build, test, run and others; the names were checked against the reference page), with no documented way to add new ones ([Bazel command-line reference](https://bazel.build/reference/command-line-reference)). Starlark's design notes refuse unbounded loops because they "would encourage users to write more complex code", and say "CPU-intensive computations are better written in another language".
16. **"An AI coding agent guesses make test on Turn 1"**.
    - **Evidence:** No measurement exists in the research. Anecdotes point both ways:
      - **Against:** "It keeps running custom CLI commands when it has instructions to use Makefile targets" ([foofloobar on HN](https://news.ycombinator.com/item?id=47678065)), and "Claude Code ignored the make targets and struggled until i had to point it to them" ([vincentdesmet on r/devops](https://www.reddit.com/r/devops/comments/1v2ppv2/how_are_you_setting_up_build_systems_in_monorepos/oyzmysh/)).
      - **For:** "LLMs have seen millions of Makefiles in pre-training, so they resolve target: prerequisites way more reliably than prose rules" ([u/RandalSchwartz on r/AI_Agents](https://www.reddit.com/r/AI_Agents/comments/1x17saa/why_i_replaced_my_20step_ai_agent_prompt/)). That is an assertion, not a measurement.
      - **AGENTS.md** is "used by over 60k open-source projects" and recommends a "Build and test commands" section ([AGENTS.md](https://agents.md/)). Its own samples use only pnpm, with tool-specific flags such as "Run `pnpm turbo run test --filter <project_name>`", and never mention make.
17. **Design Question 5 frames change detection as timestamps versus hashes**.
    - **Evidence:**
      - Commenters name a third input: the recipe. On r/cpp, the most repeated objection was that Make ignores "the build files themselves" and does not "record the command line that generated a target" (OrphisFlo).
      - Ninja, bmake meta mode, illumos dmake and werk already track it, and Thibaud's own post lists it as a Make flaw.
18. **Copied help boilerplate**.
    - **Evidence:**
      - A reader of Thibaud's post called the copied help recipe "unacceptable in any codebase besides absolutely single run shell commands" ([SP-Niemand on r/programming](https://www.reddit.com/r/programming/comments/1xl5irk/the_case_against_makefiles/19rzlmj0gn7s2/)).
      - Woodruff's Makefile effect names the same pattern: a snippet that every project copies is a sign the tool is "too complicated (or annoying) to use from scratch".
      - Thibaud makes the same complaint: "You just have to remember to copy them into every new project you do."


## Coverage and confidence

**How each venue was read:**

- **Hacker News:** the Algolia API, which returns raw comment text.
- **Lobsters:** plain curl with its default user agent. A story's .json includes every comment with its score. Browser-like user agents get an Anubis challenge instead. Lobsters has no build tag, so build stories were found under other tags and by search.
- **Reddit:** read through its Atom RSS feeds.
  - The feeds carry no scores, vote counts or comment totals, so Reddit items here have a date and a handle only.
  - A thread feed returns at most 100 comments. The r/programming thread on Thibaud's post hit that cap, so a few comments may be missing.
  - Reddit rate-limited about every second request. As a result, r/golang, r/C_Programming, r/commandline and r/linux were not searched, and Reddit threads on knit, redo, tup, just and Taskfile were not fetched.
- **Bluesky:** the public search API returned 403 without a login.
- **Mastodon:** the #makefile and #make tag timelines on mastodon.social, read back to August 2023, had nothing on either essay. Full-text search needs a login.
- **gnu.org:** timed out or refused. GNU Coding Standards and Automake text was checked against GitHub mirrors of the texinfo source, and one Automake page through the Wayback Machine.
- **Savannah:** refused access. Bug #64571 was read through its bug-make mirror, and the maintainers' response to the graph-output proposals remains unknown.

**Quote verification (2026-11-09).** Every quote that the first version marked for a spot-check was downloaded again with curl from its raw source: 63 quoted passages on 29 pages, plus the facts beside them on 6 more pages. Each was compared after normalizing whitespace and HTML entities.

- **Exact:** 60 matched word for word. Some differ only in curly versus straight quotes, code formatting, link markup or texinfo markup.
- **Corrected:** 3. Amper's FAQ has "we believe", in lowercase, after "Having said that". Two Starlark principles use a period after the principle's name, not a colon.
- **Removed:** none. No passage was missing from its source.
- **Markers left:** none. Every source could be fetched by at least one route.

The same pass also fixed three things that were not quote wording:

- The Automake quote's link now points to "Introducing the GNU Build System", where it actually appears, instead of "Standard Targets".
- The claim that our Discovery Tax figures were wrong has been withdrawn (correction 14).
- Anhaia's PORT is now described as an environment variable rather than a target parameter.

**Quotes outside that pass:**

- The Lobsters and Reddit quotes were copied from raw story JSON and feeds.
- New quotes from Thibaud's, Jarv's, Davis-Hansson's and Anhaia's pages and from agents.md were checked against the same raw downloads.
- Quotes that were never marked came from pages the researchers read raw: READMEs, man pages, mailing-list HTML and HN API text. They were not downloaded a second time.
- The fetch tool paraphrased apenwarr's view on checksums ("can work, sometimes"). Do not quote it.

**Known only from search-result summaries, not from opened pages:**

- cook's later `--fingerprint-update` option and its 2010 changelog date;
- goredo's jobserver compatibility;
- the Chromium Siso announcement;
- Bazel "Builds without the Bytes" eviction behavior;
- GitHub's 2025-11-20 cache-size changelog;
- the 2026 "Clinejection" cache-poisoning chain;
- Kotlin Toolchain 0.11, Amper 0.10, and the Declarative Gradle roadmap and July 2026 newsletter;
- WSO2 agent-manager issue #2105;
- the old Nx docs heading "Cacheable operations need to be side effect free";
- the Nx 18 stale-cache deploy story.

**Unverified or not checked:**

- remake's maintenance status and star count; run's star count; werk's first tagged version.
- The 1987 date for mk, which is commonly cited, including in the HN title.
- Identities:
  - Thibaud's full name (his Reddit handle com_kieffer matches a "comkieffer" GitHub handle);
  - whether u/RandalSchwartz is Randal L. Schwartz;
  - whether u/simonask_ is werk's author (the same handle posted "Introducing Werk").
- Whether `mvn --help` lists project goals.
- just's remote imports, Task's embedded shell interpreter, and cargo-make's features.
- The output formats of Gradle's `--task-graph` and `mise tasks deps`.
- Whether Shake's report shows a critical path, and n2's exact change-detection design.
- Any GNU Make 4.5 plans.
- A Pants rationale sentence that surfaced in a search summary (do not quote it).
- A search claim that Turborepo's `cache: false` "does not mean always run", which the config reference contradicts.
- Claims in our own notes that this research did not test: Maven "solved in 2004", macOS shipping GNU Make 3.81, Make being preinstalled on every Mac, the POSIX.1-2024 MAKEFLAGS wording, and OpenBSD's make flags.

**Method limits:**

- The HN tally counts comments that match keyword patterns, not the stances they take. The Reddit and Lobsters tally counts distinct commenters who took a side, from a smaller set of threads. Do not add the two columns together.
- Star counts and dates are as of 2026-11-09.
- Scores come from documentation. The only local tests were of GNU Make 4.3, Rake 13.4.2, npm on Node 22 and git 2.34.
- GitHub searches were keyword- and topic-based, so a successor that uses none of the searched phrases could be missing.
