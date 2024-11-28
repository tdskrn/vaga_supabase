import 'package:flutter/material.dart';

Widget _highlightedText(String title, String content, Color color) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          content,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
      ],
    ),
  );
}

Widget _cardSection(String title, List<Widget> children) {
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

class ServidorDetail extends StatelessWidget {
  final Map<String, dynamic> data;

  const ServidorDetail({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalhes do Servidor',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _cardSection('Informações Básicas', [
              _highlightedText('Nome do Servidor:',
                  data['nome_servidor'] ?? 'N/A', Colors.black),
              data['servidor_2025'] != null
                  ? _highlightedText(
                      'Servidor 2025', data['servidor_2025'], Colors.black)
                  : Container(),
              _highlightedText('Cargo:', data['cargo'] ?? 'N/A', Colors.black),
              _highlightedText(
                  'Secretaria:', data['secretaria'] ?? 'N/A', Colors.black),
              _highlightedText(
                  'Lotação:', data['lotacao'] ?? 'N/A', Colors.black),
              _highlightedText(
                "Vínculo",
                data['vinculo'] ?? 'N/A',
                Colors.black,
              ),
              _highlightedText(
                "Situação atual",
                data['situacao_atual'] ?? 'N/A',
                Colors.black,
              )
            ]),
            data['situacao_atual'] != "DESLIGADO"
                ? _cardSection('Salários e Benefícios', [
                    data['salario_base'] != null
                        ? _highlightedText(
                            'Salário Base:',
                            "R\$ ${(data['salario_base'] ?? 0).toStringAsFixed(2)}",
                            Colors.blue)
                        : Container(),
                    data['valor_gratificacao'] != null
                        ? _highlightedText(
                            'Valor da Gratificação:',
                            "R\$ ${(data['valor_gratificacao'] ?? 0).toStringAsFixed(2)}",
                            Colors.blue)
                        : Container(),
                    data['porcentagem_gratificacao'] != "0.00%"
                        ? _highlightedText(
                            "Porcentagem Gratificação",
                            data['porcentagem_gratificacao'],
                            Colors.blue,
                          )
                        : Container(),
                    data['quant_hora_extra'] != 0
                        ? _highlightedText(
                            "Quantidade de Horas Extras",
                            "${(data['quant_hora_extra'] ?? 0).toString()}",
                            Colors.blue,
                          )
                        : Container(),
                    data['valor_hora_extra'] != null
                        ? _highlightedText(
                            "Valor Hora Extra",
                            "R\$ ${(data['valor_hora_extra'] ?? 0).toStringAsFixed(2)}",
                            Colors.blue,
                          )
                        : Container(),
                    data['total_horas'] != null
                        ? _highlightedText(
                            "Total Horas",
                            "R\$ ${(data['total_horas'] ?? 0).toStringAsFixed(2)}",
                            Colors.blue,
                          )
                        : Container(),
                    data['quant_quinquenios'] != 0
                        ? _highlightedText(
                            "Quantidade de Quinquenios",
                            data['quant_quinquenios'].toString(),
                            Colors.blue,
                          )
                        : Container(),
                    data['valor_quinquenios'] != null
                        ? _highlightedText(
                            "Valor Quinquênios",
                            "R\$ ${(data['valor_quinquenios'] ?? 0).toStringAsFixed(2)}",
                            Colors.blue,
                          )
                        : Container(),
                    data['adic_noturno'] != null
                        ? _highlightedText(
                            'Adicional Noturno:',
                            "R\$ ${(data['adic_noturno'] ?? 0).toStringAsFixed(2)}",
                            Colors.blue)
                        : Container(),
                    data['insal_periculosidade'] != null
                        ? _highlightedText(
                            'Insalubridade/Periculosidade:',
                            "R\$ ${(data['insal_periculosidade'] ?? 0).toStringAsFixed(2)}",
                            Colors.blue)
                        : Container(),
                    data['compl_enfermagem'] != null
                        ? _highlightedText(
                            'Complemento de Enfermagem:',
                            "R\$ ${(data['compl_enfermagem'] ?? 0).toStringAsFixed(2)}",
                            Colors.blue)
                        : Container(),
                    data['salario_familia'] != null
                        ? _highlightedText(
                            'Salário Família:',
                            "R\$ ${(data['salario_familia'] ?? 0).toStringAsFixed(2)}",
                            Colors.blue)
                        : Container(),
                  ])
                : Container(),
            data['situacao_atual'] != "DESLIGADO"
                ? _cardSection('Descontos', [
                    data['inss'] != null
                        ? _highlightedText(
                            'INSS:',
                            "R\$ ${(data['inss'] ?? 0).toStringAsFixed(2)}",
                            Colors.red)
                        : Container(),
                    data['imposto_renda'] != null
                        ? _highlightedText(
                            'Imposto de Renda:',
                            "R\$ ${(data['imposto_renda'] ?? 0).toStringAsFixed(2)}",
                            Colors.red)
                        : Container(),
                    data['sind_serv_publicos'] != null
                        ? _highlightedText(
                            'Sindicato dos Servidores Público:',
                            "R\$ ${(data['sind_serv_publicos'] ?? 0).toStringAsFixed(2)}",
                            Colors.red)
                        : Container(),
                    _highlightedText(
                        'Total de Descontos:',
                        "R\$ ${(data['total_descontos'] ?? 0).toStringAsFixed(2)}",
                        Colors.red),
                  ])
                : Container(),
            data['situacao_atual'] != "DESLIGADO"
                ? _cardSection('Resumo Financeiro', [
                    _highlightedText(
                        'Total Bruto:',
                        "R\$ ${(data['total_bruto'] ?? 0).toStringAsFixed(2)}",
                        Colors.blue),
                    _highlightedText(
                        'Total de Descontos:',
                        "R\$ ${(data['total_descontos'] ?? 0).toStringAsFixed(2)}",
                        Colors.red),
                    _highlightedText(
                        'Total Líquido:',
                        "R\$ ${(data['total_liquido'] ?? 0).toStringAsFixed(2)}",
                        Colors.green),
                  ])
                : Container(),
          ],
        ),
      ),
    );
  }
}
