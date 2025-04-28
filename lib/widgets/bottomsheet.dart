import 'package:flutter/material.dart';
import 'package:mytodo/modles/todo_model.dart';
import 'package:mytodo/widgets/card.dart';
import 'package:provider/provider.dart';

Widget showCompleteTodo() {
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        
        return Consumer<CompletedTodo>(
          builder: (context, completedTodo, child) => Container(
            decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
                child: SingleChildScrollView(
                controller: scrollController,
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    const SizedBox(height: 10),
                    Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                      color: Colors.deepPurple.shade900,
                      borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                      'Completed Todos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                    ),
                    if (completedTodo.getCompletedTodos().isEmpty)
                        Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.playlist_remove_rounded,
                          size: 100,
                          color: Colors.deepPurple.shade300,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                          'No Completed Todos',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                        ],
                        )
                    else

                    for (var todo in completedTodo.getCompletedTodos())
                        TodoCard(
                        todo: todo,
                        ),
                    ],
                  ),
                ),
                )
          ),
        );
      },
    );
  }