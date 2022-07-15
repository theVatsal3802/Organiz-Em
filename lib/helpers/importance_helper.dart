import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ImportanceHelper {
  void toggleMarkImportant(
      QueryDocumentSnapshot<Object?> task, User? user) async {
    String tasks = dotenv.get("TASKS_COLLECTION", fallback: "");
    String myTask = dotenv.get("SUB_TASKS_COLLECTION", fallback: "");
    if (task["isImportant"] == true) {
      await FirebaseFirestore.instance
          .collection(tasks)
          .doc(user!.uid)
          .collection(myTask)
          .doc(task["postTime"])
          .update({"isImportant": false});
    } else {
      await FirebaseFirestore.instance
          .collection(tasks)
          .doc(user!.uid)
          .collection(myTask)
          .doc(task["postTime"])
          .update({"isImportant": true});
    }
  }
}
