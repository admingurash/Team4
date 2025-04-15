import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class BaseScreen extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? drawer;

  const BaseScreen({
    Key? key,
    required this.title,
    required this.body,
    this.actions,
    this.drawer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          ...?actions,
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthService>().logout(context),
          ),
        ],
      ),
      drawer: drawer,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: body,
        ),
      ),
    );
  }
}
