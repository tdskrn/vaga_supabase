import 'package:flutter/material.dart';
import 'custom_text_fields.dart';

List<Widget> buildDeductionsFields({
  required TextEditingController inssController,
  required TextEditingController impostoRendaController,
  required TextEditingController sindServPublicosController,
}) {
  return [
    buildTextFormField(
      controller: inssController,
      labelText: 'INSS',
    ),
    buildTextFormField(
      controller: impostoRendaController,
      labelText: 'Imposto de Renda',
    ),
    buildTextFormField(
      controller: sindServPublicosController,
      labelText: 'Sindicato dos Servidores Públicos',
    ),
  ];
}
