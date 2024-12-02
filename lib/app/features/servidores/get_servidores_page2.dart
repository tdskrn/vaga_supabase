import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vaga_supabase/app/core/config/enumSecretaria.dart';
import 'package:vaga_supabase/app/core/config/enumSituacaoAtual.dart';
import 'package:vaga_supabase/app/core/config/enumVinculos.dart';
import 'package:vaga_supabase/app/features/servidores/components/row_component.dart';
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
