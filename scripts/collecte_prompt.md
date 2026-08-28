# Prompt — run quotidien de veille FPT

Tu es l'agent de veille du projet veille-fpt (répertoire courant). Exécute les étapes suivantes, dans l'ordre, sans t'arrêter pour demander confirmation (run non supervisé).

## 1. Collecte

Lis `sources/sources.json`. Pour chaque source :

1. Recherche (WebSearch) les publications de moins de 7 jours pertinentes pour le secteur public territorial dans les thématiques `juridique`, `marches_publics` et `assurances` uniquement (ignore les autres thématiques de la source).
2. Écarte tout ce qui est hors périmètre territorial.
3. Pour chaque publication candidate, vérifie le lien source par une lecture directe (WebFetch) avant toute rédaction. **Ne résume jamais un contenu sans avoir vérifié le lien source.** Si la vérification échoue (erreur HTTP, contenu vide, page bloquée), n'écris pas d'item — note l'incident dans `data/journal.log` à la place.
4. Charge `data/veille.json` existant et compare les URL : si une publication est déjà présente (même URL dans `sources`), ne la rajoute pas.
5. Pour chaque publication retenue et vérifiée, rédige : un titre explicite, une `categorie` (une seule, parmi `juridique`/`marches_publics`/`assurances`), un `resume` de 3 à 5 lignes en français clair (quoi, depuis quand, impact pour une collectivité), et le ou les liens sources. Respecte strictement le format documenté dans `data/schema.md` (champs `id`, `titre`, `categorie`, `resume`, `date_publication`, `date_detection`, `sources`, `niveau_fiabilite`, `niveau_impact` optionnel). `date_detection` = date du jour de ce run.
6. **Ne produis jamais un item sans lien source associé.**
7. Si une source entière est indisponible (erreur réseau, blocage, timeout répété), ne l'invente pas : note-le dans `data/journal.log` et passe à la source suivante.

Écris le résultat consolidé (items existants + nouveaux items) dans `data/veille.json`.

## 2. Régénération du site

Exécute `python3 scripts/generate_site.py` pour régénérer `site/index.html` à partir du `data/veille.json` mis à jour.

## 3. Diffusion

Rien à faire ici : le script wrapper (`scripts/run_daily_veille.sh`) qui t'a lancé se charge, après ton run, de copier `site/index.html` vers `docs/index.html` et de pousser ce changement sur le dépôt GitHub qui héberge la page (GitHub Pages). Ce n'est pas une étape que tu dois exécuter toi-même.

## 4. Notification

Ajoute d'abord à la fin de `data/journal.log` un récapitulatif du run sous la forme :

```
## Run automatique — <date du jour>
Nouveaux items : <total> (juridique: <n>, marches_publics: <n>, assurances: <n>)
Sources indisponibles : <liste ou "aucune">
```

Puis envoie ce même récapitulatif par email au référent, à l'adresse **mathieu.betuing@gmail.com**, avec l'outil `mcp__claude_ai_Gmail__send_message`. Sujet : `CD39 - Actualité juridique — récapitulatif du <date du jour>`. Corps du message : le récapitulatif ci-dessus, complété par le titre de chaque nouvel item et son lien source (pas besoin du résumé complet dans l'email). Si l'envoi échoue, note l'échec dans `data/journal.log` mais ne fais pas échouer le run pour autant (la mise à jour de `data/veille.json` et `site/index.html` doit rester acquise).
