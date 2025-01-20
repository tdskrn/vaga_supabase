class Servidor {
  String nome;

  String secretaria;
  String lotacao;
  String cargo;
  String vinculo;
  String situacaoAtual;

  // Benefícios
  double salarioBase;
  double gratificacao;
  String porcentagemGratificacao;
  double quantHorasExtras;
  double valorHoras;
  double totalHoras;
  int quantQuinquenios;
  double valorQuinquenios;
  double adicionalNoturno;
  double insalPericulosidade;
  double complEnfermagem;
  double salarioFamilia;

  // Descontos e totais
  double inss;
  double impostoRenda;
  double sindServPublicos;
  double totalBruto;
  double totalDescontos;
  double totalLiquido;

  Servidor({
    required this.nome,
    required this.secretaria,
    required this.lotacao,
    required this.cargo,
    required this.vinculo,
    required this.situacaoAtual,
    this.salarioBase = 0.0,
    this.gratificacao = 0.0,
    this.porcentagemGratificacao = "0.0",
    this.quantHorasExtras = 0.0,
    this.valorHoras = 0.0,
    this.totalHoras = 0.0,
    this.quantQuinquenios = 0,
    this.valorQuinquenios = 0.0,
    this.adicionalNoturno = 0.0,
    this.insalPericulosidade = 0.0,
    this.complEnfermagem = 0.0,
    this.salarioFamilia = 0.0,
    this.inss = 0.0,
    this.impostoRenda = 0.0,
    this.sindServPublicos = 0.0,
    this.totalBruto = 0.0,
    this.totalDescontos = 0.0,
    this.totalLiquido = 0.0,
  });

  factory Servidor.fromJson(Map<String, dynamic> json) {
    return Servidor(
      nome: json['nome_servidor'] ?? '',
      secretaria: json['secretaria'] ?? '',
      lotacao: json['lotacao'] ?? '',
      cargo: json['cargo'] ?? '',
      vinculo: json['vinculo'] ?? '',
      situacaoAtual: json['situacao_atual'] ?? '',
      salarioBase: (json['salario_base'] ?? 0).toDouble(),
      gratificacao: (json['valor_gratificacao'] ?? 0).toDouble(),
      porcentagemGratificacao: (json['porcentagem_gratificacao'] ?? ""),
      quantHorasExtras: (json['quant_hora_extra'] ?? 0).toDouble(),
      valorHoras: (json['valor_hora_extra'] ?? 0).toDouble(),
      totalHoras: (json['total_horas'] ?? 0).toDouble(),
      quantQuinquenios: (json['quant_quinquenios'] ?? 0).toInt(),
      valorQuinquenios: (json['valor_quinquenios'] ?? 0).toDouble(),
      adicionalNoturno: (json['adic_noturno'] ?? 0).toDouble(),
      insalPericulosidade: (json['insal_periculosidade'] ?? 0).toDouble(),
      complEnfermagem: (json['compl_enfermagem'] ?? 0).toDouble(),
      salarioFamilia: (json['salario_familia'] ?? 0).toDouble(),
      inss: (json['inss'] ?? 0).toDouble(),
      impostoRenda: (json['imposto_renda'] ?? 0).toDouble(),
      sindServPublicos: (json['sind_serv_publicos'] ?? 0).toDouble(),
      totalBruto: (json['total_bruto'] ?? 0).toDouble(),
      totalDescontos: (json['total_descontos'] ?? 0).toDouble(),
      totalLiquido: (json['total_liquido'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome_servidor': nome,
      'secretaria': secretaria,
      'lotacao': lotacao,
      'cargo': cargo,
      'vinculo': vinculo,
      'situacao_atual': situacaoAtual,
      'salario_base': salarioBase,
      'valor_gratificacao': gratificacao,
      'porcentagem_gratificacao': porcentagemGratificacao,
      'quant_hora_extra': quantHorasExtras,
      'valor_hora_extra': valorHoras,
      'total_horas': totalHoras,
      'quant_quinquenios': quantQuinquenios,
      'valor_quinquenios': valorQuinquenios,
      'adic_noturno': adicionalNoturno,
      'insal_periculosidade': insalPericulosidade,
      'compl_enfermagem': complEnfermagem,
      'salario_familia': salarioFamilia,
      'inss': inss,
      'imposto_renda': impostoRenda,
      'sind_serv_publicos': sindServPublicos,
      'total_bruto': totalBruto,
      'total_descontos': totalDescontos,
      'total_liquido': totalLiquido,
    };
  }
}
