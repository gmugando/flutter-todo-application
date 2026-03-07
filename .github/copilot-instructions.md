# Copilot Instructions for Flutter Todo Application

This guide helps Copilot sessions work effectively in the flutter_todo_application repository.

## Project Overview

This is a Flutter-based todo/task management application following the **MVVM (Model-View-ViewModel)** architectural pattern. The app supports multiple platforms (Android, iOS, Web, Linux, macOS, Windows) with features like task creation, calendar views, and status tracking.

## Build, Test, and Lint Commands

### Getting Started
```bash
flutter pub get
```

### Running the Application
```bash
# Run on connected device/emulator
flutter run

# Run on specific platform (web)
flutter run -d chrome

# Run with verbose output for debugging
flutter run -v
```

### Testing
```bash
# Run all tests
flutter test

# Run a specific test file
flutter test test/widget_test.dart

# Run tests with verbose output
flutter test -v

# Run tests with coverage
flutter test --coverage
```

### Code Analysis & Linting
```bash
# Static analysis
flutter analyze

# Format code according to Dart style guide
dart format lib/ test/

# Check code format without applying changes
dart format --output=none --set-exit-if-changed lib/ test/
```

### Building for Production
```bash
# Android APK
flutter build apk

# iOS
flutter build ios

# Web
flutter build web

# macOS
flutter build macos

# Windows
flutter build windows

# Linux
flutter build linux
```

### Code Generation
```bash
# Generate ObjectBox database code (required after modifying models)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for continuous generation during development
flutter pub run build_runner watch
```

## Architecture Overview

### Directory Structure

```
lib/
├── main.dart                    # App entry point, Provider setup
├── models/
│   └── todo_item.dart          # Data model with ObjectBox annotations
├── viewmodels/
│   └── todo_viewmodel.dart     # Business logic, state management (ChangeNotifier)
├── views/
│   ├── home_screen.dart        # Navigation hub (list/calendar views)
│   ├── task_list_screen.dart   # Todo list display and editing
│   ├── add_edit_task_screen.dart # Form for creating/editing todos
│   └── calendar_screen.dart    # Calendar view of tasks
└── data/
    ├── objectbox.dart          # ObjectBox database setup
    └── repositories/
        ├── base_repository.dart            # Abstract base class
        ├── todo_repository.dart            # ObjectBox implementation
        └── in_memory_todo_repository.dart  # In-memory implementation (web-compatible)
```

### Key Architectural Patterns

**MVVM Pattern:**
- **Model** (`models/`) - Data structures with ObjectBox ORM annotations
- **ViewModel** (`viewmodels/`) - Business logic using `ChangeNotifier` for reactive updates
- **View** (`views/`) - Flutter widgets that consume ViewModel via Provider

**State Management:**
- Uses **Provider** package (v6.1.5+)
- `TodoViewmodel` extends `ChangeNotifier` for observable state
- Views subscribe to viewmodel changes via `Provider.of<TodoViewmodel>()` or `context.watch<TodoViewmodel>()`
- Call `notifyListeners()` when state changes to trigger UI rebuilds

**Data Persistence:**
- **ObjectBox** for native platforms (Android, iOS, macOS, Linux, Windows)
- **In-memory repository** for Web (platform-compatible alternative)
- Repository abstraction allows swapping implementations without touching ViewModels

**Repository Pattern:**
- All data access goes through repository classes (not ViewModels directly)
- `TodoRepository` queries ObjectBox database using typed queries
- `InMemoryTodoRepository` stores tasks in a `Map<String, TodoItem>`
- Both implement the same interface for interchangeable use

## Key Conventions

### Model Conventions
- Use ObjectBox annotations (`@Entity()`, `@Id()`, `@Unique()`, `@Property()`) for persistence
- Store enums as int values (`priorityValue`, `statusValue`) with getters/setters for enum access
- Example:
  ```dart
  @Entity()
  class TodoItem {
    @Unique()
    final String id;  // Business ID
    @Id()
    int? dbId;        // Database ID
    int priorityValue; // Stored as int
    
    Priority get priority => Priority.values[priorityValue];
    set priority(Priority value) => priorityValue = value.index;
  }
  ```

### ViewModel Conventions
- All public methods that modify state call `notifyListeners()` at the end
- Repository is injected via constructor (enables testing with mock repositories)
- Keep business logic in ViewModel, UI logic in Views
- Example:
  ```dart
  class TodoViewmodel extends ChangeNotifier {
    void updateTask(TodoItem updated) {
      _repository.updateTodo(updated);
      notifyListeners(); // Always notify after changes
    }
  }
  ```

### View Conventions
- Use `context.watch<TodoViewmodel>()` for reactive updates (rebuilds when watched properties change)
- Use `context.read<TodoViewmodel>()` for non-reactive access (method calls)
- Material Design 3 (`useMaterial3: true`, `ColorScheme.fromSeed()`)
- Custom theme colors defined in `main.dart` (seedColor: `0xFFC7DA75`, background: `0xFFF4F4F4`)
- Use `const` constructors wherever possible for performance

### Naming Conventions
- Classes: PascalCase (`TodoItem`, `TodoViewmodel`, `TaskListScreen`)
- Fields/variables: camelCase (`todoItem`, `isCompleted`, `dueDate`)
- Files: snake_case (`todo_item.dart`, `todo_viewmodel.dart`, `home_screen.dart`)
- Enum values: lowercase (`Priority.low`, `TodoStatus.pending`)
- Repository methods: descriptive verb names (`getAllTodos()`, `getTodosForDate()`, `countByStatus()`)

### Status and Priority Enums
The app defines two key enums:
```dart
enum Priority { low, medium, high }
enum TodoStatus { pending, inProgress, review, completed }
```
These are stored as int values in ObjectBox but accessed via getters/setters.

## Important Implementation Notes

### Platform-Specific Data Persistence
- Currently uses `InMemoryTodoRepository` by default (web-compatible)
- `TodoRepository` with ObjectBox is available for native platforms but commented out in `main.dart`
- To enable ObjectBox: Modify `main.dart` to instantiate `TodoRepository` instead and handle initialization
- **Code Generation Dependency**: Modifying `TodoItem` requires running `flutter pub run build_runner build`

### Common Tasks

**Adding a New Todo Field:**
1. Add property to `TodoItem` model with ObjectBox annotations
2. Run `flutter pub run build_runner build --delete-conflicting-outputs`
3. Update repository methods if needed for filtering/querying
4. Update UI forms in `add_edit_task_screen.dart`

**Creating a New View:**
1. Create file in `views/` following naming convention
2. Use `Provider.of<TodoViewmodel>()` or `context.watch()` for state access
3. Follow Material Design 3 with theme colors from `main.dart`
4. Navigate using Flutter's `Navigator.push()` or define routes in app

**Adding Repository Method:**
1. Define in base interface (if creating new abstraction)
2. Implement in both `TodoRepository` and `InMemoryTodoRepository`
3. Expose via ViewModel if it's business logic
4. Update ViewModel to call `notifyListeners()`

## Code Style

- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `dart format lib/ test/` to auto-format code
- Enable all lint rules from `flutter_lints` (see `analysis_options.yaml`)
- Suppress lint rules only when absolutely necessary with `// ignore: rule_name`
- Keep methods focused and small; extract complex logic to separate methods/widgets
- Add comments only for non-obvious logic; code should be self-documenting

## Testing

- Currently minimal test coverage (see `test/widget_test.dart`)
- Write widget tests for new screens/features
- Write unit tests for ViewModel business logic
- Use `testWidgets()` for widget tests, `test()` for unit tests
- Mock repositories in ViewModel tests to isolate business logic

## Debugging

- Use `flutter run -v` for verbose output
- Use `debugPrint()` for debug logging (won't spam in production)
- DevTools: Run `flutter pub global run devtools` then `flutter run` with DevTools enabled
- Check `flutter_01.log` for error details (checked into repo for reference)
- ObjectBox browser available when using `TodoRepository` for database inspection

## Custom Agents

This repository includes a custom agent:
- **flutter-design-reviewer**: Reviews Flutter code for design patterns, architecture, and best practices. Use when you need architectural review of Flutter widgets or app structure.

## Performance Considerations

- Use `const` constructors to reduce widget rebuilds
- Avoid rebuilding entire widget trees when only parts need updates
- ListView/GridView should use builder constructors for large lists
- ObjectBox queries are efficient; use specific queries rather than filtering in memory
- Dispose controllers and listeners in State widgets to prevent memory leaks
