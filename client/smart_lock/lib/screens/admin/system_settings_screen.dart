import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SystemSettingsScreen extends StatefulWidget {
  const SystemSettingsScreen({Key? key}) : super(key: key);

  @override
  State<SystemSettingsScreen> createState() => _SystemSettingsScreenState();
}

class _SystemSettingsScreenState extends State<SystemSettingsScreen> {
  bool _enableNotifications = true;
  bool _enableCloudBackup = true;
  String _selectedTheme = 'system';
  String _apiKey = '';
  String _endpointUrl = 'https://api.smartlock.com';
  String _esp32IpAddress = '192.168.1.1';
  int _esp32Port = 80;
  bool _isConnected = false;
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _endpointUrlController = TextEditingController();
  final TextEditingController _esp32IpController = TextEditingController();
  final TextEditingController _esp32PortController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _enableNotifications = prefs.getBool('notifications') ?? true;
      _enableCloudBackup = prefs.getBool('cloudBackup') ?? true;
      _selectedTheme = prefs.getString('theme') ?? 'system';
      _apiKey = prefs.getString('apiKey') ?? '';
      _endpointUrl =
          prefs.getString('endpointUrl') ?? 'https://api.smartlock.com';
      _esp32IpAddress = prefs.getString('esp32Ip') ?? '192.168.1.1';
      _esp32Port = prefs.getInt('esp32Port') ?? 80;

      _apiKeyController.text = _apiKey;
      _endpointUrlController.text = _endpointUrl;
      _esp32IpController.text = _esp32IpAddress;
      _esp32PortController.text = _esp32Port.toString();
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', _enableNotifications);
    await prefs.setBool('cloudBackup', _enableCloudBackup);
    await prefs.setString('theme', _selectedTheme);
    await prefs.setString('apiKey', _apiKey);
    await prefs.setString('endpointUrl', _endpointUrl);
    await prefs.setString('esp32Ip', _esp32IpAddress);
    await prefs.setInt('esp32Port', _esp32Port);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved successfully')),
    );
  }

  void _showHelpDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l10n.connectionHelp),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.esp32ConnectionHelp,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '${l10n.esp32ConnectionStep1}\n'
                  '${l10n.esp32ConnectionStep2}\n'
                  '${l10n.esp32ConnectionStep3}\n'
                  '${l10n.esp32ConnectionStep4}\n\n'
                  '${l10n.apiConnectionHelp}\n'
                  '${l10n.apiConnectionStep1}\n'
                  '${l10n.apiConnectionStep2}\n'
                  '${l10n.apiConnectionStep3}\n\n'
                  '${l10n.helpDocLink}',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
          ],
        );
      },
    );
  }

  Future<void> _testEsp32Connection() async {
    // TODO: Implement actual ESP32 connection test
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isConnected = true;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully connected to ESP32')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.systemSettings),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelpDialog,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    l10n.securityPolicies,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                SwitchListTile(
                  title: Text(l10n.enableNotifications),
                  subtitle: Text(l10n.notificationsSubtitle),
                  value: _enableNotifications,
                  onChanged: (value) {
                    setState(() {
                      _enableNotifications = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text(l10n.cloudBackup),
                  subtitle: Text(l10n.cloudBackupSubtitle),
                  value: _enableCloudBackup,
                  onChanged: (value) {
                    setState(() {
                      _enableCloudBackup = value;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    l10n.esp32Connection,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: _esp32IpController,
                    decoration: InputDecoration(
                      labelText: l10n.esp32IpAddress,
                      hintText: '192.168.1.1',
                    ),
                    onChanged: (value) => _esp32IpAddress = value,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: _esp32PortController,
                    decoration: InputDecoration(
                      labelText: l10n.port,
                      hintText: '80',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) =>
                        _esp32Port = int.tryParse(value) ?? 80,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: _testEsp32Connection,
                        child: Text(l10n.testConnection),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        _isConnected ? Icons.check_circle : Icons.error,
                        color: _isConnected ? Colors.green : Colors.red,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    l10n.apiSettings,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: _apiKeyController,
                    decoration: InputDecoration(
                      labelText: l10n.apiKey,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: _apiKeyController.text));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.apiKeyCopied)),
                          );
                        },
                      ),
                    ),
                    obscureText: true,
                    onChanged: (value) => _apiKey = value,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: _endpointUrlController,
                    decoration: InputDecoration(
                      labelText: l10n.endpointUrl,
                      hintText: 'https://api.smartlock.com',
                    ),
                    onChanged: (value) => _endpointUrl = value,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    l10n.themeSettings,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                RadioListTile(
                  title: Text(l10n.systemTheme),
                  value: 'system',
                  groupValue: _selectedTheme,
                  onChanged: (value) {
                    setState(() {
                      _selectedTheme = value.toString();
                    });
                  },
                ),
                RadioListTile(
                  title: Text(l10n.lightTheme),
                  value: 'light',
                  groupValue: _selectedTheme,
                  onChanged: (value) {
                    setState(() {
                      _selectedTheme = value.toString();
                    });
                  },
                ),
                RadioListTile(
                  title: Text(l10n.darkTheme),
                  value: 'dark',
                  groupValue: _selectedTheme,
                  onChanged: (value) {
                    setState(() {
                      _selectedTheme = value.toString();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _endpointUrlController.dispose();
    _esp32IpController.dispose();
    _esp32PortController.dispose();
    super.dispose();
  }
}
