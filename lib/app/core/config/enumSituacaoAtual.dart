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
}
