import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:universal_html/html.dart';

import 'package:vaga_supabase/app/core/config/enumSecretaria.dart';
import 'package:vaga_supabase/app/core/config/enumSituacaoAtual.dart';
import 'package:vaga_supabase/app/core/config/enumVinculos.dart';

class ChartServidoresPage extends StatefulWidget {
  const ChartServidoresPage({super.key});

  @override
  State<ChartServidoresPage> createState() => _ChartServidoresPageState();
}

class _ChartServidoresPageState extends State<ChartServidoresPage> {
  Secretaria? _selectedSecretaria;
  Vinculo? _selectedVinculo;
  SituacaoAtual? _selectedSituacao;
  final SupabaseClient supabase = Supabase.instance.client;
  late final Stream<List<Map<String, dynamic>>> stream;
  late ServidorDataSource dataSource;
  final GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();

  @override
  void initState() {
    super.initState();
    stream = supabase
        .from('vagas')
        .stream(primaryKey: ['id'])
        .order('nome_servidor', ascending: true)
        .map((data) => data.cast<Map<String, dynamic>>());
  }

  void _resetFilters() {
    setState(() {
      _selectedSecretaria = null;
      _selectedVinculo = null;
      _selectedSituacao = null;
    });
  }

  double calcular(List<Map<String, dynamic>> servidores, String field) {
    return servidores.fold(0, (total, servidor) {
      if (servidor[field] != null) {
        total += servidor[field];
      }
      return total; // Soma o salário bruto de cada servidor
    });
  }

  TextStyle _estiloTextos = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  String formatCurrency(double value) {
    final currencyFormat = NumberFormat.simpleCurrency(locale: 'pt_BR');
    return currencyFormat.format(value); // Formata o número para R$ 1.000,00
  }

  Stream<List<Map<String, dynamic>>> getFilteredStream() {
    return stream.map((data) {
      return data.where((servidor) {
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

        return matchesSecretaria && matchesVinculo && matchesSituacao;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getFilteredStream(),
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
        }
        final dadosFiltrados = snapshot.data;
        dataSource = ServidorDataSource(dadosFiltrados!);

        double total_bruto = calcular(dadosFiltrados, 'total_bruto');
        double total_descontos = calcular(dadosFiltrados, 'total_descontos');
        double total_liquido = calcular(dadosFiltrados, 'total_liquido');
        List nomesServidores = dadosFiltrados
            .map((servidor) => servidor['nome_servidor'])
            .toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<Secretaria>(
                      decoration: _decoration,
                      hint: const Text('Seleciona a Secretaria'),
                      value: _selectedSecretaria,
                      items: Secretaria.values.map((secretaria) {
                        return DropdownMenuItem(
                            value: secretaria, child: Text(secretaria.name));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSecretaria = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<Vinculo>(
                      decoration: _decoration,
                      value: _selectedVinculo,
                      onChanged: (value) =>
                          setState(() => _selectedVinculo = value),
                      hint: const Text('Selecione o Vínculo'),
                      items: Vinculo.values.map((vinculo) {
                        return DropdownMenuItem(
                          value: vinculo,
                          child: Text(vinculo.name),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<SituacaoAtual>(
                      decoration: _decoration,
                      value: _selectedSituacao,
                      onChanged: (value) =>
                          setState(() => _selectedSituacao = value),
                      hint: const Text('Selecione a Situação'),
                      items: SituacaoAtual.values.map((situacao) {
                        return DropdownMenuItem(
                          value: situacao,
                          child: Text(situacao.name),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: _resetFilters,
                child: const Text('Resetar Filtros'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildSummaryCard(
                  title: 'Total Bruto',
                  value: formatCurrency(total_bruto),
                  color: Colors.green,
                ),
                buildSummaryCard(
                  title: 'Descontos',
                  value: formatCurrency(total_descontos),
                  color: Colors.red,
                ),
                buildSummaryCard(
                  title: 'Total Líquido',
                  value: formatCurrency(total_liquido),
                  color: Colors.blue,
                ),
                buildSummaryCard(
                  title: 'Total de Servidores',
                  value: nomesServidores.length.toString(),
                  color: Colors.orange,
                ),
              ],
            ),
            Divider(),
            ElevatedButton(
              onPressed: () async {
                String currentDate =
                    'DATA: ' + DateFormat('dd-MM-yyyy').format(DateTime.now());

                PdfDocument document = key.currentState!.exportToPdfDocument(
                    canRepeatHeaders: false,
                    fitAllColumnsInOnePage: true,
                    cellExport: (details) {
                      if (details.cellType == DataGridExportCellType.row &&
                          details.columnName == "servidor_2025") {
                        if (details.cellValue == "" &&
                            details.cellValue == null &&
                            details.cellValue == "sem nome" &&
                            details.cellValue == "SEM NOME") {
                          details.pdfCell.value = " ";
                        }
                      }
                    });
                List<int> bytes = await document.save();
                AnchorElement(
                    href:
                        "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
                  ..setAttribute("download", "relatório_${currentDate}.pdf")
                  ..click();
              },
              child: Text('Exporte em Pdf'),
            ),
            Expanded(
              flex: 1,
              child: SfDataGridTheme(
                data: SfDataGridThemeData(
                  sortIconColor: Colors.white,
                  headerColor: Color.fromARGB(255, 3, 9, 97),
                ),
                child: SfDataGrid(
                  key: key,
                  allowSorting: true,
                  allowMultiColumnSorting: true,
                  source: dataSource,
                  columns: <GridColumn>[
                    GridColumn(
                      columnWidthMode: ColumnWidthMode.fill,
                      columnName: 'nome',
                      label: Center(
                          child: Text(
                        'Nome',
                        style: _estiloTextos,
                      )),
                    ),
                    GridColumn(
                      columnWidthMode: ColumnWidthMode.fill,
                      columnName: 'servidor_2025',
                      label: Center(
                          child: Text(
                        'Servidor 2025',
                        style: _estiloTextos,
                      )),
                    ),
                    GridColumn(
                      columnWidthMode: ColumnWidthMode.fitByCellValue,
                      columnName: 'secretaria',
                      label: Center(
                          child: Text(
                        'Secretaria',
                        style: _estiloTextos,
                      )),
                    ),
                    GridColumn(
                      columnWidthMode: ColumnWidthMode.fitByCellValue,
                      columnName: 'vinculo',
                      label: Center(
                          child: Text(
                        'Vínculo',
                        style: _estiloTextos,
                      )),
                    ),
                    GridColumn(
                      columnWidthMode: ColumnWidthMode.fitByCellValue,
                      columnName: 'total_liquido',
                      label: Center(
                          child: Text(
                        'Total Líquido',
                        style: _estiloTextos,
                      )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

Widget buildSummaryCard({
  required String title,
  required String value,
  required Color color,
}) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    color: color,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}

final InputDecoration _decoration = InputDecoration(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
  ),
  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
);

class ServidorDataSource extends DataGridSource {
  String formatCurrency(double value) {
    final currencyFormat = NumberFormat.simpleCurrency(locale: 'pt_BR');
    return currencyFormat.format(value); // Formata o número para R$ 1.000,00
  }

  ServidorDataSource(List<Map<String, dynamic>> servidores) {
    _rows = servidores.map<DataGridRow>((servidor) {
      return DataGridRow(cells: [
        DataGridCell(columnName: 'nome', value: servidor['nome_servidor']),
        DataGridCell(
            columnName: "servidor_2025",
            value: servidor['servidor_2025'] ?? "SEM NOME"),
        DataGridCell(columnName: 'secretaria', value: servidor['secretaria']),
        DataGridCell(columnName: 'vinculo', value: servidor['vinculo']),
        DataGridCell(
            columnName: 'total_liquido',
            value: formatCurrency(servidor['total_liquido'] ?? 0.00)),
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
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(dataGridCell.value.toString()),
        );
      }).toList(),
    );
  }
}
