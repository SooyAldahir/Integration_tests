import 'dart:convert';
import 'package:http/http.dart' as http;

class TaskService {
  // Ajusta según tu entorno: 172.28.80.1 es la IP que usabas
  // Alternativas:
  // - Android Emulator (host): http://10.0.2.2:3000
  // - Dispositivo físico: http://<IP_de_tu_PC>:3000
 final String baseUrl = "http://127.0.0.1:3000";

  Future<List<dynamic>> getTasks() async {
    final res = await http.get(Uri.parse("$baseUrl/tasks"));
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Error al obtener tareas");
    }
  }

  Future<Map<String, dynamic>> createTask(String title, {String description = ""}) async {
    final res = await http.post(
      Uri.parse("$baseUrl/tasks"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"title": title, "description": description, "done": false}),
    );
    if (res.statusCode == 201) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Error al crear tarea");
    }
  }

  Future<void> deleteTask(int id) async {
    final res = await http.delete(Uri.parse("$baseUrl/tasks/$id"));
    if (res.statusCode != 200) {
      throw Exception("Error al eliminar tarea");
    }
  }
}
