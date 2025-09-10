// test/task_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:task_app/task_service.dart';

void main() {
  final service = TaskService();

  // OJO: Este test hace llamadas HTTP reales.
  // Asegúrate de tener el backend corriendo en http://172.28.80.1:3000
  // o ajusta baseUrl en TaskService.

  test('✅ Debe crear una tarea válida', () async {
    final task = await service.createTask("Estudiar pruebas", description: "Cap. integración");
    expect(task["title"], "Estudiar pruebas");
    expect(task["done"], false);
  });

  test('📋 Debe obtener la lista de tareas (array)', () async {
    final tasks = await service.getTasks();
    expect(tasks, isA<List>());
  });
}
