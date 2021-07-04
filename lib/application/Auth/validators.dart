bool validateEmailAddress(String input) {
  // Maybe not the most robust way of email validation but it's good enough
  const emailRegex = r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";
  if (RegExp(emailRegex).hasMatch(input)) {
    return true;
  } else {
    return false;
  }
}

class EmailFieldValidator {
  static String validate(String val) {
    return val.isEmpty || !validateEmailAddress(val) ? "Provide a valid email" : null;
  }
}

class PasswordFieldValidator {
  static String validate(String val) {
    return val.isEmpty || val.length < 3 ? "Provide a valid password" : null;
  }
}

class ValidateMatchResult {
  static List<String> validResultPlayer1Wins = ['60', '61', '62', '63', '64', '75', '76'];
  static List<String> validResultPlayer2Wins = ['06', '16', '26', '36', '46', '57', '67'];

  static bool validateWinUser1(String val) {
    return validResultPlayer1Wins.contains(val);
  }

  static bool validateWinUser2(String val) {
    return validResultPlayer2Wins.contains(val);
  }
}
