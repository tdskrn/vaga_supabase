import 'package:flutter/material.dart';

Map<String, dynamic> buildUpdateData({
  required TextEditingController nomeController,
  required TextEditingController secretariaController,
  required TextEditingController lotacaoController,
  required TextEditingController cargoController,
  required TextEditingController vinculoController,
  required TextEditingController situacaoAtualController,
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
  required TextEditingController inssController,
  required TextEditingController impostoRendaController,
  required TextEditingController sindServPublicosController,
  required TextEditingController totalBrutoController,
  required TextEditingController totalDescontosController,
  required TextEditingController totalLiquidoController,
}) {
  final Map<String, dynamic> dataToUpdate = {};

  void addToMap(String key, dynamic value) {
    if (value != null && value.toString().isNotEmpty) {
      dataToUpdate[key] = value;
    }
  }

  addToMap('nome_servidor', nomeController.text);
  addToMap('secretaria', secretariaController.text);
  addToMap('lotacao', lotacaoController.text);
  addToMap('cargo', cargoController.text);
  addToMap('vinculo', vinculoController.text);
  addToMap('situacao_atual', situacaoAtualController.text);
  addToMap('salario_base', double.tryParse(salarioBaseController.text));
  addToMap('valor_gratificacao', double.tryParse(gratificacaoController.text));
  addToMap('porcentagem_gratificacao',
      double.tryParse(porcentagemGratificacaoController.text));
  addToMap(
      'quant_hora_extra', double.tryParse(quantHorasExtrasController.text));
  addToMap('valor_hora_extra', double.tryParse(valorHorasController.text));
  addToMap('total_horas', double.tryParse(totalHorasController.text));
  addToMap('quant_quinquenios', int.tryParse(quantQuinqueniosController.text));
  addToMap(
      'valor_quinquenios', double.tryParse(valorQuinqueniosController.text));
  addToMap('adic_noturno', double.tryParse(adicionalNoturnoController.text));
  addToMap('insal_periculosidade',
      double.tryParse(insalPericulosidadeController.text));
  addToMap('compl_enfermagem', double.tryParse(complEnfermagemController.text));
  addToMap('salario_familia', double.tryParse(salarioFamiliaController.text));
  addToMap('inss', double.tryParse(inssController.text));
  addToMap('imposto_renda', double.tryParse(impostoRendaController.text));
  addToMap(
      'sind_serv_publicos', double.tryParse(sindServPublicosController.text));
  addToMap('total_bruto', double.tryParse(totalBrutoController.text));
  addToMap('total_descontos', double.tryParse(totalDescontosController.text));
  addToMap('total_liquido', double.tryParse(totalLiquidoController.text));

  return dataToUpdate;
}
