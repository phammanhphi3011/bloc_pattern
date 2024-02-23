class Validation {
  static bool emailValid(String? email) {
    return RegExp(
            r'^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(?!gmail|yahoo|hotmail)(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$')
        .hasMatch(email!);
  }

  static bool hasEmailPersonal(String? email) {
    return RegExp(r'^/(?!gmail)([a-z0-9]+)$').hasMatch(email!);
  }

  static bool validateStructure(String value) {
    var pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    var regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }


  static bool? upperAndLowerCase(String value) {
    var regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z]).{2,}$');
    if (!regex.hasMatch(value)) {
      return false;
    } else {
      return true;
    }
  }

  static bool? lengthCharacter(String value) {
    var regex = RegExp(r'^.{8,}$');
    if (!regex.hasMatch(value)) {
      return false;
    } else {
      return true;
    }
  }

  static bool? optionalSpecialCharacter(String value) {
    var regex = RegExp(r'(?=.*?[!@#\$&*~]).{1,}$');
    if (!regex.hasMatch(value)) {
      return false;
    } else {
      return true;
    }
  }

  static bool? oneOrMoreDigit(String value) {
    var regex = RegExp(r'^(?=.*?[0-9]).{1,}$');
    if (!regex.hasMatch(value)) {
      return false;
    } else {
      return true;
    }
  }

}
