import 'package:flutter/material.dart';
import 'package:vaga_supabase/app/features/servidores/components/cardSectionComponent.dart';
import 'package:vaga_supabase/app/features/servidores/components/highlightedTextComponent.dart';

Widget ServidorDetailPanel(Map<String, dynamic> dadosStreamServidor) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        cardSection('Informações Básicas', [
          highlightedText('Nome do Servidor:',
              dadosStreamServidor!['nome_servidor'] ?? 'N/A', Colors.black),
          dadosStreamServidor['servidor_2025'] != null
              ? highlightedText('Servidor 2025',
                  dadosStreamServidor['servidor_2025'], Colors.black)
              : Container(),
          highlightedText(
              'Cargo:', dadosStreamServidor['cargo'] ?? 'N/A', Colors.black),
          highlightedText('Secretaria:',
              dadosStreamServidor['secretaria'] ?? 'N/A', Colors.black),
          highlightedText('Lotação:', dadosStreamServidor['lotacao'] ?? 'N/A',
              Colors.black),
          highlightedText(
            "Vínculo",
            dadosStreamServidor['vinculo'] ?? 'N/A',
            Colors.black,
          ),
          highlightedText(
            "Situação atual",
            dadosStreamServidor['situacao_atual'] ?? 'N/A',
            Colors.black,
          )
        ]),
        dadosStreamServidor['situacao_atual'] != "DESLIGADO"
            ? cardSection('Salários e Benefícios', [
                dadosStreamServidor['salario_base'] != null
                    ? highlightedText(
                        'Salário Base:',
                        "R\$ ${(dadosStreamServidor['salario_base'] ?? 0).toStringAsFixed(2)}",
                        Colors.blue)
                    : Container(),
                dadosStreamServidor['valor_gratificacao'] != null
                    ? highlightedText(
                        'Valor da Gratificação:',
                        "R\$ ${(dadosStreamServidor['valor_gratificacao'] ?? 0).toStringAsFixed(2)}",
                        Colors.blue)
                    : Container(),
                (dadosStreamServidor['porcentagem_gratificacao'] != "0.00%" &&
                        dadosStreamServidor['porcentagem_gratificacao'] != null)
                    ? highlightedText(
                        "Porcentagem Gratificação",
                        dadosStreamServidor['porcentagem_gratificacao'],
                        Colors.blue,
                      )
                    : Container(),
                dadosStreamServidor['quant_hora_extra'] != 0
                    ? highlightedText(
                        "Quantidade de Horas Extras",
                        "${(dadosStreamServidor['quant_hora_extra'] ?? 0).toString()}",
                        Colors.blue,
                      )
                    : Container(),
                dadosStreamServidor['valor_hora_extra'] != null
                    ? highlightedText(
                        "Valor Hora Extra",
                        "R\$ ${(dadosStreamServidor['valor_hora_extra'] ?? 0).toStringAsFixed(2)}",
                        Colors.blue,
                      )
                    : Container(),
                dadosStreamServidor['total_horas'] != null
                    ? highlightedText(
                        "Total Horas",
                        "R\$ ${(dadosStreamServidor['total_horas'] ?? 0).toStringAsFixed(2)}",
                        Colors.blue,
                      )
                    : Container(),
                dadosStreamServidor['quant_quinquenios'] != 0
                    ? highlightedText(
                        "Quantidade de Quinquenios",
                        dadosStreamServidor['quant_quinquenios'].toString(),
                        Colors.blue,
                      )
                    : Container(),
                dadosStreamServidor['valor_quinquenios'] != null
                    ? highlightedText(
                        "Valor Quinquênios",
                        "R\$ ${(dadosStreamServidor['valor_quinquenios'] ?? 0).toStringAsFixed(2)}",
                        Colors.blue,
                      )
                    : Container(),
                dadosStreamServidor['adic_noturno'] != null
                    ? highlightedText(
                        'Adicional Noturno:',
                        "R\$ ${(dadosStreamServidor['adic_noturno'] ?? 0).toStringAsFixed(2)}",
                        Colors.blue)
                    : Container(),
                dadosStreamServidor['insal_periculosidade'] != null
                    ? highlightedText(
                        'Insalubridade/Periculosidade:',
                        "R\$ ${(dadosStreamServidor['insal_periculosidade'] ?? 0).toStringAsFixed(2)}",
                        Colors.blue)
                    : Container(),
                dadosStreamServidor['compl_enfermagem'] != null
                    ? highlightedText(
                        'Complemento de Enfermagem:',
                        "R\$ ${(dadosStreamServidor['compl_enfermagem'] ?? 0).toStringAsFixed(2)}",
                        Colors.blue)
                    : Container(),
                dadosStreamServidor['salario_familia'] != null
                    ? highlightedText(
                        'Salário Família:',
                        "R\$ ${(dadosStreamServidor['salario_familia'] ?? 0).toStringAsFixed(2)}",
                        Colors.blue)
                    : Container(),
              ])
            : Container(),
        dadosStreamServidor['situacao_atual'] != "DESLIGADO"
            ? cardSection('Descontos', [
                dadosStreamServidor['inss'] != null
                    ? highlightedText(
                        'INSS:',
                        "R\$ ${(dadosStreamServidor['inss'] ?? 0).toStringAsFixed(2)}",
                        Colors.red)
                    : Container(),
                dadosStreamServidor['imposto_renda'] != null
                    ? highlightedText(
                        'Imposto de Renda:',
                        "R\$ ${(dadosStreamServidor['imposto_renda'] ?? 0).toStringAsFixed(2)}",
                        Colors.red)
                    : Container(),
                dadosStreamServidor['sind_serv_publicos'] != null
                    ? highlightedText(
                        'Sindicato dos Servidores Público:',
                        "R\$ ${(dadosStreamServidor['sind_serv_publicos'] ?? 0).toStringAsFixed(2)}",
                        Colors.red)
                    : Container(),
                highlightedText(
                    'Total de Descontos:',
                    "R\$ ${(dadosStreamServidor['total_descontos'] ?? 0).toStringAsFixed(2)}",
                    Colors.red),
              ])
            : Container(),
        dadosStreamServidor['situacao_atual'] != "DESLIGADO"
            ? cardSection('Resumo Financeiro', [
                highlightedText(
                    'Total Bruto:',
                    "R\$ ${(dadosStreamServidor['total_bruto'] ?? 0).toStringAsFixed(2)}",
                    Colors.blue),
                highlightedText(
                    'Total de Descontos:',
                    "R\$ ${(dadosStreamServidor['total_descontos'] ?? 0).toStringAsFixed(2)}",
                    Colors.red),
                highlightedText(
                    'Total Líquido:',
                    "R\$ ${(dadosStreamServidor['total_liquido'] ?? 0).toStringAsFixed(2)}",
                    Colors.green),
              ])
            : Container(),
      ],
    ),
  );
}
