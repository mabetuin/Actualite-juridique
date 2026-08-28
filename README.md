# veille-fpt

Agent de veille automatisée pour les agents de la **fonction publique territoriale (FPT)**, couvrant trois domaines :

- **Juridique** — textes de loi, décrets, jurisprudence administrative
- **Marchés publics** — appels d'offres, réglementation de la commande publique
- **Assurances** — évolutions réglementaires et contractuelles pour les collectivités

## Objectif

Ce projet permet de surveiller automatiquement un ensemble de sources officielles et professionnelles, puis de restituer les informations collectées de deux façons complémentaires :

1. **Via Claude** — en interrogeant directement les données structurées du dossier `/data` dans une conversation.
2. **Via une page HTML autonome** (`/site`) — consultable par n'importe quel agent de la collectivité, sans avoir besoin d'une licence Claude ni d'un compte particulier.

L'idée est de centraliser une veille utile aux agents territoriaux (services juridiques, marchés publics, assurances) tout en rendant l'information accessible à tous, y compris aux personnes qui n'utilisent pas d'outils IA au quotidien.

Pour les agents qui consultent la page de veille, voir le [guide d'utilisation](GUIDE_UTILISATION.md) : comment la consulter, comprendre les catégories et niveaux de fiabilité, et signaler une erreur ou proposer une source.

## Structure du projet

```
veille-fpt/
├── sources/    # Configuration des sites et flux à surveiller
├── data/       # Base de veille au format structuré (résultats collectés)
├── site/       # Page HTML générée, consultable sans licence Claude
├── scripts/    # Scripts de collecte des sources et de génération du site
└── README.md
```

### `/sources`
Contient la configuration déclarative des sites à surveiller (URL, domaine — juridique / marchés publics / assurances, fréquence, mots-clés).

### `/data`
Contient la base de veille : les éléments collectés, structurés (par exemple en JSON), avec leurs métadonnées (date, source, domaine, résumé, lien).

### `/site`
Contient la page HTML générée à partir des données de `/data`, destinée aux agents qui n'ont pas accès à Claude.

### `/scripts`
Contient les scripts qui collectent les sources déclarées dans `/sources`, alimentent `/data`, puis génèrent la page dans `/site`.

## Utilisation prévue

1. Déclarer les sites à surveiller dans `/sources`.
2. Lancer la collecte (scripts dans `/scripts`) pour alimenter `/data`.
3. Générer la page HTML de restitution dans `/site`.
4. Consulter la veille soit directement via Claude (lecture de `/data`), soit via la page HTML partagée aux agents.
