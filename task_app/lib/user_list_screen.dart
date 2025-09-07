import 'package:flutter/material.dart';
import 'user_service.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final UserService _userService = UserService();
  late Future<List<dynamic>> _users;

  @override
  void initState() {
    super.initState();
    _users = _userService.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lista de Usuarios")),
      body: FutureBuilder<List<dynamic>>(
        future: _users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error al cargar usuarios"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay usuarios registrados"));
          }

          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(user["name"]),
                subtitle: Text(user["email"]),
              );
            },
          );
        },
      ),
    );
  }
}
