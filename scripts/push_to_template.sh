#!/bin/bash

# Script pour pousser toutes les branches vers un repository template existant
# Usage: ./scripts/push_to_template.sh [template-repo-url]

TEMPLATE_REPO_URL="${1:-https://github.com/anietchka/rails8-template.git}"

echo "📤 Poussage vers le repository template..."
echo "Repository: $TEMPLATE_REPO_URL"
echo ""

# Ajouter le remote template
echo "🔗 Configuration du remote 'template'..."
git remote remove template 2>/dev/null
git remote add template "$TEMPLATE_REPO_URL"

if [ $? -ne 0 ]; then
    echo "❌ Erreur lors de l'ajout du remote"
    exit 1
fi

echo "✅ Remote 'template' configuré"
echo ""

# Vérifier que le repository existe
echo "🔍 Vérification du repository..."
if ! git ls-remote --heads template &>/dev/null; then
    echo "❌ Le repository n'existe pas ou n'est pas accessible"
    echo ""
    echo "💡 Créez d'abord le repository sur GitHub :"
    echo "   1. Allez sur https://github.com/new"
    echo "   2. Nom: rails8-template"
    echo "   3. Description: Rails 8 template avec authentification, CI/CD, Dependabot"
    echo "   4. Public ou Privé"
    echo "   5. Ne cochez PAS 'Initialize with README'"
    echo "   6. Cliquez sur 'Create repository'"
    echo ""
    echo "Ensuite, relancez ce script avec l'URL complète :"
    echo "   ./scripts/push_to_template.sh https://github.com/anietchka/rails8-template.git"
    exit 1
fi

echo "✅ Repository trouvé"
echo ""

# Pousser toutes les branches
echo "📤 Poussage de toutes les branches..."
git push template --all

if [ $? -ne 0 ]; then
    echo "❌ Erreur lors du push des branches"
    exit 1
fi

echo "✅ Toutes les branches ont été poussées"
echo ""

# Pousser tous les tags
echo "📤 Poussage des tags..."
git push template --tags 2>/dev/null

echo ""
echo "🎉 Push terminé avec succès !"
echo ""
echo "📋 Prochaines étapes :"
echo "   1. Allez sur https://github.com/anietchka/rails8-template/settings"
echo "   2. Cochez 'Template repository' dans les options"
echo "   3. Vous pourrez alors utiliser 'Use this template' pour créer de nouveaux projets"
echo ""

