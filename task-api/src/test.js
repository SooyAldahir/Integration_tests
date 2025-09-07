const request = require("supertest");
const { expect } = require("chai");
const { app, _reset } = require("./server");

describe("Pruebas a nivel de componente - Usuarios API", () => {
  // Limpia el arreglo antes de cada prueba
  beforeEach(() => _reset());

  it("Debe registrar un usuario con datos válidos", async () => {
    const res = await request(app)
      .post("/api/users")
      .send({ name: "Waldir", email: "w@test.com" });

    expect(res.status).to.equal(201);
    expect(res.body).to.have.property("id");
    expect(res.body.name).to.equal("Waldir");
  });

  it("Debe rechazar registro si faltan datos", async () => {
    const res = await request(app).post("/api/users").send({ name: "" });

    expect(res.status).to.equal(400);
    expect(res.body).to.have.property("error");
  });

  it("Debe listar usuarios registrados", async () => {
    // agrega un usuario primero
    await request(app)
      .post("/api/users")
      .send({ name: "Ana", email: "ana@test.com" });

    const res = await request(app).get("/api/users");
    expect(res.status).to.equal(200);
    expect(res.body).to.be.an("array");
    expect(res.body.length).to.equal(1);
  });
});
