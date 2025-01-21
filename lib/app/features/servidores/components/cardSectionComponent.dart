import 'package:flutter/material.dart';

Widget cardSection(String title, List<Widget> children) {
  return Card(
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          Divider(),
          ...children,
        ],
      ),
    ),
  );
}
