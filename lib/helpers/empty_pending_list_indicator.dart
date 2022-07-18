import 'package:flutter/material.dart';

class EmptyPendingListIndicator extends StatelessWidget {
  const EmptyPendingListIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
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
          Center(
            child: Text(
              "Hurray!! No Pending Tasks!",
              textScaleFactor: 1,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
