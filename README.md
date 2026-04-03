# Polyglot Order Toolkit

Academic test repository for validating the `AI_agents_for_CI_shared_library` Jenkins shared library against a project that is different from the original demo application.

The repository is intentionally small, but it exercises a mixed-language setup:

- Python for order totals and discounts.
- JavaScript for order normalization and validation.
- Java for order risk scoring and manual-review rules.

## Project goal

This repository is designed to answer a simple question for the thesis work: can the Jenkins shared library and the `FixWithAI(...)` workflow be applied to another project after only repository-level configuration?

To support that goal, the repository includes:

- three independent test suites;
- a Jenkins pipeline shaped like the original reference pipeline;
- intentional SonarQube findings documented in `INTENTIONAL_SONAR_ISSUES.md`;
- a test-runner contract in `ai-tests-config.json`.

## Repository structure

```text
.
|-- Jenkinsfile
|-- README.md
|-- INTENTIONAL_SONAR_ISSUES.md
|-- ai-tests-config.json
|-- requirements/
|   `-- python_requirements.txt
|-- scripts/
|   `-- run_java_tests.sh
|-- src/
|   |-- java/
|   |   `-- com/example/order/OrderRiskRules.java
|   |-- javascript/
|   |   `-- order_validator.js
|   `-- python/
|       `-- order_totals.py
`-- tests/
    |-- java/
    |   `-- com/example/order/OrderRiskRulesTest.java
    |-- javascript/
    |   `-- test_order_validator.js
    `-- python/
        `-- test_order_totals.py
```

## Local verification

### Python

```bash
python -m pip install -r requirements/python_requirements.txt
PYTHONPATH=src/python python -m pytest tests/python/test_order_totals.py
```

### JavaScript

```bash
node --test tests/javascript/test_order_validator.js
```

### Java

```bash
bash scripts/run_java_tests.sh
```

## Jenkins and SonarQube flow

The pipeline mirrors the reference repository:

1. Checkout the repository.
2. Recreate `reports_for_IA/`.
3. Compile Java classes so SonarQube can analyze the Java sources.
4. On `ai-fix/*` PR branches, run Python, JavaScript, and Java validation tests.
5. On other PR branches, run SonarQube analysis, wait for the Quality Gate, and execute `FixWithAI(...)`.

Important Jenkins note:

- The `Jenkinsfile` intentionally does not include `githubPush()`.
- The multibranch job should be configured to build pull requests only, so plain branch pushes and merges do not trigger normal branch builds.

## Shared-library contract

`FixWithAI(...)` is configured with:

- `repoSlug: 'PabloMartinezIbanez/polyglot-order-toolkit'`
- `testConfigFile: 'ai-tests-config.json'`
- `dryRun: false`

This keeps the experiment aligned with the shared library contract already used by the original demo repository.
