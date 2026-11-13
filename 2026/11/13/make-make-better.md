# make make Better

2026-11-13 - texarkanine

Everybody who gets fed up with Make ships a new task runner. [just](https://just.systems/), [Task](https://taskfile.dev/), and [run](https://runtool.dev/) each throw out the Makefile and invent a [justfile](https://just.systems/man/en/quick-start.html), a [Taskfile.yml](https://taskfile.dev/docs/reference/schema), or a [Runfile](https://runtool.dev/docs/runfile-syntax.html) to replace it, and each has a crowd cheering it on.

I have [previously argued](/2026/11/13/just-run-make.html) that the behaviors people hate about Make are Chesterton's Fences that should not be torn down. The *fair* complaints are a different set, and they are all about what it's like to *use* `make`: asking it for help, typing it bare, looking at what it's about to do.

None of these are about anything you wrote in your `Makefile`; every one lives in the `make` binary. Upstream GNU Make hasn't shipped a release since 4.4.1 in February 2023, and macOS still ships GNU Make 3.81 from 2006.

Keep the Makefile, keep every fence intact, and improve the program that reads it:

Let's **make `make` better**.

## What's Actually Broken in the Binary

### `make --help` Belongs to Make

Ask `make --help` and the binary answers about itself. GNU Make intercepts the flag before reading a line of your `Makefile` and prints its own option table, a feature dating to 1993.[^help-1993] `make test --help` ignores `test` and prints the same help text as before.

Ask `make help` instead and you are running a target. If the project's author wrote one called `help`, you get whatever they made it print. If they didn't:

```text
make: *** No rule to make target 'help'.  Stop.
```

So there are two things to ask about - the binary and the project - and Make has a contract for only one of them. No released version of GNU Make can list a project's targets; the development branch gained `--print-targets` in January 2024,[^print-targets-commit] which prints names only, and it still hasn't shipped.

The workaround is [five pasted lines](/2026/11/13/just-run-make.html#five-lines-beat-a-new-binary), and it is still a workaround. Copying it into every repository has been called [the Makefile Effect](https://blog.yossarian.net/2025/01/10/Be-aware-of-the-Makefile-effect): When a tool is "too complicated (or annoying) to use from scratch", people stop writing its files and start copying templates. Thibaud Chupin [said the same](https://thibaud.space/2026/10/the-case-against-makefiles.html) of Make's workarounds: "You just have to remember to copy them into every new project you do." 

Alas, no copy/pasted magic target can rescue `make --help` while the binary swallows the flag first.

In the session logs from my own three workstations, AI coding agents reached for a dashed help flag (`--help` or `-h`) in [92.7% of 1,042 help calls](/garden/cli-help-patterns.html#preliminary-field-data-from-stockroom), and a `make help`-style verb in only 2.2%. An agent following that 92.7% instinct in a Make repository gets Make's 1993 option table instead of your targets.

How to build a project is absolutely the build tool's question to answer - it surely knows! And while perhaps `make --help` should still answer about Make, there also must needs be a standard way to interrogate the project's own targets.

It is the binary's job to make that happen.

### Keystroke Savers from 1976

Two more warts date from an era when saving keystrokes on a slow terminal was worth a little magic, and nearly every Unix build compiled C. Or something like it. Or at least *compiled files.*

First, running bare `make` with no arguments executes whichever ordinary target happens to sit at the top of the Makefile - or at the top of the first file an `include` pulls in above it, which is why GNU Make had to add `.DEFAULT_GOAL` to wrestle control back. Saving four keystrokes over `make build` made sense in 1976.

Typing a bare command in an unfamiliar repository shouldn't kick off a mystery build. It should print some useful guidance and exit.

Second, GNU Make 4.4.1 still ships with 92 built-in implicit rules baked into the binary:[^other-makes-builtins] recipes for C, C++, Fortran, Pascal, Modula-2 (`.mod`), Ratfor (`.r`), TeX, and CWEB, plus rules for checking missing files straight out of RCS (`%,v`) and SCCS (`SCCS/s.%`). Back when almost every project compiled `.c` files into `.o` files, built-in recipes meant a tiny Makefile worked out of the box. Today Make orchestrates `pytest`, `cargo`, `docker`, and plenty else, and those 92 ghost rules only clutter debug traces and misfire when a filename matches one. Even `MAKEFLAGS += --no-builtin-rules` only started clearing them inside a Makefile in [GNU Make 4.0][make-news] (2013), so on macOS's stock 3.81 a Makefile can't even turn them all off by itself.

Those rules did their work back when nearly every build was C. A Make for 2026 should ship none of them.

### Make Keeps the Graph to Itself

A real graph - say, nine targets in three parallel tracks, three deep - is hard to see when its edges are scattered across nine rule definitions in a flat file read top-to-bottom.

GNU Make has no graph view of its own. [Requests to export the graph](https://web.archive.org/web/20251017115001/http://savannah.gnu.org/bugs/?25751) go back to 2009, and add-ons such as [makefile2graph](https://github.com/lindenb/makefile2graph) have to scrape Make's debug output to draw one.

The binary already builds the graph. It should print it like a proper Unix program.[^unix-philosophy]

### Nothing Enforces the Verbs

`make test` is only a convention. The GNU Coding Standards [say flat-out](https://web.archive.org/web/20261030235037/https://www.gnu.org/prep/standards/html_node/Standard-Targets.html): "All GNU programs should have the following targets in their Makefiles:" and list `all`, `install`, `clean`, `check`, and more. The Automake manual [sums up the result](https://web.archive.org/web/20261029155032/https://www.gnu.org/software/automake/manual/html_node/GNU-Build-System.html): "A unified build system that makes all packages almost indistinguishable by the installer." Nothing in Make itself enforces this, though, so one repository has `make check`, the next has `make test`, and a third invents `make test-ci`.

Nobody can guess the right name without a standard, and standards hold best when the build tool enforces them.

Maven started enforcing them in October 2005. At the time, its 1.0 release had let projects script their builds in a `maven.xml` file written in [Jelly](https://commons.apache.org/proper/commons-jelly/), an XML scripting language. Maven 2.0 [deleted](https://svn.apache.org/repos/infra/websites/production/maven/content/maven1.html) `maven.xml` and replaced it with a fixed lifecycle: `validate`, `compile`, `test`, `package`, `verify`, `install`, `deploy`. Plugins bind their goals to those phases, projects configure the plugins in a declarative `pom.xml`, and the logic lives in prepackaged plugins, each of which has passed its own test suite. Maven's [lifecycle guide](https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html) states the contract beautifully:

> For the person building a project, this means that it is only necessary to learn a small set of commands to build any Maven project, and the POM will ensure they get the results they desired.

A fixed lifecycle also answers most of the help question before anyone asks it. Nobody runs `mvn validate --help`: you know what `validate` is for before you clone the repository, and the `pom.xml` is the canonical, inspectable definition of what `validate` will do *here.*

Gradle took the opposite bet, turning the build file into a Groovy or Kotlin program - [an application in the delivery pipeline](/2026/11/13/just-run-make.html#its-just-no-place-to-run-an-application) - and lost.

Gradle's own documentation [now says](https://docs.gradle.org/8.2/userguide/authoring_maintainable_build_scripts.html) "The end goal of every build script should be to only contain declarative language elements", and since 2023 it has been building [Declarative Gradle](https://blog.gradle.org/declarative-gradle), where "Generic control flow and calls to arbitrary methods will be disallowed" and logic moves into plugins.

While the `make`, `just`, and `run` camps argue about what commands a repository should even have, Gradle's re-deriving from first principles what Maven's known for over two decades.

Maybe one project in ten thousand truly doesn't fit a standard lifecycle like Maven's. Before you decide yours is that one, ask who knows more about software lifecycles: the Apache Software Foundation, with twenty years of other people's builds behind it, or you and your new project.

> If you don’t see the use of Maven's lifecycle phases, I certainly won’t let you work around them. Go away and think. Then, when you can come back and tell me that you do see the use of them, I may allow you to create your own.

A better Make should reserve a short list of lifecycle verbs as tasks (not file targets) and hold every project to them. Maven-style.

### Timestamps Don't Travel

In 1976, using the filesystem's own timestamps as the build's cache key was a brilliant zero-storage trick. GNU Make's maintainer, Paul D. Smith, [described it in 2003](https://web.archive.org/web/20241018034053/https://lists.gnu.org/archive/html/bug-make/2003-03/msg00004.html): "Currently make is completely stateless, because we only compare relative timestamps between files". The same message calls content hashing "an absolute must-have if make is to survive too much into the future".

Take a file target:

```makefile
SRCS := main.py requirements.txt

function.zip: $(SRCS)
	rm -f $@
	zip -q $@ $(SRCS)
```

Make can only skip building `function.zip` when an earlier run left `function.zip` on disk with a newer timestamp than `main.py`. A fresh CI runner starts with a clean disk, so nothing gets skipped. Restore yesterday's `function.zip` from a CI cache and `git checkout` still trips you up: it stamps every source file with the current time rather than when the file last changed, so `main.py` looks newer than the cached zip and Make rebuilds it anyway.

Meanwhile, [GitHub says](https://docs.github.com/en/actions/reference/workflows-and-actions/dependency-caching) it "will remove any cache entries that have not been accessed in over 7 days" so a slow project will eventually repeat work even if none of its inputs change *and* the cache keys are perfect.

Further complicating matters, Make never notices when the recipe line itself changes in the Makefile: you've got to pay attention with the right incantation or just re-run the whole build lest ye be left with needed work uncompleted.

What build state should travel between machines, and what should the tool do when that state is missing, stale, or evicted? Nobody has a good answer yet, which figures: cache invalidation is one of the two hard problems in computer science.[^two-hard-things] Caching alone can't be the whole answer, either, because it tempts developers to count on cache hits to keep work from repeating - which holds only until the cache is evicted.

A better Make should consider file contents and recipe text instead of clocks, and clearly specify what it does on an invalidated *or missing* "cache" entry.

## Twenty-Six Tools and Still No Successor

Evan Martin, who wrote Ninja, admits in the retrospective ["The Success and Failure of Ninja"](https://neugierig.org/software/blog/2020/05/ninja.html): "I regret not spending more time researching before building".

So before proposing another tool, I went looking for the one I want across 26 build and task runners, from Plan 9's [mk](https://9fans.github.io/plan9port/man/man1/mk.html) to this year's crop of hotshot upstarts. Nobody has built it. What I found instead is strangers rebuilding the fences from ["just run make"](/2026/11/13/just-run-make.html), each for a different reason than mine:

- [Ninja](https://ninja-build.org/) refused build-time options, for speed.[^ninja-options] That is [the no-flags fence](/2026/11/13/just-run-make.html#targets-take-no-flags).
- [makesure](https://github.com/xonixx/makesure) refused task arguments, to keep the build file self-contained.[^makesure-arguments] Same fence.
- [tup](https://gittup.org/tup/) refused alternate build modes, for usability.[^tup-modes] Same fence again.
- [Bazel](https://bazel.build/)'s Starlark language refused `while` loops, to keep build code simple.[^starlark-loops] That is the fence against [running an application in your build](/2026/11/13/just-run-make.html#its-just-no-place-to-run-an-application).
- [Maven](https://maven.apache.org/) froze its lifecycle verbs back in 2.0, so that one small set of commands builds any project. That is the no-flags fence built one rail higher: Make refuses flags on a verb, and Maven fixes the verbs themselves. Both guard [commands every caller can guess](/2026/11/13/just-run-make.html#targets-take-no-flags).
- Et cetera, et cetera.[^more-fences]

The nearest thing to the shape I want is [remake](https://github.com/Trepan-Debuggers/remake), which "patched GNU Make 4.3 sources to add improved error reporting, tracing, target listing, graph visualization, profiling, and more." It proves that target listing and a graph view fit inside a binary that reads ordinary Makefiles. It is also a fork whose last release was in January 2022, and its target list waits behind a `--tasks` flag of its own that an agent has no reason to try.

Native Windows is the other gap. Make isn't pre-installed there and most Makefiles assume a POSIX shell, so for a developer who just happens to sit at a Windows workstation my answer is WSL or a [devcontainer](https://containers.dev/). A project that is Windows all the way down deserves better than that, and that's something else that a better Make could address.[^native-windows]

## A Make That Reads Your Makefile

Every fix lives in the binary, so a successor should be an improved binary that reads the Makefiles people already have. It keeps all five fences:

1. [Targets that can be files *or* tasks](/2026/11/13/just-run-make.html#a-target-is-a-file-until-you-say-otherwise)
2. [Prerequisites in no promised order](/2026/11/13/just-run-make.html#siblings-run-in-any-order)
3. [Targets that take no flags](/2026/11/13/just-run-make.html#targets-take-no-flags)
4. [A fresh shell for every recipe line](/2026/11/13/just-run-make.html#every-line-gets-its-own-shell)
5. [A language you don't program in](/2026/11/13/just-run-make.html#its-just-no-place-to-run-an-application)

What changes in the binary is the rest:

1. **Help and bare invocation:** there is one standard way to ask the binary for the project's own targets, wherever `make --help` itself ends up pointing, and a bare `make` prints guidance and exits without running anything.
2. **No 1976 ghost rules:** the 92 built-in implicit rules are gone.
3. **Graph inspection:** the binary prints the dependency graph it already builds, in a form other programs can read.
4. **Reserved lifecycle verbs:** how does it tell a task from a file without `.PHONY`? That's the neat part: you never tell it anything. **Reserve the lifecycle names**, Maven-style. A reserved name (`build`, `test`, `package`, `deploy`, `clean`, and friends) is always a task that no cache skips, and any other name is a file on disk - giving Make Maven's universal verb contract without Maven's XML plugin plumbing. Need a task with a different name? `.PHONY:` still works, and we could even add a clearer alias for the 21st century.
5. **Change detection without clocks:** file contents and recipe text decide what is stale, and the binary clearly specifies what it does when its saved state is invalidated or missing.
6. **The host's own shell on Windows:** a Windows build of the binary sends each recipe line to `cmd.exe` or PowerShell, the way a Unix build sends it to `sh`, and that port gets tested like the others.

### Must We Keep Makefiles?

[Yes.](/2026/11/13/just-run-make.html#must-we-keep-makefiles)

---

A returning reader has caught me by now: I've [argued](/2026/11/13/just-run-make.html#five-lines-beat-a-new-binary) that saving five lines of Makefile isn't worth deploying a new binary everywhere, and here I am asking for a new binary. Price the two trades side by side:

Moving to `just` or `run` costs a new binary on every machine before anyone can run a single task, a rewrite of every build file, **and the fences.** Nobody prices that last part until they're stuck maintaining an [untested glue ghetto](/2026/11/13/just-run-make.html#its-just-no-place-to-run-an-application) in their build tool. 

Our *better Make* binary reads the Makefiles you already have. Modern repositories keep working on day one without a rewrite[^day-one-compat] - even alongside machines still running stock `make` - and work *better* everywhere the new binary lands.

Best case, GNU Make sands its own edges and this tool never needs to exist.

But I've waited more than a decade for that while everyone else shipped tools that tear the fences down, so I might build the one that keeps them myself, if a reader convinced by this post doesn't beat me to it.

Keep your Makefiles. **make make better**.

---

## Footnotes & References

[^help-1993]: GNU Make's [NEWS][make-news] entry for version 3.63, dated 22 Jan 1993: "Make now accepts long options. There is now an informative usage message that tells you what all the options are and what they do."

[^print-targets-commit]: Paul D. Smith's [commit](https://web.archive.org/web/20240429135352/https://git.savannah.gnu.org/cgit/make.git/commit/?id=31036e648f4a92ae0cce215eb3d60a1311a09c60) of 8 January 2024: "Add an option to print a list of targets defined in the makefiles." GNU Make 4.4.1, still the latest release, came out in February 2023.

[^more-fences]: The list goes on. Two more, if you want to match them to their fences yourself: [Hume's paper on mk][mk-paper] says "Mk does not define the order of execution of independent recipes." [werk](https://github.com/simonask/werk)'s README says "`werk` will never be a scripting language."


[^other-makes-builtins]: GNU Make has company. POSIX [requires](https://pubs.opengroup.org/onlinepubs/9799919799/utilities/make.html#tag_20_76_13_09) a default rule set for C, lex, yacc, and shell scripts, and records that its authors debated dropping it: "They provide convenience, but do not enhance portability of applications." OpenBSD's [mk](https://github.com/openbsd/src/blob/master/share/mk/sys.mk) carries 40 suffix rules for C, C++, Fortran, Ratfor, Pascal, assembler, lex, yacc, and shell scripts. Microsoft's NMAKE has [predefined rules](https://learn.microsoft.com/en-us/cpp/build/reference/predefined-rules) too, and an `/R` switch to ignore them. Two tools already ship none. "Unlike make, mk has no built-in rules", says [Hume's paper on mk][mk-paper], and Ninja's [manual](https://ninja-build.org/manual.html) lists them among its non-goals: "Out of the box, Ninja has no rules for e.g. compiling C code."

[^unix-philosophy]: The [Unix philosophy](https://cscie2x.dce.harvard.edu/hw/ch01s06.html) is to build small, simple tools that do one thing well and compose them into larger systems. Here in particular, I mean: *"Design programs to be connected to other programs."*

[mk-paper]: https://9p.io/sys/doc/mk.html

[^two-hard-things]: "There are 2 hard problems in computer science: cache invalidation, naming things, and off-by-1 errors." <https://martinfowler.com/bliki/TwoHardThings.html>

[^ninja-options]: Ninja's [manual](https://ninja-build.org/manual.html#:~:text=Options%20belong%20in%20the%20program%20that%20generates%20the%20ninja%20files) lists "build-time customization of the build" among the things it deliberately leaves out: "Options belong in the program that generates the ninja files."


[^makesure-arguments]: Under "Omitted features" in makesure's [README](https://github.com/xonixx/makesure#omitted-features): "We deliberately don't support this feature. The idea is that the build file should be self-contained, so have all the information to run in it, no external arguments should be required."


[^tup-modes]: Rule 3 on page 7 of Mike Shal's 2009 paper, ["Build System Rules and Algorithms"](https://gittup.org/tup/build_system_rules_and_algorithms.pdf): "Usability: There must not be different ways of building the system that the user must remember in order to accommodate rules 1) or 2)."

[^starlark-loops]: Under "No unbounded loops" in Starlark's [design notes](https://github.com/bazelbuild/starlark/blob/master/design.md#no-unbounded-loops): "Support for unbounded loops (e.g. `while`) would encourage users to write more complex code."

[^native-windows]: Nothing in the fences requires POSIX. The shell fence is a fresh shell for every line and copy-paste parity with *your* terminal, and on Windows your terminal is `cmd.exe` or PowerShell.

	GNU Make's Windows port already gets halfway. Its [README](https://web.archive.org/web/20261113011611/https://raw.githubusercontent.com/mirror/make/4.4.1/README.W32) says that on a system with no Bourne shell, "All command lines will be put into batch files and executed via $(COMSPEC)", and admits that this style of execution "has not been tested that carefully". The mechanism is there; what's missing is the testing.

	A Makefile full of `cmd.exe` recipes won't run on Linux, but neither will the project it builds. And if you really need that, well, CMake can [generate platform-specific Makefiles](https://cmake.org/cmake/help/latest/manual/cmake-generators.7.html) for you...


[^day-one-compat]: What breaks are the 1976 holdovers this post drops on purpose: `./configure && make` scripts expecting bare `make` to run the first target, C builds leaning on the 92 implicit rules, and any Makefile where a reserved verb like `build` or `test` named an actual file on disk. None of those are the repositories people are fleeing for `just` or `run`.

[make-news]: https://web.archive.org/web/20241213073812/http://git.savannah.gnu.org/cgit/make.git/tree/NEWS
