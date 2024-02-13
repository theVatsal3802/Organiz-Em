import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../screens/description_screen.dart';
import './completeion_helper.dart';
import './importance_helper.dart';

class CustomListView extends StatefulWidget {
  final List<dynamic> docs;
  final User user;
  const CustomListView({required this.docs, required this.user, Key? key})
      : super(key: key);

  @override
  State<CustomListView> createState() => _CustomListViewState();
}

class _CustomListViewState extends State<CustomListView> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    String tasks = dotenv.get("TASKS_COLLECTION", fallback: "");
    String myTask = dotenv.get("SUB_TASKS_COLLECTION", fallback: "");
    return ListView.builder(
      itemBuilder: (context, index) {
        final task = widget.docs[index]["postTime"];
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
                  .doc(widget.user.uid)
                  .collection(myTask)
                  .doc(
                    widget.docs[index]["postTime"],
                  )
                  .delete();
              setState(() {});
            }
          },
          child: Container(
            height: height * 0.11,
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
                    "postTime": widget.docs[index]["postTime"],
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
                          .toggleMarkComplete(widget.docs[index], widget.user);
                    },
                    icon: Icon(
                      widget.docs[index]["isComplete"] == true
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.docs[index]["title"],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textScaler: TextScaler.noScaling,
                          style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .fontSize,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          widget.docs[index]["description"].isEmpty
                              ? ""
                              : widget.docs[index]["description"],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textScaler: TextScaler.noScaling,
                        ),
                        if (!widget.docs[index]["dueDate"].isEmpty)
                          Row(
                            children: [
                              const Icon(
                                Icons.notifications,
                                color: Colors.red,
                              ),
                              Text(
                                widget.docs[index]["dueDate"],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                textScaler: TextScaler.noScaling,
                                style: const TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const VerticalDivider(),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.calendar_month),
                        Text(
                          widget.docs[index]["date"],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textScaler: TextScaler.noScaling,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    color: Colors.blue,
                    onPressed: () {
                      ImportanceHelper()
                          .toggleMarkImportant(widget.docs[index], widget.user);
                    },
                    icon: Icon(
                      widget.docs[index]["isImportant"] == true
                          ? Icons.star
                          : Icons.star_border,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      itemCount: widget.docs.length,
    );
  }
}
