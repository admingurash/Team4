import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'screens/admin_dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Lock Admin',
      locale: _locale,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AdminDashboard(),
      onGenerateTitle: (context) =>
          AppLocalizations.of(context).smartLockAdmin,
    );
  }
}

class AttendanceRecord {
  final String name;
  final String id;
  final DateTime checkIn;
  DateTime? checkOut;

  AttendanceRecord({
    required this.name,
    required this.id,
    required this.checkIn,
    this.checkOut,
  });
}

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final List<AttendanceRecord> _records = [
    AttendanceRecord(
      name: 'John Doe',
      id: 'ID001',
      checkIn: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    AttendanceRecord(
      name: 'Jane Smith',
      id: 'ID002',
      checkIn: DateTime.now().subtract(const Duration(hours: 4)),
      checkOut: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    AttendanceRecord(
      name: 'Bob Johnson',
      id: 'ID003',
      checkIn: DateTime.now().subtract(const Duration(hours: 3)),
    ),
  ];

  void _addNewRecord() {
    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return AlertDialog(
          title: Text(l10n.addNewRecord),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: l10n.name),
                onChanged: (value) {
                  // Handle name input
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: l10n.id),
                onChanged: (value) {
                  // Handle ID input
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _records.add(
                    AttendanceRecord(
                      name: l10n.newEmployee,
                      id: 'ID${_records.length + 1}',
                      checkIn: DateTime.now(),
                    ),
                  );
                });
                Navigator.pop(context);
              },
              child: Text(l10n.add),
            ),
          ],
        );
      },
    );
  }

  void _checkOut(AttendanceRecord record) {
    setState(() {
      record.checkOut = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.attendanceSystem),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _records.length,
        itemBuilder: (context, index) {
          final record = _records[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(child: Text(record.name[0])),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              record.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${l10n.id}: ${record.id}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      if (record.checkOut == null)
                        TextButton(
                          onPressed: () => _checkOut(record),
                          child: Text(l10n.checkOut),
                        ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: record.checkOut == null
                              ? Colors.green[100]
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          record.checkOut == null ? l10n.present : l10n.left,
                          style: TextStyle(
                            color: record.checkOut == null
                                ? Colors.green[700]
                                : Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.checkIn,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              _formatDateTime(record.checkIn),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      if (record.checkOut != null) ...[
                        const SizedBox(width: 32),
                        Expanded(
        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.checkOut,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
            Text(
                                _formatDateTime(record.checkOut!),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
            ),
          ],
        ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewRecord,
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
