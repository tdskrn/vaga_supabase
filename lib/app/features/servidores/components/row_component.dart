import 'package:flutter/material.dart';

Widget RowComponent(String text, int flex, Color color,
    {Color textColor = Colors.black}) {
  return Expanded(
    flex: flex,
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade700,
        ),
        color: color,
      ),
      child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          )),
    ),
  );
}
