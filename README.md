# action-allure-report
GH Action to create Allure report on tests.

This action requires github pages to be enabled.

## v2
- added support for upload of multiple reports within one job

## Inputs

### github-token
**Required:**  [Github token](https://docs.github.com/en/actions/security-guides/automatic-token-authentication)

### mapping-json
**Required**: Mapping of source where allure test results were written and unique, URL friendly description

Example:
```yaml
mapping-json: |
  {
      "allure-results-unit": "unit_tests",
      "allure-results-integration": "integration_tests"
  }
```

### allure-version
Optional: Version of Allure to be installed

Default: `2.38.1`

### pages-branch
Optional: Branch where GitHub Pages is deployed.

Default: gh-pages

### report-path
Optional: Path under which the report will be published.

Default: `allure/<repo-name>_<sha>`

## Example usage

First you need to make sure allure report is generated. Install language-appropriate allure extension for your test framework and run the tests.

In the following example adding `--alluredir=allure-results` enables Allure report generation.

```yml

- name: Run your tests
    run: |
    pytest tests/unit --alluredir=allure-results

- name: Allure Report
    uses: firebolt-db/action-allure-report@v2
    if: always() # Needed in order to report failed tests
    with:
        github-token: ${{ secrets.GITHUB_TOKEN }}
        # The rest of the inputs are optional
        pages-branch: gh-pages
        mapping-json: |
            {
                "allure-results": "unit_tests"
            }
```
