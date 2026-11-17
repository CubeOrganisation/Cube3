# Workflow Git – Collector.shop

## 1. Organisation de l'équipe

| Rôle | Responsabilités | Membre(s) |
|---|---|---|
| Développeur·se | Crée ses branches `feature/*`, ouvre les PR vers `dev` | Toute l'équipe |
| Relecteur·rice | Relit et approuve les PR (1 approbation minimum) | emi-rou |
| Responsable des releases | Ouvre la PR `dev` → `main`, lance `cz bump`, tague la version | JOJOK63|

Règles :
- Un seul dépôt commun, et tous les membres y sont ajoutés comme collaborateurs.
- `main` et `dev` sont **protégées** : aucun push direct, tout passe par une PR relue.
- Celui qui écrit une PR ne l'approuve pas lui-même.

## 2. Branches (Git Flow simplifié)

```
main      ●───────────────●────────── (production, tags v0.1.0, v0.2.0…)
           \             /
dev         ●──●────●───●──────────── (intégration)
                \  /  \/
feature/xxx      ●●    ●●            (une branche par fonctionnalité)
```

| Branche | Rôle | Créée depuis | Fusionnée dans |
|---|---|---|---|
| `main` | Production, stable, versionnée | — | — |
| `dev` | Intégration | `main` | `main` (release) |
| `feature/<nom>` | Une fonctionnalité | `dev` | `dev` via PR |
| `hotfix/<nom>` *(optionnel)* | Correctif urgent en prod | `main` | `main` + `dev` |

### Cycle d'une fonctionnalité
```bash
git switch dev && git pull
git switch -c feature/catalogue-articles
# ... travail ...
cz commit                       # ou git commit -m "feat(catalogue): ..."
git push -u origin feature/catalogue-articles
# → ouvrir une PR feature/catalogue-articles → dev, assigner un relecteur
```

## Release

1. Partir de `dev` à jour :
   ```bash
   git switch dev && git pull
   git switch -c release/x.y.z
   ```
2. Calculer et appliquer la version :
   ```bash
   uv run cz bump --dry-run    # vérifier la version proposée
   uv run cz bump              # version, CHANGELOG.md, commit et tag vX.Y.Z, en une commande
   git push -u origin release/x.y.z
   ```
3. PR `release/x.y.z → main`, mergée en **Create a merge commit** (pas de squash : le tag doit rester dans l'historique de `main`).
4. Après le merge : `git push origin vX.Y.Z` → le workflow `release.yml` crée la release GitHub.
5. PR `main → dev` (merge commit) pour que `dev` récupère la version et le changelog.

## Hotfix

Correction urgente d'un bug présent sur `main` :

1. `git switch main && git pull`, puis `git switch -c hotfix/description`.
2. Corriger avec un commit `fix: …`, puis `uv run cz bump` (version de correctif).
3. PR `hotfix/… → main` (merge commit), puis `git push origin vX.Y.Z`.
4. PR `main → dev` pour reporter la correction.

## Definition of Done

Une tâche est terminée quand :

- [ ] le code respecte Ruff, Black et mypy (hooks pre-commit et CI verts) ;
- [ ] les fonctions publiques ont une docstring ;
- [ ] des tests couvrent le nouveau code (couverture ≥ 80 % dès qu'elle sera exigée) ;
- [ ] les messages de commit et le titre de la PR respectent Conventional Commits ;
- [ ] la PR est relue, approuvée et ses conversations sont résolues ;
- [ ] la documentation (README, CONTRIBUTING) est à jour si besoin ;
- [ ] l'issue liée est fermée (`Closes #N`).

## 3. Commits standardisés (Conventional Commits)

Format : `type(scope): description`

| Type | Usage | Effet sur la version |
|---|---|---|
| `feat` | Nouvelle fonctionnalité | MINOR |
| `fix` | Correction de bug | PATCH |
| `docs` | Documentation | — |
| `style` | Formatage, sans changement de logique | — |
| `refactor` | Restructuration du code | — |
| `test` | Ajout ou modification de tests | — |
| `chore` | Maintenance, dépendances | — |
| `ci` | Pipeline CI/CD | — |

Changement cassant (MAJOR) : `feat!: ...` ou footer `BREAKING CHANGE: ...`

Exemples :
```
feat(panier): ajouter un article au panier
fix(auth): corriger l'expiration du token
feat(api)!: renommer /items en /articles

BREAKING CHANGE: l'endpoint /items est supprimé
```

## 4. Installation sur chaque poste (une fois)

```bash
pip install commitizen pre-commit
pre-commit install          # installe les hooks pre-commit, commit-msg et pre-push
```

Les hooks vérifient ensuite automatiquement :
- **commit-msg** : un message non conforme est refusé ;
- **pre-push** : une branche qui contient un commit non conforme n'est pas poussée ;
- **pre-commit** : les espaces, fichiers YAML et marqueurs de conflit, et aucun commit direct sur `main` ou `dev`.

Pour écrire un commit de manière guidée : `cz commit`.

## 5. Protection des branches (admin, une fois)

```bash
./scripts/protect-branches.sh <owner>/<repo>
```
Ou à la main : *Settings → Branches → Add rule* sur `main` et `dev` : *Require a pull request*, 1 approbation, *Require review from Code Owners*, sans force push ni suppression.
x
