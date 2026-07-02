import 'package:flutter/material.dart';
import '../utils/auth_utils.dart';

class SubmitReportScreen extends StatefulWidget {
  const SubmitReportScreen({super.key});

  @override
  State<SubmitReportScreen> createState() => _SubmitReportScreenState();
}

class _SubmitReportScreenState extends State<SubmitReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Checkbox state for categories
  final Map<String, bool> _categories = {
    'Phishing': false,
    'Scam / Fraud': false,
    'Malware': false,
    'Fake Website': false,
    'Suspicious SMS': false,
  };

  // Severity state
  String _severity = 'Medium';
  final List<String> _severityOptions = ['Low', 'Medium', 'High'];

  bool _loading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitReport() {
    if (!_formKey.currentState!.validate()) return;

    // Ensure at least one category is selected
    final selectedCategories = _categories.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    if (selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one threat category.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _loading = true);

    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() => _loading = false);

      // Construct report data
      final reportData = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'time': 'Just now',
        'status': 'Under Review',
        'severity': _severity,
        'categories': selectedCategories,
      };

      // Return data to the previous screen using Navigator.pop
      Navigator.pop(context, reportData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Submit Report',
            style: TextStyle(fontWeight: FontWeight.bold, color: dark)),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: dark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Report a Threat',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: dark)),
                const SizedBox(height: 4),
                const Text('Help us keep the community safe by reporting suspicious activity.',
                    style: TextStyle(fontSize: 14, color: grey)),
                const SizedBox(height: 24),

                // ── Threat Title ──
                const Text('Title',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: dark)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  validator: (v) => requiredValidator(v, 'title'),
                  decoration: InputDecoration(
                    hintText: 'e.g., Fake Bank Alert SMS',
                    hintStyle: const TextStyle(color: grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: green, width: 1.5),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // ── Threat Description ──
                const Text('Description',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: dark)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  validator: (v) => requiredValidator(v, 'description'),
                  decoration: InputDecoration(
                    hintText: 'Provide details about the threat...',
                    hintStyle: const TextStyle(color: grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: green, width: 1.5),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),

                // ── Checkboxes for Categories ──
                const Text('Threat Categories (Select all that apply)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: dark)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Column(
                    children: _categories.keys.map((String key) {
                      return CheckboxListTile(
                        title: Text(key, style: const TextStyle(fontSize: 14, color: dark)),
                        value: _categories[key],
                        activeColor: green,
                        checkColor: Colors.white,
                        controlAffinity: ListTileControlAffinity.leading,
                        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                        onChanged: (bool? value) {
                          setState(() {
                            _categories[key] = value ?? false;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),

                // ── Severity Dropdown ──
                const Text('Severity Level',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: dark)),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _severity,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: green, width: 1.5),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  items: _severityOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(color: dark)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _severity = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(height: 32),

                // ── Submit Button ──
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _submitReport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: _loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text('Submit Report', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
