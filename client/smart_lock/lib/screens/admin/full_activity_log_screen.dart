import 'package:flutter/material.dart';

class FullActivityLogScreen extends StatelessWidget {
  const FullActivityLogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Activity Log'),
      ),
      body: ListView.builder(
        itemCount: 20, // TODO: Replace with real data from backend
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.person),
            title: Text('User ${index + 1}'),
            subtitle:
                Text('Action performed at 2025-05-07 11:56:49.${700 + index}'),
          );
        },
      ),
    );
  }
}
