import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/admin_service.dart';
import '../../../models/user_model.dart';

class AdminUsersView extends StatelessWidget {
  const AdminUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserModel>>(
      stream: AdminService().getAllUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final users = snapshot.data ?? [];
        if (users.isEmpty) {
          return Center(child: Text('No users registered.', style: TextStyle(color: grey)));
        }

        final isDark = Theme.of(context).brightness == Brightness.dark;
        final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final u = users[index];
            return Card(
              color: cardColor,
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: isDark ? const Color(0xFF333333) : Colors.grey.shade200)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: green.withValues(alpha: 0.1),
                  child: Text(u.name.isNotEmpty ? u.name[0].toUpperCase() : 'U', style: TextStyle(color: green, fontWeight: FontWeight.bold)),
                ),
                title: Text(u.name, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark)),
                subtitle: Text(u.email, style: TextStyle(color: isDark ? const Color(0xFFAAAAAA) : grey, fontSize: 12)),
                trailing: u.email.toLowerCase() == 'wajahatkhan2003@gmail.com'
                    ? const SizedBox.shrink()
                    : IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () {
                          AdminService().deleteUser(u.uid);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User deleted')));
                        },
                      ),
              ),
            );
          },
        );
      }
    );
  }
}



