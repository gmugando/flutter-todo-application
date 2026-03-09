import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repositories/in_memory_todo_repository.dart';
import 'viewmodels/todo_viewmodel.dart';
import 'views/home_screen.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        // TODO: Implement platform-specific ObjectBox initialization
        // Currently using in-memory repository for all platforms as a workaround
        // to avoid conditional import compilation errors.
        // 
        // For native platforms (Android, iOS, macOS, Linux, Windows):
        // - Initialize ObjectBox store in main()
        // - Use TodoRepository with ObjectBox for persistent storage
        // 
        // For web platform:
        // - Continue using InMemoryTodoRepository (ObjectBox requires dart:ffi)
        //
        // See: data/repositories/todo_repository.dart (already implemented)
        // See: GitHub issue #3 for tracking
        return TodoViewmodel(InMemoryTodoRepository());
      },
      child: MaterialApp(
        title: 'Todo Manager',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFC7DA75)),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF4F4F4),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF4F4F4),
            foregroundColor: Color(0xFF1B1C1F),
            elevation: 0,
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}