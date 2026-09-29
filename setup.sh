#!/usr/bin/env bash
# ============================================================
# Pokémon Team Builder - Initial Setup Script
#
# HOW TO USE:
#   1. Open a terminal (Git Bash on Windows, or Terminal on Mac/Linux)
#   2. Clone your repo and go into it:
#        git clone https://github.com/marcinsadowy/teambuilder.git
#        cd teambuilder
#   3. Save this script as setup.sh in that folder
#   4. Run it:
#        bash setup.sh
#   It will create all project files, commit and push to GitHub.
# ============================================================
set -euo pipefail

echo ">> Creating project files..."

mkdir -p src .github/workflows

# ------------------------------------------------------------
cat > .gitignore <<'EOF'
node_modules
dist
.DS_Store
*.local
EOF

# ------------------------------------------------------------
cat > package.json <<'EOF'
{
  "name": "teambuilder",
  "private": true,
  "version": "0.1.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "@emotion/react": "^11.13.0",
    "@emotion/styled": "^11.13.0",
    "@mui/icons-material": "^6.1.0",
    "@mui/material": "^6.1.0",
    "react": "^18.3.1",
    "react-dom": "^18.3.1"
  },
  "devDependencies": {
    "@vitejs/plugin-react": "^4.3.1",
    "vite": "^5.4.8"
  }
}
EOF

# ------------------------------------------------------------
cat > vite.config.js <<'EOF'
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// 'base' must match the repo name so assets load correctly on GitHub Pages:
// https://marcinsadowy.github.io/teambuilder/
export default defineConfig({
  base: '/teambuilder/',
  plugins: [react()],
});
EOF

# ------------------------------------------------------------
cat > index.html <<'EOF'
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="theme-color" content="#1976d2" />
    <title>Pokémon Team Builder</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
EOF

# ------------------------------------------------------------
cat > src/main.jsx <<'EOF'
import React from 'react';
import ReactDOM from 'react-dom/client';
import { ThemeProvider, CssBaseline } from '@mui/material';
import theme from './theme';
import App from './App';

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <App />
    </ThemeProvider>
  </React.StrictMode>
);
EOF

# ------------------------------------------------------------
cat > src/theme.js <<'EOF'
import { createTheme } from '@mui/material/styles';

const theme = createTheme({
  palette: {
    primary: { main: '#1976d2' },
    secondary: { main: '#f50057' },
    background: { default: '#f4f6f8' },
  },
});

export default theme;
EOF

# ------------------------------------------------------------
cat > src/App.jsx <<'EOF'
import { useState } from 'react';
import {
  AppBar, Toolbar, Typography, Container, Box, Grid, Card, CardContent,
  CardMedia, Button, TextField, Chip,
} from '@mui/material';

// Placeholder Pokémon (Gen 4 starters) — will be replaced by our Platinum JSON data later.
// Sprites come from PokéAPI's public sprite CDN.
const SPRITES = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon';
const MOCK_POKEMON = [
  { id: 387, name: 'turtwig', types: ['grass'] },
  { id: 388, name: 'grotle', types: ['grass'] },
  { id: 389, name: 'torterra', types: ['grass', 'ground'] },
  { id: 390, name: 'chimchar', types: ['fire'] },
  { id: 391, name: 'monferno', types: ['fire', 'fighting'] },
  { id: 392, name: 'infernape', types: ['fire', 'fighting'] },
  { id: 393, name: 'piplup', types: ['water'] },
  { id: 394, name: 'prinplup', types: ['water'] },
  { id: 395, name: 'empoleon', types: ['water', 'steel'] },
];

const TYPE_COLORS = {
  grass: '#78c850', fire: '#f08030', water: '#6890f0',
  ground: '#e0c068', fighting: '#c03028', steel: '#b8b8d0',
};

function App() {
  const [team, setTeam] = useState([]);
  const [search, setSearch] = useState('');

  const addToTeam = (p) => {
    if (team.length < 6 && !team.some((t) => t.id === p.id)) setTeam([...team, p]);
  };
  const removeFromTeam = (p) => setTeam(team.filter((t) => t.id !== p.id));

  const filtered = MOCK_POKEMON.filter((p) =>
    p.name.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <Box>
      <AppBar position="static">
        <Toolbar>
          <Typography variant="h6">Pokémon Team Builder</Typography>
        </Toolbar>
      </AppBar>

      <Container maxWidth="lg" sx={{ py: 4 }}>
        {/* Team slots */}
        <Typography variant="h5" gutterBottom>Your Team ({team.length}/6)</Typography>
        <Grid container spacing={2} sx={{ mb: 5 }}>
          {Array.from({ length: 6 }).map((_, i) => {
            const p = team[i];
            return (
              <Grid item xs={6} sm={4} md={2} key={i}>
                <Card
                  variant={p ? 'elevation' : 'outlined'}
                  sx={{ height: '100%', textAlign: 'center', py: 1 }}
                >
                  {p ? (
                    <>
                      <CardMedia
                        component="img"
                        image={`${SPRITES}/${p.id}.png`}
                        alt={p.name}
                        sx={{ width: 96, height: 96, mx: 'auto', imageRendering: 'pixelated' }}
                      />
                      <CardContent sx={{ py: 0 }}>
                        <Typography variant="subtitle1">{p.name}</Typography>
                        <Button size="small" color="error" onClick={() => removeFromTeam(p)}>
                          Remove
                        </Button>
                      </CardContent>
                    </>
                  ) : (
                    <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'center', height: 140 }}>
                      <Typography variant="body2" color="text.secondary">Empty slot</Typography>
                    </Box>
                  )}
                </Card>
              </Grid>
            );
          })}
        </Grid>

        {/* Search */}
        <TextField
          label="Search Pokémon"
          variant="outlined"
          size="small"
          sx={{ mb: 2, width: 300 }}
          value={search}
          onChange={(e) => setSearch(e.target.value)}
        />

        {/* Available Pokémon */}
        <Grid container spacing={2}>
          {filtered.map((p) => (
            <Grid item xs={6} sm={4} md={3} lg={2} key={p.id}>
              <Card sx={{ textAlign: 'center', py: 1 }}>
                <CardMedia
                  component="img"
                  image={`${SPRITES}/${p.id}.png`}
                  alt={p.name}
                  sx={{ width: 96, height: 96, mx: 'auto', imageRendering: 'pixelated' }}
                />
                <CardContent sx={{ py: 0 }}>
                  <Typography variant="subtitle1">{p.name}</Typography>
                  <Box sx={{ display: 'flex', gap: 0.5, justifyContent: 'center', my: 1 }}>
                    {p.types.map((t) => (
                      <Chip key={t} label={t} size="small" sx={{ bgcolor: TYPE_COLORS[t] ?? '#999', color: '#fff' }} />
                    ))}
                  </Box>
                  <Button
                    variant="contained"
                    size="small"
                    onClick={() => addToTeam(p)}
                    disabled={team.length >= 6 || team.some((t) => t.id === p.id)}
                  >
                    Add to Team
                  </Button>
                </CardContent>
              </Card>
            </Grid>
          ))}
        </Grid>
      </Container>
    </Box>
  );
}

export default App;
EOF

# ------------------------------------------------------------
cat > .github/workflows/deploy.yml <<'EOF'
name: Deploy to GitHub Pages

on:
  push:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: pages
  cancel-in-progress: true

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm
      - run: npm ci
      - run: npm run build
      - uses: actions/upload-pages-artifact@v3
        with:
          path: dist
  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - id: deployment
        uses: actions/deploy-pages@v4
EOF

echo ">> Files created. Committing and pushing..."

git add .
git commit -m "Initial setup: Vite + React + MUI scaffold with GitHub Pages deploy workflow"
git push origin main

echo ""
echo ">> Done! Next steps:"
echo "   1. On GitHub: repo Settings -> Pages -> Source: 'GitHub Actions'"
echo "   2. Wait for the Actions run to finish, then visit:"
echo "      https://marcinsadowy.github.io/teambuilder/"
echo "   3. To work locally:  npm install && npm run dev"
