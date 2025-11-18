# Configuration des Branch Protection Rules

Ce document explique comment configurer les protections de branche sur GitHub pour exiger que Rubocop et les tests passent avant de pouvoir merger.

## Méthode 1 : Via l'interface GitHub (Recommandée)

1. Allez sur votre repository GitHub : https://github.com/anietchka/dictation_app
2. Cliquez sur **Settings** (Paramètres)
3. Dans le menu de gauche, cliquez sur **Branches**
4. Dans la section **Branch protection rules**, cliquez sur **Add rule** (Ajouter une règle)
5. Dans le champ **Branch name pattern**, entrez : `main`
6. Cochez les options suivantes :
   - ✅ **Require a pull request before merging**
     - Optionnel : cochez "Require approvals" et définissez le nombre d'approbations (recommandé : 1)
   - ✅ **Require status checks to pass before merging**
     - Cochez **Require branches to be up to date before merging**
     - Dans la liste des status checks, cochez :
       - `lint` (Rubocop)
       - `test` (Tests unitaires)
       - `system-test` (Tests système) - optionnel mais recommandé
   - ✅ **Require conversation resolution before merging** (optionnel mais recommandé)
   - ✅ **Do not allow bypassing the above settings** (recommandé pour la sécurité)

7. Cliquez sur **Create** (Créer)

## Méthode 2 : Via GitHub CLI

Si vous avez GitHub CLI configuré avec les permissions appropriées :

```bash
gh api repos/anietchka/dictation_app/branches/main/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["lint","test","system-test"]}' \
  --field enforce_admins=true \
  --field required_pull_request_reviews='{"required_approving_review_count":1}' \
  --field restrictions=null
```

## Vérification

Après configuration, lorsque vous créez une Pull Request vers `main` :
- Les jobs CI (`lint`, `test`, `system-test`) doivent tous passer
- La PR ne pourra pas être mergée tant que tous les checks ne sont pas verts
- Un message apparaîtra indiquant "All checks have passed" ou listant les checks en attente/échoués

