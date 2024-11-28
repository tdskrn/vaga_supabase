import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChartServidoresPage extends StatefulWidget {
  const ChartServidoresPage({super.key});

  @override
  State<ChartServidoresPage> createState() => _ChartServidoresPageState();
}

class _ChartServidoresPageState extends State<ChartServidoresPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List quant = [];
  double total = 0;

  Future<List<Map<String, dynamic>>> _readData() async {
    var query = supabase.from('vagas').select('*');
    final response = await query;

    try {
      if (response != null && response is List) {
        return response.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      print('Erro ao buscar dados: $e');
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text('Aguardando Resultados...'),
          TextButton(
              onPressed: () async {
                quant = await _readData();
                for (var row in quant) {
                  if (row['total_bruto'] != null) {
                    total += row['total_bruto'];
                  }
                }
                setState(() {});
              },
              child: Text('Aguarde')),
          Text(quant.length > 0
              ? "Existem ${quant.length} registros e o valor total é ${total.toStringAsFixed(2)}"
              : "Nenhum Registro")
        ],
      ),
    );
  }
}
