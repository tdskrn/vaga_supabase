import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vaga_supabase/app/core/config/enumSecretaria.dart';
import 'package:vaga_supabase/app/core/config/enumSituacaoAtual.dart';
import 'package:vaga_supabase/app/core/config/enumVinculos.dart';
import 'package:vaga_supabase/app/features/servidores/components/row_component.dart';
import 'package:vaga_supabase/app/features/servidores/components/servidor_detail.dart';

class GetServidoresPage extends StatefulWidget {
  const GetServidoresPage({super.key});

  @override
  State<GetServidoresPage> createState() => _GetServidoresPageState();
}

class _GetServidoresPageState extends State<GetServidoresPage> {
  final TextEditingController _searchController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;

  String _searchValue = '';
  Secretaria? _selectedSecretaria;
  Vinculo? _selectedVinculo;
  SituacaoAtual? _selectedSituacao;

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

  Future<List<Map<String, dynamic>>> _fetchServidores() async {
    var query = supabase.from('vagas').select('*');

    if (_searchValue.isNotEmpty) {
      query = query.ilike('nome_servidor', '%$_searchValue%');
    }

    if (_selectedSecretaria != null) {
      query = query.eq('secretaria', _selectedSecretaria!.name);
    }

    if (_selectedVinculo != null) {
      query = query.eq('vinculo', _selectedVinculo!.name);
    }

    if (_selectedSituacao != null) {
      query = query.ilike('situacao_atual', '%${_selectedSituacao!.name}%');
    }

    try {
      final response = await query;
      // ignore: unnecessary_null_comparison, unnecessary_type_check
      if (response != null && response is List) {
        return response.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      print('Erro ao buscar dados: $e');
    }
    return [];
  }

  @override
  void dispose() {
    _searchController.dispose();
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<Secretaria>(
                    value: _selectedSecretaria,
                    onChanged: (value) =>
                        setState(() => _selectedSecretaria = value),
                    hint: const Text('Selecione a Secretaria'),
                    items: Secretaria.values.map((secretaria) {
                      return DropdownMenuItem(
                        value: secretaria,
                        child: Text(secretaria.name),
                      );
                    }).toList(),
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
                ),
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
              RowComponent('NOME SERVIDOR', 3, Colors.blue,
                  textColor: Colors.white),
              RowComponent('SERVIDOR 2025', 3, Colors.blue,
                  textColor: Colors.white),
              RowComponent('CARGO', 3, Colors.blue, textColor: Colors.white),
              RowComponent('SECRETARIA', 3, Colors.blue,
                  textColor: Colors.white),
              RowComponent('VINCULO', 3, Colors.blue, textColor: Colors.white),
              RowComponent('AÇÕES', 1, Colors.blue, textColor: Colors.white),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchServidores(),
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
                return ListView.builder(
                  itemCount: servidores.length,
                  itemBuilder: (context, index) {
                    final servidor = servidores[index];
                    return Row(
                      children: [
                        RowComponent(servidor['nome_servidor'] ?? 'Sem Nome', 3,
                            Colors.white),
                        RowComponent(servidor['servidor_2025'] ?? 'Sem Nome', 3,
                            Colors.white),
                        RowComponent(
                            servidor['cargo'] ?? 'Sem Nome', 3, Colors.white),
                        RowComponent(servidor['secretaria'] ?? 'Sem Nome', 3,
                            Colors.white),
                        RowComponent(
                            servidor['vinculo'] ?? 'Sem Nome', 3, Colors.white),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ServidorDetail(
                                    data: servidor,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.remove_red_eye),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
