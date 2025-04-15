import 'package:flutter/material.dart';
import 'package:smart_lock/screens/user/card_scan_screen.dart';
import 'package:smart_lock/screens/user/face_recognition_screen.dart';

class AccessRequestForm extends StatefulWidget {
  const AccessRequestForm({Key? key}) : super(key: key);

  @override
  State<AccessRequestForm> createState() => _AccessRequestFormState();
}

class _AccessRequestFormState extends State<AccessRequestForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedLocation;
  String _selectedMethod = 'card';
  final TextEditingController _reasonController = TextEditingController();

  final List<String> _locations = [
    'Main Entrance',
    'Server Room',
    'Office Area',
    'Conference Room',
    'Storage Room',
  ];

  void _handleLocationDetected(String location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  Future<void> _startScanning() async {
    if (_selectedMethod == 'card') {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CardScanScreen(
            onLocationDetected: _handleLocationDetected,
          ),
        ),
      );
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FaceRecognitionScreen(
            onLocationDetected: _handleLocationDetected,
          ),
        ),
      );
    }
  }

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Access request submitted successfully'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );

      // Reset form
      setState(() {
        _selectedLocation = null;
        _selectedMethod = 'card';
        _reasonController.clear();
      });
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'New Access Request',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            value: _selectedLocation,
            decoration: const InputDecoration(
              labelText: 'Select Location',
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
            items: _locations.map((location) {
              return DropdownMenuItem(
                value: location,
                child: Text(location),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedLocation = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a location';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: 'card',
                icon: Icon(Icons.credit_card),
                label: Text('Card Scan'),
              ),
              ButtonSegment(
                value: 'face',
                icon: Icon(Icons.face),
                label: Text('Face Recognition'),
              ),
            ],
            selected: {_selectedMethod},
            onSelectionChanged: (Set<String> selection) {
              setState(() {
                _selectedMethod = selection.first;
              });
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _reasonController,
            decoration: const InputDecoration(
              labelText: 'Reason for Access',
              prefixIcon: Icon(Icons.description_outlined),
            ),
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a reason';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _startScanning,
              icon: Icon(
                _selectedMethod == 'card' ? Icons.credit_card : Icons.face,
              ),
              label: Text(
                _selectedMethod == 'card'
                    ? 'Scan Card'
                    : 'Start Face Recognition',
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          if (_selectedLocation != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _submitRequest,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('Submit Request'),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
