.PHONY: docs-install docs-serve docs-build lint-md lint-contracts lint

VENV := .venv
PY   := $(VENV)/bin/python

$(VENV):
	python3 -m venv $(VENV)
	$(PY) -m pip install -q -r requirements-docs.txt

docs-install: $(VENV)

docs-serve: $(VENV)
	$(VENV)/bin/mkdocs serve

docs-build: $(VENV)
	$(VENV)/bin/mkdocs build --strict

lint-md:
	npx --yes markdownlint-cli2 "docs/**/*.md" "README.md"

lint-contracts:
	npx --yes @redocly/cli@latest lint docs/api/*.openapi.yaml
	npx --yes @asyncapi/cli@latest validate docs/events/asyncapi.yaml

lint: lint-md lint-contracts
