#!/bin/bash

# Script pour créer un nouveau repository GitHub template à partir du projet actuel
# Usage: ./scripts/create_template_repo.sh [template-repo-name]

TEMPLATE_REPO_NAME="${1:-rails8-template}"
REPO_OWNER="anietchka"
CURRENT_REPO="dictation_app"

echo "🚀 Création du repository template: $TEMPLATE_REPO_NAME"
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

# Créer le nouveau repository
echo "📦 Création du repository sur GitHub..."
gh repo create "$REPO_OWNER/$TEMPLATE_REPO_NAME" \
  --public \
  --description "Rails 8 template avec authentification, CI/CD, Dependabot et best practices" \
  --template=false

if [ $? -ne 0 ]; then
    echo "❌ Erreur lors de la création du repository"
    echo "Le repository existe peut-être déjà. Voulez-vous continuer ? (y/n)"
    read -r response
    if [ "$response" != "y" ]; then
        exit 1
    fi
fi

echo "✅ Repository créé: https://github.com/$REPO_OWNER/$TEMPLATE_REPO_NAME"
echo ""

# Ajouter le nouveau remote
echo "🔗 Ajout du remote template..."
git remote add template "https://github.com/$REPO_OWNER/$TEMPLATE_REPO_NAME.git" 2>/dev/null || \
git remote set-url template "https://github.com/$REPO_OWNER/$TEMPLATE_REPO_NAME.git"

echo "✅ Remote 'template' configuré"
echo ""

# Pousser toutes les branches
echo "📤 Poussage de toutes les branches..."
git push template --all

# Pousser tous les tags (s'il y en a)
echo "📤 Poussage des tags..."
git push template --tags

echo ""
echo "✅ Toutes les branches ont été poussées vers le template"
echo ""

# Marquer le repository comme template
echo "🏷️  Marquage du repository comme template..."
gh api "repos/$REPO_OWNER/$TEMPLATE_REPO_NAME" \
  --method PATCH \
  --field is_template=true

if [ $? -eq 0 ]; then
    echo "✅ Repository marqué comme template"
else
    echo "⚠️  Impossible de marquer automatiquement comme template"
    echo "   Allez sur https://github.com/$REPO_OWNER/$TEMPLATE_REPO_NAME/settings"
    echo "   et cochez 'Template repository' dans les options"
fi

echo ""
echo "🎉 Template créé avec succès !"
echo ""
echo "📋 Prochaines étapes :"
echo "   1. Allez sur https://github.com/$REPO_OWNER/$TEMPLATE_REPO_NAME"
echo "   2. Vérifiez que 'Template repository' est coché dans Settings"
echo "   3. Vous pouvez maintenant utiliser 'Use this template' pour créer de nouveaux projets"
echo ""
echo "🔗 URL du template: https://github.com/$REPO_OWNER/$TEMPLATE_REPO_NAME"

