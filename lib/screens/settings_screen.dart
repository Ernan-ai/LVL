import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../services/passcode_service.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _username;
  String? _profilePicturePath;
  bool _isLoading = true;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final username = await StorageService.getUsername();
    final profilePic = await StorageService.getProfilePicture();
    setState(() {
      _username = username;
      _profilePicturePath = profilePic;
      _isLoading = false;
    });
  }
  
  Future<void> _changeProfilePicture() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    
    if (image != null) {
      // Copy image to app directory
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await File(image.path).copy('${appDir.path}/$fileName');
      
      await StorageService.saveProfilePicture(savedImage.path);
      setState(() {
        _profilePicturePath = savedImage.path;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('> PROFILE PICTURE UPDATED'),
            backgroundColor: Colors.white,
          ),
        );
      }
    }
  }

  Future<void> _changePasscode() async {
    final TextEditingController currentController = TextEditingController();
    final TextEditingController newController = TextEditingController();
    final TextEditingController confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: Colors.white, width: 2),
        ),
        title: const Text(
          '> CHANGE PASSCODE',
          style: TextStyle(
            fontFamily: 'monospace',
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontSize: 16,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentController,
                obscureText: true,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(
                  fontFamily: 'monospace',
                  color: Colors.white,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  labelText: 'CURRENT PASSCODE',
                  labelStyle: TextStyle(
                    fontFamily: 'monospace',
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: Colors.white, width: 3),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newController,
                obscureText: true,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(
                  fontFamily: 'monospace',
                  color: Colors.white,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  labelText: 'NEW PASSCODE',
                  labelStyle: TextStyle(
                    fontFamily: 'monospace',
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: Colors.white, width: 3),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmController,
                obscureText: true,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(
                  fontFamily: 'monospace',
                  color: Colors.white,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  labelText: 'CONFIRM NEW PASSCODE',
                  labelStyle: TextStyle(
                    fontFamily: 'monospace',
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: Colors.white, width: 3),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white, width: 2),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            child: const Text(
              '> CANCEL',
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
          OutlinedButton(
            onPressed: () async {
              // Validate current passcode
              final isValid = await PasscodeService.verifyPasscode(currentController.text);
              if (!isValid) {
                Navigator.pop(context);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('! ERROR: Current passcode is incorrect'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                return;
              }

              // Validate new passcode
              if (newController.text.isEmpty) {
                Navigator.pop(context);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('! ERROR: New passcode cannot be empty'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                return;
              }

              if (!RegExp(r'^\d+$').hasMatch(newController.text)) {
                Navigator.pop(context);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('! ERROR: Passcode must contain only numbers'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                return;
              }

              // Validate confirmation
              if (newController.text != confirmController.text) {
                Navigator.pop(context);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('! ERROR: Passcodes do not match'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                return;
              }

              // Save new passcode
              await PasscodeService.savePasscode(newController.text);
              Navigator.pop(context);
              
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('> PASSCODE CHANGED SUCCESSFULLY'),
                    backgroundColor: Colors.white,
                  ),
                );
              }
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              side: const BorderSide(color: Colors.white, width: 2),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            child: const Text(
              '> CHANGE',
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // User info card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _changeProfilePicture,
                    child: Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 3),
                            borderRadius: BorderRadius.circular(12),
                            image: _profilePicturePath != null
                                ? DecorationImage(
                                    image: FileImage(File(_profilePicturePath!)),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: _profilePicturePath == null
                              ? Center(
                                  child: Text(
                                    _username != null && _username!.isNotEmpty
                                        ? _username![0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '> ${_username?.toUpperCase() ?? 'USER'}',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Security section
          Card(
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.lock, color: Colors.white),
                  ),
                  title: const Text(
                    '> CHANGE PASSCODE',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14,
                      letterSpacing: 1,
                    ),
                  ),
                  subtitle: Text(
                    'Update your master passcode',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 11,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.white),
                  onTap: _changePasscode,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // App info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '> ABOUT',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'LVL v1.0.0\n'
                    'Secure password encryption\n'
                    'using custom algorithms',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 11,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
