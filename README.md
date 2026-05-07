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
| Git hooks            | [pre-commit](https://pre-commit.com/) (ruff, ty, uv-lock, hygiene) |
| Conventional commits | [commitizen](https://commitizen-tools.github.io/)                  |
| Task runner          | [just](https://github.com/casey/just)                              |
| Docs                 | [zensical](https://zensical.org/) + mkdocstrings (auto API)        |
| CI/CD                | GitHub Actions + [setup-uv](https://github.com/astral-sh/setup-uv) |
| PyPI publish         | `uv publish` with API token (`PYPI_API_TOKEN` GitHub secret)       |
| Container image      | GHCR via `docker.yml`, build provenance attested                   |

## Quick start

```bash
# 0. Install uv (if you don't have it)
curl -LsSf https://astral.sh/uv/install.sh | sh

# 1. Install just (one-time, system-wide)
uv tool install rust-just

# 2. Set up the dev environment (creates .venv, installs hooks)
just setup

# 3. Run lint + tests
just lint
just test
```

## Recipes (`just --list`)

- `just setup`: sync deps and install pre-commit hooks
- `just lint`: run all pre-commit hooks (ruff fix, ruff format, ty, uv-lock, file hygiene)
- `just test`: pytest with coverage
- `just build`: produce sdist and wheel in `dist/`

## Renaming the package

Replace `mylib` with your library name in:

- `pyproject.toml` (`name`, `[tool.pytest.ini_options].addopts`, `[tool.coverage.run].source`, `[tool.commitizen].version_files`)
- `src/mylib/` -> `src/<your_name>/`
- `tests/test_core.py` (`from mylib import ...`)
- `zensical.toml` (`site_name`)
- `docs/index.md`, `docs/api.md` (the `::: mylib` line)
- `README.md`

A one-shot rename:

```bash
NEW=your_name
git grep -l mylib | xargs sed -i "s/mylib/$NEW/g"
mv src/mylib src/$NEW
```

## Adding dependencies

Always use `uv add`. Never edit `pyproject.toml` deps by hand or call `uv pip install`. uv resolves versions and updates `uv.lock` for you.

```bash
uv add httpx                       # runtime dep
uv add --dev mypy                  # dev tool
uv add --group docs mkdocstrings   # docs-only dep
uv remove httpx                    # remove
```

The `uv-lock` pre-commit hook fails the commit (and CI) if `uv.lock` is out of sync with `pyproject.toml`.

## Docs

```bash
uv run zensical serve   # local preview at http://127.0.0.1:8000
uv run zensical build   # build static site to ./site
```

`docs/index.md` is the landing page. `docs/api.md` is one line, `::: mylib`, which auto-renders the public API of your package via mkdocstrings: every class, function, and submodule under `src/mylib/` appears with no markdown edits. Add new code, rebuild, it shows up. Inject a specific symbol with `::: mylib.module.ClassName` if you want a focused page.

The `Docs` workflow auto-deploys to GitHub Pages on push to `main`. Enable Pages -> Source: *GitHub Actions* in repo settings.

## Releasing to PyPI

1. Make conventional-commit-formatted commits (`feat:`, `fix:`, `chore:`, etc.).
2. `uv run cz bump` bumps the version in `pyproject.toml` + `__init__.py`, updates `CHANGELOG.md`, creates a git tag.
3. `git push --follow-tags`. The `Release` workflow runs `uv build` and `uv publish` with the token.

**One-time setup on GitHub:**

1. Create a project-scoped API token on PyPI (Account settings, API tokens).
2. Repo Settings, Environments, create an environment named `pypi`.
3. Add the token as a secret named `PYPI_API_TOKEN` on the `pypi` environment (recommended) or as a repo-level secret.
4. (Optional) Lock the `pypi` environment to tag pushes only via deployment branch rules.

## Container image

The `Docker` workflow builds a multi-stage image (uv slim base for build, `python:slim` for runtime, non-root user) and pushes it to GitHub Container Registry on every push to `main`, every `v*` tag, and any manual run.

- Image: `ghcr.io/<owner>/<repo>`
- Tags emitted by `metadata-action`: branch name, semver decomposition (`1.2.3`, `1.2`, `1`), short sha, `latest` on default branch
- Cache: BuildKit GHA layer cache (`type=gha,mode=max`) plus a uv cache mount inside the Dockerfile
- Each push is signed with a build-provenance attestation viewable in the repo's Attestations tab
- PRs build the Dockerfile but **do not** push (verifies the image still builds without registry side-effects)

After the first run, set the package visibility to public (Repo Settings, Packages, your-package, Package settings, Change visibility) if you want anonymous pulls.

Local build:

```bash
docker build -t mylib .
docker run --rm mylib
# Hello, docker!
```

## CI surface

| Workflow      | Triggers                              | What it does                                                          |
| ------------- | ------------------------------------- | --------------------------------------------------------------------- |
| `ci.yml`      | push to `main`, PRs to `main`         | `pytest` matrix on Python 3.11/3.12/3.13/3.14 + `pre-commit` hooks    |
| `docs.yml`    | push to `main`, manual                | `zensical build` and deploy to GitHub Pages                           |
| `release.yml` | tag push `v*`                         | `uv build` and `uv publish` to PyPI via `PYPI_API_TOKEN`              |
| `docker.yml`  | push to `main`, tags, PRs, manual     | Build image; push and attest on non-PR events                         |

## License

MIT, see [LICENSE](LICENSE).
