import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import './add_task_screen.dart';
import '../helpers/custom_list_view.dart';
import '../helpers/empty_list_indicator.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            .orderBy("timeStamp")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final docs = snapshot.data != null ? snapshot.data!.docs : [];
          return docs.isEmpty
              ? const EmptyListIndicator(
                  asset: "assets/images/empty.png",
                  text: "No Tasks Yet! Start Adding Some",
                  navigationRoute: AddTaskScreen.routeName,
                )
              : CustomListView(docs: docs, user: user!);
        },
      ),
    );
  }
}
