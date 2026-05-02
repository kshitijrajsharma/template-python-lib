set shell := ["bash", "-uc"]

# Default: list available recipes
default:
    @just --list

# Sync the dev environment (creates .venv) and install pre-commit hooks
setup:
    uv sync --all-groups
    uv run pre-commit install --install-hooks --hook-type pre-commit --hook-type commit-msg

# Run all pre-commit hooks (ruff fix, ruff format, ty, file hygiene)
lint:
    uv run pre-commit run --all-files

# Run the test suite with coverage
test *ARGS:
    uv run pytest {{ARGS}}

# Build sdist and wheel into dist/
build:
    uv build
