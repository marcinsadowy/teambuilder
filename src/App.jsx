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
