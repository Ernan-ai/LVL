import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../services/passcode_service.dart';
import '../services/storage_service.dart';
import '../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  String? _username;
  String? _profilePicturePath;
  bool _isLoading = true;
  final ImagePicker _picker = ImagePicker();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation1;
  late Animation<double> _fadeAnimation2;
  late Animation<double> _fadeAnimation3;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    _fadeAnimation1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    
    _fadeAnimation2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );
    
    _fadeAnimation3 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );
    
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
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
            backgroundColor: kSoftWhite,
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
          side: BorderSide(color: kSoftWhite, width: 2),
        ),
        title: const Text(
          '> CHANGE PASSCODE',
          style: TextStyle(
            fontFamily: 'monospace',
            color: kSoftWhite,
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
                  color: kSoftWhite,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  labelText: 'CURRENT PASSCODE',
                  labelStyle: TextStyle(
                    fontFamily: 'monospace',
                    color: kSoftWhite,
                    fontSize: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: kSoftWhite, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: kSoftWhite, width: 3),
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
                  color: kSoftWhite,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  labelText: 'NEW PASSCODE',
                  labelStyle: TextStyle(
                    fontFamily: 'monospace',
                    color: kSoftWhite,
                    fontSize: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: kSoftWhite, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: kSoftWhite, width: 3),
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
                  color: kSoftWhite,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  labelText: 'CONFIRM NEW PASSCODE',
                  labelStyle: TextStyle(
                    fontFamily: 'monospace',
                    color: kSoftWhite,
                    fontSize: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: kSoftWhite, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: kSoftWhite, width: 3),
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
              foregroundColor: kSoftWhite,
              side: const BorderSide(color: kSoftWhite, width: 2),
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
                    backgroundColor: kSoftWhite,
                  ),
                );
              }
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: kSoftWhite,
              side: const BorderSide(color: kSoftWhite, width: 2),
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
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: kSoftWhite),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          // User info card
          FadeTransition(
            opacity: _fadeAnimation1,
            child: Card(
              child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _changeProfilePicture,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            border: Border.all(color: kSoftWhite, width: 3),
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
                                  child: Image.asset(
                                    'assets/images/logo.png',
                                    width: 50,
                                    height: 50,
                                    color: kSoftWhite,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Text(
                                        _username != null && _username!.isNotEmpty
                                            ? _username![0].toUpperCase()
                                            : '?',
                                        style: const TextStyle(
                                          fontFamily: 'monospace',
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          color: kSoftWhite,
                                        ),
                                      );
                                    },
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
                              color: kSoftWhite,
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
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '> ${_username?.toUpperCase() ?? 'USER'}',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kSoftWhite,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Security section
          FadeTransition(
            opacity: _fadeAnimation2,
            child: Card(
              child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      border: Border.all(color: kSoftWhite, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.lock, color: kSoftWhite),
                  ),
                  title: const Text(
                    '> CHANGE PASSCODE',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      color: kSoftWhite,
                      fontSize: 14,
                      letterSpacing: 1,
                    ),
                  ),
                  subtitle: Text(
                    'Update your master passcode',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      color: kSoftWhite.withOpacity(0.5),
                      fontSize: 11,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: kSoftWhite),
                  onTap: _changePasscode,
                ),
              ],
            ),
            ),
          ),
          const SizedBox(height: 16),
          
          // App info
          FadeTransition(
            opacity: _fadeAnimation3,
            child: Card(
              child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '> ABOUT',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      color: kSoftWhite.withOpacity(0.9),
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
                      color: kSoftWhite.withOpacity(0.5),
                      fontSize: 11,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            ),
          ),
        ],
        ),
      ),
      ),
    );
  }
}
