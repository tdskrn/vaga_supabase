import 'package:flutter/material.dart';
import 'package:vaga_supabase/app/core/config/enumSecretaria.dart';
import 'package:vaga_supabase/app/core/config/enumSituacaoAtual.dart';
import 'package:vaga_supabase/app/core/config/enumVinculos.dart';
import 'package:vaga_supabase/app/core/config/utils.dart';
import 'package:vaga_supabase/app/core/router/app_router.dart';
import 'package:vaga_supabase/app/core/router/theme/icon_theme.dart';

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
  Map<String, dynamic> dadosServidor = {};
  late final Stream<Map<String, dynamic>> _dadosStream;
  TextEditingController nomeController = TextEditingController();

  TextEditingController secretariaController = TextEditingController();
  TextEditingController lotacaoController = TextEditingController();
  TextEditingController cargoController = TextEditingController();
  TextEditingController vinculoController = TextEditingController();
  TextEditingController situacaoAtualController = TextEditingController();
  // referentes a benefícios
  TextEditingController salarioBaseController = TextEditingController();
  TextEditingController gratificacaoController = TextEditingController();
  TextEditingController porcentagemGratificacaoController =
      TextEditingController();
  TextEditingController quantHorasExtrasController = TextEditingController();
  TextEditingController valorHorasController = TextEditingController();
  TextEditingController totalHorasController = TextEditingController();
  TextEditingController quantQuinqueniosController = TextEditingController();
  TextEditingController valorQuinqueniosController = TextEditingController();
  TextEditingController adicionalNoturnoController = TextEditingController();
  TextEditingController insalPericulosidadeController = TextEditingController();
  TextEditingController complEnfermagemController = TextEditingController();
  TextEditingController salarioFamiliaController = TextEditingController();

  TextEditingController inssController = TextEditingController();
  TextEditingController impostoRendaController = TextEditingController();
  TextEditingController sindServPublicosController = TextEditingController();
  TextEditingController totalBrutoController = TextEditingController();
  TextEditingController totalDescontosController = TextEditingController();
  TextEditingController totalLiquidoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dadosStream = supabase
        .from('vagas')
        .stream(primaryKey: ['id'])
        .eq('id', widget.data['id'])
        .map((event) => event.isNotEmpty ? event.first : {});
    // Inicializando os controladores com os valores do dadosServidor
  }

  @override
  void dispose() {
    // Limpando os controladores ao finalizar
    nomeController.dispose();

    secretariaController.dispose();
    lotacaoController.dispose();
    cargoController.dispose();
    vinculoController.dispose();
    situacaoAtualController.dispose();

    salarioBaseController.dispose();
    gratificacaoController.dispose();
    porcentagemGratificacaoController.dispose();
    quantHorasExtrasController.dispose();
    valorHorasController.dispose();
    totalHorasController.dispose();
    quantQuinqueniosController.dispose();
    valorQuinqueniosController.dispose();
    adicionalNoturnoController.dispose();
    insalPericulosidadeController.dispose();
    complEnfermagemController.dispose();
    salarioFamiliaController.dispose();

    inssController.dispose();
    impostoRendaController.dispose();
    sindServPublicosController.dispose();
    totalBrutoController.dispose();
    totalDescontosController.dispose();
    totalLiquidoController.dispose();

    super.dispose();
  }

  Future<Map<String, dynamic>> fetchData() async {
    final dynamic id = widget.data['id'];

    // Execute a consulta no Supabase
    final response = await supabase
        .from('vagas')
        .select()
        .eq('id', id)
        .single(); // Use `.single()` se espera apenas um registro.

    // Verifique se houve erro
    if (response == null) {
      print('Erro: ${response}');
    }

    // Caso contrário, os dados estarão disponíveis aqui
    return response;
  }

  Future<void> _updateServidor(Map<String, dynamic> dataToUpdate) async {
    try {
      await supabase
          .from('vagas')
          .update(dataToUpdate)
          .eq('id', widget.data['id']);

      // Aguarda um curto período para garantir que o trigger tenha tempo de executar

      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dados atualizados com sucesso!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar: $e')),
        );
      }
    }
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
                  inputFormatters: [UpperCaseTextFormatter()],
                  controller: nomeController,
                  decoration: InputDecoration(labelText: 'Nome do Servidor'),
                ),
                TextFormField(
                  inputFormatters: [UpperCaseTextFormatter()],
                  controller: cargoController,
                  decoration: InputDecoration(labelText: 'Cargo'),
                ),
                DropdownButtonFormField<Secretaria>(
                  decoration: InputDecoration(labelText: "Secretária"),
                  value:
                      SecretariaExtension.fromString(secretariaController.text),
                  items: Secretaria.values.map((secretaria) {
                    return DropdownMenuItem(
                      value: secretaria,
                      child: Text(
                        secretaria.name,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    secretariaController.text = value!.name;
                  },
                ),
                TextFormField(
                  controller: lotacaoController,
                  decoration: InputDecoration(labelText: 'Lotação'),
                ),
                DropdownButtonFormField<Vinculo>(
                  decoration: InputDecoration(labelText: "Vínculo"),
                  value: VinculoExtension.fromString(vinculoController.text),
                  items: Vinculo.values.map((Vinculo) {
                    return DropdownMenuItem(
                      value: Vinculo,
                      child: Text(
                        Vinculo.name,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    vinculoController.text = value!.name;
                  },
                ),
                DropdownButtonFormField<SituacaoAtual>(
                  decoration: InputDecoration(labelText: "Situação Atual"),
                  value: SituacaoAtualExtension.fromString(
                      situacaoAtualController.text),
                  items: SituacaoAtual.values.map((SituacaoAtual) {
                    return DropdownMenuItem(
                      value: SituacaoAtual,
                      child: Text(
                        SituacaoAtual.name,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    situacaoAtualController.text = value!.name;
                  },
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
                  controller: porcentagemGratificacaoController,
                  decoration:
                      InputDecoration(labelText: 'Porcentagem Gratificação'),
                ),
                TextFormField(
                  controller: quantHorasExtrasController,
                  decoration:
                      InputDecoration(labelText: 'Quantidade Horas Extras'),
                ),
                TextFormField(
                  controller: valorHorasController,
                  decoration: InputDecoration(labelText: 'Valor Hora Extra'),
                ),
                TextFormField(
                  controller: totalHorasController,
                  decoration: InputDecoration(labelText: 'Total Horas'),
                ),
                TextFormField(
                  controller: quantQuinqueniosController,
                  decoration:
                      InputDecoration(labelText: 'Quantidade Quinquênios'),
                ),
                TextFormField(
                  controller: valorQuinqueniosController,
                  decoration: InputDecoration(labelText: 'Valor Quinquênios'),
                ),
                TextFormField(
                  controller: adicionalNoturnoController,
                  decoration: InputDecoration(labelText: 'Adicional Noturno'),
                ),
                TextFormField(
                  controller: insalPericulosidadeController,
                  decoration: InputDecoration(
                      labelText: 'Insalubridade/Periculosidade'),
                ),
                TextFormField(
                  controller: complEnfermagemController,
                  decoration:
                      InputDecoration(labelText: 'Complemento de Enfermagem'),
                ),
                TextFormField(
                  controller: salarioFamiliaController,
                  decoration: InputDecoration(labelText: 'Salário Família'),
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
                  controller: sindServPublicosController,
                  decoration: InputDecoration(
                      labelText: 'Sindicato dos Servidores Públicos'),
                ),
                Divider(),
                TextFormField(
                  controller: totalBrutoController,
                  decoration: InputDecoration(labelText: 'Total Bruto'),
                ),
                TextFormField(
                  controller: totalDescontosController,
                  decoration: InputDecoration(labelText: 'Total de Descontos'),
                ),
                TextFormField(
                  controller: totalLiquidoController,
                  decoration: InputDecoration(labelText: 'Total Líquido'),
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
              onPressed: () async {
                try {
                  // Construir dinamicamente o mapa de atualização
                  final Map<String, dynamic> dataToUpdate = {};

                  // Adicionar valors ao mapa apenas se não estiverem vazios ou nulos
                  if (nomeController.text.isNotEmpty) {
                    dataToUpdate['nome_servidor'] = nomeController.text;
                  }

                  if (secretariaController.text.isNotEmpty) {
                    dataToUpdate['secretaria'] = secretariaController.text;
                  }
                  if (lotacaoController.text.isNotEmpty) {
                    dataToUpdate['lotacao'] = lotacaoController.text;
                  }
                  if (cargoController.text.isNotEmpty) {
                    dataToUpdate['cargo'] = cargoController.text;
                  }
                  if (vinculoController.text.isNotEmpty) {
                    dataToUpdate['vinculo'] = vinculoController.text;
                  }
                  if (situacaoAtualController.text.isNotEmpty) {
                    dataToUpdate['situacao_atual'] =
                        situacaoAtualController.text;
                  }

                  if (porcentagemGratificacaoController.text.isNotEmpty) {
                    dataToUpdate['porcentagem_gratificacao'] =
                        porcentagemGratificacaoController.text;
                  }

                  // Converter campos numéricos somente se houver valores válidos
                  if (salarioBaseController.text.isNotEmpty) {
                    dataToUpdate['salario_base'] =
                        double.tryParse(salarioBaseController.text);
                  }
                  if (gratificacaoController.text.isNotEmpty) {
                    dataToUpdate['valor_gratificacao'] =
                        double.tryParse(gratificacaoController.text);
                  }

                  if (quantHorasExtrasController.text.isNotEmpty) {
                    dataToUpdate['quant_hora_extra'] =
                        double.tryParse(quantHorasExtrasController.text);
                  }
                  if (valorHorasController.text.isNotEmpty) {
                    dataToUpdate['valor_hora_extra'] =
                        double.tryParse(valorHorasController.text);
                  }
                  if (totalHorasController.text.isNotEmpty) {
                    dataToUpdate['total_horas'] =
                        double.tryParse(totalHorasController.text);
                  }
                  if (quantQuinqueniosController.text.isNotEmpty) {
                    dataToUpdate['quant_quinquenios'] =
                        int.tryParse(quantQuinqueniosController.text);
                  }
                  if (valorQuinqueniosController.text.isNotEmpty) {
                    dataToUpdate['valor_quinquenios'] =
                        double.tryParse(valorQuinqueniosController.text);
                  }
                  if (adicionalNoturnoController.text.isNotEmpty) {
                    dataToUpdate['adic_noturno'] =
                        double.tryParse(adicionalNoturnoController.text);
                  }
                  if (insalPericulosidadeController.text.isNotEmpty) {
                    dataToUpdate['insal_periculosidade'] =
                        double.tryParse(insalPericulosidadeController.text);
                  }
                  if (complEnfermagemController.text.isNotEmpty) {
                    dataToUpdate['compl_enfermagem'] =
                        double.tryParse(complEnfermagemController.text);
                  }
                  if (salarioFamiliaController.text.isNotEmpty) {
                    dataToUpdate['salario_familia'] =
                        double.tryParse(salarioFamiliaController.text);
                  }
                  if (inssController.text.isNotEmpty) {
                    dataToUpdate['inss'] = double.tryParse(inssController.text);
                  }
                  if (impostoRendaController.text.isNotEmpty) {
                    dataToUpdate['imposto_renda'] =
                        double.tryParse(impostoRendaController.text);
                  }
                  if (sindServPublicosController.text.isNotEmpty) {
                    dataToUpdate['sind_serv_publicos'] =
                        double.tryParse(sindServPublicosController.text);
                  }
                  if (totalBrutoController.text.isNotEmpty) {
                    dataToUpdate['total_bruto'] =
                        double.tryParse(totalBrutoController.text);
                  }
                  if (totalDescontosController.text.isNotEmpty) {
                    dataToUpdate['total_descontos'] =
                        double.tryParse(totalDescontosController.text);
                  }
                  if (totalLiquidoController.text.isNotEmpty) {
                    dataToUpdate['total_liquido'] =
                        double.tryParse(totalLiquidoController.text);
                  }

                  if (dataToUpdate.isNotEmpty) {
                    Navigator.pop(context); // Fecha o diálogo primeiro
                    await _updateServidor(dataToUpdate);
                  } else {}
                } catch (e) {
                  print(e);
                }
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
    final dynamic id = widget.data['id'];
    final servidor = supabase.from('vagas').select().eq('id', id);
    print(servidor);

    return Scaffold(
        appBar: AppBar(
          iconTheme: iconTheme,
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
        body: StreamBuilder<Map<String, dynamic>>(
            stream: _dadosStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Erro ao carregar dados: ${snapshot.error}",
                    style: TextStyle(color: Colors.red),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text('Nenhum dado encontrado.'),
                );
              }
              final dadosServidor = snapshot.data;
              nomeController =
                  TextEditingController(text: dadosServidor!['nome_servidor']);

              secretariaController =
                  TextEditingController(text: dadosServidor['secretaria']);

              lotacaoController =
                  TextEditingController(text: dadosServidor['lotacao']);
              cargoController =
                  TextEditingController(text: dadosServidor['cargo']);

              vinculoController =
                  TextEditingController(text: dadosServidor['vinculo']);
              situacaoAtualController =
                  TextEditingController(text: dadosServidor['situacao_atual']);

              salarioBaseController = TextEditingController(
                  text: (dadosServidor['salario_base'] ?? '').toString());
              gratificacaoController = TextEditingController(
                  text: (dadosServidor['valor_gratificacao'] ?? '').toString());
              porcentagemGratificacaoController = TextEditingController(
                  text: (dadosServidor['porcentagem_gratificacao'] ?? ''));
              quantHorasExtrasController = TextEditingController(
                  text: (dadosServidor['quant_hora_extra'] ?? '').toString());
              valorHorasController = TextEditingController(
                  text: (dadosServidor['valor_hora_extra'] ?? '').toString());
              totalHorasController = TextEditingController(
                  text: (dadosServidor['total_horas'] ?? '').toString());
              quantQuinqueniosController = TextEditingController(
                  text: (dadosServidor['quant_quinquenios'] ?? '').toString());
              valorQuinqueniosController = TextEditingController(
                  text: (dadosServidor['valor_quinquenios'] ?? '').toString());
              adicionalNoturnoController = TextEditingController(
                  text: (dadosServidor['adic_noturno'] ?? '').toString());
              insalPericulosidadeController = TextEditingController(
                  text:
                      (dadosServidor['insal_periculosidade'] ?? '').toString());

              complEnfermagemController = TextEditingController(
                  text: (dadosServidor['compl_enfermagem'] ?? '').toString());
              salarioFamiliaController = TextEditingController(
                  text: (dadosServidor['salario_familia'] ?? '').toString());

              inssController = TextEditingController(
                  text: (dadosServidor['inss'] ?? '').toString());
              impostoRendaController = TextEditingController(
                  text: (dadosServidor['imposto_renda'] ?? '').toString());
              sindServPublicosController = TextEditingController(
                  text: (dadosServidor['sind_serv_publicos'] ?? '').toString());
              totalBrutoController = TextEditingController(
                  text: (dadosServidor['total_bruto'] ?? '').toString());
              totalDescontosController = TextEditingController(
                  text: (dadosServidor['total_descontos'] ?? '').toString());
              totalLiquidoController = TextEditingController(
                  text: (dadosServidor['total_liquido'] ?? '').toString());

              Stream<Map<String, dynamic>> _streamData() {
                return supabase
                    .from('vagas')
                    .stream(primaryKey: [
                      'id'
                    ]) // Use a chave primária para identificar alterações
                    .eq('id', dadosServidor['id'])
                    .map((event) => event.isNotEmpty ? event.first : {});
              }

              return StreamBuilder(
                  stream: _streamData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Erro: ${snapshot.error}',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text('Nenhum dado encontrado'),
                      );
                    }

                    final dadosStreamServidor = snapshot.data;

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _cardSection('Informações Básicas', [
                            _highlightedText(
                                'Nome do Servidor:',
                                dadosStreamServidor!['nome_servidor'] ?? 'N/A',
                                Colors.black),
                            dadosStreamServidor['servidor_2025'] != null
                                ? _highlightedText(
                                    'Servidor 2025',
                                    dadosStreamServidor['servidor_2025'],
                                    Colors.black)
                                : Container(),
                            _highlightedText(
                                'Cargo:',
                                dadosStreamServidor['cargo'] ?? 'N/A',
                                Colors.black),
                            _highlightedText(
                                'Secretaria:',
                                dadosStreamServidor['secretaria'] ?? 'N/A',
                                Colors.black),
                            _highlightedText(
                                'Lotação:',
                                dadosStreamServidor['lotacao'] ?? 'N/A',
                                Colors.black),
                            _highlightedText(
                              "Vínculo",
                              dadosStreamServidor['vinculo'] ?? 'N/A',
                              Colors.black,
                            ),
                            _highlightedText(
                              "Situação atual",
                              dadosStreamServidor['situacao_atual'] ?? 'N/A',
                              Colors.black,
                            )
                          ]),
                          dadosStreamServidor['situacao_atual'] != "DESLIGADO"
                              ? _cardSection('Salários e Benefícios', [
                                  dadosStreamServidor['salario_base'] != null
                                      ? _highlightedText(
                                          'Salário Base:',
                                          "R\$ ${(dadosStreamServidor['salario_base'] ?? 0).toStringAsFixed(2)}",
                                          Colors.blue)
                                      : Container(),
                                  dadosStreamServidor['valor_gratificacao'] !=
                                          null
                                      ? _highlightedText(
                                          'Valor da Gratificação:',
                                          "R\$ ${(dadosStreamServidor['valor_gratificacao'] ?? 0).toStringAsFixed(2)}",
                                          Colors.blue)
                                      : Container(),
                                  (dadosStreamServidor[
                                                  'porcentagem_gratificacao'] !=
                                              "0.00%" &&
                                          dadosStreamServidor[
                                                  'porcentagem_gratificacao'] !=
                                              null)
                                      ? _highlightedText(
                                          "Porcentagem Gratificação",
                                          dadosStreamServidor[
                                              'porcentagem_gratificacao'],
                                          Colors.blue,
                                        )
                                      : Container(),
                                  dadosStreamServidor['quant_hora_extra'] != 0
                                      ? _highlightedText(
                                          "Quantidade de Horas Extras",
                                          "${(dadosStreamServidor['quant_hora_extra'] ?? 0).toString()}",
                                          Colors.blue,
                                        )
                                      : Container(),
                                  dadosStreamServidor['valor_hora_extra'] !=
                                          null
                                      ? _highlightedText(
                                          "Valor Hora Extra",
                                          "R\$ ${(dadosStreamServidor['valor_hora_extra'] ?? 0).toStringAsFixed(2)}",
                                          Colors.blue,
                                        )
                                      : Container(),
                                  dadosStreamServidor['total_horas'] != null
                                      ? _highlightedText(
                                          "Total Horas",
                                          "R\$ ${(dadosStreamServidor['total_horas'] ?? 0).toStringAsFixed(2)}",
                                          Colors.blue,
                                        )
                                      : Container(),
                                  dadosStreamServidor['quant_quinquenios'] != 0
                                      ? _highlightedText(
                                          "Quantidade de Quinquenios",
                                          dadosStreamServidor[
                                                  'quant_quinquenios']
                                              .toString(),
                                          Colors.blue,
                                        )
                                      : Container(),
                                  dadosStreamServidor['valor_quinquenios'] !=
                                          null
                                      ? _highlightedText(
                                          "Valor Quinquênios",
                                          "R\$ ${(dadosStreamServidor['valor_quinquenios'] ?? 0).toStringAsFixed(2)}",
                                          Colors.blue,
                                        )
                                      : Container(),
                                  dadosStreamServidor['adic_noturno'] != null
                                      ? _highlightedText(
                                          'Adicional Noturno:',
                                          "R\$ ${(dadosStreamServidor['adic_noturno'] ?? 0).toStringAsFixed(2)}",
                                          Colors.blue)
                                      : Container(),
                                  dadosStreamServidor['insal_periculosidade'] !=
                                          null
                                      ? _highlightedText(
                                          'Insalubridade/Periculosidade:',
                                          "R\$ ${(dadosStreamServidor['insal_periculosidade'] ?? 0).toStringAsFixed(2)}",
                                          Colors.blue)
                                      : Container(),
                                  dadosStreamServidor['compl_enfermagem'] !=
                                          null
                                      ? _highlightedText(
                                          'Complemento de Enfermagem:',
                                          "R\$ ${(dadosStreamServidor['compl_enfermagem'] ?? 0).toStringAsFixed(2)}",
                                          Colors.blue)
                                      : Container(),
                                  dadosStreamServidor['salario_familia'] != null
                                      ? _highlightedText(
                                          'Salário Família:',
                                          "R\$ ${(dadosStreamServidor['salario_familia'] ?? 0).toStringAsFixed(2)}",
                                          Colors.blue)
                                      : Container(),
                                ])
                              : Container(),
                          dadosStreamServidor['situacao_atual'] != "DESLIGADO"
                              ? _cardSection('Descontos', [
                                  dadosStreamServidor['inss'] != null
                                      ? _highlightedText(
                                          'INSS:',
                                          "R\$ ${(dadosStreamServidor['inss'] ?? 0).toStringAsFixed(2)}",
                                          Colors.red)
                                      : Container(),
                                  dadosStreamServidor['imposto_renda'] != null
                                      ? _highlightedText(
                                          'Imposto de Renda:',
                                          "R\$ ${(dadosStreamServidor['imposto_renda'] ?? 0).toStringAsFixed(2)}",
                                          Colors.red)
                                      : Container(),
                                  dadosStreamServidor['sind_serv_publicos'] !=
                                          null
                                      ? _highlightedText(
                                          'Sindicato dos Servidores Público:',
                                          "R\$ ${(dadosStreamServidor['sind_serv_publicos'] ?? 0).toStringAsFixed(2)}",
                                          Colors.red)
                                      : Container(),
                                  _highlightedText(
                                      'Total de Descontos:',
                                      "R\$ ${(dadosStreamServidor['total_descontos'] ?? 0).toStringAsFixed(2)}",
                                      Colors.red),
                                ])
                              : Container(),
                          dadosStreamServidor['situacao_atual'] != "DESLIGADO"
                              ? _cardSection('Resumo Financeiro', [
                                  _highlightedText(
                                      'Total Bruto:',
                                      "R\$ ${(dadosStreamServidor['total_bruto'] ?? 0).toStringAsFixed(2)}",
                                      Colors.blue),
                                  _highlightedText(
                                      'Total de Descontos:',
                                      "R\$ ${(dadosStreamServidor['total_descontos'] ?? 0).toStringAsFixed(2)}",
                                      Colors.red),
                                  _highlightedText(
                                      'Total Líquido:',
                                      "R\$ ${(dadosStreamServidor['total_liquido'] ?? 0).toStringAsFixed(2)}",
                                      Colors.green),
                                ])
                              : Container(),
                        ],
                      ),
                    );
                  });
            }));
  }
}
