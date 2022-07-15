import 'package:flutter/material.dart';

class ContentText extends StatelessWidget {
  final String content;
  const ContentText(this.content, {Key? key}) : super(key: key);

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
        content,
        softWrap: true,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }
}
