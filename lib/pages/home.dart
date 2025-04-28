import 'package:flutter/material.dart';
import 'package:mytodo/modles/todo_model.dart';
import 'package:mytodo/widgets/appbar.dart';
import 'package:mytodo/widgets/bottomsheet.dart';
import 'package:mytodo/widgets/card.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(onCreateTodoPressed: createTodo),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.deepPurple, Colors.deepPurple.shade800])),
        child: Stack(
          children: [
            Consumer<PendingTodo>(
              builder: (context, pendingProvider, child) {
                final pendingTodos = pendingProvider.getPendingTodos();
                return pendingTodos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.create,
                                size: 150, color: Colors.deepPurple.shade700),
                            const SizedBox(height: 30),
                            Text('Create your First Todo!',
                                style: TextStyle(
                                    color: Colors.deepPurple.shade300,
                                    fontSize: 20))
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ReorderableListView.builder(
                          buildDefaultDragHandles: false,
                          proxyDecorator: (child, index, animation) {
                            return Material(
                              color: Colors.transparent,
                              child: child,
                            );
                          },
                          itemBuilder: (context, index) => ReorderableDragStartListener(
                            index: index,
                            key: ValueKey(index),
                            child: TodoCard(
                                // key: ValueKey(index),
                                todo: pendingTodos[index],),
                          ),
                          itemCount: pendingTodos.length,
                          onReorder: (oldIndex, newIndex) {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            final item = pendingTodos.removeAt(oldIndex);
                            pendingTodos.insert(newIndex, item);
                          },
                        ),
                      );
              },
            ),
            showCompleteTodo(),
          ],
        ),
      ),
    );
  }

  void createTodo() {
    TextEditingController titleController = TextEditingController();
    TextEditingController descController = TextEditingController();
    FocusNode titleFocusNode = FocusNode();
    inputDecor(String label) => InputDecoration(
        label: Text(label),
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))));
    titleFocusNode.requestFocus();
    void onSavePressed() {
      if (titleController.text.isNotEmpty) {
        final todo = TodoModel(
          id: DateTime.now().millisecondsSinceEpoch,
          title: titleController.text,
          desc: descController.text,
          createdAt: DateTime.now(),
          completed: false,
        );
        Provider.of<PendingTodo>(context, listen: false).addTodo(todo);
        Navigator.of(context).pop();
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: const Text('Please enter a title', style: TextStyle(color: Colors.red, fontSize: 16),),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
    showDialog(context: context, builder:(context) => AlertDialog(

      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create Todo',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: titleController,
            decoration: inputDecor('Title'),
            focusNode: titleFocusNode,            
          ),
          const SizedBox(height: 12),
          TextField(
            controller: descController,
            maxLines: 3,
            decoration: inputDecor('Description'),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: onSavePressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade500,
                  minimumSize: const Size(100, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Create',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
