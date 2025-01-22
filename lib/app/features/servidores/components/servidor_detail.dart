import 'package:flutter/material.dart';
import 'package:vaga_supabase/app/core/config/enumSecretaria.dart';
import 'package:vaga_supabase/app/core/config/enumSituacaoAtual.dart';
import 'package:vaga_supabase/app/core/config/enumVinculos.dart';
import 'package:vaga_supabase/app/core/config/utils.dart';
import 'package:vaga_supabase/app/core/router/app_router.dart';
import 'package:vaga_supabase/app/core/router/theme/icon_theme.dart';
import 'package:vaga_supabase/app/features/servidores/components/servidor_detail_panel.dart';
import 'package:vaga_supabase/app/features/servidores/components/servidores/custom_dropdowns.dart';
import 'package:vaga_supabase/app/features/servidores/components/servidores/custom_text_fields.dart';
import 'package:vaga_supabase/app/features/servidores/components/servidores/deduction_fields.dart';
import 'package:vaga_supabase/app/features/servidores/components/servidores/dialog_action.dart';
import 'package:vaga_supabase/app/features/servidores/components/servidores/financial_fields.dart';
import 'package:vaga_supabase/app/features/servidores/components/servidores/utils/update_data_builder.dart';

class ServidorDetail extends StatefulWidget {
  final Map<String, dynamic> data;

  const ServidorDetail({super.key, required this.data});

  @override
  State<ServidorDetail> createState() => _ServidorDetailState();
}

class _ServidorDetailState extends State<ServidorDetail> {
  Map<String, dynamic> dadosServidor = {};
  late final Stream<Map<String, dynamic>> _dadosStream;
  TextEditingController nomeController = TextEditingController();

  TextEditingController secretariaController = TextEditingController();
  TextEditingController lotacaoController = TextEditingController();
  TextEditingController cargoController = TextEditingController();
  TextEditingController vinculoController = TextEditingController();
  TextEditingController situacaoAtualController = TextEditingController();
  // referentes a benefícios
  TextEditingController salarioBaseController = TextEditingController();
  TextEditingController gratificacaoController = TextEditingController();
  TextEditingController porcentagemGratificacaoController =
      TextEditingController();
  TextEditingController quantHorasExtrasController = TextEditingController();
  TextEditingController valorHorasController = TextEditingController();
  TextEditingController totalHorasController = TextEditingController();
  TextEditingController quantQuinqueniosController = TextEditingController();
  TextEditingController valorQuinqueniosController = TextEditingController();
  TextEditingController adicionalNoturnoController = TextEditingController();
  TextEditingController insalPericulosidadeController = TextEditingController();
  TextEditingController complEnfermagemController = TextEditingController();
  TextEditingController salarioFamiliaController = TextEditingController();

  TextEditingController inssController = TextEditingController();
  TextEditingController impostoRendaController = TextEditingController();
  TextEditingController sindServPublicosController = TextEditingController();
  TextEditingController totalBrutoController = TextEditingController();
  TextEditingController totalDescontosController = TextEditingController();
  TextEditingController totalLiquidoController = TextEditingController();

  void initializeControllers(Map<String, dynamic> dadosServidor) {
    nomeController.text = dadosServidor['nome_servidor'] ?? '';
    secretariaController.text = dadosServidor['secretaria'] ?? '';
    lotacaoController.text = dadosServidor['lotacao'] ?? '';
    cargoController.text = dadosServidor['cargo'] ?? '';
    vinculoController.text = dadosServidor['vinculo'] ?? '';
    situacaoAtualController.text = dadosServidor['situacao_atual'] ?? '';
    salarioBaseController.text =
        (dadosServidor['salario_base'] ?? '').toString();
    gratificacaoController.text =
        (dadosServidor['valor_gratificacao'] ?? '').toString();
    porcentagemGratificacaoController.text =
        (dadosServidor['porcentagem_gratificacao'] ?? '').toString();
    quantHorasExtrasController.text =
        (dadosServidor['quant_hora_extra'] ?? '').toString();
    valorHorasController.text =
        (dadosServidor['valor_hora_extra'] ?? '').toString();
    totalHorasController.text = (dadosServidor['total_horas'] ?? '').toString();
    quantQuinqueniosController.text =
        (dadosServidor['quant_quinquenios'] ?? '').toString();
    valorQuinqueniosController.text =
        (dadosServidor['valor_quinquenios'] ?? '').toString();
    adicionalNoturnoController.text =
        (dadosServidor['adic_noturno'] ?? '').toString();
    insalPericulosidadeController.text =
        (dadosServidor['insal_periculosidade'] ?? '').toString();
    complEnfermagemController.text =
        (dadosServidor['compl_enfermagem'] ?? '').toString();
    salarioFamiliaController.text =
        (dadosServidor['salario_familia'] ?? '').toString();
    inssController.text = (dadosServidor['inss'] ?? '').toString();
    impostoRendaController.text =
        (dadosServidor['imposto_renda'] ?? '').toString();
    sindServPublicosController.text =
        (dadosServidor['sind_serv_publicos'] ?? '').toString();
    totalBrutoController.text = (dadosServidor['total_bruto'] ?? '').toString();
    totalDescontosController.text =
        (dadosServidor['total_descontos'] ?? '').toString();
    totalLiquidoController.text =
        (dadosServidor['total_liquido'] ?? '').toString();
  }

  @override
  void initState() {
    super.initState();
    _dadosStream = supabase
        .from('vagas')
        .stream(primaryKey: ['id'])
        .eq('id', widget.data['id'])
        .map((event) => event.isNotEmpty ? event.first : {});
    // Inicializando os controladores com os valores do dadosServidor
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

  Future<Map<String, dynamic>> fetchData() async {
    final dynamic id = widget.data['id'];

    // Execute a consulta no Supabase
    final response = await supabase
        .from('vagas')
        .select()
        .eq('id', id)
        .single(); // Use `.single()` se espera apenas um registro.

    // Verifique se houve erro
    if (response == null) {
      print('Erro: ${response}');
    }

    // Caso contrário, os dados estarão disponíveis aqui
    return response;
  }

  Future<void> _updateServidor(Map<String, dynamic> dataToUpdate) async {
    try {
      await supabase
          .from('vagas')
          .update(dataToUpdate)
          .eq('id', widget.data['id']);

      // Aguarda um curto período para garantir que o trigger tenha tempo de executar
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar: $e')),
        );
      }
    }
  }

  _editServidor() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Servidor'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildTextFormField(
                  controller: nomeController,
                  labelText: 'Nome do Servidor',
                  inputFormatters: [UpperCaseTextFormatter()],
                ),
                buildTextFormField(
                  controller: cargoController,
                  labelText: 'Cargo',
                  inputFormatters: [UpperCaseTextFormatter()],
                ),
                buildDropdown<Secretaria>(
                  value:
                      SecretariaExtension.fromString(secretariaController.text),
                  labelText: 'Secretária',
                  items: Secretaria.values,
                  onChanged: (value) {
                    secretariaController.text = value?.name ?? '';
                  },
                ),
                buildTextFormField(
                  controller: lotacaoController,
                  labelText: 'Lotação',
                ),
                buildDropdown<Vinculo>(
                  value: VinculoExtension.fromString(vinculoController.text),
                  labelText: 'Vínculo',
                  items: Vinculo.values,
                  onChanged: (value) {
                    vinculoController.text = value?.name ?? '';
                  },
                ),
                buildDropdown<SituacaoAtual>(
                  value: SituacaoAtualExtension.fromString(
                      situacaoAtualController.text),
                  labelText: 'Situação Atual',
                  items: SituacaoAtual.values,
                  onChanged: (value) {
                    situacaoAtualController.text = value?.name ?? '';
                  },
                ),
                Divider(),
                ...buildFinancialFields(
                  salarioBaseController: salarioBaseController,
                  gratificacaoController: gratificacaoController,
                  porcentagemGratificacaoController:
                      porcentagemGratificacaoController,
                  quantHorasExtrasController: quantHorasExtrasController,
                  valorHorasController: valorHorasController,
                  totalHorasController: totalHorasController,
                  quantQuinqueniosController: quantQuinqueniosController,
                  valorQuinqueniosController: valorQuinqueniosController,
                  adicionalNoturnoController: adicionalNoturnoController,
                  insalPericulosidadeController: insalPericulosidadeController,
                  complEnfermagemController: complEnfermagemController,
                  salarioFamiliaController: salarioFamiliaController,
                ),
                Divider(),
                ...buildDeductionsFields(
                  inssController: inssController,
                  impostoRendaController: impostoRendaController,
                  sindServPublicosController: sindServPublicosController,
                ),
                Divider(),
                buildTextFormField(
                  controller: totalBrutoController,
                  labelText: 'Total Bruto',
                ),
                buildTextFormField(
                  controller: totalDescontosController,
                  labelText: 'Total de Descontos',
                ),
                buildTextFormField(
                  controller: totalLiquidoController,
                  labelText: 'Total Líquido',
                ),
              ],
            ),
          ),
          actions: buildDialogActions(
            context: context,
            onSave: () async {
              final dataToUpdate = buildUpdateData(
                nomeController: nomeController,
                secretariaController: secretariaController,
                lotacaoController: lotacaoController,
                cargoController: cargoController,
                vinculoController: vinculoController,
                situacaoAtualController: situacaoAtualController,
                salarioBaseController: salarioBaseController,
                gratificacaoController: gratificacaoController,
                porcentagemGratificacaoController:
                    porcentagemGratificacaoController,
                quantHorasExtrasController: quantHorasExtrasController,
                valorHorasController: valorHorasController,
                totalHorasController: totalHorasController,
                quantQuinqueniosController: quantQuinqueniosController,
                valorQuinqueniosController: valorQuinqueniosController,
                adicionalNoturnoController: adicionalNoturnoController,
                insalPericulosidadeController: insalPericulosidadeController,
                complEnfermagemController: complEnfermagemController,
                salarioFamiliaController: salarioFamiliaController,
                inssController: inssController,
                impostoRendaController: impostoRendaController,
                sindServPublicosController: sindServPublicosController,
                totalBrutoController: totalBrutoController,
                totalDescontosController: totalDescontosController,
                totalLiquidoController: totalLiquidoController,
              );

              if (dataToUpdate.isNotEmpty) {
                Navigator.pop(context);
                await _updateServidor(dataToUpdate);
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dynamic id = widget.data['id'];
    final servidor = supabase.from('vagas').select().eq('id', id);
    print(servidor);

    return Scaffold(
        appBar: AppBar(
          iconTheme: iconTheme,
          title: Text(
            'Detalhes do Servidor',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.indigo,
          actions: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    _editServidor();
                  },
                  icon: Icon(Icons.edit),
                ),
              ],
            )
          ],
        ),
        body: StreamBuilder<Map<String, dynamic>>(
            stream: _dadosStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Erro ao carregar dados: ${snapshot.error}",
                    style: TextStyle(color: Colors.red),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text('Nenhum dado encontrado.'),
                );
              }
              final dadosServidor = snapshot.data;
              initializeControllers(dadosServidor!);

              Stream<Map<String, dynamic>> _streamData() {
                return supabase
                    .from('vagas')
                    .stream(primaryKey: [
                      'id'
                    ]) // Use a chave primária para identificar alterações
                    .eq('id', dadosServidor['id'])
                    .map((event) => event.isNotEmpty ? event.first : {});
              }

              return StreamBuilder(
                  stream: _streamData(),
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
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text('Nenhum dado encontrado'),
                      );
                    }

                    final dadosStreamServidor = snapshot.data;

                    return ServidorDetailPanel(dadosStreamServidor!);
                  });
            }));
  }
}
