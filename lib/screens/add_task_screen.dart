import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../helpers/date_helper.dart';
import './bottom_nav_screen.dart';

class AddTaskScreen extends StatefulWidget {
  static const routeName = "/add-task";
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  String dueDate = "";
  bool _isLoading = false;
  bool isImportant = false;

  void datePicker() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    String month = DateHelper().setMonth(selectedDate!.month);
    setState(() {
      dueDate =
          "${selectedDate.toString().substring(8, 10)} $month, ${selectedDate.year}";
    });
  }

  void addtask() async {
    String tasks = dotenv.get("TASKS_COLLECTION", fallback: "");
    String myTask = dotenv.get("SUB_TASKS_COLLECTION", fallback: "");
    FocusScope.of(context).unfocus();
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Please add a task first",
            textScaler: TextScaler.noScaling,
          ),
          action: SnackBarAction(
            label: "OK",
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    User? user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;
    DateTime date = DateTime.now();
    String month = DateHelper().setMonth(date.month);
    String dateAdded =
        "${date.toString().substring(8, 10)} $month, ${date.year}";
    String time = date.toString().substring(11, 16);
    await FirebaseFirestore.instance
        .collection(tasks)
        .doc(uid)
        .collection(myTask)
        .doc(date.toString())
        .set(
      {
        "title": titleController.text,
        "description": descController.text,
        "time": time,
        "date": dateAdded,
        "dueDate": dueDate,
        "postTime": date.toString(),
        "timeStamp": date,
        "isImportant": isImportant,
        "isComplete": false,
      },
    ).then(
      (_) {
        setState(() {
          titleController.text = "";
          descController.text = "";
          isImportant = false;
          dueDate = "";
          _isLoading = false;
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => const BottomNavScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add New Task",
          textScaler: TextScaler.noScaling,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            SizedBox(
              child: TextField(
                textCapitalization: TextCapitalization.words,
                enableSuggestions: true,
                autocorrect: true,
                controller: titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(),
                  ),
                  labelText: "Task",
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              child: TextField(
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                enableSuggestions: true,
                autocorrect: true,
                textCapitalization: TextCapitalization.sentences,
                controller: descController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(),
                  ),
                  labelText: "Description",
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Add Due Date",
                        textScaler: TextScaler.noScaling,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      if (dueDate.isNotEmpty)
                        Text(
                          "Selected Due Date: $dueDate",
                          textScaler: TextScaler.noScaling,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                    ],
                  ),
                  IconButton(
                    onPressed: datePicker,
                    icon: const Icon(Icons.calendar_month),
                  ),
                ],
              ),
            ),
            CheckboxListTile(
              activeColor: Theme.of(context).colorScheme.primary,
              title: const Text(
                "Mark as Important",
                textScaler: TextScaler.noScaling,
              ),
              value: isImportant,
              onChanged: (newValue) {
                setState(() {
                  isImportant = !isImportant;
                });
              },
            ),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
            if (!_isLoading)
              ElevatedButton(
                onPressed: addtask,
                child: Text(
                  "Add Task",
                  textScaler: TextScaler.noScaling,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
