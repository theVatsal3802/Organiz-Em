import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../helpers/custom_list_view.dart';
import '../helpers/empty_list_indicator.dart';

class ImportantTaskScreen extends StatefulWidget {
  static const routeName = "/important";
  const ImportantTaskScreen({Key? key}) : super(key: key);

  @override
  State<ImportantTaskScreen> createState() => _ImportantTaskScreenState();
}

class _ImportantTaskScreenState extends State<ImportantTaskScreen> {
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
            .where("isImportant", isEqualTo: true)
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
                  text: "No Important Tasks Yet!",
                )
              : CustomListView(docs: docs, user: user!);
        },
      ),
    );
  }
}
