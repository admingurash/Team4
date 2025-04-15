import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccessVerification extends StatefulWidget {
  const AccessVerification({Key? key}) : super(key: key);

  @override
  State<AccessVerification> createState() => _AccessVerificationState();
}

class _AccessVerificationState extends State<AccessVerification> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'pending';

  // Sample data - replace with actual data from API
  final List<Map<String, dynamic>> _requests = [
    {
      'id': '1',
      'userName': 'John Doe',
      'userId': 'USR001',
      'location': 'Server Room',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'method': 'Card Scan',
      'status': 'pending',
      'reason': 'System maintenance',
    },
    {
      'id': '2',
      'userName': 'Jane Smith',
      'userId': 'USR002',
      'location': 'Main Office',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
      'method': 'Face Recognition',
      'status': 'approved',
      'reason': 'Regular work hours',
    },
    {
      'id': '3',
      'userName': 'Bob Wilson',
      'userId': 'USR003',
      'location': 'Conference Room',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
      'method': 'Card Scan',
      'status': 'denied',
      'reason': 'Meeting with clients',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search requests...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 14),
                    ),
                    onChanged: (value) {
                      setState(() {
                        // Implement search functionality
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', 'all'),
                const SizedBox(width: 8),
                _buildFilterChip('Pending', 'pending'),
                const SizedBox(width: 8),
                _buildFilterChip('Approved', 'approved'),
                const SizedBox(width: 8),
                _buildFilterChip('Denied', 'denied'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _requests.length,
              itemBuilder: (context, index) {
                final request = _requests[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        child: Text(
                          request['userName'][0],
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        request['userName'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            request['location'],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.access_time_outlined,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('HH:mm').format(request['timestamp']),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(request['status'])
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          request['status'][0].toUpperCase() +
                              request['status'].substring(1),
                          style: TextStyle(
                            color: _getStatusColor(request['status']),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow('User ID', request['userId']),
                              const SizedBox(height: 8),
                              _buildDetailRow('Method', request['method']),
                              const SizedBox(height: 8),
                              _buildDetailRow('Reason', request['reason']),
                              const SizedBox(height: 16),
                              if (request['status'] == 'pending')
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    OutlinedButton(
                                      onPressed: () => _denyRequest(request),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ),
                                        foregroundColor:
                                            Theme.of(context).colorScheme.error,
                                      ),
                                      child: const Text('Deny'),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () => _approveRequest(request),
                                      child: const Text('Approve'),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[800],
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
      },
      backgroundColor: Colors.white,
      selectedColor: Theme.of(context).colorScheme.primary,
      checkmarkColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'denied':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _approveRequest(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Access'),
        content: Text(
            'Are you sure you want to approve ${request['userName']}\'s access request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                request['status'] = 'approved';
              });
              Navigator.pop(context);
            },
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  void _denyRequest(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deny Access'),
        content: Text(
            'Are you sure you want to deny ${request['userName']}\'s access request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                request['status'] = 'denied';
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Deny'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
