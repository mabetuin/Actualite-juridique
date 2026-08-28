# Schéma d'un item de veille

Ce document décrit le format d'un item stocké dans la base de veille (`/data`). Chaque item représente une information détectée sur l'une des sources déclarées dans [`/sources/sources.json`](../sources/sources.json).

## Champs

| Champ              | Type              | Obligatoire | Description |
|---------------------|-------------------|:-----------:|--------------|
| `id`                | string            | oui         | Identifiant unique de l'item (ex. `2026-08-28-legifrance-001`). |
| `titre`             | string            | oui         | Titre court et explicite de l'information. |
| `categorie`         | string            | oui         | Thématique principale. Une des valeurs : `juridique`, `marches_publics`, `assurances`, `rh_fpt`, `europe`. |
| `resume`            | string            | oui         | Résumé de l'information en 3 à 5 lignes, compréhensible sans lire la source. |
| `date_publication`  | string (AAAA-MM-JJ) | oui       | Date de publication de l'information par la source d'origine. |
| `date_detection`    | string (AAAA-MM-JJ) | oui       | Date à laquelle l'item a été détecté par la collecte. |
| `sources`           | tableau de string (URL) | oui  | Une ou plusieurs URL pointant vers le(s) document(s) d'origine. |
| `niveau_fiabilite`  | string            | oui         | Fiabilité de l'information. Une des valeurs : `officiel`, `presse_specialisee`. |
| `niveau_impact`     | string            | non         | Impact estimé pour les agents de la FPT. Une des valeurs : `faible`, `moyen`, `fort`. |

## Exemple

```json
{
  "id": "2026-08-28-legifrance-001",
  "titre": "Décret modifiant les règles de publicité des marchés publics de faible montant",
  "categorie": "marches_publics",
  "resume": "Un décret publié au Journal officiel relève le seuil de dispense de publicité et de mise en concurrence pour les marchés publics. Les collectivités territoriales pourront ainsi passer certains marchés de faible montant sans formalité préalable. Le texte entre en vigueur le mois suivant sa publication. Les services marchés publics des collectivités doivent mettre à jour leurs procédures internes en conséquence.",
  "date_publication": "2026-08-20",
  "date_detection": "2026-08-28",
  "sources": [
    "https://www.legifrance.gouv.fr/jorf/id/EXEMPLE000000000"
  ],
  "niveau_fiabilite": "officiel",
  "niveau_impact": "fort"
}
```

## Notes

- `categorie` reprend une seule valeur parmi les `thematiques` possibles d'une source (une source peut couvrir plusieurs thématiques, un item n'en couvre qu'une, la plus pertinente).
- `niveau_fiabilite` est dérivé de la `nature` de la source d'origine (`officiel` ou `presse_specialisee`), telle que définie dans `/sources/sources.json`.
- `niveau_impact` est laissé à l'appréciation de la collecte ou d'une relecture manuelle ; il peut être omis si non déterminé.
