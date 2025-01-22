import 'package:flutter/material.dart';

List<Widget> buildDialogActions({
  required BuildContext context,
  required Future<void> Function() onSave,
}) {
  return [
    TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text('Cancelar'),
    ),
    ElevatedButton(
      onPressed: onSave,
      child: Text('Salvar'),
    ),
  ];
}
