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

class ServidorDetail extends StatefulWidget {
  final Map<String, dynamic> data;

  const ServidorDetail({super.key, required this.data});

  @override
  State<ServidorDetail> createState() => _ServidorDetailState();
}

class _ServidorDetailState extends State<ServidorDetail> {
  late final TextEditingController nomeController;
  late final TextEditingController cargoController;
  late final TextEditingController secretariaController;
  late final TextEditingController lotacaoController;
  late final TextEditingController vinculoController;
  late final TextEditingController situacaoAtualController;

  late final TextEditingController salarioBaseController;
  late final TextEditingController gratificacaoController;
  late final TextEditingController horasExtrasController;
  late final TextEditingController valorHorasController;
  late final TextEditingController totalHorasController;
  late final TextEditingController quantQuinqueniosController;
  late final TextEditingController quinqueniosController;
  late final TextEditingController adicionalNoturnoController;
  late final TextEditingController complEnfermagemController;
  late final TextEditingController insalPericulosidadeController;

  late final TextEditingController inssController;
  late final TextEditingController impostoRendaController;
  late final TextEditingController descontosTotaisController;

  @override
  void initState() {
    super.initState();

    // Inicializando os controladores com os valores do widget.data
    nomeController = TextEditingController(text: widget.data['nome_servidor']);
    cargoController = TextEditingController(text: widget.data['cargo']);
    secretariaController =
        TextEditingController(text: widget.data['secretaria']);
    lotacaoController = TextEditingController(text: widget.data['lotacao']);
    vinculoController = TextEditingController(text: widget.data['vinculo']);
    situacaoAtualController =
        TextEditingController(text: widget.data['situacao_atual']);

    salarioBaseController = TextEditingController(
        text: (widget.data['salario_base'] ?? '').toString());
    gratificacaoController = TextEditingController(
        text: (widget.data['valor_gratificacao'] ?? '').toString());
    horasExtrasController = TextEditingController(
        text: (widget.data['quant_hora_extra'] ?? '').toString());
    valorHorasController = TextEditingController(
        text: (widget.data['valor_hora_extra'] ?? '').toString());
    quinqueniosController = TextEditingController(
        text: (widget.data['quant_quinquenios'] ?? '').toString());
    quantQuinqueniosController = TextEditingController(
        text: (widget.data['valor_quinquenions'] ?? '').toString());
    adicionalNoturnoController = TextEditingController(
        text: (widget.data['adic_noturno'] ?? '').toString());

    inssController =
        TextEditingController(text: (widget.data['inss'] ?? '').toString());
    impostoRendaController = TextEditingController(
        text: (widget.data['imposto_renda'] ?? '').toString());
    descontosTotaisController = TextEditingController(
        text: (widget.data['total_descontos'] ?? '').toString());
  }

  @override
  void dispose() {
    // Limpando os controladores ao finalizar
    nomeController.dispose();
    cargoController.dispose();
    secretariaController.dispose();
    lotacaoController.dispose();
    vinculoController.dispose();
    situacaoAtualController.dispose();

    salarioBaseController.dispose();
    gratificacaoController.dispose();
    horasExtrasController.dispose();
    valorHorasController.dispose();
    quinqueniosController.dispose();
    adicionalNoturnoController.dispose();

    inssController.dispose();
    impostoRendaController.dispose();
    descontosTotaisController.dispose();
    super.dispose();
  }

  _editServidor() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Servidor'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nomeController,
                  decoration: InputDecoration(labelText: 'Nome do Servidor'),
                ),
                TextFormField(
                  controller: cargoController,
                  decoration: InputDecoration(labelText: 'Cargo'),
                ),
                TextFormField(
                  controller: secretariaController,
                  decoration: InputDecoration(labelText: 'Secretaria'),
                ),
                TextFormField(
                  controller: lotacaoController,
                  decoration: InputDecoration(labelText: 'Lotação'),
                ),
                TextFormField(
                  controller: vinculoController,
                  decoration: InputDecoration(labelText: 'Vínculo'),
                ),
                TextFormField(
                  controller: situacaoAtualController,
                  decoration: InputDecoration(labelText: 'Situação Atual'),
                ),
                Divider(),
                TextFormField(
                  controller: salarioBaseController,
                  decoration: InputDecoration(labelText: 'Salário Base'),
                ),
                TextFormField(
                  controller: gratificacaoController,
                  decoration: InputDecoration(labelText: 'Gratificação'),
                ),
                TextFormField(
                  controller: horasExtrasController,
                  decoration: InputDecoration(labelText: 'Horas Extras'),
                ),
                TextFormField(
                  controller: valorHorasController,
                  decoration: InputDecoration(labelText: 'Valor Hora Extra'),
                ),
                TextFormField(
                  controller: quinqueniosController,
                  decoration: InputDecoration(labelText: 'Quinquênios'),
                ),
                TextFormField(
                  controller: adicionalNoturnoController,
                  decoration: InputDecoration(labelText: 'Adicional Noturno'),
                ),
                Divider(),
                TextFormField(
                  controller: inssController,
                  decoration: InputDecoration(labelText: 'INSS'),
                ),
                TextFormField(
                  controller: impostoRendaController,
                  decoration: InputDecoration(labelText: 'Imposto de Renda'),
                ),
                TextFormField(
                  controller: descontosTotaisController,
                  decoration: InputDecoration(labelText: 'Descontos Totais'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Aqui você pode manipular os dados editados
                print('Dados salvos');
                Navigator.pop(context);
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

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
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  _editServidor();
                },
                icon: Icon(Icons.edit),
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _cardSection('Informações Básicas', [
              _highlightedText('Nome do Servidor:',
                  widget.data['nome_servidor'] ?? 'N/A', Colors.black),
              widget.data['servidor_2025'] != null
                  ? _highlightedText('Servidor 2025',
                      widget.data['servidor_2025'], Colors.black)
                  : Container(),
              _highlightedText(
                  'Cargo:', widget.data['cargo'] ?? 'N/A', Colors.black),
              _highlightedText('Secretaria:',
                  widget.data['secretaria'] ?? 'N/A', Colors.black),
              _highlightedText(
                  'Lotação:', widget.data['lotacao'] ?? 'N/A', Colors.black),
              _highlightedText(
                "Vínculo",
                widget.data['vinculo'] ?? 'N/A',
                Colors.black,
              ),
              _highlightedText(
                "Situação atual",
                widget.data['situacao_atual'] ?? 'N/A',
                Colors.black,
              )
            ]),
            widget.data['situacao_atual'] != "DESLIGADO"
                ? _cardSection('Salários e Benefícios', [
                    widget.data['salario_base'] != null
                        ? _highlightedText(
                            'Salário Base:',
                            "R\$ ${(widget.data['salario_base'] ?? 0).toStringAsFixed(2)}",
                            Colors.blue)
                        : Container(),
                    widget.data['valor_gratificacao'] != null
                        ? _highlightedText(
                            'Valor da Gratificação:',
                            "R\$ ${(widget.data['valor_gratificacao'] ?? 0).toStringAsFixed(2)}",
                            Colors.blue)
                        : Container(),
                    widget.data['porcentagem_gratificacao'] != "0.00%"
                        ? _highlightedText(
                            "Porcentagem Gratificação",
                            widget.data['porcentagem_gratificacao'],
                            Colors.blue,
                          )
                        : Container(),
                    widget.data['quant_hora_extra'] != 0
                        ? _highlightedText(
                            "Quantidade de Horas Extras",
                            "${(widget.data['quant_hora_extra'] ?? 0).toString()}",
                            Colors.blue,
                          )
                        : Container(),
                    widget.data['valor_hora_extra'] != null
                        ? _highlightedText(
                            "Valor Hora Extra",
                            "R\$ ${(widget.data['valor_hora_extra'] ?? 0).toStringAsFixed(2)}",
                            Colors.blue,
                          )
                        : Container(),
                    widget.data['total_horas'] != null
                        ? _highlightedText(
                            "Total Horas",
                            "R\$ ${(widget.data['total_horas'] ?? 0).toStringAsFixed(2)}",
                            Colors.blue,
                          )
                        : Container(),
                    widget.data['quant_quinquenios'] != 0
                        ? _highlightedText(
                            "Quantidade de Quinquenios",
                            widget.data['quant_quinquenios'].toString(),
                            Colors.blue,
                          )
                        : Container(),
                    widget.data['valor_quinquenios'] != null
                        ? _highlightedText(
                            "Valor Quinquênios",
                            "R\$ ${(widget.data['valor_quinquenios'] ?? 0).toStringAsFixed(2)}",
                            Colors.blue,
                          )
                        : Container(),
                    widget.data['adic_noturno'] != null
                        ? _highlightedText(
                            'Adicional Noturno:',
                            "R\$ ${(widget.data['adic_noturno'] ?? 0).toStringAsFixed(2)}",
                            Colors.blue)
                        : Container(),
                    widget.data['insal_periculosidade'] != null
                        ? _highlightedText(
                            'Insalubridade/Periculosidade:',
                            "R\$ ${(widget.data['insal_periculosidade'] ?? 0).toStringAsFixed(2)}",
                            Colors.blue)
                        : Container(),
                    widget.data['compl_enfermagem'] != null
                        ? _highlightedText(
                            'Complemento de Enfermagem:',
                            "R\$ ${(widget.data['compl_enfermagem'] ?? 0).toStringAsFixed(2)}",
                            Colors.blue)
                        : Container(),
                    widget.data['salario_familia'] != null
                        ? _highlightedText(
                            'Salário Família:',
                            "R\$ ${(widget.data['salario_familia'] ?? 0).toStringAsFixed(2)}",
                            Colors.blue)
                        : Container(),
                  ])
                : Container(),
            widget.data['situacao_atual'] != "DESLIGADO"
                ? _cardSection('Descontos', [
                    widget.data['inss'] != null
                        ? _highlightedText(
                            'INSS:',
                            "R\$ ${(widget.data['inss'] ?? 0).toStringAsFixed(2)}",
                            Colors.red)
                        : Container(),
                    widget.data['imposto_renda'] != null
                        ? _highlightedText(
                            'Imposto de Renda:',
                            "R\$ ${(widget.data['imposto_renda'] ?? 0).toStringAsFixed(2)}",
                            Colors.red)
                        : Container(),
                    widget.data['sind_serv_publicos'] != null
                        ? _highlightedText(
                            'Sindicato dos Servidores Público:',
                            "R\$ ${(widget.data['sind_serv_publicos'] ?? 0).toStringAsFixed(2)}",
                            Colors.red)
                        : Container(),
                    _highlightedText(
                        'Total de Descontos:',
                        "R\$ ${(widget.data['total_descontos'] ?? 0).toStringAsFixed(2)}",
                        Colors.red),
                  ])
                : Container(),
            widget.data['situacao_atual'] != "DESLIGADO"
                ? _cardSection('Resumo Financeiro', [
                    _highlightedText(
                        'Total Bruto:',
                        "R\$ ${(widget.data['total_bruto'] ?? 0).toStringAsFixed(2)}",
                        Colors.blue),
                    _highlightedText(
                        'Total de Descontos:',
                        "R\$ ${(widget.data['total_descontos'] ?? 0).toStringAsFixed(2)}",
                        Colors.red),
                    _highlightedText(
                        'Total Líquido:',
                        "R\$ ${(widget.data['total_liquido'] ?? 0).toStringAsFixed(2)}",
                        Colors.green),
                  ])
                : Container(),
          ],
        ),
      ),
    );
  }
}
