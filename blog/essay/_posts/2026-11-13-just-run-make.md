---
layout: post
title: "just run make"
subtitle: "The fences the new task runners tear down were guarding your delivery pipeline."
description: "The task runners just and run win converts by removing Make's restrictions. Those restrictions are Chesterton's fences: they skip unchanged work, parallelize for free, give every caller the same commands, and keep an untested application out of your build."
author: texarkanine
category: essay
tags:
  - build-systems
  - chestertons-fence
  - ci-cd
  - harness-engineering
  - make
  - software-engineering
  - task-runners
---

In October 2026, Thibaud Chupin published ["The case against Makefiles"](https://thibaud.space/2026/10/the-case-against-makefiles.html). It opens:

> You don't need a Makefile. Whatever your use-case, there is a better tool. Makefiles are archaic technology, living on by force of inertia and notalgia [*sic*].

That opening is Thibaud's. With it comes familiar company, his objections and the usual ones beside them:

* "The fundamental mistake of Make is that it describes the edges of the build graph, not the nodes."
* Every task needs `.PHONY` above it.
* Recipe lines must start with a tab.
* Building two Docker images takes a family of near-duplicate targets that call back into `$(MAKE)` with a variable set.
* No built-in "help" mechanism to describe what a task does.
* Esoteric [DSL](https://en.wikipedia.org/wiki/Domain-specific_language) syntax.

So, for tasks, use Casey Rodarmor's [just](https://just.systems/): "My personal go-to is just."

A month later, Michael Jarvis published ["The Edge-and-Node Trap: Why Makefiles Were Never Meant for Tasks"](https://blog.jarv.dev/the-edge-and-node-trap). Jarvis takes Thibaud's case as settled, names the cost of `.PHONY` "The Phony Tax", and then makes the same kind of moves against `just`:

- **The Polyglot Wall:** `just` recipes are shell scripts, so "the moment you need real logic—parsing a JSON response from a remote registry, manipulating dates, checking semver boundaries, or reading a configuration file—you are thrown right back into bash's string manipulation nightmare".
- **The Discovery Tax:** an AI coding agent dropped into a repository has to read the Makefile or justfile, guess at arguments, fail, and retry, which costs "2,000 prompt tokens and four round trips just to run cargo test with a package filter."

So use [run](https://runtool.dev/), Jarvis's own task runner, built on the premise that "tasks are functions, not files." A Runfile holds typed functions with defaults, their bodies can be inline Python, Node, or Ruby, and `run --serve-mcp` hands every documented function to agents as a tool over the Model Context Protocol (MCP).

When Thibaud posted the essay to r/programming, one reply quoted its first line and [answered in three words](https://www.reddit.com/r/programming/comments/1xl5irk/the_case_against_makefiles/19rzrd19aryuc/): *"Sigh. Chesterton's fence."[^chesterton]*

Make to `just`, then `run`: each step removes a restriction the last tool imposed, and Jarvis's post is the more useful of the two because it walks the road to its end. Out there, tasks are typed functions with embedded interpreters, published to agents as tools, and your delivery pipeline has become an application unto itself. Every restriction Make imposes - targets that are files, prerequisites in no promised order, targets that take no flags, a fresh shell for every recipe line, a language too awkward to program in - is a fence along that road.

Let's look closely at those fences!

## A Target Is a File Until You Say Otherwise

Make assumes every target names a file, and skips any target whose file is newer than its prerequisites. `.PHONY` marks the targets that aren't files, so that a stray file called `test` can't convince Make the tests already ran. That declaration is Jarvis's Phony Tax, and in GNU Make you can stop paying it with one line:

```makefile
MAKEFLAGS += --always-make
```

Every target now runs every time.[^bmake-always-make] I don't use that trick, personally, because a surprising number of my targets aren't tasks. Packaging a Google Cloud Function looks like this:

```makefile
SRCS := main.py requirements.txt

function.zip: $(SRCS)
	rm -f $@
	zip -q $@ $(SRCS)

.PHONY: package
package: function.zip
```

The first `make package` runs both commands. The second invocation prints:

```text
make: Nothing to be done for 'package'.
```

Edit `main.py`, and it zips again. A `just` recipe or a `run` function zips every time, because neither tool knows what a file is. `just`'s author [says so himself](https://news.ycombinator.com/item?id=34318483): "Just doesn't have file-based dependencies, so it's not a build system, just a command runner."

That `function.zip: $(SRCS)` line is an edge, the thing Thibaud called Make's fundamental mistake. It is also the only reason Make can skip the zip.

Maybe skipping a two-file `zip` leaves you cold; if `just` and `run` rerun every task unconditionally, maybe rerunning everything is fine? Swap that toy example `zip` for the build and test steps across a life-size monorepo and suddenly skipping unchanged work becomes an entire product category:

{%linkcard
	https://turborepo.dev/
	Turborepo
%}

> Turborepo is the build system for coding agents. Developers, CI, and agents never do the same work twice.

Turborepo pulls [over 44 million weekly downloads on npm](https://www.npmjs.com/package/turbo). Vercel [bought the company](https://vercel.com/blog/vercel-acquires-turborepo) in 2021, and [over 43,000 teams paid](https://vercel.com/changelog/free-vercel-remote-cache) for its remote cache before Vercel started giving it away as an on-ramp to its paid platform (while [Nx Cloud](https://nx.dev/pricing) still charges directly for theirs). Teams will pay real money not to repeat work whose inputs haven't changed - the exact thing `just` and `run` threw out with `.PHONY`.

## Siblings Run in Any Order

List two prerequisites, run `make -j`, and Make may build them in either order, or both at once.

That freedom is what makes the build fast. When you write a build script, you encode the one serial path you worked out in your head: `build`, then `test`, then `package`, then `upload`. In a Makefile, you write down what each step actually needs:

```makefile
upload: test package
test: build
package: build
```

From those edges alone, `make -j` finds the parallel schedule for free: `build`, then `test` and `package` side by side, then `upload`. You write no thread pool and need no scheduling expertise, and a target you add next month joins the schedule without anyone re-planning the pipeline.

Declare the relationships instead of a single path and the same graph parallelizes across machines, too. Locally, `make -j$(nproc)` saturates every core on your laptop; across a network, [distcc](https://www.distcc.org/) rides `make -j` to spread C and C++ compiles over a cluster, and `bmake`'s ancestor, Berkeley's [PMake][freebsd-make], was built to farm Make jobs out across machines. Today's monorepo tools sell the exact same trick back to JavaScript teams: [Turborepo](https://turborepo.dev/docs/crafting-your-repository/running-tasks) runs independent tasks side by side on one machine, and [Nx Cloud](https://nx.dev/docs/features/ci-features/distribute-task-execution) distributes them across CI workers straight from the task graph.

The only price for all of that free speed is **saying what you mean** instead of trying to write a script in the prerequisite list. `upload: build test` tells Make that `build` and `test` are independent siblings; if `test` actually has to wait for `build`, say `test: build`. Thibaud's post shows what happens when people try anyway - a build script reduced to `make -j$(nproc) all || make -j$(nproc) all || make -j$(nproc) all` - and fairly admits: "This is definitely a skill issue." GNU Make 4.4 even added `--shuffle` to [randomize sibling order](https://lists.gnu.org/archive/html/info-gnu/2022-10/msg00008.html#:~:text=New%20feature%3A%20The%20%2D%2Dshuffle%20command%20line%20option) on purpose, smoking out undeclared dependencies before a CI runner stumbles into them.

Leaving Make doesn't get you a free lunch, either. Move to `just` and you lose automatic graph parallelism: dependencies run serially unless each recipe's author remembers to [opt in](https://just.systems/man/en/parallelism.html) with `[parallel]`, whereas Make leaves concurrency to whoever invokes `-j` across the whole graph at once. Move to a runner that *does* parallelize dependencies, like Taskfile, and the same fence waits for you there. Viktor Farcic of DevOps Toolkit [left Make](https://devopstoolkit.live/ci-cd/from-makefile-to-justfile-or-taskfile-recipe-runner-replacement/index.html) for Taskfile, and later for `just`, over the usual grievances ("If I never see .PHONY recipes again, I will die a happy person"), then [found in Taskfile](https://devopstoolkit.live/ci-cd/say-goodbye-to-makefile-use-taskfile-to-manage-tasks-in-ci-cd-pipelines-and-locally/index.html) that "I got burned more than once by adding tasks to dependencies and forgetting that they run in parallel. As a result, I spend hours trying to figure out why the results are not as expected." His takeaway is Make's rule, rediscovered in YAML: if a task can't run in parallel with the others, "it's not a dependency."

They figured this out half a century ago.

## Targets Take No Flags

You can set a variable on Make's command line, but a target can't take a flag:

```text
~ $ make test --integration
make: unrecognized option '--integration'
```

That refusal guards the most valuable thing a task runner provides: one shared contract across all callers. A repository's tasks serve four classes of caller at once: a developer moving between projects, an AI coding agent dropped cold into a fresh worktree, a CI runner, and the platform engineer maintaining one pipeline that every repository reuses.[^four-consumers] All four run the exact same verification **when** all four can guess the same commands without reading a word:

```sh
make test
make build
make package
make deploy
```

A Hacker News commenter [described the payoff](https://news.ycombinator.com/item?id=32442007): "Being able to drop into any repo at work and expect that `make init`, `make test` and `make start` will by convention always work no matter what the underlying language or technology is, has saved me a lot of time."

### Custom Flags Can't Be Intuited

`make test` and npm's [reserved](https://docs.npmjs.com/cli/v11/using-npm/scripts) `npm test` live in decades of developer muscle memory and in every language model's training data. Nobody has to look them up.

Watch how fast custom surfaces erode that. First, repositories pile bespoke script names beside the standard one:

```sh
npm run test:ci
npm run test:integration
npm run test:all
```

You can't guess which one you need right now, nor if CI will run integration tests, though at least everyone who runs the reserved `npm test` runs the *same* command. Flags break even that guarantee:

```sh
just test --integration
just test --retries 5
just test --timeout 10 -j 6
```

Every caller can now pass a different combination and get a different test. Worse, you have built a custom CLI that exists neither in the task runner's manual nor in any model's weights, so nobody can intuit it. Whoever shows up next - human or agent - has to hunt down the right document first (a `README`, [`--help` output](/garden/cli-help-patterns.html), an [AGENTS.md]({% post_url blog/essay/2026-02-12-stop-doing-agents-md %}) file, a [preloaded CLI skill](https://justin.poehnelt.com/posts/rewrite-your-cli-for-ai-agents/#ship-agent-skills-not-just-commands), an MCP schema) and *then* parse your conventions before running a single check. `make test` and `npm test` carry none of that burden.

That self-inflicted lookup cost is what Jarvis's Discovery Tax actually measures. In his example, an agent spends four tool calls and ~2,000 tokens hunting down `make test SERVICE=worker`, against one call and ~90 tokens calling `test(service: "worker")` over `run --serve-mcp`. The agent only went hunting because the repository's author parameterized `make test` ("just to run cargo test with a package filter"). If plain vanilla `make test` runs the tests, the first guess works with no discovery and no MCP server - beating even a paltry 90 tokens!

In ["It's Model Context Protocol, Not Agent Context Protocol"]({% post_url blog/essay/2026-02-23-model-context-protocol-not-agent-context-protocol %}) I put this as "MCP has to beat free", and Armin Ronacher landed in the same place in ["Agentic Coding Recommendations"](https://lucumr.pocoo.org/2025/6/12/agentic-coding/): "I place critical tools into a Makefile", barely touching MCP "because Claude Code is very capable of just running regular tools." Even `run`'s headline upgrade over `just` - typed signatures like `task(env: str, port = 8080)` - exists only to feed the documentation and schema machinery your parameters required,[^run-types-runtime-only] while publishing parameterized tasks over MCP turns `deploy(prod)` into a live endpoint an agent can call.[^mcp-deploy]

### Doing Without Task Flags

Not only *should* you run tasks without flags, you *can*. The usual objections have short answers:

- **"I need to run one test."** Then run one test.

	At a previous company I wrote this into our platform documentation: `make test` is the zero-argument gate that asks whether a change is ready to ship. In a red-green loop at two in the afternoon, call `pytest tests/test_parser.py -k edge_case` directly. Routing `pytest`'s flags through a task runner only gets you a worse `pytest`.
- **"I build two images."** Then your build graph has two nodes.

	Thibaud's own justfile exposes `build-docker-foo` and `build-docker-bar` as zero-argument recipes over a private helper. The same two recipes in GNU Make call one helper:

  ```makefile
  .PHONY: package build-docker-foo build-docker-bar build-docker
  package: build-docker-foo build-docker-bar

  build-docker-foo:
  	$(MAKE) build-docker IMAGE=my-foo-image

  build-docker-bar:
  	$(MAKE) build-docker IMAGE=my-bar-image

  build-docker:
  	docker image build -t $(IMAGE) docker/$(IMAGE)
  ```

	`make -j package` builds both images at once, and nobody has to know their names.
- **"I deploy to more than one environment."** Either give each one a zero-argument target built on shared internals (`make deploy-dev`, `make deploy-prod`), or `export DEPLOY_ENV=staging` and run `make deploy` (or `make DEPLOY_ENV=staging deploy` if you must). That is the **one** case where calling it an environment variable is literally accurate.[^variable-sin]

And if you still feel like you need flags, you're writing a program. Stop and go write a real CLI in a real language, with an argument parser, tests, and a `--help` that works, and let your task runner call it.

## Every Line Gets Its Own Shell

"I absolutely hate that every command line is a separate process," [one reply](https://www.reddit.com/r/programming/comments/1xl5irk/the_case_against_makefiles/19rzsvx3x3x2b/) to Thibaud said, "so you can't set a variable on one line and use it on the next." A `cd` on line one is gone by line two, and a loop needs backslash continuations and doubled dollar signs.

Stuart Feldman [wrote Make](https://en.wikipedia.org/wiki/Make_(software)) at Bell Labs in 1976, and I can't tell you Feldman meant this as a fence. Bell Labs' own successor to it, Andrew Hume's [mk][mk], "feeds the entire recipe to the shell";[^mk-whole-recipe] so does `bmake` when it runs jobs in parallel,[^bmake-whole-script] and so does GNU Make under `.ONESHELL`.

Regardless, it works as a fence for a reason jclulow [gave on Lobsters](https://lobste.rs/c/ylwkv8): separate shells allow "the exit status of each line to be checked independently regardless of whether the shell you've chosen has implicit errexit behaviour", and let Make log each command and its output on their own. Newer build tools kept that single-command boundary and made it stricter: [werk](https://github.com/simonask/werk) runs one command per recipe entry, [Ninja](https://ninja-build.org/manual.html) runs one command per build edge, and [tup](https://gittup.org/tup/manual.html) runs each single-line rule under `sh -e -c`.

Chesterton asks you to learn why a fence went up before you tear it down.

Knowing if the last line succeeded, and if you should continue the recipe, is half the reason. The shell itself is the other half.

Shelling out preserves two-way copy-paste parity between your terminal and your recipes. Make echoes each command before running it, so when a step fails, you copy that exact line into your prompt, tack on a debug flag, and watch it fail up close. Going the other way, a command you work out interactively at your prompt pastes behind a tab and runs in the same shell environment, with the same quoting and environment variables. Drop the shell for direct process execution, or replace it with an embedded Python or Node runtime, and your terminal and your build file stop speaking the same language.

This is an excellent feature for a task runner that seeks to organize and orchestrate the *already-extant* commands that drive a project!

## It's just No Place to run an Application

The last fence is the sum of the others: Make is miserable to program in. [Another reply](https://www.reddit.com/r/programming/comments/1xl5irk/the_case_against_makefiles/19s1gnqmdylnk/) to Thibaud saw exactly what that's for:

> What makes make so well suited to this is that it's an utterly horrible tool for anything else. I have no temptation to start making my makefiles clever or complex.

Jarvis's Polyglot Wall is real. Shell **is** a bad language for parsing JSON or comparing semver ranges, and `run`'s answer is to let you write those functions in Python, Node, or Ruby, inline, in the Runfile. Jarvis's post shows one, a `validate-spec(file)` task documented as "Verify API payload against schema". The blog post has an illustrative implementation, so imagine [wiring up a real schema validator](https://ajv.js.org/guide/getting-started.html#basic-data-validation) in its place. How many lines of code must you get right for `run validate-spec` to work, and how will you *ensure* they stay right?

The `make` binary has a test suite. So do your compiler, your linter, `pytest`, and your application. The twenty lines of shell, Python, or Groovy in your Makefile, justfile, Runfile, Jenkinsfile, or GitHub Actions workflow have none.

> They live in an **untested glue ghetto**: code outside every module system, with no test runner wired to it, that no unit test can import without setting off its side effects.

The one developer in a thousand who keeps a test suite for their task-runner glue can sit content in their moral superiority over the rest of us - while slogging through that second system's upkeep. For everyone else, once a task runner makes conditionals, loops, and inline Python comfortable, someone on the team **will** write an application in there.

Congratulations, you now have an untested application orchestrating your tested application. Actually, *is* it orchestrating? Who knows? Not you!

Tools that sand off Make's friction - `just`'s shebang recipes, `run`'s polyglot functions - are tech debt in a sleek buy-now-pay-later trim. Each line of a recipe should run one tested program, Unix-style; when you need real logic or complexity, put it in a real package with its own real tests.

### I Built the Harness

Years before `run` existed, I wrote an internal tech blog post at a previous company with a title close to "Do Not Write an Application in Your Delivery Pipeline", after watching Mike Hadlow's ["Configuration Complexity Clock"](https://mikehadlow.blogspot.com/2012/05/configuration-complexity-clock.html) strike twelve: configuration grows into a homemade scripting language, the team moves real logic into it, and eventually "Some of the team have started to work on a unit testing framework in their spare time."

I'm one of the few people who can tell you from the other side what that bill actually costs, because I paid it. At HomeAway, then owned by Expedia, our [Jenkinsfiles](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/) and [Jenkins](https://www.jenkins.io/) [Shared Libraries](https://www.jenkins.io/doc/book/pipeline/shared-libraries/) were programs in the Turing-complete Groovy language that weren't going away, and [JenkinsPipelineUnit](https://github.com/jenkinsci/JenkinsPipelineUnit) had hand-written mocks that its own developer [described](https://github.com/jenkinsci/workflow-cps-plugin/issues/1173) as "low fidelity to real behavior." So I built the [jenkins-spock](https://github.com/ExpediaGroup/jenkins-spock) unit-testing framework, which generates Spock mocks by scanning the real Jenkins plugin JARs pinned in your `pom.xml`. Even after that massive engineering effort, plain Groovy still disagreed with Jenkins's [continuation-passing transform](https://www.jenkins.io/doc/book/pipeline/cps-method-mismatches/) on edge cases. When I surveyed Jenkins and 28 other CI and CD systems this month, no CI vendor had ever shipped a mocked-step test harness at all, even though configuration management built [ChefSpec](https://github.com/chef/chefspec) in 2011 and infrastructure-as-code shipped [Terraform mocks](https://developer.hashicorp.com/terraform/language/tests/mocking) in 2024.

The complexity clock struck twelve, I built the harness, saw the other side, and can tell you firsthand: **the fence is cheaper.**

## Must We Keep Makefiles?

Fine, keep the behavioral fences - must they live in a `Makefile`'s "esoteric" syntax? What about a runner with a cleaner file format?

One popular answer is YAML, the format Taskfile and most CI pipelines picked, and trading Makefile quirks for YAML quirks is trading six of one for half a dozen of the other. Developers gravitate to YAML because its first ten lines look effortless next to a Makefile they never learned, without knowing either format deeply enough to see what line two hundred looks like.

To scratch the surface:

1. YAML has no variables or expressions of its own, so every tool bolts a proprietary dialect on top: Taskfile embeds Go's `{% raw %}{{.VAR}}{% endraw %}` [template language](https://taskfile.dev/docs/reference/templating) inside strings, GitHub Actions invents `{% raw %}${{ ... }}{% endraw %}` [expressions](https://docs.github.com/en/actions/reference/workflows-and-actions/expressions), Ansible wraps [Jinja2](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_templating.html), CloudFormation ships `!Sub` and `!Ref` [intrinsics](https://docs.aws.amazon.com/AWSCloudFormation/latest/TemplateReference/intrinsic-function-reference.html), and GitLab adds `!reference` [tags](https://docs.gitlab.com/ci/yaml/yaml_optimization/#reference-tags). The file extension may be `.yaml` but the language is whichever tool opens the file.
2. Native (variable-free) reuse means anchors (`&`) and aliases (`*`) - doing C-style pointer dereferencing in your head.
3. Map merging relies on the `<<` [merge key](https://yaml.org/type/merge.html), a 2005 YAML 1.1 draft type that [YAML 1.2 dropped](https://yaml.org/spec/1.2.2/) and you'll probably never encounter *until* a file that was relying on merging an alias to work around the lack of variables breaks on you.
4. Even what "plain YAML" means [depends on which spec and parser your tool linked](https://matrix.yaml.info/).[^yaml-norway]

If you actually want a declarative format without syntactic traps, the short list is [TOML](https://toml.io/en/) and XML[^die-mad-about-xml] - or a DSL purpose-built for the job at hand, *which is what Make already has.*

Even so, suppose you set out to sand the rough edges off Make's DSL. Given that so many behavioral "quirks" and "idiosyncrasies" were functioning Chesterton's Fences, what *could* you sand off without knocking down another one? I gave it the ol' college try, and every rough edge I reached for turned out to be far from free to drop:

- **The tab.** It belongs to Make's parser, and every character after it, spaces included, belongs to your command. Anyone who has fought YAML's [block scalars](https://yaml.org/spec/1.2.2/#81-block-scalar-styles) to keep a snippet's indentation intact has wished for exactly that split, and Make has had it since 1976.
- **Deferred evaluation.** `X = $(shell ...)` costs nothing until a recipe uses `X`. You can trivially try it out and see the eager version, `X := $(shell sleep 3; echo computed)`, add three seconds to every run, including runs of a target that never touched it. Lazy stays in *declarative.* Do away with it and you're asking for *imperative* - a script - tearing down a fence!
- **`$(NAME)` for variables.** Make is a metaprogramming language for shell commands, and in a Makefile the variables you mean are usually Make's, so Make's get the short syntax and the shell's get `$$`. The cost is that `$(...)` collides with the shell's command substitution: a recipe line `echo "built $(date)"` prints `built `, because Make expands `$(date)` as one of its own variables, which is empty, before the shell sees the line. Flipping the default in a new format would invert fifty years of Makefile muscle memory just to make shell scripting inside recipes more comfortable - the exact habit the fourth and fifth fences exist to discourage.
- **`%`.** Pattern rules need a wildcard, and a different token would be the same feature in a new spelling.
- **Function calls.** Jarvis's [launch post][run-launch] held up `$(word 2,$(subst -, ,$@))` as proof that Make's syntax is arcane, and it is. Bare `word(...)` in a recipe would belong to the shell, so Make reuses `$(...)` for its own functions too - and when nested string surgery looks that ugly, the fifth fence is doing its job.

The syntax is fences all the way down. Don't change it! Or at least, first *"Go away and think. Then, when you can come back and tell me that you do see the use of it, I may allow you to destroy it."[^chesterton]*

## Five Lines Beat a New Binary

Every complaint about what goes on *inside* a Makefile turned out to be a fence - whether it be the syntax itself, or the behavioral semantic that syntax describes. One item from the opening list is still standing, and it's a fair hit: Make has no built-in help for a project's targets. That wart lives in the `make` binary, though - your `Makefile` did nothing wrong.

Even there, self-documenting `make help` - and bare `make`, when `help` comes first - takes five lines:[^better-help-snippet]

```makefile
.PHONY: help
help: ## Show this help
	@awk -F ':[^=#]*## ' \
		'/^[A-Za-z0-9_][A-Za-z0-9_.-]*:[^=#]*## / {printf "  %-18s %s\n", $$1, $$2}' \
		$(MAKEFILE_LIST) $(.MAKE.MAKEFILES)
```

Document a target by ending its line with `##` and a description:

```makefile
test: lint ## Run the test suite
	pytest

lint: ## Lint the code
	ruff check .
```

Then `make` prints:

```text
  help               Show this help
  test               Run the test suite
  lint               Lint the code
```

Make is already pre-installed on every Mac, Linux developer machine, and Unix CI runner I've used (Will McGinnis made the full ubiquity case in ["You Don't Need a Justfile"](https://mcginniscommawill.com/posts/2026-04-17-you-dont-need-a-justfile/)). If you're going to demand a new binary and a new file format on every laptop, container, and runner in the organization to avoid pasting five lines of `Makefile`, that new binary had better be **9×** better[^gourville] - because five lines alone is not a crisis. Instead, `just` and `run` save you five lines by tearing down every fence above and making it effortless for the next person on the team to write an untested application in your build tool. Bad trade.

A poor carpenter blames their tools. Write the five lines and keep the fences.

Jarvis wrote that "Make had a magnificent run." It's still running. Whenever you reach for `just` or `run`: **just run make**.

---

## Footnotes & References

0. If you really want to throw some energy at improving things, maybe we should just [make make Better]({% post_url blog/essay/2026-11-13-make-make-better %})!
{: start="0"}

[^chesterton]: [Chesterton's fence](https://fs.blog/chestertons-fence/) is the rule that you don't tear down a fence until you know why someone put it up in the first place:
	> *"If you don’t see the use of it, I certainly won’t let you clear it away. Go away and think. Then, when you can come back and tell me that you do see the use of it, I may allow you to destroy it."*

[^mk-whole-recipe]: "Note that unlike make, mk feeds the entire recipe to the shell rather than running each line of the recipe separately." From [mk(1)][mk].

[^bmake-whole-script]: "When make is run in jobs mode with -j max_jobs, the entire script for the target is fed to a single instance of the shell." From [make(1), FreeBSD 15.0-RELEASE][freebsd-make].

[^bmake-always-make]: In GNU Make, anyway. `bmake`, the `make` of FreeBSD and NetBSD, has no `--always-make` flag (its `-B` runs commands sequentially in backwards-compatible mode instead) and still demands `.PHONY` - which, since you shouldn't disable file targets across the whole Makefile anyway, arguably means `bmake` had the right idea.

[^four-consumers]: This wasn't always the case, and it may still not be the case for all users. If your use-case doesn't have all four consumers, then a different tool *may* be okay for you. And a tool that is targeting such use-cases may get to forgo some of the fences (as irrelevant) that Make erects. But a general-purpose tool aiming for widespread utility in 2026 must account for them. `just` - or at least a big chunk of `just` proponents - are making a go at replacing `make` and must, therefore, account for the use-cases that `make` currently serves.

[^mcp-deploy]: On `run`'s [r/crewai launch thread][run-launch], [one reader](https://www.reddit.com/r/crewai/comments/1wt25eu/i_got_tired_of_being_the_makefile_person_at_work/pd15ydr/) wrote that "deploy(prod) feels like exactly the kind of task I'd want an agent to be able to list but never actually call." Because "the current MCP spec treats all registered tools as callable endpoints", Jarvis [suggested](https://www.reddit.com/r/crewai/comments/1wt25eu/i_got_tired_of_being_the_makefile_person_at_work/pd2xs54/) putting a `[ -t 0 ]` terminal check inside the task body. With a Makefile, an agent reads the file without executing it, and the shell harness already gates `make test` separately from `make deploy`.

[^run-types-runtime-only]: `run`'s [FAQ](https://runtool.dev/docs/faq.html) concedes that in shell functions, "types power documentation and MCP schemas only."

[^variable-sin]: Why allow `DEPLOY_ENV=staging` after prosecuting `SERVICE=worker`? A Make variable is harmless when the exact same recipe lines run for every value and the variable only fills in where that work lands. Once a variable's value changes *which* work runs - `SERVICE=worker` selecting a different test suite, or a `DEPLOY_ENV=prod` that sneaks in extra steps - you have hidden nodes of your build graph inside runtime state, and those belong as named targets.

[^yaml-norway]: [YAML 1.1's implicit typing](https://yaml.org/type/bool.html) quietly turns unquoted `no`, `off`, and `on` into booleans... which caused a problem for the [Norway country code NO](https://www.bram.us/2022/01/11/yaml-the-norway-problem/); [YAML 1.2](https://yaml.org/spec/1.2.2/#103-core-schema) restricted booleans to `true` and `false`. Which one are you using? Which one's your tool's parser's default?

[^die-mad-about-xml]: Which Maven understood over two decades ago.

[^better-help-snippet]: If you've seen a `Makefile` help recipe before, it was probably François Zaninotto's 2016 [self-documenting Makefile](https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html), which pipes `grep` into `awk` with a `*?` quantifier that strict POSIX `awk` rejects, and reads only GNU Make's file list. This version uses `.PHONY: help` (standard in POSIX since 2024, so it works in `bmake` too and leaves real file targets intact), passes both `$(MAKEFILE_LIST)` (GNU Make back to macOS's 3.81, and [documented](https://man.openbsd.org/make.1) by OpenBSD's `make`) and `$(.MAKE.MAKEFILES)` (`bmake`) so each Make expands its own variable, and uses one POSIX extended regular expression that skips `.PHONY:` and `FOO := bar ## note` assignments across `gawk`, `mawk`, BusyBox, and the [one-true-awk][one-true-awk][^one-true-awk] on macOS and the BSDs. Add `.DEFAULT_GOAL := help` in GNU Make if an `include` sits above `help`.

[one-true-awk]: https://github.com/onetrueawk/awk
[^one-true-awk]: `awk` is named after its Bell Labs creators Alfred **A**ho, Peter **W**einberger, and Brian **K**ernighan; Unix users and the BSD source trees dubbed Kernighan's maintained release of the version from their 1988 book *The AWK Programming Language* "the one true awk", a name [one-true-awk/awk][one-true-awk] adopted. The [GNU Awk manual](https://web.archive.org/web/20261005164359/https://www.gnu.org/software/gawk/manual/html_node/Other-Versions.html) gives its build instructions as: "To build it, review the settings in the makefile, and then **just run make**."

[^gourville]: John T. Gourville, "Eager Sellers and Stony Buyers: Understanding the Psychology of New-Product Adoption," *Harvard Business Review*, June 2006. Buyers overweight the benefits of what they already have by a factor of three, and the people shipping the replacement overweight what it adds by a factor of three. Gourville calls the result "a mismatch of nine to one, or 9×, between what innovators think consumers desire and what consumers really want." <https://web.archive.org/web/20251212040814/https://web.mit.edu/mamd/www/tech_strat/courseMaterial/topics/topic4/readings/Eager_Sellers_and_Stony_Buyers/Eager_Sellers_and_Stony_Buyers.pdf/Eager_Sellers_and_Stony_Buyers.pdf>[^gourville-pdf-url]

[^gourville-pdf-url]: Yeah they put the PDF name in the url thrice, and repeated the PDF name as a directory enclosing the actual PDF. I dunno, man. I didn't go to MIT.

[freebsd-make]: https://man.freebsd.org/cgi/man.cgi?query=make&sektion=1&manpath=FreeBSD+15.0-RELEASE
[run-launch]: https://www.reddit.com/r/crewai/comments/1wt25eu/i_got_tired_of_being_the_makefile_person_at_work/
[mk]: https://9fans.github.io/plan9port/man/man1/mk.html
