import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../helpers/custom_list_view.dart';
import '../helpers/date_helper.dart';
import '../helpers/empty_pending_list_indicator.dart';

class TodayTaskScreen extends StatefulWidget {
  const TodayTaskScreen({Key? key}) : super(key: key);

  @override
  State<TodayTaskScreen> createState() => TodayTaskScreenState();
}

class TodayTaskScreenState extends State<TodayTaskScreen> {
  User? user;
  String todayDate = "";

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    setTodayDate();
  }

  void setTodayDate() {
    DateTime date = DateTime.now();
    String month = DateHelper().setMonth(date.month);
    String year = date.year.toString();
    String day = date.toString().substring(8, 10);
    todayDate = "$day $month, $year";
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
            .where("dueDate", isEqualTo: todayDate)
            .where("isComplete", isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final docs = snapshot.data != null ? snapshot.data!.docs : [];
          return docs.isEmpty
              ? const EmptyPendingListIndicator()
              : CustomListView(docs: docs, user: user!);
        },
      ),
    );
  }
}
