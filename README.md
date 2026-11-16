# Livret du citoyen — Quiz iOS (Mai 2026)

App SwiftUI pour réviser le **Livret du citoyen** : concepts cliquables → ouverture du **PDF à la bonne page**, résumés par partie, quiz QCM.

## Contenu

- PDF : `VISA2026Quiz/Resources/VISA_2026.pdf` (copie de votre fichier)
- Métadonnées / quiz : `VISA2026Quiz/Resources/content.json` (pages alignées sur la **pagination du livret**, pas l’index du fichier si vous changez de PDF)

Le PDF officiel est **scanné** (peu de texte sélectionnable). L’app s’appuie sur **PDFKit** pour l’affichage et sur `content.json` pour les résumés et questions.

## Ouvrir sur Mac (iPhone)

### Option A — XcodeGen (recommandé)

```bash
brew install xcodegen   # une fois
cd /chemin/vers/VISA2026Quiz
xcodegen generate
open VISA2026Quiz.xcodeproj
```

1. Cible **VISA2026Quiz** → votre iPhone ou simulateur  
2. **Run** (⌘R)

### Option B — Xcode à la main

1. **File → New → Project → iOS App** (SwiftUI), nom `VISA2026Quiz`  
2. Remplacer / ajouter les fichiers du dossier `VISA2026Quiz/`  
3. Glisser `Resources/` dans le projet en cochant **Copy items** et **Create folder references** ou group + target membership  
4. Vérifier que `VISA_2026.pdf` et `content.json` apparaissent dans **Build Phases → Copy Bundle Resources**

## Enrichir

Éditez `content.json` :

- **`concepts`** : `title`, `page`, `summary`  
- **`quizzes`** : questions avec `explanationPage` pour le lien « Voir la source »

Pour générer plus de questions depuis les pages scannées, il faudrait de l’**OCR** ou saisie manuelle ; les scripts d’aperçu sont dans `SoftwareContract/.agent-scripts/` (`render-visa-thumb.py`).

## Structure de l’app

| Onglet    | Rôle |
|----------|------|
| Concepts | Liste par partie ; détail + lien PDF |
| Résumés  | Synthèses par partie |
| Quiz     | QCM avec correction et saut vers la page |
| PDF      | Lecteur intégral avec navigation |