import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class TodoDialog extends StatefulWidget{
  final FirestoreService firestoreService;
  const TodoDialog({
    super.key,
    required this.firestoreService
  });

  @override
  State<TodoDialog> createState() => _TodoDialogState();
}

class _TodoDialogState extends State<TodoDialog>{
  final TextEditingController _taskController = TextEditingController();

  @override
  void dispose(){
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return AlertDialog(
      title: const Text('Add Todo'),
      content: TextField(
        controller: _taskController,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Add new task..'),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            final taskText = _taskController.text.trim();
            if (taskText.isNotEmpty) {
              try {
                await widget.firestoreService.addTodo(taskText);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menambah tugas: $e')),
                  );
                }
              }
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}