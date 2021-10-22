.PHONY: clean
clean: clean-build clean-pyc clean-test clean-docs

.PHONY: clean-build
clean-build:
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs/
	rm -fr pip-wheel-metadata
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -fr {} +
	rm -fr Pipfile.lock

.PHONY: clean-docs
clean-docs:
	rm -fr site/

.PHONY: clean-pyc
clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +
	find . -name '.DS_Store' -exec rm -fr {} +

.PHONY: clean-test
clean-test:
	rm -fr .tox/
	rm -f .coverage
	find . -name ".coverage*" -not -name ".coveragerc" -exec rm -fr "{}" \;
	rm -fr coverage.xml
	rm -fr htmlcov/
	rm -fr .hypothesis
	rm -fr .pytest_cache
	rm -fr .mypy_cache/
	rm -fr input_file
	rm -fr output_file
	find . -name 'log.txt' -exec rm -fr {} +
	find . -name 'log.*.txt' -exec rm -fr {} +

.PHONY: lint
lint:
	pipenv run black src/
	pipenv run isort src/
	pipenv run flake8 src/
	pipenv run vulture src/

.PHONY: security
security:
	bandit -s B104 -r src/

.PHONY: vulture
vulture:
	if [ "0" == "$(shell ((vulture  src/ whitelist.py )  | wc -l))" ];\
	then\
      echo "ah code is all used."; \
  else \
      echo "Not used!"; \
  fi
	if [ "0" == "$(shell ((vulture src/ whitelist.py )  | wc -l))" ];\
	then\
      echo "deployer code is all used."; \
  else \
      echo "Not used!"; \
  fi

.PHONY: static
static:
	mypy src/

.PHONY: new_env
new_env: clean
	pipenv --rm;\
	pipenv --python 3.8;\
	echo "Enter clean virtual environment now: 'pipenv shell'.";\

.PHONY: install_env
install_env:
	pipenv install --dev --skip-lock

.PHONY: install_hooks
install_hooks:
	cp  scripts/pre-push .git/hooks/pre-push


.PHONY: setup_repo
setup_repo:
	install_hooks
	cp  scripts/pre-push .git/hooks/pre-push


.PHONY: tests
tests:
	pipenv run python -m unittest discover tests/

.PHONY: run_app
run_app:
	pipenv run app

