# Guide de test en local

## Prérequis

1. **Clé API OpenAI** : Vous devez avoir une clé API OpenAI valide
   - Créez un compte sur https://platform.openai.com
   - Générez une clé API depuis https://platform.openai.com/api-keys

## Configuration

1. **Créer le fichier `.env`** à la racine du projet :
   ```bash
   touch .env
   ```

2. **Ajouter votre clé API** dans le fichier `.env` :
   ```
   OPENAI_API_KEY=sk-votre-cle-api-ici
   ```
   
   Remplacez `sk-votre-cle-api-ici` par votre vraie clé API OpenAI.

## Démarrer l'application

1. **Vérifier que la base de données est à jour** :
   ```bash
   rails db:migrate
   ```

2. **Démarrer le serveur** :
   ```bash
   rails server
   ```
   ou
   ```bash
   bin/dev
   ```

3. **Accéder à l'application** :
   - Ouvrir http://localhost:3000 dans votre navigateur

## Tester la création d'une dictée

1. **Créer un compte** ou se connecter
2. **Aller sur "Nouvelle dictée"** (bouton en haut à droite)
3. **Remplir le formulaire** :
   - **Niveau** : choisir un niveau (ex: CE1)
   - **Nombre minimum de mots** : optionnel (ex: 50)
   - **Nombre maximum de mots** : optionnel (ex: 100)
   - **Mots imposés** : optionnel (ex: maison, école)
   - **Règles d'orthographe/grammaire** : optionnel (ex: accord du participe passé)
4. **Cliquer sur "Créer la dictée"**
5. **Vérifier** :
   - La dictée est créée avec succès
   - Le contenu généré par OpenAI s'affiche
   - Le contenu ne contient que le texte de la dictée (pas d'explications, pas de préfixes)

## Vérifier les logs

Si la génération échoue, vérifier les logs du serveur pour voir l'erreur :
```bash
tail -f log/development.log
```

## Erreurs courantes

- **"Clé API OpenAI requise"** : 
  - Vérifier que le fichier `.env` existe à la racine du projet
  - Vérifier que `.env` contient `OPENAI_API_KEY=sk-...`
  - Redémarrer le serveur après avoir créé/modifié `.env`

- **"Clé API invalide"** : 
  - Vérifier que la clé API est correcte
  - Vérifier que la clé API est active sur votre compte OpenAI

- **"Limite de débit dépassée"** : 
  - Attendre quelques instants et réessayer
  - Vérifier votre quota sur https://platform.openai.com/usage

## Notes importantes

- Le fichier `.env` est ignoré par git (déjà configuré dans `.gitignore`)
- Ne jamais commiter votre clé API dans le dépôt
- Si la génération échoue, la dictée ne sera **pas créée** (comportement attendu)

