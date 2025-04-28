import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoModel{
  int id;
  String title;
  String desc;
  DateTime createdAt;
  bool completed;
  
  TodoModel({
    required this.id,
    required this.title,
    required this.desc,
    required this.createdAt,
    required this.completed
  });
}

class CompletedTodo with ChangeNotifier{
  List<TodoModel> completedTodo = [];

  CompletedTodo() {
    SharedPreferences.getInstance().then((prefs) {
      final List<String>? storedTodos = prefs.getStringList('completedTodo');
      print(storedTodos);
      if (storedTodos != null) {
        for (var todoStr in storedTodos) {
          final todo = Map<String, dynamic>.from(
              // ignore: unnecessary_string_escapes
              Map.fromEntries(todoStr.substring(1, todoStr.length - 1).split(', ').map((e) {
                final parts = e.split(': ');
                return MapEntry(parts[0], parts[1]);
              })));
          completedTodo.add(TodoModel(
            id: int.parse(todo['id']),
            title: todo['title'],
            desc: todo['desc'],
            createdAt: DateTime.parse(todo['createdAt']),
            completed: todo['completed'] == 'true',
          ));
        }
        notifyListeners();
      }
    });
  }
  void saveTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> todoList = completedTodo.map((todo) {
      return {
        'id': todo.id,
        'title': todo.title,
        'desc': todo.desc,
        'createdAt': todo.createdAt.toIso8601String(),
        'completed': todo.completed,
      }.toString();
    }).toList();
    prefs.setStringList('completedTodo', todoList);
  }
  
  void addTodo(TodoModel todo){
    completedTodo.add(todo);
    saveTodos();
    notifyListeners();
  }

  void removeTodoAtIndex(int index){
    completedTodo.removeAt(index);
    saveTodos();
    notifyListeners();
  }

  void removeTodoWithId(int id) {
    completedTodo.removeWhere((todo) => todo.id == id);
    saveTodos(); 
    notifyListeners();
  }

  List<TodoModel> getCompletedTodos() {
    return completedTodo;
  }
}


class PendingTodo with ChangeNotifier{
  List<TodoModel> pendingTodo = [];

  PendingTodo() {
    SharedPreferences.getInstance().then((prefs) {
      final List<String>? storedTodos = prefs.getStringList('pendingTodo');
      if (storedTodos != null) {
        for (var todoStr in storedTodos) {
          final todo = Map<String, dynamic>.from(
              // ignore: unnecessary_string_escapes
              Map.fromEntries(todoStr.substring(1, todoStr.length - 1).split(', ').map((e) {
                final parts = e.split(': ');
                return MapEntry(parts[0], parts[1]);
              })));
          pendingTodo.add(TodoModel(
            id: int.parse(todo['id']),
            title: todo['title'],
            desc: todo['desc'],
            createdAt: DateTime.parse(todo['createdAt']),
            completed: todo['completed'] == 'true',
          ));
        }
        notifyListeners();
      }
    });
  }

  void saveTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> todoList = pendingTodo.map((todo) {
      return {
        'id': todo.id,
        'title': todo.title,
        'desc': todo.desc,
        'createdAt': todo.createdAt.toIso8601String(),
        'completed': todo.completed,
      }.toString();
    }).toList();
    prefs.setStringList('pendingTodo', todoList);
  }
  
  void addTodo(TodoModel todo){
    pendingTodo.add(todo);
    saveTodos();
    notifyListeners();
  }

  void removeTodoAtIndex(int index){
    pendingTodo.removeAt(index);
    saveTodos();
    notifyListeners();
  }
  void removeTodoWithId(int id) {
    pendingTodo.removeWhere((todo) => todo.id == id);
    saveTodos(); // Added saveTodos() to persist changes
    notifyListeners();
  }

  List<TodoModel> getPendingTodos() {
    return pendingTodo;
  }

}