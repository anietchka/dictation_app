#!/bin/bash

# Script pour configurer les branch protection rules sur GitHub
# Usage: ./setup-branch-protection.sh [branch-name]
# Par défaut: main

BRANCH="${1:-main}"
REPO="anietchka/dictation_app"

echo "Configuration des branch protection rules pour la branche: $BRANCH"
echo "Repository: $REPO"
echo ""

# Vérifier que gh CLI est installé et authentifié
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) n'est pas installé."
    echo "Installez-le depuis: https://cli.github.com/"
    exit 1
fi

if ! gh auth status &> /dev/null; then
    echo "❌ Vous n'êtes pas authentifié avec GitHub CLI."
    echo "Exécutez: gh auth login"
    exit 1
fi

echo "✅ GitHub CLI est configuré"
echo ""

# Configurer les branch protection rules
echo "Configuration des protections..."
gh api "repos/$REPO/branches/$BRANCH/protection" \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["lint","test","system-test"]}' \
  --field enforce_admins=true \
  --field required_pull_request_reviews='{"required_approving_review_count":1,"dismiss_stale_reviews":true,"require_code_owner_reviews":false}' \
  --field restrictions=null \
  --field allow_force_pushes=false \
  --field allow_deletions=false

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Branch protection rules configurées avec succès pour '$BRANCH'"
    echo ""
    echo "Les règles configurées:"
    echo "  - ✅ Require status checks: lint, test, system-test"
    echo "  - ✅ Require branches to be up to date before merging"
    echo "  - ✅ Require pull request reviews (1 approval minimum)"
    echo "  - ✅ Enforce for administrators"
    echo "  - ✅ Block force pushes"
    echo "  - ✅ Block branch deletion"
else
    echo ""
    echo "❌ Erreur lors de la configuration des branch protection rules"
    echo "Vérifiez que vous avez les permissions nécessaires sur le repository"
    exit 1
fi

