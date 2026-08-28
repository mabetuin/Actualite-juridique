#!/bin/zsh
# Lance le run quotidien de veille FPT via la CLI Claude Code, en headless,
# puis déploie la page mise à jour sur GitHub Pages (dossier /docs).
# Déclenché par launchd (voir ~/Library/LaunchAgents/com.veillefpt.daily.plist).

set -uo pipefail

PROJET_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJET_DIR"

LOG_DIR="$PROJET_DIR/scripts/logs"
mkdir -p "$LOG_DIR"

HORODATAGE="$(date +%Y-%m-%d_%H%M%S)"
LOG_FICHIER="$LOG_DIR/run-$HORODATAGE.log"

PROMPT="$(cat "$PROJET_DIR/scripts/collecte_prompt.md")"

{
  echo "=== Démarrage run veille-fpt : $(date) ==="

  claude --print "$PROMPT"
  CODE_CLAUDE=$?
  if [ "$CODE_CLAUDE" -ne 0 ]; then
    echo "AVERTISSEMENT : la session Claude s'est terminée avec le code $CODE_CLAUDE"
  fi

  echo "--- Déploiement GitHub Pages ---"
  if [ -f "$PROJET_DIR/site/index.html" ]; then
    cp "$PROJET_DIR/site/index.html" "$PROJET_DIR/docs/index.html"
    git add docs/index.html site/index.html data/veille.json data/journal.log

    if git diff --cached --quiet; then
      echo "Rien à déployer (aucun changement)."
    else
      if git commit -m "Mise à jour automatique du $(date +%Y-%m-%d)" && git push origin main; then
        echo "Déploiement réussi."
      else
        echo "ÉCHEC du déploiement Git."
        printf '\n## Échec de déploiement Git — %s\nLa mise à jour automatique n'"'"'a pas pu être poussée vers le dépôt distant. Voir scripts/logs/%s pour le détail.\n' \
          "$(date +%Y-%m-%d)" "$(basename "$LOG_FICHIER")" >> "$PROJET_DIR/data/journal.log"
      fi
    fi
  else
    echo "site/index.html introuvable, déploiement ignoré."
  fi

  echo "=== Fin run veille-fpt : $(date) ==="
} >> "$LOG_FICHIER" 2>&1
