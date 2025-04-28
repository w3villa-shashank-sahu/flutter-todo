import 'package:flutter/material.dart';
import 'package:mytodo/modles/todo_model.dart';
import 'package:provider/provider.dart';

class TodoCard extends StatefulWidget {
  final TodoModel todo;

  const TodoCard({super.key, required this.todo});

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  late bool iscompleted;

  @override
  void initState() {
    super.initState();
    iscompleted = widget.todo.completed;
  }

  void showDetail() {
    final titleController = TextEditingController(text: widget.todo.title);
    final descController = TextEditingController(text: widget.todo.desc);
    bool tempCompleted = iscompleted;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.deepPurple.shade100,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
              20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Todo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Status: '),
                  StatefulBuilder(
                    builder: (context, setState) => Switch(
                      value: tempCompleted,
                      onChanged: (value) {
                        setState(() => tempCompleted = value);
                      },
                    ),
                  ),
                  Text(tempCompleted ? 'Completed' : 'Pending'),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Update the todo item in state management
                      if(tempCompleted){
                        Provider.of<PendingTodo>(context, listen: false)
                            .removeTodoWithId(widget.todo.id);
                        Provider.of<CompletedTodo>(context, listen: false)
                            .addTodo(TodoModel(
                          id: widget.todo.id,
                          title: titleController.text,
                          desc: descController.text,
                          createdAt: widget.todo.createdAt,
                          completed: tempCompleted,
                        ));
                      }else{
                        Provider.of<CompletedTodo>(context, listen: false)
                            .removeTodoWithId(widget.todo.id);
                        Provider.of<PendingTodo>(context, listen: false)
                            .addTodo(TodoModel(
                          id: widget.todo.id,
                          title: titleController.text,
                          desc: descController.text,
                          createdAt: widget.todo.createdAt,
                          completed: tempCompleted,
                        ));
                      }
                      Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String date =
        "${widget.todo.createdAt.day}/${widget.todo.createdAt.month}/${widget.todo.createdAt.year}";
    return InkWell(
      onTap: showDetail,
      onLongPress: (){
        showDialog(context: context, builder: (context) => AlertDialog(

          title: const Text('Delete Todo'),
          content: const Text('Are you sure you want to delete this todo?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<PendingTodo>(context, listen: false)
                    .removeTodoWithId(widget.todo.id);
                Provider.of<CompletedTodo>(context, listen: false)
                    .removeTodoWithId(widget.todo.id);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        ),);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
            color: Colors.deepPurple.shade400,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: widget.todo.completed,
                  onChanged: (value) {
                    iscompleted = value!;
                    if (iscompleted) {
                      Provider.of<PendingTodo>(context, listen: false)
                          .removeTodoWithId(widget.todo.id);
                      Provider.of<CompletedTodo>(context, listen: false)
                          .addTodo(
                        TodoModel(
                          id: widget.todo.id,
                          title: widget.todo.title,
                          desc: widget.todo.desc,
                          createdAt: widget.todo.createdAt,
                          completed: iscompleted,
                        ),
                      );
                    } else {
                      Provider.of<CompletedTodo>(context, listen: false)
                          .removeTodoWithId(widget.todo.id);
                      Provider.of<PendingTodo>(context, listen: false)
                          .addTodo(
                        TodoModel(
                          id: widget.todo.id,
                          title: widget.todo.title,
                          desc: widget.todo.desc,
                          createdAt: widget.todo.createdAt,
                          completed: iscompleted,
                        ),
                      );
                    }
                  },
                  fillColor: const WidgetStatePropertyAll(Colors.white),
                  checkColor: Colors.deepPurple.shade400,
                ),
                Text(widget.todo.title,
                    maxLines: 2,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.todo.desc,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                    )),
                Text(date, style: TextStyle(color: Colors.grey.shade200)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
