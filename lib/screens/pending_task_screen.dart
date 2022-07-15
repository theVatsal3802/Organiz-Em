import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import './description_screen.dart';
import '../helpers/completeion_helper.dart';
import '../helpers/importance_helper.dart';

class PendingTaskScreen extends StatefulWidget {
  const PendingTaskScreen({Key? key}) : super(key: key);

  @override
  State<PendingTaskScreen> createState() => _PendingTaskScreenState();
}

class _PendingTaskScreenState extends State<PendingTaskScreen> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    String tasks = dotenv.get("TASKS_COLLECTION", fallback: "");
    String myTask = dotenv.get("SUB_TASKS_COLLECTION", fallback: "");
    return Container(
      padding: const EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(tasks)
            .doc(user!.uid)
            .collection(myTask)
            .where("isComplete", isNotEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final docs = snapshot.data != null ? snapshot.data!.docs : [];
          return docs.isEmpty
              ? Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 70,
                      ),
                      Image.asset(
                        "assets/images/todo.png",
                        height: 200,
                        width: 200,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Text(
                        "Hurray!! No Pending Tasks!",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    final task = docs[index]["postTime"];
                    return Dismissible(
                      key: Key(task),
                      direction: DismissDirection.endToStart,
                      background: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ],
                      ),
                      onDismissed: (direction) async {
                        if (direction == DismissDirection.endToStart) {
                          await FirebaseFirestore.instance
                              .collection(tasks)
                              .doc(user!.uid)
                              .collection(myTask)
                              .doc(
                                docs[index]["postTime"],
                              )
                              .delete();
                          setState(() {});
                        }
                      },
                      child: Container(
                        height: 80,
                        width: double.infinity,
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(width: 1, color: Colors.white),
                          color: Theme.of(context).colorScheme.background,
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              DescriptionScreen.routeName,
                              arguments: {
                                "index": index,
                                "postTime": docs[index]["postTime"],
                              },
                            );
                          },
                          splashColor: Theme.of(context).colorScheme.primary,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                color: Theme.of(context).colorScheme.secondary,
                                onPressed: () {
                                  CompletionHelper()
                                      .toggleMarkComplete(docs[index], user);
                                },
                                icon: Icon(
                                  docs[index]["isComplete"] == true
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      docs[index]["title"],
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .fontSize,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Text(
                                      docs[index]["description"].isEmpty
                                          ? ""
                                          : docs[index]["description"],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    Text(
                                      docs[index]["dueDate"].isEmpty
                                          ? ""
                                          : "Due Date: ${docs[index]["dueDate"]}",
                                      overflow: TextOverflow.fade,
                                      style: const TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Added at: ${docs[index]["time"]}",
                                      overflow: TextOverflow.fade,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      "Added on: ${docs[index]["date"]}",
                                      overflow: TextOverflow.fade,
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                color: Theme.of(context).colorScheme.surface,
                                onPressed: () {
                                  ImportanceHelper()
                                      .toggleMarkImportant(docs[index], user);
                                },
                                icon: Icon(
                                  docs[index]["isImportant"] == true
                                      ? Icons.check_box
                                      : Icons.square_outlined,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: docs.length,
                );
        },
      ),
    );
  }
}
