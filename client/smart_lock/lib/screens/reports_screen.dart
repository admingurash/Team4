import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: AuthService.getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userInfo = snapshot.data;
          final isGuest = AuthService.isGuestMode;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isGuest)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange[700]),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'You are in guest mode. Some reports are limited.',
                            style: TextStyle(color: Colors.orange[900]),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: const Text('Login'),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
                _buildReportSection(
                  context,
                  title: 'Attendance Overview',
                  children: [
                    _buildStatCard(
                      context,
                      'Total Present',
                      '85%',
                      Icons.check_circle_outline,
                      Colors.green,
                    ),
                    _buildStatCard(
                      context,
                      'Late Arrivals',
                      '12%',
                      Icons.warning_outlined,
                      Colors.orange,
                    ),
                    _buildStatCard(
                      context,
                      'Absences',
                      '3%',
                      Icons.cancel_outlined,
                      Colors.red,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildReportSection(
                  context,
                  title: 'Monthly Trends',
                  children: [
                    Container(
                      height: 200,
                      padding: const EdgeInsets.all(16),
                      child: const Center(
                        child: Text('Monthly attendance chart coming soon'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildReportSection(
                  context,
                  title: 'Department Statistics',
                  children: [
                    Container(
                      height: 200,
                      padding: const EdgeInsets.all(16),
                      child: const Center(
                        child: Text('Department statistics chart coming soon'),
                      ),
                    ),
                  ],
                ),
                if (!isGuest) ...[
                  const SizedBox(height: 24),
                  _buildReportSection(
                    context,
                    title: 'Export Options',
                    children: [
                      ListTile(
                        leading: const Icon(Icons.download),
                        title: const Text('Export to Excel'),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Export to Excel coming soon')),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.picture_as_pdf),
                        title: const Text('Export to PDF'),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Export to PDF coming soon')),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildReportSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
