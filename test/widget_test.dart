// Basic smoke test for the todo app

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_todo_application/main.dart';

void main() {
  testWidgets('launches and renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const TodoApp());
    // Verify the app renders without errors and finds navigation icons
    expect(find.byIcon(Icons.home_outlined), findsWidgets);
    expect(find.byIcon(Icons.calendar_month_outlined), findsWidgets);
  });
}
