import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/models.dart';
import 'client_home_screen.dart';
import 'company_home_screen.dart';
import 'admin_home_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Redirigir según el rol del usuario
    switch (user.role) {
      case Role.adminRoot:
        return const AdminHomeScreen();
      case Role.company:
        return const CompanyHomeScreen();
      case Role.client:
        return const ClientHomeScreen();
    }
  }
}
