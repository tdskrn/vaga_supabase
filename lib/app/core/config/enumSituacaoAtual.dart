enum SituacaoAtual {
  ativo,
  desligado,
  afastado,
}

extension SituacaoAtualExtension on SituacaoAtual {
  String get name {
    switch (this) {
      case SituacaoAtual.ativo:
        return 'ATIVO';
      case SituacaoAtual.desligado:
        return 'DESLIGADO';
      case SituacaoAtual.afastado:
        return 'AFASTADO';
    }
  }

  static SituacaoAtual? fromString(String? value) {
    switch (value?.toUpperCase()) {
      case "ATIVO":
        return SituacaoAtual.ativo;
      case "DESLIGADO":
        return SituacaoAtual.desligado;
      case "AFASTADO":
        return SituacaoAtual.afastado;
      default:
        return null;
    }
  }
}
