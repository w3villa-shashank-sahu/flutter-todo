import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onCreateTodoPressed;
  const MyAppBar({super.key, required this.onCreateTodoPressed});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 60,
      backgroundColor: Colors.deepPurple.shade900,
      centerTitle: true,
      title: const Text('Track It',
          style: TextStyle(
              fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold)),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: SizedBox(
              width: 35,
              height: 35,
              child: ElevatedButton(
                  onPressed: onCreateTodoPressed,
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // reduced radius
                      ),
                      padding: const EdgeInsets.all(0)),
                  child: const Center(child: Icon(Icons.add)))),
        )
      ],
    );
  }
}
