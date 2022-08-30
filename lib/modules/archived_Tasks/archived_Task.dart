import 'package:flutter/material.dart';

class archivedTask extends StatelessWidget {
  const archivedTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Archived Tasks',
        style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
      ),
    );
  }
}
