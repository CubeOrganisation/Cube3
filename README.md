# Cube3

Description du projet en deux phrases.

## Prérequis

- [uv](https://docs.astral.sh/uv/) (installe Python 3.13 automatiquement)
- Git

## Installation

```bash
git clone <url-du-depot>
cd Cube3
uv sync                      # crée .venv avec Python 3.13 et les dépendances
uv run pre-commit install    # active les vérifications à chaque commit
```

## Commandes utiles

```bash
uv run pytest            # tests
uv run ruff check .      # lint
uv run black .           # formatage
uv run cz commit         # assistant de message de commit
```

## Qualité et conventions

| Élément | Outil | Configuration |
| --- | --- | --- |
| Environnement | uv, Python 3.13 | `pyproject.toml`, `uv.lock`, `.python-version` |
| Lint | Ruff | `pyproject.toml` |
| Formatage | Black | `pyproject.toml` |
| Tests | pytest | `pyproject.toml`, dossier `tests/` |
| Messages de commit | Conventional Commits, Commitizen | `.cz.toml` |
| Vérifications avant commit | pre-commit | `.pre-commit-config.yaml` |
| Intégration continue | GitHub Actions | `.github/workflows/ci.yml` |
| Style d'édition | EditorConfig | `.editorconfig` |
| Fins de ligne (LF) | Git | `.gitattributes` |
| Versions | SemVer, tags `vX.Y.Z` | `.cz.toml` |
| Documentation du code | Ruff (règles `D`, style Google) | `pyproject.toml` |
| Complexité maximale (10) | Ruff (règles `C90`) | `pyproject.toml` |
| Failles des dépendances | pip-audit (CI) | `.github/workflows/ci.yml` |
## Branches

- `main` : versions stables
- `dev` : intégration (branche par défaut)
- `feature/…` : une branche par tâche, fusionnée dans `dev` par pull request

`main` et `dev` sont protégées : pas de push direct, une approbation obligatoire.

## Contribuer

Le workflow complet (branches, commits, pull requests, relecture) est décrit dans
[CONTRIBUTING.md](CONTRIBUTING.md).
