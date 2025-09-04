const request = require("supertest");
const app = require("./server");

describe("Pruebas a nivel de componete - Usuarios API", () => {
  it("Debe registrar un usuario con datos validos", async () => {
    const response = await request(app)
      .post("/api/users")
      .send({ name: "Waldir", email: "w@test.com" });

    expect(response.status).toBe(201);
    expect(response.body).toHaveProperty("id");
    expect(response.body.name).toBe("Waldir");
  });

  it("Debe rechazar registro si faltan datos", async () => {
    const response = await request(app).post("/api/users").send({ name: "" });

    expect(response.status).toBe(400);
    expect(response.body).toHaveProperty("error");
  });

  it("Debe listar usuarios registrados", async () => {
    const response = await request(app).get("/api/users");
    expect(response.status).toBe(200);
    expect(Array.isArray(response.body)).toBe(true);
  });
});
