import 'package:flutter/material.dart';

class EmptyListIndicator extends StatelessWidget {
  final String asset;
  final String text;
  final String? navigationRoute;
  const EmptyListIndicator(
      {required this.asset, this.navigationRoute, required this.text, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset(
            asset,
            height: 300,
            width: 300,
          ),
          Center(
            child: Text(
              text,
              textScaler: TextScaler.noScaling,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          if (navigationRoute != null)
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(navigationRoute!);
              },
              icon: const Icon(Icons.edit),
              label: Text(
                "Add Task",
                textScaler: TextScaler.noScaling,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
