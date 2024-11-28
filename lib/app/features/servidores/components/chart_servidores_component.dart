import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraficoDinamico extends StatefulWidget {
  final Map<String, dynamic> data;

  const GraficoDinamico({super.key, required this.data});

  @override
  _GraficoDinamicoState createState() => _GraficoDinamicoState();
}

class _GraficoDinamicoState extends State<GraficoDinamico> {
  String _graficoSelecionado = "bar"; // Pode ser "bar" ou "pie"

  // Método para atualizar o gráfico selecionado
  void _atualizarGrafico(String tipo) {
    setState(() {
      _graficoSelecionado = tipo;
    });
  }

  // Método que retorna um gráfico de barras
  Widget _graficoBarra() {
    // Exemplo de dados de barra
    List<BarChartGroupData> data = [
      BarChartGroupData(x: 0, barRods: [
        BarChartRodData(
            y: widget.data['salario_base'] ?? 0, colors: [Colors.blue]),
      ]),
      BarChartGroupData(x: 1, barRods: [
        BarChartRodData(
            y: widget.data['valor_gratificacao'] ?? 0, colors: [Colors.blue]),
      ]),
      BarChartGroupData(x: 2, barRods: [
        BarChartRodData(
            y: widget.data['valor_quinquenios'] ?? 0, colors: [Colors.blue]),
      ]),
    ];

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barGroups: data,
        titlesData: FlTitlesData(show: true),
        borderData: FlBorderData(show: true),
        gridData: FlGridData(show: true),
        axisTitleData: FlAxisTitleData(show: true),
      ),
    );
  }

  // Método que retorna um gráfico de pizza
  Widget _graficoPizza() {
    // Exemplo de dados de pizza
    List<PieChartSectionData> data = [
      PieChartSectionData(
        value: widget.data['salario_base'] ?? 0,
        color: Colors.blue,
        title: "Salário Base",
      ),
      PieChartSectionData(
        value: widget.data['valor_gratificacao'] ?? 0,
        color: Colors.green,
        title: "Gratificação",
      ),
      PieChartSectionData(
        value: widget.data['valor_quinquenios'] ?? 0,
        color: Colors.orange,
        title: "Quinquênios",
      ),
    ];

    return PieChart(
      PieChartData(sections: data),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gráficos Dinâmicos'),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          // Filtros para selecionar o tipo de gráfico
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _atualizarGrafico("bar"),
                child: Text("Gráfico de Barras"),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () => _atualizarGrafico("pie"),
                child: Text("Gráfico de Pizza"),
              ),
            ],
          ),

          // Exibição do gráfico com base na seleção
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _graficoSelecionado == "bar"
                  ? _graficoBarra()
                  : _graficoPizza(),
            ),
          ),
        ],
      ),
    );
  }
}
