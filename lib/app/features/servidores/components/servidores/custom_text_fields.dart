import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildTextFormField({
  required TextEditingController controller,
  required String labelText,
  List<TextInputFormatter>? inputFormatters,
  TextInputType? keyboardType,
}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(labelText: labelText),
    inputFormatters: inputFormatters,
    keyboardType: keyboardType,
  );
}
