import 'package:flutter/material.dart';

// ─── Constants ──────────────────────────────────────────────────────────────

const Color green = Color(0xFF2E7D32);
const Color grey = Color(0xFF757575);
const Color dark = Color(0xFF333333);

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
