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

### Release (responsable des releases)
```bash
git switch dev && git pull
cz bump                          # calcule la version, met à jour CHANGELOG.md, crée le tag
git push && git push --tags
# → ouvrir une PR dev → main, fusionner après approbation
```

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
