import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../core/services/profile_picture_service.dart';
import '../../../../core/services/permission_service.dart';
import '../../../../core/models/api_user_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ProfilePictureService _profilePictureService = ProfilePictureService();
  final PermissionService _permissionService = PermissionService();
  
  File? _newProfileImage;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFD0D0D0),
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Picture Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    'Profile Picture',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _showImagePickerOptions,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: _newProfileImage != null
                              ? FileImage(_newProfileImage!) as ImageProvider
                              : (currentUser?.profilePicture != null && 
                                 currentUser!.profilePicture!.isNotEmpty)
                                  ? FileImage(File(currentUser.profilePicture!)) as ImageProvider
                                  : const AssetImage('assets/images/profile_placeholder.png'),
                          backgroundColor: Colors.grey[200],
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Tap to change profile picture',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // User Info Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'User Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Name Field
                  TextField(
                    controller: TextEditingController(text: currentUser?.fullName ?? ''),
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    enabled: false, // For now, disable name editing
                  ),
                  
                  const SizedBox(height: 15),
                  
                  // Email Field
                  TextField(
                    controller: TextEditingController(text: currentUser?.email ?? ''),
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    enabled: false, // For now, disable email editing
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Error Message
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red.shade600),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red.shade600),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choose Profile Picture',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromGallery();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromCamera() async {
    try {
      setState(() => _errorMessage = null);
      
      final image = await _profilePictureService.pickImageFromCamera();
      if (image != null) {
        setState(() {
          _newProfileImage = image;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to pick image from camera: $e';
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      setState(() => _errorMessage = null);
      
      final image = await _profilePictureService.pickImageFromGallery();
      if (image != null) {
        setState(() {
          _newProfileImage = image;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to pick image from gallery: $e';
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_newProfileImage == null) {
      Navigator.pop(context);
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = authProvider.currentUser;

    if (currentUser == null) {
      setState(() {
        _errorMessage = 'No user logged in';
      });
      return;
    }

    try {
      setState(() => _isLoading = true);

      print('EditProfileScreen: Current user profile picture: ${currentUser.profilePicture}');

      // Save the new profile picture
      final savedImagePath = await _profilePictureService.saveProfilePicture(
        _newProfileImage!,
        currentUser.id,
      );

      print('EditProfileScreen: Saved image path: $savedImagePath');

      // Update user with new profile picture path
      final updatedUser = ApiUser(
        id: currentUser.id,
        firstName: currentUser.firstName,
        lastName: currentUser.lastName,
        name: currentUser.name,
        email: currentUser.email,
        username: currentUser.username,
        phoneNumber: currentUser.phoneNumber,
        profilePicture: savedImagePath,
        role: currentUser.role,
        status: currentUser.status,
        lastLogin: currentUser.lastLogin,
        createdAt: currentUser.createdAt,
        updatedAt: DateTime.now(),
      );

      // Update locally first to ensure UI updates immediately
      authProvider.setCurrentUser(updatedUser);
      print('EditProfileScreen: Updated user locally with new profile picture');

      // Try to update on server (but don't fail if it doesn't work)
      try {
        await authProvider.updateUser(updatedUser);
        print('EditProfileScreen: Server update successful');
      } catch (e) {
        print('EditProfileScreen: Server update failed, but local update succeeded: $e');
        // Don't show error to user since local update worked
      }

      setState(() => _isLoading = false);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to update profile: $e';
      });
    }
  }
}
