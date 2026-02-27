import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/providers/admin_provider.dart';
import '../../../../core/models/api_user_model.dart';
import 'admin_edit_user_screen.dart';

class AdminUserDetailScreen extends StatefulWidget {
  final String userId;

  const AdminUserDetailScreen({
    super.key,
    required this.userId,
  });

  @override
  State<AdminUserDetailScreen> createState() => _AdminUserDetailScreenState();
}

class _AdminUserDetailScreenState extends State<AdminUserDetailScreen> {
  ApiUser? _user;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await context.read<AdminProvider>().getUserById(widget.userId);
      if (user != null) {
        setState(() {
          _user = user;
        });
      } else {
        setState(() {
          _errorMessage = 'User not found';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load user: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteUser() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete user "${_user?.fullName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && _user != null) {
      final success = await context.read<AdminProvider>().deleteUser(_user!.id);
      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User deleted successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_user?.fullName ?? 'User Details'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          if (_user != null) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminEditUserScreen(user: _user!),
                  ),
                ).then((_) => _loadUser());
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteUser,
            ),
          ],
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading user',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(_errorMessage!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadUser,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _user == null
                  ? const Center(
                      child: Text('User not found'),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Section
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.blue.shade100,
                                    backgroundImage: _user!.profilePicture != null
                                        ? NetworkImage(_user!.profilePicture!)
                                        : null,
                                    child: _user!.profilePicture == null
                                        ? Text(
                                            _user!.firstName.isNotEmpty 
                                                ? _user!.firstName[0].toUpperCase()
                                                : 'U',
                                            style: TextStyle(
                                              fontSize: 24,
                                              color: Colors.blue.shade700,
                                            ),
                                          )
                                        : null,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _user!.fullName,
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _user!.email,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // User Information
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'User Information',
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildInfoRow('User ID', _user!.id),
                                  _buildInfoRow('First Name', _user!.firstName),
                                  _buildInfoRow('Last Name', _user!.lastName),
                                  if (_user!.name != null) 
                                    _buildInfoRow('Full Name', _user!.name!),
                                  if (_user!.username != null) 
                                    _buildInfoRow('Username', _user!.username!),
                                  if (_user!.phoneNumber != null) 
                                    _buildInfoRow('Phone Number', _user!.phoneNumber!),
                                  _buildInfoRow('Email', _user!.email),
                                  _buildInfoRow('Role', _user!.role.toUpperCase()),
                                  _buildInfoRow('Status', _user!.status.toUpperCase()),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // System Information
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'System Information',
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildInfoRow(
                                    'Created At',
                                    _formatDateTime(_user!.createdAt),
                                  ),
                                  _buildInfoRow(
                                    'Last Updated',
                                    _formatDateTime(_user!.updatedAt),
                                  ),
                                  if (_user!.lastLogin != null)
                                    _buildInfoRow(
                                      'Last Login',
                                      _formatDateTime(_user!.lastLogin!),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/'
           '${dateTime.month.toString().padLeft(2, '0')}/'
           '${dateTime.year} '
           '${dateTime.hour.toString().padLeft(2, '0')}:'
           '${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
