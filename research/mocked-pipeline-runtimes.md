# Mocked Pipeline Runtimes

As of 2026-11-09.

Question: has any CI vendor shipped a harness that runs a pipeline definition with its steps replaced by mocks, so a test can assert what the pipeline would do?

Jenkins has two. No other CI vendor has shipped one. Configuration management and infrastructure-as-code have had the shape for years. Counts below are from that day.

## What was counted

A tool counts only when it runs the pipeline outside the real engine and replaces the engine's steps with mocks. Local runners, linters, plugin tests, and tests of a program that generates YAML are a different question.

| Code | Category | What it does |
|---|---|---|
| A | Mocked runtime | Runs the pipeline outside the engine, steps replaced by mocks, and asserts what ran |
| B | Call-log snapshot | Records what ran and fails on any difference from a stored file |
| C | Local or integration runner | Runs the pipeline on the real engine or an emulator |
| D | Static check | Lints, checks a schema, or lists jobs without running steps |
| E | Package test | Tests an action, task, orb, or plugin with ordinary mocks |
| F | Generator test | A normal program emits the pipeline, and normal unit tests cover that program |

One tool can span categories. JenkinsPipelineUnit is A, with an optional B mode.

## Jenkins

JenkinsPipelineUnit (JPU) shipped first. Its first commit is 2017-01-25, and 0.10 reached Maven Central on 2017-02-02. That release already had `registerAllowedMethod`, build-status assertions, and call-stack regression files ([v0.10 README](https://github.com/jenkinsci/JenkinsPipelineUnit/blob/v0.10/README.md)). In April 2017 its developer, Ozan Günalp, wrote that JPU "adheres to the first option (Mock Framework)... it is quick, flexible but has low fidelity to real behavior" ([workflow-cps-plugin #1173](https://github.com/jenkinsci/workflow-cps-plugin/issues/1173)). The mocks are a hand-curated set, 88 by default, plus whatever a test registers under any name ([BasePipelineTest.groovy](https://github.com/jenkinsci/JenkinsPipelineUnit/blob/master/src/main/groovy/com/lesfurets/jenkins/unit/BasePipelineTest.groovy)).

jenkins-spock's first public release, 2.0.0, "Initial OSS Release," was 2018-09-12, about 19 months later, during a 27-month gap in JPU releases ([CHANGELOG](https://github.com/ExpediaGroup/jenkins-spock/blob/master/CHANGELOG.md)). 1.x had been used internally at HomeAway before that open-source release. The 1.x dates stayed behind the corporate firewall. Before a test runs, jenkins-spock scans the test classpath for `StepDescriptor`, `@Symbol`, and `GlobalVariable` extensions in the plugins declared as dependencies, and turns each into a Spock mock ([README](https://github.com/ExpediaGroup/jenkins-spock/blob/master/README.md); [WholeClasspathPipelineExtensionDetector.java](https://github.com/ExpediaGroup/jenkins-spock/blob/master/src/main/java/com/homeaway/devtools/jenkins/testing/WholeClasspathPipelineExtensionDetector.java)). A step no declared plugin provides has no mock. The failure asks whether the plugin is in the `pom.xml`. No other Jenkins tool in the survey builds its mocks from plugin metadata. JPU, the HealthPartners helper, and papiocloud's 2021 framework all start from names a person wrote down.

The fidelity stops at those names. Each step mock is a Spock `Mock()` of type `Closure`, so it accepts any arguments ([JenkinsPipelineSpecification.groovy](https://github.com/ExpediaGroup/jenkins-spock/blob/fe606b79f8f99d1f1a7fe2763ea9cd9f4ea16943/src/main/groovy/com/homeaway/devtools/jenkins/testing/JenkinsPipelineSpecification.groovy)). Return values are still chosen by the test. A misspelled parameter passes when the test misspells it the same way. A method call on a global variable gets a mock made on the spot, so a typo such as `docker.insde(...)` passes ([PipelineVariableImpersonator.groovy](https://github.com/ExpediaGroup/jenkins-spock/blob/fe606b79f8f99d1f1a7fe2763ea9cd9f4ea16943/src/main/groovy/com/homeaway/devtools/jenkins/testing/PipelineVariableImpersonator.groovy)). jenkins-spock also runs the pipeline as plain Groovy. Jenkins documents cases where CPS-transformed code returns a different result, or fails, with no error in the untransformed code ([Pipeline CPS method mismatches](https://www.jenkins.io/doc/book/pipeline/cps-method-mismatches/)). JPU's experimental CPS mode warns that "the serialization used to test is not the same as what Jenkins uses" ([JPU README](https://github.com/jenkinsci/JenkinsPipelineUnit/blob/master/README.md)). A 2021 comment on the same Jenkins issue said that neither framework can properly execute CPS code.

jenkins-spock has no Declarative parser. Getting executed steps out of a `pipeline` block would require the Declarative interpreter itself ([jenkins-spock #27](https://github.com/ExpediaGroup/jenkins-spock/issues/27)). JPU shipped its own re-implementation in v1.3 on 2020-01-29: `when`, `post`, `parallel`, `parameters`, and `agent`, including `branch`, `tag`, `expression`, `allOf`, `anyOf`, and `not` ([v1.3](https://github.com/jenkinsci/JenkinsPipelineUnit/releases/tag/v1.3); [WhenDeclaration.groovy](https://github.com/jenkinsci/JenkinsPipelineUnit/blob/master/src/main/groovy/com/lesfurets/jenkins/unit/declarative/WhenDeclaration.groovy)). That interpreter is JPU's, and no audit was found of how it matches Jenkins' `ModelInterpreter`.

JPU is the one Jenkins documents. On 2026-11-09 it had 1,586 stars against jenkins-spock's 190, and v1.31 (2026-07-01) had moved to Java 21. jenkins.io names JPU in four files and jenkins-spock in none ([Pipeline development](https://www.jenkins.io/doc/book/pipeline/development/)). Code search that day found about 258 repositories referencing JPU and 45 referencing jenkins-spock, roughly 25 to 30 of those genuine users ([JPU search](https://github.com/search?q=com.lesfurets.jenkins.unit&type=code); [jenkins-spock search](https://github.com/search?q=com.homeaway.devtools.jenkins&type=code)).

jenkins-spock's last release, 2.1.5, was 2021-04-13. The last commit on master was 2021-11-29. Since jenkins-core 2.357 every test fails with a cglib `UnsupportedOperationException` ([#143](https://github.com/ExpediaGroup/jenkins-spock/issues/143)). A pull request for Java 11 and newer jenkins-core was closed unmerged on 2024-07-01 ([#150](https://github.com/ExpediaGroup/jenkins-spock/pull/150)). Of 75 forks, five carry commits beyond upstream, and none has a release. On 2025-04-11 a user on #147 wrote, "We are migrating to JenkinsPipelineUnit with JUnit" ([#147](https://github.com/ExpediaGroup/jenkins-spock/issues/147)). In October 2026, [corporate-gadfly/jenkins-spock-harness](https://github.com/corporate-gadfly/jenkins-spock-harness) shipped a JDK 21 and Groovy 4 harness that reuses `getPipelineMock` and `explicitlyMockPipelineVariable`. Its README does not mention jenkins-spock.

The real engine is the other Jenkins option. The Jenkins Test Harness boots a Jenkins during `mvn test` ([jenkins-test-harness](https://github.com/jenkinsci/jenkins-test-harness)). Jenkinsfile Runner runs it as a command-line tool and was still incubating, last released 2023-11-12 ([jenkinsfile-runner](https://github.com/jenkinsci/jenkinsfile-runner)).

## The other 28

No vendor in this list ships category A. The near misses sit under the table.

| System | What exists | Source |
|---|---|---|
| GitHub Actions | act runs steps in Docker; act-js mocks steps inside act | [act](https://github.com/nektos/act) |
| GitLab CI | CI Lint can simulate which jobs a pipeline would create; an open request asks for unit tests and names JPU | [#442955](https://gitlab.com/gitlab-org/gitlab/-/issues/442955) |
| Bitbucket Pipelines | Run the build image by hand; community runners have no mock mode | [Atlassian](https://support.atlassian.com/bitbucket-cloud/kb/debug-pipelines-locally-with-docker/) |
| Azure Pipelines | junit-pipeline runs rewritten YAML on a real project; an offline evaluator runs no steps; a 2017 stubbed "local run" never shipped | [#2479](https://github.com/microsoft/azure-pipelines-agent/issues/2479) |
| CircleCI | `config validate`, `config process`, and `local execute` for single jobs, "not workflows" | [local CLI](https://circleci.com/docs/2.0/how-to-use-the-circleci-local-cli) |
| Buildkite | SDK tests compare generated YAML; plugin tests use BATS | [SDK](https://buildkite.com/docs/pipelines/configure/dynamic-pipelines/sdk) |
| TeamCity | Docs say Kotlin DSL scripts can be tested with JUnit. The Kotlin runs at generation time; the server does not | [Kotlin DSL](https://www.jetbrains.com/help/teamcity/kotlin-dsl.html) |
| Bamboo | The Java Specs archetype generates an offline `checkYourPlanOffline()` test | [tutorial](https://confluence.atlassian.com/bamboo/tutorial-create-a-simple-plan-with-bamboo-java-specs-894743911.html) |
| GoCD | Server-side preflight validation since 19.2.0 | [API](https://api.gocd.org/current/#preflight-check-of-config-repo-configurations) |
| Drone | `drone exec` runs the real engine locally | [drone exec](https://docs.drone.io/cli/drone-exec/) |
| Woodpecker | `woodpecker-cli exec` and a linter | [local execution](https://woodpecker-ci.org/docs/usage/local-execution) |
| Travis CI | `travis compile` renders a job as bash | [travis-build](https://github.com/travis-ci/travis-build) |
| AWS CodeBuild / CDK | CDK assertion tests cover a synthesized pipeline; CodeBuild has a local agent | [CDK testing](https://docs.aws.amazon.com/cdk/v2/guide/testing.html) |
| Google Cloud Build | `cloud-build-local`, archived, "not 100% feature-compatible" with the hosted service | [repo](https://github.com/GoogleCloudPlatform/cloud-build-local) |
| Harness | Pipelines evaluated against OPA policies | [governance](https://developer.harness.io/docs/platform/governance/policy-as-code/harness-governance-quickstart) |
| Semaphore | YAML validation | [sem-ai](https://docs.semaphore.io/using-semaphore/ai/sem-ai) |
| Octopus | Parse the OCL and assert on the structure | [OCL](https://octopus.com/docs/projects/version-control/ocl-file-format) |
| Tekton | Catalog tests create a namespace on a real cluster and fake outside services, never Tekton | [CONTRIBUTING](https://github.com/tektoncd/catalog/blob/main/CONTRIBUTING.md) |
| Argo | `argo lint --offline`; Hera's example calls a step as Python, then submits the workflow to a server | [Hera](https://github.com/argoproj-labs/hera/blob/main/docs/examples/workflows/use-cases/testing_templates_and_workflows.md) |
| Concourse | `fly validate-pipeline` | [docs](https://concourse-ci.org/docs/pipelines/setting-pipelines/) |
| Spinnaker | Netflix ran functional test pipelines on a cron | [spinnaker-testing](https://github.com/spinnaker/pipeline-templates/tree/master/netflix/spinnaker-testing) |
| Dagger | Tests call the module on the real engine. No mock client | [#4199](https://github.com/dagger/dagger/issues/4199) |
| Earthly | No Earthfile test tool. Commercial services ended in 2025 | [shutdown](https://earthly.dev/blog/shutting-down-earthfiles-cloud/) |
| Jenkins X | `jx pipeline lint` | [lint](https://github.com/jenkins-x-plugins/jx-pipeline/blob/main/docs/cmd/jx-pipeline_lint.md) |
| Zuul | A change to pipeline config is tested by running that config before merge | [project config](https://zuul-ci.org/docs/zuul/latest/project-config.html) |
| Screwdriver | `sd-local` | [sd-local](https://docs.screwdriver.cd/user-guide/local) |
| Keptn | v1 reached end of life in 2023. No unit-test framework found | [keptn](https://github.com/keptn/keptn) |
| Flux | `flux-local` renders and lints | [flux-local](https://github.com/allenporter/flux-local) |

### Near misses

**act-js** (kiegroup, November 2022) is the one GitHub Actions tool that replaces named steps and asserts `name`, `output`, and `status`. Every test still runs the workflow through act in Docker. It mocks a step by rewriting the workflow file on disk, and it reads results from act's console output ([act-js](https://github.com/kiegroup/act-js)). It has 65 stars. The last stable release was v2.6.2 on 2024-04-23. nektos/act itself has no step mocks. Issue #847, open since 2021-10-18, asks to stub a step and assert whether a later step would run ([act #847](https://github.com/nektos/act/issues/847)). Only GitHub runs the service that matches events to workflows and schedules jobs. Gitea and Forgejo run GitHub-style workflows on forks of act ([Forgejo runner](https://code.forgejo.org/forgejo/runner)).

**Azure.** hvmerode/junit-pipeline (2023, 13 stars) offers `mockStepSearchByIdentifier` and `assertVariableEqualsSearchStepByDisplayName`, and its README says "testing a pipeline within the IDE is not possible": it rewrites the YAML, pushes it, and runs it on a real Azure DevOps project ([junit-pipeline](https://github.com/hvmerode/junit-pipeline)). blakharaz/AdoPipelineTest (2026) evaluates templates offline and runs no steps. Microsoft's 2017 agent "local run" mode would have run the job while stubbing calls to the server. The doc said "internal only, public preview soon." Issue #2479 (2019) said it was not implemented, and the dead code was deleted in 2020 ([#2479](https://github.com/microsoft/azure-pipelines-agent/issues/2479)). `azure-pipelines-task-lib` mocks a task's own code, which is category E.

**GitLab** comes closest for declarative YAML, and only for job selection. CI Lint's `dry_run` runs GitLab's own `Ci::CreatePipelineService` and returns the jobs that would exist ([CI Lint API](https://docs.gitlab.com/api/lint/)). Issue #442955 (2024-02-23) asks to "unit test the pipelines themselves" and names JenkinsPipelineUnit. It was still open. firecow/gitlab-ci-local runs jobs locally and has no job mocking.

**Dagger** has no mocked engine. On 2022-12-15 issue #4199 asked to mock commands so a test could check logic without a deployment. No maintainer replied. It was closed as "completed" on 2026-03-24 ([#4199](https://github.com/dagger/dagger/issues/4199)).

## Outside CI

The same shape is old once the thing under test is a program and the engine is expensive to boot.

ChefSpec (first gem 2011-07-31) "runs your cookbooks locally while skipping making actual changes," and stubs shell commands, search, and data bags ([ChefSpec](https://github.com/chef/chefspec/blob/main/README.md)). rspec-puppet (first gem 2011-07-18) compiles a catalog under faked facts. Pulumi's unit tests "replace the engine with mocks," landed 2020-02-29 ([PR #3738](https://github.com/pulumi/pulumi/pull/3738)). Terraform's mock providers merged on 2023-10-31 and shipped in 1.7; with `override_resource`, "Terraform does not call the underlying provider" ([mocking](https://developer.hashicorp.com/terraform/language/tests/mocking)). Read as a claim about CI orchestrators, the vendor gap survives this list. Read as a claim about software delivery in general, it does not.

## Why the field looks like this

Mocked runtimes showed up where three conditions met: the pipeline's logic is a program when it runs, a normal test runner can host that language, and starting the real engine is slow or costly. Jenkins Pipeline met all three, and so did Chef in 2011. YAML pipelines keep their logic in shell, and the tools around them lint the file or list the jobs. TeamCity, CDK, and Buildkite move the logic to generation time, where an ordinary unit test is enough. Dagger meets the first two conditions and runs its engine locally, so its documented tests call the real engine.

The request is still open: act #847 (2021), Dagger #4199 (2022), GitLab #442955 (2024), and the 2026 harness that reuses jenkins-spock's API names. On declarative YAML, the request on the trackers is to evaluate conditions for a scenario. GitLab's CI Lint simulation does that with GitLab's own pipeline-creation code.
