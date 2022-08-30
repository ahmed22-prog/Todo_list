import 'package:flutter/material.dart';
Widget buildTaskItem(Map model)=>
Padding(
padding:  EdgeInsets.all(20.0),
child: Row(
children: [
CircleAvatar(
radius: 40,
child: Text('${model['time']}',
),
),
const SizedBox(
width: 20,
),
Column(
mainAxisSize: MainAxisSize.min,
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text('${model['title']}',
),
Text(
  '${model['date']}',
style: TextStyle(color: Colors.grey[300]),),
],
),
],
),
);
