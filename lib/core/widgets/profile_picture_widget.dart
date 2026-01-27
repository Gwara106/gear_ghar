import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/profile_picture_service.dart';

class ProfilePictureWidget extends StatelessWidget {
  final String? profilePicturePath;
  final double size;
  final String? name;
  final bool showEditButton;
  final VoidCallback? onEdit;
  final VoidCallback? onTap;

  const ProfilePictureWidget({
    super.key,
    this.profilePicturePath,
    this.size = 80.0,
    this.name,
    this.showEditButton = false,
    this.onEdit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
                border: Border.all(color: Colors.white, width: 2.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(child: _buildProfileImage()),
            ),
            if (showEditButton)
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    width: size * 0.3,
                    height: size * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.0),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: size * 0.15,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    if (profilePicturePath != null && profilePicturePath!.isNotEmpty) {
      if (profilePicturePath!.startsWith('http')) {
        return CachedNetworkImage(
          imageUrl: profilePicturePath!,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildPlaceholder(),
          errorWidget: (context, url, error) => _buildPlaceholder(),
        );
      } else {
        final file = File(profilePicturePath!);
        if (file.existsSync()) {
          return Image.file(
            file,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
          );
        }
      }
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: size * 0.4, color: Colors.grey[600]),
            if (name != null && name!.isNotEmpty)
              Text(
                _getInitials(name!),
                style: TextStyle(
                  fontSize: size * 0.25,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty) {
      return parts[0].substring(0, 1).toUpperCase();
    }
    return '';
  }
}

class ProfilePicturePicker extends StatefulWidget {
  final String? currentProfilePicture;
  final Function(String?) onPictureChanged;
  final String userId;

  const ProfilePicturePicker({
    super.key,
    this.currentProfilePicture,
    required this.onPictureChanged,
    required this.userId,
  });

  @override
  State<ProfilePicturePicker> createState() => _ProfilePicturePickerState();
}

class _ProfilePicturePickerState extends State<ProfilePicturePicker> {
  final ProfilePictureService _profilePictureService = ProfilePictureService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfilePictureWidget(
          profilePicturePath: widget.currentProfilePicture,
          size: 120,
          name: 'User',
          showEditButton: true,
          onEdit: _showImagePicker,
        ),
        const SizedBox(height: 16),
        if (_isLoading) const CircularProgressIndicator(),
      ],
    );
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickFromGallery();
              },
            ),
            if (widget.currentProfilePicture != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Remove Photo',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _removePhoto();
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFromCamera() async {
    setState(() => _isLoading = true);
    try {
      final imageFile = await _profilePictureService.pickImageFromCamera();
      if (imageFile != null) {
        final savedPath = await _profilePictureService.saveProfilePicture(
          imageFile,
          widget.userId,
        );
        widget.onPictureChanged(savedPath);
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image from camera: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickFromGallery() async {
    setState(() => _isLoading = true);
    try {
      final imageFile = await _profilePictureService.pickImageFromGallery();
      if (imageFile != null) {
        final savedPath = await _profilePictureService.saveProfilePicture(
          imageFile,
          widget.userId,
        );
        widget.onPictureChanged(savedPath);
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image from gallery: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _removePhoto() async {
    if (widget.currentProfilePicture != null) {
      await _profilePictureService.deleteProfilePicture(
        widget.currentProfilePicture!,
      );
      widget.onPictureChanged(null);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
