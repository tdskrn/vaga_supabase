enum Secretaria {
  agricultura,
  assistencia_social,
  conselho_tutelar,
  creche,
  cultura,
  defesa_civil,
  educacao,
  esporte,
  governo,
  juridico,
  meio_ambiente,
  obras,
  saude,
  transporte
}

extension SecretariaExtension on Secretaria {
  String get name {
    switch (this) {
      case Secretaria.agricultura:
        return "AGRICULTURA";
      case Secretaria.assistencia_social:
        return "ASSISTENCIA SOCIAL";
      case Secretaria.conselho_tutelar:
        return "CONSELHO TUTELAR";
      case Secretaria.creche:
        return "CRECHE";
      case Secretaria.cultura:
        return "CULTURA";
      case Secretaria.defesa_civil:
        return "DEFESA CIVIL";
      case Secretaria.educacao:
        return "EDUCAÇÃO";
      case Secretaria.esporte:
        return "ESPORTE";
      case Secretaria.governo:
        return "GOVERNO";
      case Secretaria.juridico:
        return "JURÍDICO";
      case Secretaria.meio_ambiente:
        return "MEIO AMBIENTE";
      case Secretaria.obras:
        return "OBRAS";
      case Secretaria.saude:
        return "SAÚDE";
      case Secretaria.transporte:
        return "TRANSPORTE";
    }
  }
}
