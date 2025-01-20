import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:vaga_supabase/app/core/config/enumSecretaria.dart';
import 'package:vaga_supabase/app/core/config/enumSituacaoAtual.dart';
import 'package:vaga_supabase/app/core/config/enumVinculos.dart';
import 'package:vaga_supabase/app/core/config/utils.dart';
import 'package:vaga_supabase/app/features/servidores/components/servidor_detail.dart';

class GetServidoresPage2 extends StatefulWidget {
  const GetServidoresPage2({super.key});

  @override
  State<GetServidoresPage2> createState() => _GetServidoresPageState();
}

class _GetServidoresPageState extends State<GetServidoresPage2> {
  final TextEditingController _searchController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;

  String _searchValue = '';
  Secretaria? _selectedSecretaria;
  Vinculo? _selectedVinculo;
  SituacaoAtual? _selectedSituacao;
  late final TextEditingController nomeController;

  late final TextEditingController secretariaController;
  late final TextEditingController lotacaoController;
  late final TextEditingController cargoController;
  late final TextEditingController vinculoController;
  late final TextEditingController situacaoAtualController;
  // referentes a benefícios
  late final TextEditingController salarioBaseController;
  late final TextEditingController gratificacaoController;
  late final TextEditingController porcentagemGratificacaoController;
  late final TextEditingController quantHorasExtrasController;
  late final TextEditingController valorHorasController;
  late final TextEditingController totalHorasController;
  late final TextEditingController quantQuinqueniosController;
  late final TextEditingController valorQuinqueniosController;
  late final TextEditingController adicionalNoturnoController;
  late final TextEditingController insalPericulosidadeController;
  late final TextEditingController complEnfermagemController;
  late final TextEditingController salarioFamiliaController;

  late final TextEditingController inssController;
  late final TextEditingController impostoRendaController;
  late final TextEditingController sindServPublicosController;
  late final TextEditingController totalBrutoController;
  late final TextEditingController totalDescontosController;
  late final TextEditingController totalLiquidoController;

  late final Stream<List<Map<String, dynamic>>> stream;
  late ServidorDataSource dataSource;

  @override
  void initState() {
    super.initState();
    stream = supabase
        .from('vagas')
        .stream(primaryKey: ['id'])
        .order('nome_servidor', ascending: true)
        .map((data) => data.cast<Map<String, dynamic>>());

    nomeController = TextEditingController();
    secretariaController = TextEditingController();
    lotacaoController = TextEditingController();
    cargoController = TextEditingController();
    vinculoController = TextEditingController();
    situacaoAtualController = TextEditingController();

    salarioBaseController = TextEditingController();
    gratificacaoController = TextEditingController();
    porcentagemGratificacaoController = TextEditingController();
    quantHorasExtrasController = TextEditingController();
    valorHorasController = TextEditingController();
    totalHorasController = TextEditingController();
    quantQuinqueniosController = TextEditingController();
    valorQuinqueniosController = TextEditingController();
    adicionalNoturnoController = TextEditingController();
    insalPericulosidadeController = TextEditingController();
    complEnfermagemController = TextEditingController();
    salarioFamiliaController = TextEditingController();

    inssController = TextEditingController();
    impostoRendaController = TextEditingController();
    sindServPublicosController = TextEditingController();
    totalBrutoController = TextEditingController();
    totalDescontosController = TextEditingController();
    totalLiquidoController = TextEditingController();
  }

  Stream<List<Map<String, dynamic>>> getFilteredStream() {
    return stream.map((data) {
      return data.where((servidor) {
        final matchesSearch = _searchValue.isEmpty ||
            servidor['nome_servidor']
                    ?.toString()
                    .toLowerCase()
                    .contains(_searchValue.toLowerCase()) ==
                true;

        final matchesSecretaria = _selectedSecretaria == null ||
            servidor['secretaria'] == _selectedSecretaria!.name;

        final matchesVinculo = _selectedVinculo == null ||
            servidor['vinculo'] == _selectedVinculo!.name;

        final matchesSituacao = _selectedSituacao == null ||
            servidor['situacao_atual']
                    ?.toString()
                    .toLowerCase()
                    .contains(_selectedSituacao!.name.toLowerCase()) ==
                true;

        return matchesSearch &&
            matchesSecretaria &&
            matchesVinculo &&
            matchesSituacao;
      }).toList();
    });
  }

  _addServidor() {
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
                    await supabase.from('vagas').insert(dataToUpdate);
                  } else {}
                } catch (e) {
                  print(e);
                }

                // Aqui você pode manipular os dados editados

                Navigator.pop(context);
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _performSearch() {
    setState(() {
      _searchValue = _searchController.text.trim();
    });
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _searchValue = '';
      _selectedSecretaria = null;
      _selectedVinculo = null;
      _selectedSituacao = null;
    });
  }

  Future<void> _deleteServidor(int id) async {
    try {
      final response =
          await Supabase.instance.client.from('vagas').delete().eq('id', id);

      if (response.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erro ao deletar: ${response.error!.message}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Servidor deletado com sucesso!')),
        );

        // Atualize a UI (se necessário, dependente de como você está gerenciando o estado)
        setState(() {});
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro inesperado: $e')),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _searchController,
                    onFieldSubmitted: (value) {
                      _performSearch();
                    },
                    decoration: const InputDecoration(
                      hintText: 'Pesquise por nome',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _performSearch,
                  child: const Text('Pesquisar'),
                ),
              ],
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = constraints.maxWidth > 600
                  ? (constraints.maxWidth - 16) / 3.3
                  : (constraints.maxWidth - 16) / 1.5;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    SizedBox(
                      width: itemWidth,
                      child: DropdownButtonFormField<Secretaria>(
                        isExpanded: true,
                        decoration: _decoration,
                        value: _selectedSecretaria,
                        onChanged: (value) =>
                            setState(() => _selectedSecretaria = value),
                        hint: Text('Selecione a Secretaria'),
                        items: Secretaria.values.map((secretaria) {
                          return DropdownMenuItem(
                            value: secretaria,
                            child: Text(secretaria.name),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: itemWidth,
                      child: DropdownButtonFormField<Vinculo>(
                        isExpanded: true,
                        decoration: _decoration,
                        value: _selectedVinculo,
                        onChanged: (value) =>
                            setState(() => _selectedVinculo = value),
                        hint: Text('Selecione o Vínculo'),
                        items: Vinculo.values.map((vinculo) {
                          return DropdownMenuItem(
                            value: vinculo,
                            child: Text(vinculo.name),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: itemWidth,
                      child: DropdownButtonFormField<SituacaoAtual>(
                        isExpanded: true,
                        decoration: _decoration,
                        value: _selectedSituacao,
                        onChanged: (value) =>
                            setState(() => _selectedSituacao = value),
                        hint: Text(
                          'Selecione a Situação',
                        ),
                        items: SituacaoAtual.values.map((situacao) {
                          return DropdownMenuItem(
                            value: situacao,
                            child: Text(situacao.name),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _resetFilters,
                  child: const Text('Resetar Filtros'),
                ),
                ElevatedButton(
                  onPressed: _addServidor,
                  child: const Text('Adicionar Servidor'),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: getFilteredStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Erro: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Nenhum dado encontrado.'));
                }

                final servidores = snapshot.data!;
                dataSource =
                    ServidorDataSource(servidores, context, _deleteServidor);

                return SfDataGridTheme(
                  data: SfDataGridThemeData(
                      sortIconColor: Colors.white,
                      headerColor: Color.fromARGB(255, 3, 9, 97)),
                  child: SfDataGrid(
                      selectionMode: SelectionMode.single,
                      navigationMode: GridNavigationMode.cell,
                      allowSorting: true,
                      allowMultiColumnSorting: true,
                      isScrollbarAlwaysShown: true,
                      showSortNumbers: true,
                      source: dataSource,
                      columns: <GridColumn>[
                        GridColumn(
                          columnWidthMode: ColumnWidthMode.fill,
                          columnName: 'nome',
                          label: Center(
                            child: Text(
                              'Nome',
                              style: _estiloTextos,
                            ),
                          ),
                        ),
                        GridColumn(
                          columnWidthMode: ColumnWidthMode.fill,
                          columnName: 'cargo',
                          label: Center(
                            child: Text(
                              'Cargo',
                              style: _estiloTextos,
                            ),
                          ),
                        ),
                        GridColumn(
                          columnWidthMode: ColumnWidthMode.fill,
                          columnName: 'secretaria',
                          label: Center(
                            child: Text(
                              'Secretaria',
                              style: _estiloTextos,
                            ),
                          ),
                        ),
                        GridColumn(
                          columnWidthMode: ColumnWidthMode.fill,
                          columnName: 'acoes',
                          label: Center(
                            child: Text(
                              "Ações",
                              style: _estiloTextos,
                            ),
                          ),
                        ),
                      ]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _estiloTextos = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
}

class ServidorDataSource extends DataGridSource {
  final BuildContext context;
  final Function(int) onDelete;
  String formatCurrency(double value) {
    final currencyFormat = NumberFormat.simpleCurrency(locale: 'pt_BR');
    return currencyFormat.format(value); // Formata o número para R$ 1.000,00
  }

  ServidorDataSource(
      List<Map<String, dynamic>> servidores, this.context, this.onDelete) {
    _rows = servidores.map<DataGridRow>((servidor) {
      return DataGridRow(cells: [
        DataGridCell(columnName: 'nome', value: servidor['nome_servidor']),
        DataGridCell(columnName: 'cargo', value: servidor['cargo']),
        DataGridCell(columnName: 'secretaria', value: servidor['secretaria']),
        DataGridCell(columnName: "acoes", value: servidor),
      ]);
    }).toList();
  }

  late List<DataGridRow> _rows;

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        if (dataGridCell.columnName == "acoes") {
          final servidorData = dataGridCell.value;
          return Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return ServidorDetail(data: servidorData);
                        },
                      ));
                    },
                    icon: Icon(Icons.remove_red_eye),
                  ),
                  IconButton(
                    onPressed: () async {
                      final servidorId = servidorData['id'];
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Confirmar Exclusão'),
                            content: const Text(
                                'Tem certeza que deseja excluir este servidor?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Excluir'),
                              ),
                            ],
                          );
                        },
                      );
                      if (confirm == true) {
                        await this.onDelete(
                            servidorId); // Chame a função para deletar
                      }
                    },
                    icon: Icon(color: Colors.red, Icons.delete),
                  ),
                ],
              ));
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(dataGridCell.value.toString()),
        );
      }).toList(),
    );
  }
}

final InputDecoration _decoration = InputDecoration(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
  ),
  hintStyle: TextStyle(fontSize: 10),
  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
);
