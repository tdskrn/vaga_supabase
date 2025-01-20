import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CriarServidorPage extends StatefulWidget {
  const CriarServidorPage({Key? key}) : super(key: key);

  @override
  State<CriarServidorPage> createState() => _CriarServidorPageState();
}

class _CriarServidorPageState extends State<CriarServidorPage> {
  // Controladores para os campos do formulário
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController secretariaController = TextEditingController();
  final TextEditingController lotacaoController = TextEditingController();
  final TextEditingController cargoController = TextEditingController();
  final TextEditingController vinculoController = TextEditingController();
  final TextEditingController situacaoAtualController = TextEditingController();
  final TextEditingController salarioBaseController = TextEditingController();
  final TextEditingController gratificacaoController = TextEditingController();
  final TextEditingController porcentagemGratificacaoController =
      TextEditingController();

  Future<void> _criarServidor() async {
    try {
      // Construir o mapa de dados a ser inserido
      final Map<String, dynamic> dataToInsert = {
        'nome_servidor': nomeController.text,
        'secretaria': secretariaController.text,
        'lotacao': lotacaoController.text,
        'cargo': cargoController.text,
        'vinculo': vinculoController.text,
        'situacao_atual': situacaoAtualController.text,
        'salario_base': double.tryParse(salarioBaseController.text) ?? 0.0,
        'valor_gratificacao':
            double.tryParse(gratificacaoController.text) ?? 0.0,
        'porcentagem_gratificacao': porcentagemGratificacaoController.text,
      };

      // Inserir no Supabase (tabela: servidores)
      final response = await Supabase.instance.client
          .from('servidores')
          .insert(dataToInsert)
          .select();

      if (response != null) {
        // Mostrar mensagem de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao criar servidor: ${response}')),
        );
      } else {
        // Sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Servidor criado com sucesso!')),
        );

        // Limpar os campos após o sucesso
        nomeController.clear();
        secretariaController.clear();
        lotacaoController.clear();
        cargoController.clear();
        vinculoController.clear();
        situacaoAtualController.clear();
        salarioBaseController.clear();
        gratificacaoController.clear();
        porcentagemGratificacaoController.clear();

        // Navegar ou atualizar a interface, se necessário
        Navigator.pop(context);
      }
    } catch (e) {
      // Tratar exceções
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro inesperado: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Servidor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome do Servidor'),
            ),
            TextField(
              controller: secretariaController,
              decoration: const InputDecoration(labelText: 'Secretaria'),
            ),
            TextField(
              controller: lotacaoController,
              decoration: const InputDecoration(labelText: 'Lotação'),
            ),
            TextField(
              controller: cargoController,
              decoration: const InputDecoration(labelText: 'Cargo'),
            ),
            TextField(
              controller: vinculoController,
              decoration: const InputDecoration(labelText: 'Vínculo'),
            ),
            TextField(
              controller: situacaoAtualController,
              decoration: const InputDecoration(labelText: 'Situação Atual'),
            ),
            TextField(
              controller: salarioBaseController,
              decoration: const InputDecoration(labelText: 'Salário Base'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: gratificacaoController,
              decoration: const InputDecoration(labelText: 'Gratificação'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: porcentagemGratificacaoController,
              decoration: const InputDecoration(
                  labelText: 'Porcentagem da Gratificação'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _criarServidor,
              child: const Text('Criar Servidor'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Liberar os controladores ao finalizar o widget
    nomeController.dispose();
    secretariaController.dispose();
    lotacaoController.dispose();
    cargoController.dispose();
    vinculoController.dispose();
    situacaoAtualController.dispose();
    salarioBaseController.dispose();
    gratificacaoController.dispose();
    porcentagemGratificacaoController.dispose();
    super.dispose();
  }
}
