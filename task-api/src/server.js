const express = require("express");
const app = express();

app.use(express.json());

//componente: Modulo de Usuarios
let users = [];

//End point para crear usuario
app.post("/api/users", (req, res) => {
  const { name, email } = req.body;
  if (!name || !email) {
    return res.status(400).json({
      error: "Datos incompletos",
    });
  }
  const user = { id: users.length + 1, name, email };
  users.push(user);
  res.status(201).json(user);
});

app.get("/api/users", (req, res) => {
  res.json(users);
});

app.listen(3000, () => console.log("Servidor corriendo en el puerto 3000"));

module.exports = app;
