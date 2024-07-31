class TValidator {
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "Email is Required.";
    }
    // use the email validation regex
    if (!RegExp('').hasMatch(email)) {
      return "Invalid email address.";
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Password is Required.";
    }
    // check password length
    if (password.length < 6) {
      return "Password must be at least 6 characters long.";
    }

    // check password uppercase letters
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return "Password must contain at least one uppercase letter.";
    }

    // check password special characters
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}+|/<>]'))) {
      return "Password must contain at least one special characters.";
    }
    return null;
  }

  static String? validatePhoneNumber(String? number) {
    if (number == null || number.isEmpty) {
      return "Password is Required.";
    }
    // check phone number length and its contains only digits.
    if (!RegExp(r'^\d{10}$').hasMatch(number)) {
      return "Invalid Phone number format(10 digits required).";
    }
    return null;
  }
}