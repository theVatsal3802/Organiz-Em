import 'package:flutter/material.dart';

class HeadingText extends StatelessWidget {
  final String heading;
  const HeadingText(this.heading, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 3,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 2,
      ),
      child: Text(
        heading,
        textScaler: TextScaler.noScaling,
        softWrap: true,
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
