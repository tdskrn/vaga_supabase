import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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

        double total_bruto = calcular(dadosFiltrados!, 'total_bruto');
        double total_descontos = calcular(dadosFiltrados, 'total_descontos');
        double total_liquido = calcular(dadosFiltrados, 'total_liquido');
        List nomesServidores = dadosFiltrados
            .map((servidor) => servidor['nome_servidor'])
            .toList();
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<Secretaria>(
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
              children: [
                Container(
                  width: 250,
                  color: Colors.blueAccent,
                  child: Text(
                    formatCurrency(total_bruto),
                    textAlign: TextAlign.right,
                  ),
                ),
                Container(
                  width: 250,
                  color: Colors.blueAccent,
                  child: Text(
                    formatCurrency(total_descontos),
                    textAlign: TextAlign.right,
                  ),
                ),
                Container(
                  width: 250,
                  color: Colors.blueAccent,
                  child: Text(
                    formatCurrency(
                      total_liquido,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                Container(
                  width: 250,
                  color: Colors.blueAccent,
                  child: Text(
                    nomesServidores.length.toString(),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            Divider(),
            Expanded(
                child: ListView.builder(
              itemCount: nomesServidores.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(nomesServidores[index]),
                );
              },
            ))
          ],
        );
      },
    );
  }
}
