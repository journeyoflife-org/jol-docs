# JOL Docs — documentation quality targets.
# Usage: make help

SHELL := /bin/bash
VENV := .venv
PIP := $(VENV)/bin/pip
PRE_COMMIT := $(VENV)/bin/pre-commit
DETECT_SECRETS := $(VENV)/bin/detect-secrets
NPX := npx --yes

.DEFAULT_GOAL := help

.PHONY: help install lint links secrets check clean

help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

install: ## Install QA tooling into the virtualenv and activate hooks
	@test -d $(VENV) || python3.12 -m venv $(VENV)
	$(PIP) install --upgrade pip
	$(PIP) install pre-commit detect-secrets
	$(PRE_COMMIT) install

lint: ## Lint all markdown against .markdownlint.yaml
	$(NPX) markdownlint-cli@0.41.0 "**/*.md" --config .markdownlint.yaml

links: ## Check links in all markdown files
	@find . -path ./.venv -prune -o -name '*.md' -print | xargs -r $(NPX) markdown-link-check -q

secrets: ## Re-scan for secrets and refresh the baseline report
	$(DETECT_SECRETS) scan --baseline .secrets.baseline

check: ## Run the full pre-commit suite against all files
	$(PRE_COMMIT) run --all-files

clean: ## Remove local caches and temporary artefacts
	rm -rf .mypy_cache .pytest_cache .ruff_cache
	find . -type d -name '__pycache__' -not -path './.venv/*' -prune -exec rm -rf {} +
