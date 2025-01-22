import 'package:flutter/material.dart';
import 'package:vaga_supabase/app/core/config/enumSecretaria.dart';
import 'package:vaga_supabase/app/core/config/enumSituacaoAtual.dart';
import 'package:vaga_supabase/app/core/config/enumVinculos.dart';

Widget buildDropdown<T>({
  required T? value,
  required String labelText,
  required List<T> items,
  required Function(T?) onChanged,
}) {
  return DropdownButtonFormField<T>(
    decoration: InputDecoration(labelText: labelText),
    value: value,
    items: items.map((item) {
      // Verifica se o item possui a propriedade `name` e a usa
      String itemName;
      if (item is Secretaria) {
        itemName = (item as Secretaria).name;
      } else if (item is SituacaoAtual) {
        itemName = (item as SituacaoAtual).name;
      } else if (item is Vinculo) {
        itemName = (item as Vinculo).name;
      } else {
        itemName = item.toString(); // Fallback
      }

      return DropdownMenuItem(
        value: item,
        child: Text(itemName),
      );
    }).toList(),
    onChanged: onChanged,
  );
}
