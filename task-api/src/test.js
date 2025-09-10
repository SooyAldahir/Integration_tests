// test.js
const request = require("supertest");
const { expect } = require("chai");
const { app, _reset } = require("./server");

describe("API de Tareas - CRUD", () => {
  beforeEach(() => _reset());

  it("Crea una tarea válida", async () => {
    const res = await request(app)
      .post("/tasks")
      .send({ title: "Comprar pan", description: "Ir a las 6 pm", done: false });

    expect(res.status).to.equal(201);
    expect(res.body).to.include({ title: "Comprar pan", description: "Ir a las 6 pm", done: false });
    expect(res.body).to.have.property("id");
  });

  it("Lista un array (inicialmente con 1 tras el POST)", async () => {
    await request(app).post("/tasks").send({ title: "Tarea A" });
    const res = await request(app).get("/tasks");
    expect(res.status).to.equal(200);
    expect(res.body).to.be.an("array");
    expect(res.body.length).to.equal(1);
  });

  it("Actualiza campos parciales", async () => {
    const created = await request(app).post("/tasks").send({ title: "Barrer", done: false });
    const id = created.body.id;

    const res = await request(app)
      .put(`/tasks/${id}`)
      .send({ done: true, description: "Sala y comedor" });

    expect(res.status).to.equal(200);
    expect(res.body.done).to.equal(true);
    expect(res.body.description).to.equal("Sala y comedor");
  });

  it("Elimina la tarea", async () => {
    const created = await request(app).post("/tasks").send({ title: "Estudiar" });
    const id = created.body.id;

    const del = await request(app).delete(`/tasks/${id}`);
    expect(del.status).to.equal(200);
    expect(del.body.id).to.equal(id);

    const list = await request(app).get("/tasks");
    expect(list.body.length).to.equal(0);
  });

  it("Valida errores 400 y 404", async () => {
    const bad = await request(app).post("/tasks").send({ title: "" });
    expect(bad.status).to.equal(400);

    const nf = await request(app).put("/tasks/999").send({ title: "X" });
    expect(nf.status).to.equal(404);
  });
});
