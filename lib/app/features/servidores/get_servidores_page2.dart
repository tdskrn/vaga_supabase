import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:vaga_supabase/app/core/config/enumSecretaria.dart';
import 'package:vaga_supabase/app/core/config/enumSituacaoAtual.dart';
import 'package:vaga_supabase/app/core/config/enumVinculos.dart';
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
            child: ElevatedButton(
              onPressed: _resetFilters,
              child: const Text('Resetar Filtros'),
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
                dataSource = ServidorDataSource(servidores, context);

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
                          columnName: 'servidor_2025',
                          label: Center(
                            child: Text(
                              'Servidor 2025',
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
  String formatCurrency(double value) {
    final currencyFormat = NumberFormat.simpleCurrency(locale: 'pt_BR');
    return currencyFormat.format(value); // Formata o número para R$ 1.000,00
  }

  ServidorDataSource(List<Map<String, dynamic>> servidores, this.context) {
    _rows = servidores.map<DataGridRow>((servidor) {
      return DataGridRow(cells: [
        DataGridCell(columnName: 'nome', value: servidor['nome_servidor']),
        DataGridCell(
            columnName: "servidor_2025",
            value: servidor['servidor_2025'] ?? ""),
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
              child: IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return ServidorDetail(data: servidorData);
                    },
                  ));
                },
                icon: Icon(Icons.remove_red_eye),
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
