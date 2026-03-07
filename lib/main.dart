import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repositories/in_memory_todo_repository.dart';
import 'data/repositories/todo_repository.dart';
import 'models/todo_item.dart';
import 'objectbox.g.dart';
import 'viewmodels/todo_viewmodel.dart';
import 'views/home_screen.dart';

late Store _store;
bool _objectBoxInitialized = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize ObjectBox on native platforms (not web, not test)
  if (!kIsWeb && !kDebugMode) {
    try {
      _store = openStore();
      _objectBoxInitialized = true;
    } catch (e) {
      debugPrint('Error initializing ObjectBox: $e');
      _objectBoxInitialized = false;
    }
  }

  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        // Use platform-specific repository
        dynamic repository;
        if (kIsWeb || !_objectBoxInitialized) {
          // Web platform or test environment uses in-memory storage
          repository = InMemoryTodoRepository();
        } else {
          // Native platforms use ObjectBox for persistent storage
          final todoBox = _store.box<TodoItem>();
          repository = TodoRepository(todoBox);
        }
        return TodoViewmodel(repository);
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