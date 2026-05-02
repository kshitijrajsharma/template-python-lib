# template-python-lib

> A modern Python library template. Fork it, rename `mylib`, and ship.

## Stack

| Concern              | Tool                                                               |
| -------------------- | ------------------------------------------------------------------ |
| Package manager      | [uv](https://github.com/astral-sh/uv)                              |
| Build backend        | [uv_build](https://docs.astral.sh/uv/concepts/build-backend/)      |
| Linter + formatter   | [ruff](https://github.com/astral-sh/ruff)                          |
| Type checker         | [ty](https://github.com/astral-sh/ty)                              |
| Tests                | [pytest](https://docs.pytest.org/) + pytest-cov                    |
| Git hooks            | [pre-commit](https://pre-commit.com/)                              |
| Conventional commits | [commitizen](https://commitizen-tools.github.io/)                  |
| Task runner          | [just](https://github.com/casey/just)                              |
| Docs                 | [zensical](https://zensical.org/)                                  |
| CI/CD                | GitHub Actions + [setup-uv](https://github.com/astral-sh/setup-uv) |
| PyPI publish         | `uv publish` with API token (`PYPI_API_TOKEN` GitHub secret)       |

## Quick start

```bash
# 0. Install uv (if you don't have it)
curl -LsSf https://astral.sh/uv/install.sh | sh

# 1. Install just (one-liner - pick either)
uv tool install rust-just                                            # via uv

# 2. Set up the dev environment (creates .venv, installs hooks)
just setup

# 3. Run lint + tests
just lint
just test
```

## Recipes (`just --list`)

- `just setup`: sync deps and install pre-commit hooks
- `just lint`: ruff fix, ruff format, ty, pre-commit
- `just test`: pytest with coverage
- `just build`: produce sdist and wheel in `dist/`

## Renaming the package

Replace `mylib` with your library name in:

- `pyproject.toml` (`name`, `[tool.pytest.ini_options].addopts`, `[tool.coverage.run].source`, `[tool.commitizen].version_files`)
- `src/mylib/` → `src/<your_name>/`
- `tests/test_core.py` (`from mylib import ...`)
- `zensical.toml` (`site_name`)
- `docs/index.md`
- `README.md`

A one-shot rename:

```bash
NEW=your_name
git grep -l mylib | xargs sed -i "s/mylib/$NEW/g"
mv src/mylib src/$NEW
```

## Releasing

1. Make conventional-commit-formatted commits (`feat:`, `fix:`, `chore:`, etc.).
2. `uv run cz bump` bumps the version in `pyproject.toml` + `__init__.py`,
   updates `CHANGELOG.md`, and creates a git tag.
3. `git push --follow-tags`. The `Release` workflow builds with `uv build`
   and publishes to PyPI via `uv publish` using a token.

**One-time setup on GitHub:**

1. Create a project-scoped API token on PyPI (Account settings, API tokens).
2. Repo Settings, Environments, create an environment named `pypi`.
3. Add the token as a secret named `PYPI_API_TOKEN` on the `pypi` environment
   (recommended) or as a repo-level secret.
4. (Optional) Lock the `pypi` environment to tag pushes only via deployment
   branch rules.

## Docs

```bash
uv run zensical serve   # local preview
uv run zensical build   # build to ./site
```

The `Docs` workflow auto-deploys to GitHub Pages on push to `main`. Enable
Pages → Source: *GitHub Actions* in repo settings.

## Docker

A minimal multi-stage [Dockerfile](Dockerfile) is included - built on uv's
official slim base, with a clean `python:slim` runtime stage:

```bash
docker build -t mylib .
docker run --rm mylib
# → Hello, docker!
```

The image installs dependencies from `uv.lock` (frozen), drops privileges to a
non-root user, and is small enough for a library smoke-test or as the
foundation for a CLI/server image.

## Adding dependencies

Always use `uv add` - never edit `pyproject.toml` deps by hand or call
`uv pip install`. uv resolves versions and updates `uv.lock` for you.

```bash
uv add httpx                       # runtime dep
uv add --dev mypy                  # dev tool
uv add --group docs mkdocstrings   # docs-only dep
uv remove httpx                    # remove
```

## License

MIT - see [LICENSE](LICENSE).
