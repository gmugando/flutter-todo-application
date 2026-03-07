// Basic smoke test for the todo app

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_todo_application/main.dart';

void main() {
  testWidgets('launches and shows Tasks label', (WidgetTester tester) async {
    await tester.pumpWidget(const TodoApp());
    expect(find.text('Tasks'), findsOneWidget);
  });
}
