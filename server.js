const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const app = express();
app.use(cors());
app.use(bodyParser.json());

// In-memory store
const users = [{ username: 'testuser', password: 'secret123', token: 'demo-token-123' }];
let players = [
  { name: 'Alice', score: 980 },
  { name: 'Bob', score: 930 },
  { name: 'Carol', score: 900 },
  { name: 'Dave', score: 880 },
  { name: 'Eve', score: 860 },
  { name: 'Frank', score: 850 },
  { name: 'Grace', score: 830 },
  { name: 'Heidi', score: 820 },
  { name: 'Ivan', score: 810 },
  { name: 'Judy', score: 800 },
  { name: 'Mallory', score: 790 }
];

app.post('/login', (req, res) => {
  const { username, password } = req.body;
  const found = users.find(u => u.username === username && u.password === password);
  if (!found) return res.status(401).json({ error: 'Invalid credentials' });
  return res.json({ token: found.token });
});

app.get('/ranking', (req, res) => {
  const auth = req.header('Authorization') || '';
  if (!auth.startsWith('Bearer ')) return res.status(401).json({ error: 'Unauthorized' });
  const token = auth.replace('Bearer ', '');
  if (token !== users[0].token) return res.status(403).json({ error: 'Forbidden' });

  const limit = Number(req.query.limit || 10);
  const sorted = players.sort((a,b)=>b.score - a.score).slice(0, limit);
  res.json({ players: sorted });
});

app.post('/item/grant', (req, res) => {
  const auth = req.header('Authorization') || '';
  if (!auth.startsWith('Bearer ')) return res.status(401).json({ error: 'Unauthorized' });
  const token = auth.replace('Bearer ', '');
  if (token !== users[0].token) return res.status(403).json({ error: 'Forbidden' });

  const { playerId, itemId, amount } = req.body || {};
  if (!playerId || !itemId || typeof amount !== 'number') {
    return res.status(400).json({ success: false, error: 'Bad request' });
  }
  return res.json({ success: true, granted: { playerId, itemId, amount } });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log('Mock Game API running on port ' + PORT));