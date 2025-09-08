// server.js
const express = require("express");
const app = express();

app.use(express.json());

// --- Estado en memoria para pruebas ---
let users = [];
let nextId = 1;

// POST /api/users → crear usuario
app.post("/api/users", (req, res) => {
  const { name, email } = req.body || {};
  if (
    !name || !email ||
    typeof name !== "string" || typeof email !== "string" ||
    name.trim() === "" || email.trim() === ""
  ) {
    return res.status(400).json({ error: "name y email son requeridos (string)" });
  }

  const user = { id: nextId++, name: name.trim(), email: email.trim() };
  users.push(user);
  return res.status(201).json(user);
});

// GET /api/users → listar usuarios
app.get("/api/users", (_req, res) => {
  return res.status(200).json(users);
});

// (Opcional) PUT/DELETE si lo necesitas más adelante
// app.put("/api/users/:id", ...)
// app.delete("/api/users/:id", ...)

// Levanta el server solo si se ejecuta directamente (no en tests)
if (require.main === module) {
  const PORT = process.env.PORT || 3000;
  app.listen(PORT, () => console.log(`API escuchando en puerto ${PORT}`));
}

// Helpers para pruebas
function _reset() {
  users = [];
  nextId = 1;
}

module.exports = { app, _reset };
