import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../core/widgets/profile_picture_widget.dart';
import '../../../../core/widgets/permission_request_dialog.dart';
import '../../../../core/services/profile_picture_service.dart';
import '../../../../core/services/user_service.dart';

class ProfileManagementScreen extends StatefulWidget {
  const ProfileManagementScreen({super.key});

  @override
  State<ProfileManagementScreen> createState() => _ProfileManagementScreenState();
}

class _ProfileManagementScreenState extends State<ProfileManagementScreen> {
  final ProfilePictureService _profilePictureService = ProfilePictureService();
  final UserService _userService = UserService();
  bool _isLoading = false;
  List<String> _additionalPictures = [];

  @override
  void initState() {
    super.initState();
    _loadAdditionalPictures();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await PermissionChecker.checkAndRequestPermissions(
      context,
      requestCamera: true,
      requestStorage: true,
    );
  }

  Future<void> _loadAdditionalPictures() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser != null) {
      try {
        final pictures = await _userService.getAdditionalProfilePictures(
          authProvider.currentUser!.id,
        );
        setState(() {
          _additionalPictures = pictures;
        });
      } catch (e) {
        print('Error loading additional pictures: $e');
      }
    }
  }

  Future<void> _onMainPictureChanged(String? newPath) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser != null) {
      try {
        await _userService.updateUserProfilePicture(
          authProvider.currentUser!.id,
          newPath,
        );
        // Refresh current user data
        await authProvider.initializeAuth();
      } catch (e) {
        _showErrorSnackBar('Failed to update profile picture: $e');
      }
    }
  }

  Future<void> _addAdditionalPicture() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser == null) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () async {
                Navigator.pop(context);
                await _captureAdditionalPicture(true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                await _captureAdditionalPicture(false);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _captureAdditionalPicture(bool fromCamera) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser == null) return;

    setState(() => _isLoading = true);

    try {
      final imageFile = fromCamera
          ? await _profilePictureService.pickImageFromCamera()
          : await _profilePictureService.pickImageFromGallery();

      if (imageFile != null) {
        final savedPath = await _profilePictureService.saveProfilePicture(
          imageFile,
          authProvider.currentUser!.id,
        );

        await _userService.addAdditionalProfilePicture(
          authProvider.currentUser!.id,
          savedPath,
        );

        await _loadAdditionalPictures();
        _showSuccessSnackBar('Additional picture added successfully');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to add picture: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _removeAdditionalPicture(String imagePath) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser == null) return;

    try {
      await _userService.removeAdditionalProfilePicture(
        authProvider.currentUser!.id,
        imagePath,
      );
      await _loadAdditionalPictures();
      _showSuccessSnackBar('Picture removed successfully');
    } catch (e) {
      _showErrorSnackBar('Failed to remove picture: $e');
    }
  }

  Future<void> _setAsMainPicture(String imagePath) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser == null) return;

    try {
      await _userService.updateUserProfilePicture(
        authProvider.currentUser!.id,
        imagePath,
      );
      
      // Remove from additional pictures since it's now main
      await _userService.removeAdditionalProfilePicture(
        authProvider.currentUser!.id,
        imagePath,
      );
      
      await authProvider.initializeAuth();
      await _loadAdditionalPictures();
      _showSuccessSnackBar('Main profile picture updated');
    } catch (e) {
      _showErrorSnackBar('Failed to update main picture: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Management'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.currentUser == null) {
            return const Center(
              child: Text('Please login to manage your profile'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main Profile Picture Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Main Profile Picture',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: ProfilePicturePicker(
                            currentProfilePicture: authProvider.currentUser?.profilePicture,
                            onPictureChanged: _onMainPictureChanged,
                            userId: authProvider.currentUser!.id,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Additional Pictures Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Additional Pictures',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (_isLoading)
                              const CircularProgressIndicator()
                            else
                              IconButton(
                                onPressed: _addAdditionalPicture,
                                icon: const Icon(Icons.add),
                                tooltip: 'Add Picture',
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (_additionalPictures.isEmpty)
                          const Center(
                            child: Text(
                              'No additional pictures yet',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        else
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                            ),
                            itemCount: _additionalPictures.length,
                            itemBuilder: (context, index) {
                              final imagePath = _additionalPictures[index];
                              return Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey.shade300),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        File(imagePath),
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey.shade300,
                                            child: const Icon(
                                              Icons.broken_image,
                                              color: Colors.grey,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: PopupMenuButton<String>(
                                      icon: const Icon(
                                        Icons.more_vert,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black,
                                            offset: Offset(1, 1),
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                      color: Colors.white,
                                      onSelected: (value) {
                                        switch (value) {
                                          case 'set_main':
                                            _setAsMainPicture(imagePath);
                                            break;
                                          case 'delete':
                                            _showDeleteConfirmation(imagePath);
                                            break;
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: 'set_main',
                                          child: Row(
                                            children: [
                                              Icon(Icons.star),
                                              SizedBox(width: 8),
                                              Text('Set as Main'),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'delete',
                                          child: Row(
                                            children: [
                                              Icon(Icons.delete, color: Colors.red),
                                              SizedBox(width: 8),
                                              Text('Delete', style: TextStyle(color: Colors.red)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(String imagePath) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Picture'),
        content: const Text('Are you sure you want to delete this picture?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _removeAdditionalPicture(imagePath);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
