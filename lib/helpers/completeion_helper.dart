import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CompletionHelper {
  void toggleMarkComplete(
      QueryDocumentSnapshot<Object?> task, User? user) async {
    String tasks = dotenv.get("TASKS_COLLECTION", fallback: "");
    String myTask = dotenv.get("SUB_TASKS_COLLECTION", fallback: "");
    if (task["isComplete"] == false) {
      await FirebaseFirestore.instance
          .collection(tasks)
          .doc(user!.uid)
          .collection(myTask)
          .doc(task["postTime"])
          .update(
        {
          "isComplete": true,
        },
      );
    } else {
      await FirebaseFirestore.instance
          .collection(tasks)
          .doc(user!.uid)
          .collection(myTask)
          .doc(task["postTime"])
          .update(
        {
          "isComplete": false,
        },
      );
    }
  }
}
