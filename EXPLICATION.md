# Tetris - Projet DFX (Internet Computer)

## Architecture

```
tetris/
├── dfx.json                        # Configuration DFX (canisters)
├── package.json                    # Workspace racine
├── src/
│   ├── tetris_backend/
│   │   └── main.mo                 # Backend Motoko
│   └── tetris_frontend/
│       ├── package.json            # Dépendances frontend
│       ├── svelte.config.js        # Config SvelteKit (adapter-static)
│       ├── vite.config.js          # Config Vite (proxy, env DFX)
│       ├── src/
│       │   ├── app.html            # Shell HTML (fonts, meta)
│       │   ├── index.scss          # Styles globaux (thème néon)
│       │   ├── lib/canisters.js    # Connexion au backend canister
│       │   └── routes/
│       │       ├── +layout.js      # Prerendering activé
│       │       └── +page.svelte    # Composant Tetris (logique + rendu)
│       └── dist/                   # Build statique (généré)
└── .dfx/                           # État local DFX (généré)
```

## Prérequis

| Outil   | Version minimale | Installation                          |
|---------|-----------------|---------------------------------------|
| Node.js | >= 16.0.0       | https://nodejs.org                    |
| npm     | >= 7.0.0        | Inclus avec Node.js                   |
| dfx     | >= 0.30.0       | `sh -ci "$(curl -fsSL https://internetcomputer.org/install.sh)"` |

## Installation

```bash
cd tetris
npm install
```

Cela installe les dépendances du workspace racine et du frontend SvelteKit
(Svelte 5, Vite, adapter-static, dfinity/agent...).

## Lancement en mode développement (Vite)

```bash
cd src/tetris_frontend
npx vite --port 3000
```

Ouvre http://localhost:3000/ dans n'importe quel navigateur.
Hot reload activé, pas besoin de DFX.

## Déploiement sur la réplique locale (DFX)

### 1. Build du frontend

```bash
cd src/tetris_frontend
npx vite build
```

Génère le dossier `dist/` contenant les assets statiques.
Note : `npm run build` exécute d'abord `dfx generate` (prebuild).
Si le canister backend n'existe pas encore, utiliser `npx vite build` directement.

### 2. Démarrer la réplique locale

```bash
dfx start --background
```

### 3. Déployer les canisters

```bash
dfx deploy
```

### 4. Accéder au jeu

| URL | Navigateur |
|-----|-----------|
| `http://<canister-id>.localhost:8080/` | Chrome, Firefox |
| `http://127.0.0.1:8080/?canisterId=<canister-id>` | Fonctionne partiellement (assets cassés en legacy) |

Le canister ID est affiché après `dfx deploy`.
Safari ne résout pas `*.localhost` : utiliser Chrome/Firefox ou le serveur Vite.

### 5. Arrêter la réplique

```bash
dfx stop
```

## Déploiement via Docker

Depuis le dossier parent (`icp_container/`) :

```bash
# Tout construire et lancer
make super_start

# Ou étape par étape
make build_image        # Build l'image Docker
make create_container   # Crée le container (port 4943)
make start_container    # Lance le container

# Arrêter
make stop_container

# Nettoyer tout et relancer
make re
```

Le container expose le port 4943. Accès via :
`http://127.0.0.1:4943/?canisterId=<canister-id>`

## Commandes utiles

| Commande | Description |
|----------|-------------|
| `dfx start --background` | Démarre la réplique IC locale |
| `dfx stop` | Arrête la réplique |
| `dfx deploy` | Build + déploie tous les canisters |
| `dfx canister status tetris_frontend` | Vérifie l'état du canister |
| `dfx ping` | Vérifie que la réplique est en ligne |
| `npx vite build` | Build le frontend (sans dfx generate) |
| `npx vite --port 3000` | Serveur de dev avec hot reload |

## Stack technique

- **Frontend** : SvelteKit 2 + Svelte 5, Vite 5, TypeScript, SCSS
- **Backend** : Motoko (Internet Computer)
- **Déploiement** : adapter-static -> assets canister DFX
- **Conteneurisation** : Docker (image `icp-dev-env-slim`)
