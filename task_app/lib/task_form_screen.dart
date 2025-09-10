// lib/user_form_screen.dart  (ahora realmente es un formulario de TAREAS)
import 'package:flutter/material.dart';
import 'task_service.dart';

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  final TaskService _taskService = TaskService();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final task = await _taskService.createTask(
          _titleController.text.trim(),
          description: _descController.text.trim(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Tarea creada: ${task['title']}")),
        );

        _titleController.clear();
        _descController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al registrar la tarea")),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrar Tarea")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Título"),
                validator: (value) =>
                    (value == null || value.trim().isEmpty) ? "Ingrese un título" : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: "Descripción (opcional)"),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: const Text("Guardar"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
