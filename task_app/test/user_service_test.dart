import 'package:task_app/user_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final userService = UserService();

  test('✅ Test correcto: Debe crear un usuario con datos válidos', () async {
    final user = await userService.createUser("Aldahir", "alda@ulv.edu.mx");
    expect(user["name"], "Aldahir");
    expect(user["email"], "alda@ulv.edu.mx");

    // Mensaje adicional
    print("👉 Usuario creado: $user");
  });

  test('📋 Test correcto: Debe obtener la lista de usuarios', () async {
    final users = await userService.getUsers();
    expect(users, isA<List>());

    // Mostrar lista de usuarios
    print("👥 Lista actual de usuarios: $users");
  });
}
