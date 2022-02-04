# See https://madewithml.com/courses/mlops/makefile/
# Need .PHONY since `docs` is already taken
.PHONY: docs
docs:
	jupyter-book build docs

docsrm:
	rm -rf docs/_build
	make docs

clean:
	find . -type f -name "*.DS_Store" -ls -delete
	find . | grep -E "(__pycache__|\.pyc|\.pyo)" | xargs rm -rf
	find . | grep -E ".pytest_cache" | xargs rm -rf
	find . | grep -E ".ipynb_checkpoints" | xargs rm -rf
	rm -f .coverage

commit: clean
	git add .
	git commit -m "${m}"
	git push

push: docsrm
	ghp-import -n -p -f docs/_build/html
	git status

deploy: commit docsrm
	ghp-import -n -p -f docs/_build/html
	git status


# # Each line in a recipe will execute in a separate sub-shell.
# # Using .ONESHELL executes all steps in a single shell.
# .ONESHELL:
# venv:
#     python3 -m venv ${name}
#     source ${name}/bin/activate
#     python -m pip install --upgrade pip setuptools wheel
#     python -m pip install -e ".[dev]" --no-cache-dir
#     pre-commit install
#     pre-commit autoupdate
#     pip uninstall dataclasses -y
