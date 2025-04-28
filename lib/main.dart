import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mytodo/modles/todo_model.dart';
import 'package:mytodo/pages/home.dart';
import 'package:provider/provider.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PendingTodo()),
        ChangeNotifierProvider(create: (_) => CompletedTodo()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        home: const HomePage(),
      ),
    );
  }
}
