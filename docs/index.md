# mylib

A modern Python library - built with [uv], [ruff], [ty], [pytest], [commitizen],
and [zensical].

## Install

```bash
uv add mylib
# or
pip install mylib
```

## Usage

```python
from mylib import greet

print(greet("world"))  # → "Hello, world!"
```

## About this stack:

- **[uv]** - fast, all-in-one Python package manager (replaces pip, pip-tools, virtualenv, pyenv, twine).
- **[ruff]** - linter + formatter, replaces black, isort, flake8, pyupgrade.
- **[ty]** - fast type checker (Astral).
- **[pytest]** + **pytest-cov** - testing and coverage.
- **[pre-commit]** - runs lint/format/typecheck on each commit.
- **[commitizen]** - conventional commits + automated version bumping.
- **[zensical]** - modern docs (by the Material for MkDocs team).

[uv]: https://github.com/astral-sh/uv
[ruff]: https://github.com/astral-sh/ruff
[ty]: https://github.com/astral-sh/ty
[pytest]: https://docs.pytest.org/
[pre-commit]: https://pre-commit.com/
[commitizen]: https://commitizen-tools.github.io/commitizen/
[zensical]: https://zensical.org/
