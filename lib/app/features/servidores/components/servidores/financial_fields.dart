import 'package:flutter/material.dart';
import 'custom_text_fields.dart';

List<Widget> buildFinancialFields({
  required TextEditingController salarioBaseController,
  required TextEditingController gratificacaoController,
  required TextEditingController porcentagemGratificacaoController,
  required TextEditingController quantHorasExtrasController,
  required TextEditingController valorHorasController,
  required TextEditingController totalHorasController,
  required TextEditingController quantQuinqueniosController,
  required TextEditingController valorQuinqueniosController,
  required TextEditingController adicionalNoturnoController,
  required TextEditingController insalPericulosidadeController,
  required TextEditingController complEnfermagemController,
  required TextEditingController salarioFamiliaController,
}) {
  return [
    buildTextFormField(
      controller: salarioBaseController,
      labelText: 'Salário Base',
    ),
    buildTextFormField(
      controller: gratificacaoController,
      labelText: 'Gratificação',
    ),
    buildTextFormField(
      controller: porcentagemGratificacaoController,
      labelText: 'Porcentagem Gratificação',
    ),
    buildTextFormField(
      controller: quantHorasExtrasController,
      labelText: 'Quantidade Horas Extras',
    ),
    buildTextFormField(
      controller: valorHorasController,
      labelText: 'Valor Hora Extra',
    ),
    buildTextFormField(
      controller: totalHorasController,
      labelText: 'Total Horas',
    ),
    buildTextFormField(
      controller: quantQuinqueniosController,
      labelText: 'Quantidade Quinquênios',
    ),
    buildTextFormField(
      controller: valorQuinqueniosController,
      labelText: 'Valor Quinquênios',
    ),
    buildTextFormField(
      controller: adicionalNoturnoController,
      labelText: 'Adicional Noturno',
    ),
    buildTextFormField(
      controller: insalPericulosidadeController,
      labelText: 'Insalubridade/Periculosidade',
    ),
    buildTextFormField(
      controller: complEnfermagemController,
      labelText: 'Complemento de Enfermagem',
    ),
    buildTextFormField(
      controller: salarioFamiliaController,
      labelText: 'Salário Família',
    ),
  ];
}
