import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => const MaterialApp(
        title: 'Todo App',
        home: Home(),
      );
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<Todo?>? todo;

  void getTodos() => fetchTodo();

  void createTodo() => addTodo(Todo(
      id: '1', title: 'The new todo added'));

  void modifyTodo() => updateTodo(Todo(
      id: '1', title: 'The todo updated'));

  void destroyTodo() => deleteTodo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo API App'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () => getTodos(), child: Text('Fetch todo')),
              const SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () => createTodo(), child: Text('Create todo')),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () => modifyTodo(), child: Text('Update todo')),
              const SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () => destroyTodo(), child: Text('Delete todo')),
            ],
          )
        ],
      ),
    );
  }
}

Future fetchTodo() async {
  const url = 'https://jsonplaceholder.typicode.com/todos/';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(response.body);
    print('All todos fetched!');
    print(jsonList);
  } else {
    throw Exception('Failed to load todo');
  }
}

Future addTodo(Todo todo) async {
  const url = 'https://jsonplaceholder.typicode.com/todos';
  final response = await http.post(Uri.parse(url), body: todo.toJson());

  if (response.statusCode == 201) {
    print('Todo added successfully');
    print(Todo.fromJson(json.decode(response.body)));
  } else {
    throw Exception('Failed to add todo');
  }
}

Future updateTodo(Todo todo) async {
  const url = 'https://jsonplaceholder.typicode.com/todos/1';
  final response = await http.put(Uri.parse(url), body: todo.toJson());

  if (response.statusCode == 200) {
    print('Todo updated successfully');
    print(Todo.fromJson(json.decode(response.body)));
  } else {
    throw Exception('Failed to update todo');
  }
}

Future deleteTodo() async {
  const url = 'https://jsonplaceholder.typicode.com/todos/1';
  final response = await http.delete(Uri.parse(url));

  if (response.statusCode == 200) {
    print('Deleted successfully') ;
  } else {
    throw Exception('Failed to delete todo');
  }
}

class Todo {
  final String id;
  final String title;

  Todo({
    required this.id,
    required this.title,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
      id: json['id'].toString(),
      title: json['title']);

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
  };
}
