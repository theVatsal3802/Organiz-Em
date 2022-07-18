import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../helpers/heading_text.dart';
import '../helpers/content_text.dart';
import '../helpers/completeion_helper.dart';
import '../helpers/importance_helper.dart';

class DescriptionScreen extends StatefulWidget {
  static const routeName = "/description";
  const DescriptionScreen({Key? key}) : super(key: key);

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    String tasks = dotenv.get("TASKS_COLLECTION", fallback: "");
    String myTask = dotenv.get("SUB_TASKS_COLLECTION", fallback: "");
    final data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(tasks)
          .doc(user!.uid)
          .collection(myTask)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          final docs = snapshot.data!.docs;
          final dynamic task = docs.isEmpty ? [] : docs[data["index"]];
          return Scaffold(
            appBar: AppBar(
              title: Text(
                task["title"],
                textScaleFactor: 1,
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeadingText("Description"),
                ContentText(task["description"]),
                const SizedBox(
                  height: 10,
                ),
                const HeadingText("Due Date"),
                ContentText(task["dueDate"]),
                const SizedBox(
                  height: 10,
                ),
                const HeadingText("Added on"),
                ContentText("${task["time"]} on ${task["date"]}"),
                CheckboxListTile(
                  title: const HeadingText("Important"),
                  value: task["isImportant"],
                  activeColor: Theme.of(context).colorScheme.primary,
                  onChanged: (newValue) {
                    ImportanceHelper().toggleMarkImportant(task, user);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const HeadingText("Status"),
                    ContentText(task["isComplete"] == true
                        ? "Completed"
                        : "Not Yet Complete"),
                  ],
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      CompletionHelper().toggleMarkComplete(task, user);
                    },
                    icon: const Icon(Icons.check_circle),
                    label: Text(
                      task["isComplete"]
                          ? "Mark Not Complete"
                          : "Mark Complete",
                      textScaleFactor: 1,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
