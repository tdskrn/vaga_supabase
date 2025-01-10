import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VagasPage extends StatefulWidget {
  const VagasPage({super.key});

  @override
  State<VagasPage> createState() => _VagasPageState();
}

class _VagasPageState extends State<VagasPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  late final Stream<List<Map<String, dynamic>>> stream;

  @override
  void initState() {
    super.initState();
    stream = supabase
        .from('numero_vagas')
        .stream(primaryKey: ['id'])
        .order('cargo', ascending: true)
        .map((data) => data.cast<Map<String, dynamic>>());
  }

  Stream<List<Map<String, dynamic>>> fetchServidores(String cargo) {
    return supabase
        .from('vagas')
        .stream(primaryKey: ['id'])
        .eq('cargo', cargo)
        .map((data) => data.cast<Map<String, dynamic>>());
  }

  Future<void> _addOrEditVaga({Map<String, dynamic>? vaga}) async {
    final isEditing = vaga != null;
    final cargoController = TextEditingController(text: vaga?['cargo'] ?? '');
    final quantidadeController =
        TextEditingController(text: vaga?['quantidade']?.toString() ?? '');
    final observacoesController =
        TextEditingController(text: vaga?['observacoes'] ?? '');

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Editar Vaga' : 'Adicionar Vaga'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: cargoController,
                decoration: const InputDecoration(labelText: 'Cargo'),
              ),
              TextField(
                controller: quantidadeController,
                decoration: const InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: observacoesController,
                decoration: const InputDecoration(labelText: 'Observações'),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final cargo = cargoController.text.trim();
                final quantidade =
                    int.tryParse(quantidadeController.text.trim());
                final observacoes = observacoesController.text.trim();

                if (cargo.isEmpty || quantidade == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Preencha todos os campos corretamente.')),
                  );
                  return;
                }

                if (isEditing) {
                  await supabase.from('numero_vagas').update({
                    'cargo': cargo,
                    'quantidade': quantidade,
                    'observacoes': observacoes,
                  }).eq('id', vaga['id']);
                } else {
                  await supabase.from('numero_vagas').insert({
                    'cargo': cargo,
                    'quantidade': quantidade,
                    'observacoes': observacoes,
                  });
                }

                Navigator.pop(context);
              },
              child: const Text('Salvar'),
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
        title: const Text('Vagas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _addOrEditVaga(),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: stream,
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

          final vagas = snapshot.data!;

          return ListView.builder(
            itemCount: vagas.length,
            itemBuilder: (context, index) {
              final vaga = vagas[index];

              return Card(
                child: ExpansionTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(vaga['cargo'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          StreamBuilder(
                            stream: fetchServidores(vaga['cargo']),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return Text(
                                    'Preenchidas: 0 / ${vaga['quantidade']}',
                                    style: const TextStyle(fontSize: 12));
                              }

                              final servidores = snapshot.data!;
                              final servidoresFiltrados = servidores
                                  .where((servidor) =>
                                      servidor['servidor_2025'] != null)
                                  .toList();
                              final preenchidas = servidoresFiltrados.length;
                              final faltando = vaga['quantidade'] - preenchidas;
                              final porcentagem =
                                  (preenchidas / vaga['quantidade']) * 100;

                              // Definir cor condicional
                              final corTexto = porcentagem >= 90
                                  ? Colors.red
                                  : porcentagem >= 75
                                      ? Colors.orange
                                      : Colors.green;

                              return Text(
                                'Preenchidas: $preenchidas / ${vaga['quantidade']} (Faltando: $faltando)',
                                style: TextStyle(fontSize: 12, color: corTexto),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  children: [
                    ListTile(
                      title: const Text('Editar'),
                      leading: const Icon(Icons.edit),
                      onTap: () => _addOrEditVaga(vaga: vaga),
                    ),
                    if (vaga['observacoes'] != null &&
                        vaga['observacoes'].isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          'Obs: ${vaga['observacoes']}',
                          style: const TextStyle(
                              fontSize: 12, fontStyle: FontStyle.italic),
                        ),
                      ),
                    StreamBuilder(
                      stream: fetchServidores(vaga['cargo']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Erro: ${snapshot.error}'),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Nenhum servidor encontrado.'),
                          );
                        }

                        final servidores = snapshot.data!;
                        final servidoresFiltrados = servidores
                            .where(
                                (servidor) => servidor['servidor_2025'] != null)
                            .toList();

                        if (servidoresFiltrados.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Nenhuma vaga preenchida!'),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: servidoresFiltrados.length,
                          itemBuilder: (context, index) {
                            final servidor = servidoresFiltrados[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Servidor Antigo: ${servidor['nome_servidor']}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Servidor Novo: ${servidor['servidor_2025']}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue),
                                    ),
                                    const SizedBox(height: 10),
                                    Text('Cargo: ${servidor['cargo']}',
                                        style: const TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
