# action-allure-report
GH Action to create Allure report on tests.

This action requires github pages to be enabled.

## Inputs

### github-key
**Required:**  [Github token](https://docs.github.com/en/actions/security-guides/automatic-token-authentication)

### test-type
Optional: Type of the test to distinguish when reporting. Integration or unit.

Default: unit

### allure-dir
Optional: Directory where allure report lives.

Default: allure-results

### pages-branch
Optional: Branch where GitHub Pages is deployed.

Default: gh-pages

## Example usage

First you need to make sure allure report is generated. Install language-appropriate allure extension for your test framework and run the tests.

In the following example adding `--alluredir=allure-results` enables Allure report generation.

```yml

- name: Run your tests
    run: |
    pytest tests/unit --alluredir=allure-results

# Need to pull the pages branch in order to fetch the previous runs
- name: Get Allure history
    uses: actions/checkout@v2
    if: always() # Needed in order to report failed tests
    continue-on-error: true
    with:
        ref: gh-pages
        path: gh-pages

- name: Allure Report
    uses: firebolt-db/action-allure-report@main
    if: always() # Needed in order to report failed tests
    with:
        github-key: ${{ secrets.GITHUB_TOKEN }}
        # The rest of the inputs are optional
        test-type: Unit
        allure-dir: allure-results
        paged-branch: gh-pages
```