class Validadors {
  static String? genericValidator(String? text) {
    if (text == null || text.isEmpty) {
      return "Este campo deve ser preenchido";
    }
    return null;
  }

  static String? emailValidator(String? text) {
    if (text == null || text.isEmpty) {
      return "Você deve preencher seu email";
    }
    if (!text.contains("@")) {
      return "Preencha com um email válido";
    }
    return null;
  }

  static String? passwordValidator(String? text) {
    if (text == null || text.isEmpty) {
      return "Você deve preencher sua senha";
    }
    if (text.length < 6) {
      return "Sua senha deve ter pelo menos 6 dígitos";
    }
    return null;
  }

  static String? confirmPasswordValidator(String? text, String? password) {
    if (text == null || text.isEmpty) {
      return "Você deve preencher sua senha";
    }
    if (text != password) {
      return "As senhas não coincidem";
    }
    return null;
  }
}
