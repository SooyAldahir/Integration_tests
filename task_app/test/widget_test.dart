import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_app/main.dart'; // Asegúrate que tu paquete sea task_app

void main() {
  testWidgets('Smoke test: monta TaskApp y muestra AppBar "Tareas"',
      (WidgetTester tester) async {
    await tester.pumpWidget(const TaskApp());

    // Debe existir un AppBar y el título "Tareas" definido en TaskListScreen
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Tareas'), findsOneWidget);
  });
}
