class Servidor {
  String nome;
  String servidor2025;
  String secretaria;
  String lotacao;
  String cargo;
  String vinculo;
  String situacaoAtual;
  double salarioBase;
  double gratificacao;
  double porcentagemGratificacao;
  int quantHorasExtras;
  double valorHoras;
  double totalHoras;
  int quantQuinquenios;
  double valorQuinquenios;
  double adicionalNoturno;
  double insalPericulosidade;
  double complEnfermagem;
  double salarioFamilia;
  double inss;
  double impostoRenda;
  double sindServPublicos;
  double totalBruto;
  double totalDescontos;
  double totalLiquido;

  Servidor({
    required this.nome,
    required this.servidor2025,
    required this.secretaria,
    required this.lotacao,
    required this.cargo,
    required this.vinculo,
    required this.situacaoAtual,
    required this.salarioBase,
    required this.gratificacao,
    required this.porcentagemGratificacao,
    required this.quantHorasExtras,
    required this.valorHoras,
    required this.totalHoras,
    required this.quantQuinquenios,
    required this.valorQuinquenios,
    required this.adicionalNoturno,
    required this.insalPericulosidade,
    required this.complEnfermagem,
    required this.salarioFamilia,
    required this.inss,
    required this.impostoRenda,
    required this.sindServPublicos,
    required this.totalBruto,
    required this.totalDescontos,
    required this.totalLiquido,
  });
}
