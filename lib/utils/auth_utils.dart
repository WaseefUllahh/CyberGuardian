
// ─── Validators ─────────────────────────────────────────────────────────────

String? requiredValidator(String? value, String field) =>
    (value == null || value.isEmpty) ? 'Enter your $field' : null;

String? emailValidator(String? value) {
  if (requiredValidator(value, 'email') != null) return requiredValidator(value, 'email');
  if (!value!.contains('@')) return 'Enter a valid email';
  return null;
}

String? passwordValidator(String? value) {
  if (requiredValidator(value, 'password') != null) return requiredValidator(value, 'password');
  if (value!.length < 6) return 'Minimum 6 characters';
  return null;
}
