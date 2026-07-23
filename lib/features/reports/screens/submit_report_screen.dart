import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../utils/auth_utils.dart';
import '../../../services/report_service.dart';

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

  void _submitReport() async {
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

    try {
      // Save directly to Firestore via ReportService
      await ReportService().submitReport(
        _titleController.text.trim(),
        selectedCategories.join(', '),
        _descriptionController.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('✅ Report submitted successfully!'),
          backgroundColor: green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Return data to the previous screen
      Navigator.pop(context, {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'time': 'Just now',
        'status': 'Pending',
        'severity': _severity,
        'categories': selectedCategories,
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit report: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5);
    final appBarColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : dark;
    final subtitleColor = isDark ? const Color(0xFFAAAAAA) : grey;
    final inputFillColor = isDark ? const Color(0xFF2A2A2A) : Colors.white;
    final borderColor = isDark ? const Color(0xFF333333) : grey.withValues(alpha: 0.3);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('Submit Report',
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        backgroundColor: appBarColor,
        elevation: 0,
        surfaceTintColor: appBarColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor),
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
                Text('Report a Threat',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
                const SizedBox(height: 4),
                Text('Help us keep the community safe by reporting suspicious activity.',
                    style: TextStyle(fontSize: 14, color: subtitleColor)),
                const SizedBox(height: 24),

                // Threat Title
                Text('Title',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  validator: (v) => requiredValidator(v, 'title'),
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: 'e.g., Fake Bank Alert SMS',
                    hintStyle: TextStyle(color: subtitleColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: green, width: 1.5),
                    ),
                    filled: true,
                    fillColor: inputFillColor,
                  ),
                ),
                const SizedBox(height: 20),

                // Threat Description
                Text('Description',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  validator: (v) => requiredValidator(v, 'description'),
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: 'Provide details about the threat...',
                    hintStyle: TextStyle(color: subtitleColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: green, width: 1.5),
                    ),
                    filled: true,
                    fillColor: inputFillColor,
                  ),
                ),
                const SizedBox(height: 24),

                // Checkboxes for Categories
                Text('Threat Categories (Select all that apply)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: inputFillColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    children: _categories.keys.map((String key) {
                      return CheckboxListTile(
                        title: Text(key, style: TextStyle(fontSize: 14, color: textColor)),
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

                // Severity Dropdown
                Text('Severity Level',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: _severity,
                  dropdownColor: appBarColor,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: green, width: 1.5),
                    ),
                    filled: true,
                    fillColor: inputFillColor,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  items: _severityOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: textColor)),
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

                // Submit Button
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



