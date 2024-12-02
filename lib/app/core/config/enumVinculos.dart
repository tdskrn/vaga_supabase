enum Vinculo {
  agentes_politico_prefeito,
  agentes_politico_secretarios,
  agentes_politicos_vice,
  comissionado,
  comissionado_efetivo,
  conselheiro_tutelar,
  contratado,
  efetivo,
}

extension VinculoExtension on Vinculo {
  String get name {
    switch (this) {
      case Vinculo.agentes_politico_prefeito:
        return "AGENTES POLÍTICOS PREFEITO";
      case Vinculo.agentes_politico_secretarios:
        return "AGENTES POLÍTICOS SECRETÁRIOS";
      case Vinculo.agentes_politicos_vice:
        return "AGENTES POLÍTICOS VICE PREFEITO";
      case Vinculo.comissionado:
        return "COMISSIONADO";
      case Vinculo.comissionado_efetivo:
        return "COMISSIONADO EFETIVO";
      case Vinculo.conselheiro_tutelar:
        return "CONSELHEIRO TUTELAR";
      case Vinculo.contratado:
        return "CONTRATADO";
      case Vinculo.efetivo:
        return "EFETIVO";
    }
  }

  static Vinculo? fromString(String? value) {
    switch (value?.toUpperCase()) {
      case "AGENTES POLÍTICOS PREFEITO":
        return Vinculo.agentes_politico_prefeito;
      case "AGENTES POLÍTICOS SECRETÁRIOS":
        return Vinculo.agentes_politico_secretarios;
      case "AGENTES POLÍTICOS VICE PREFEITO":
        return Vinculo.agentes_politicos_vice;
      case "COMISSIONADO":
        return Vinculo.comissionado;
      case "COMISSIONADO EFETIVO":
        return Vinculo.comissionado_efetivo;
      case "CONSELHEIRO TUTELAR":
        return Vinculo.conselheiro_tutelar;
      case "CONTRATADO":
        return Vinculo.contratado;
      case "EFETIVO":
        return Vinculo.efetivo;
      default:
        return null;
    }
  }
}
