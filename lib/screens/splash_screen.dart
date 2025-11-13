import 'package:flutter/material.dart';
import 'dart:async';
import 'passcode_screen.dart';
import '../services/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _displayedText = '> ';
  final String _targetText = 'LVL';
  int _currentIndex = 0;
  bool _showCursor = true;
  bool _showUsernameInput = false;
  bool _isTypingComplete = false;
  bool _showWelcome = false;
  String _username = '';
  final TextEditingController _usernameController = TextEditingController();
  Timer? _typeTimer;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    _checkExistingUsername();
    
    // Blinking cursor effect
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          _showCursor = !_showCursor;
        });
      }
    });
    
    // Start typewriter effect after a short delay
    Timer(const Duration(milliseconds: 500), () {
      _startTypewriter();
    });
  }

  Future<void> _checkExistingUsername() async {
    final hasUsername = await StorageService.hasUsername();
    if (hasUsername && mounted) {
      // Load username and show welcome message
      final username = await StorageService.getUsername();
      setState(() {
        _username = username ?? '';
      });
    }
  }

  void _startTypewriter() {
    _typeTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (_currentIndex < _targetText.length) {
        setState(() {
          _displayedText += _targetText[_currentIndex];
          _currentIndex++;
        });
      } else {
        timer.cancel();
        // After typing is complete
        Timer(const Duration(milliseconds: 500), () {
          setState(() {
            _isTypingComplete = true;
          });
          // Check if username exists
          if (_username.isNotEmpty) {
            // Show welcome and navigate
            setState(() {
              _showWelcome = true;
            });
            Timer(const Duration(seconds: 2), () {
              if (mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const PasscodeScreen()),
                );
              }
            });
          } else {
            // Show username input
            _checkAndShowUsernameInput();
          }
        });
      }
    });
  }

  Future<void> _checkAndShowUsernameInput() async {
    final hasUsername = await StorageService.hasUsername();
    if (!hasUsername && mounted) {
      setState(() {
        _showUsernameInput = true;
      });
    }
  }

  Future<void> _handleUsernameSubmit() async {
    if (_usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('! ERROR: Please enter your name'),
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    
    final username = _usernameController.text.trim();
    await StorageService.saveUsername(username);
    
    // Show welcome message
    setState(() {
      _username = username;
      _showUsernameInput = false;
      _showWelcome = true;
    });
    
    // Navigate after showing welcome
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const PasscodeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _typeTimer?.cancel();
    _cursorTimer?.cancel();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Typewriter "LVL" text
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _displayedText,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 4,
                    ),
                  ),
                  if (_showCursor && !_showUsernameInput)
                    Container(
                      margin: const EdgeInsets.only(left: 4),
                      width: 14,
                      height: 36,
                      color: Colors.white,
                    ),
                ],
              ),
              
              // Username input section
              if (_showUsernameInput) ...[
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Text(
                      '> Hello ',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 20,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _usernameController,
                        autofocus: true,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 20,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                        decoration: InputDecoration(
                          hintText: '___',
                          hintStyle: TextStyle(
                            fontFamily: 'monospace',
                            color: Colors.white.withOpacity(0.3),
                          ),
                          border: InputBorder.none,
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 2),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 3),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        ),
                        onSubmitted: (_) => _handleUsernameSubmit(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _handleUsernameSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '> CONTINUE',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                ),
              ],
              
              // Welcome message
              if (_showWelcome) ...[
                const SizedBox(height: 24),
                Text(
                  '> Welcome, $_username',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 18,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
