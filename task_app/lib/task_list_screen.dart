import 'package:flutter/material.dart';
import 'task_service.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskService _service = TaskService();
  late Future<List<dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.getTasks();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _service.getTasks();
    });
  }

  Future<void> _showAddDialog() async {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final added = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Nueva tarea"),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: "Título"),
                  validator: (v) => (v == null || v.trim().isEmpty) ? "Ingresa un título" : null,
                ),
                TextFormField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: "Descripción (opcional)"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancelar")),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await _service.createTask(titleCtrl.text.trim(), description: descCtrl.text.trim());
                  if (context.mounted) Navigator.pop(ctx, true);
                }
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );

    if (added == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Tarea creada")));
      _refresh();
    }
  }

  Future<void> _deleteTask(int id) async {
    await _service.deleteTask(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Tarea eliminada")));
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tareas")),
      body: FutureBuilder<List<dynamic>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text("Error: ${snap.error}"));
          }
          final items = snap.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text("No hay tareas"));
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final t = items[i];
                return ListTile(
                  leading: const Icon(Icons.checklist),
                  title: Text(t["title"] ?? ""),
                  subtitle: (t["description"] ?? "").toString().isNotEmpty
                      ? Text(t["description"])
                      : null,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteTask(t["id"] as int),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
