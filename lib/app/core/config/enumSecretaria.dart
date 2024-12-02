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
  transporte,
}

extension SecretariaExtension on Secretaria {
  String get name {
    switch (this) {
      case Secretaria.agricultura:
        return "AGRICULTURA";
      case Secretaria.assistencia_social:
        return "ASSISTÊNCIA SOCIAL";
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

  static Secretaria? fromString(String? value) {
    switch (value?.toUpperCase()) {
      case "AGRICULTURA":
        return Secretaria.agricultura;
      case "ASSISTÊNCIA SOCIAL":
        return Secretaria.assistencia_social;
      case "CONSELHO TUTELAR":
        return Secretaria.conselho_tutelar;
      case "CRECHE":
        return Secretaria.creche;
      case "CULTURA":
        return Secretaria.cultura;
      case "DEFESA CIVIL":
        return Secretaria.defesa_civil;
      case "EDUCAÇÃO":
        return Secretaria.educacao;
      case "ESPORTE":
        return Secretaria.esporte;
      case "GOVERNO":
        return Secretaria.governo;
      case "JURÍDICO":
        return Secretaria.juridico;
      case "MEIO AMBIENTE":
        return Secretaria.meio_ambiente;
      case "OBRAS":
        return Secretaria.obras;
      case "SAÚDE":
        return Secretaria.saude;
      case "TRANSPORTE":
        return Secretaria.transporte;
      default:
        return null;
    }
  }
}
