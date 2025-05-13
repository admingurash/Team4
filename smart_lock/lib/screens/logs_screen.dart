import 'package:flutter/material.dart';

class LogsScreen extends StatelessWidget {
  const LogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Logs / History')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Icon(Icons.lock_open),
            title: Text('Door unlocked by John Doe'),
            subtitle: Text('2024-03-21 09:00 AM'),
          ),
          ListTile(
            leading: Icon(Icons.lock_outline),
            title: Text('Door locked by Maria Sharapova'),
            subtitle: Text('2024-03-21 05:00 PM'),
          ),
          ListTile(
            leading: Icon(Icons.lock_open),
            title: Text('Door unlocked by Frida Swift'),
            subtitle: Text('2024-03-21 08:45 AM'),
          ),
        ],
      ),
    );
  }
}
