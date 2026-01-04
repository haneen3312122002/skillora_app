class AuthValidators {
  static String? validateEmail(String email) {
    final v = email.trim();
    if (v.isEmpty) return 'field_required';
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(v)) return 'invalid_input';
    return null;
  }

  static String? validatePassword(String password) {
    final v = password.trim();
    if (v.isEmpty) return 'field_required';
    if (v.length < 6) return 'invalid_input';
    return null;
  }
}
