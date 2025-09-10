// server.js
const express = require("express");
const cors = require("cors");

const app = express();
app.use(express.json());
app.use(cors());

// --- Estado en memoria para pruebas ---
let tasks = [];
let nextId = 1;

// Healthcheck para probar desde el celular (navegador)
app.get("/health", (_req, res) => res.send("ok"));

// POST /tasks → crear tarea
// body esperado: { title: string, description?: string, done?: boolean }
app.post("/tasks", (req, res) => {
  const { title, description = "", done = false } = req.body || {};
  if (!title || typeof title !== "string" || title.trim() === "") {
    return res.status(400).json({ error: "title es requerido (string no vacío)" });
  }
  if (typeof description !== "string") {
    return res.status(400).json({ error: "description debe ser string" });
  }
  if (typeof done !== "boolean") {
    return res.status(400).json({ error: "done debe ser boolean" });
  }

  const task = { id: nextId++, title: title.trim(), description: description.trim(), done };
  tasks.push(task);
  return res.status(201).json(task);
});

// GET /tasks → listar tareas
app.get("/tasks", (_req, res) => res.status(200).json(tasks));

// PUT /tasks/:id → actualizar tarea
app.put("/tasks/:id", (req, res) => {
  const id = Number(req.params.id);
  const idx = tasks.findIndex(t => t.id === id);
  if (idx === -1) return res.status(404).json({ error: "task no encontrada" });

  const { title, description, done } = req.body || {};
  if (title !== undefined && (typeof title !== "string" || title.trim() === "")) {
    return res.status(400).json({ error: "title debe ser string no vacío si se envía" });
  }
  if (description !== undefined && typeof description !== "string") {
    return res.status(400).json({ error: "description debe ser string si se envía" });
  }
  if (done !== undefined && typeof done !== "boolean") {
    return res.status(400).json({ error: "done debe ser boolean si se envía" });
  }

  const current = tasks[idx];
  tasks[idx] = {
    ...current,
    ...(title !== undefined ? { title: title.trim() } : {}),
    ...(description !== undefined ? { description: description.trim() } : {}),
    ...(done !== undefined ? { done } : {}),
  };
  return res.status(200).json(tasks[idx]);
});

// DELETE /tasks/:id → eliminar tarea
app.delete("/tasks/:id", (req, res) => {
  const id = Number(req.params.id);
  const idx = tasks.findIndex(t => t.id === id);
  if (idx === -1) return res.status(404).json({ error: "task no encontrada" });
  const deleted = tasks.splice(idx, 1)[0];
  return res.status(200).json(deleted);
});

// Levanta el server solo si se ejecuta directamente (no en tests)
if (require.main === module) {
  const PORT = process.env.PORT || 3000;
  const HOST = "0.0.0.0"; // importante para aceptar conexiones desde el emulador/dispositivo
  app.listen(PORT, HOST, () => console.log(`API escuchando en http://${HOST}:${PORT}`));
}

// Helpers para pruebas
function _reset() { tasks = []; nextId = 1; }
module.exports = { app, _reset };
