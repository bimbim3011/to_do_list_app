import 'package:flutter/material.dart';
import 'package:to_do_list_app/models/todo.dart';
import 'package:to_do_list_app/services/todo_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TodoService _todoService = TodoService();
  late Future<List<Todo>> _todoList;

  @override
  void initState() {
    super.initState();
    _todoList = _todoService.fetchTodos();
  }

  void _addTodo() async {
    Todo newTodo = Todo(
      title: 'New Task',
      completed: false,
    );
    await _todoService.createTodo(newTodo);
    setState(() {
      _todoList = _todoService.fetchTodos();
    });
  }

  void _updateTodo(Todo todo) async {
    Todo updatedTodo = Todo(
      id: todo.id,
      userId: todo.userId,
      title: todo.title + ' (Updated)',
      completed: !todo.completed,
    );
    await _todoService.updateTodo(updatedTodo);
    setState(() {
      _todoList = _todoService.fetchTodos();
    });
  }

  void _deleteTodo(int id) async {
    await _todoService.deleteTodo(id);
    setState(() {
      _todoList = _todoService.fetchTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: FutureBuilder<List<Todo>>(
        future: _todoList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tasks found'));
          } else {
            List<Todo> todos = snapshot.data!;
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                Todo todo = todos[index];
                return ListTile(
                  title: Text(todo.title),
                  subtitle: Text('Completed: ${todo.completed}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _updateTodo(todo),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteTodo(todo.id!),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        child: Icon(Icons.add),
      ),
    
    );
  }
}
