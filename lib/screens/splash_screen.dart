import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import '../services/storage_service.dart';
import 'passcode_screen.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  String _displayedText = '> ';
  final String _targetText = 'LVL';
  int _currentIndex = 0;
  bool _showCursor = true;
  bool _showUsernameInput = false;
  bool _isTypingComplete = false;
  bool _showWelcome = false;
  String _username = '';
  String _welcomeText = '';
  String _fullWelcomeText = '';
  int _welcomeIndex = 0;
  String _helloText = '';
  final String _fullHelloText = '> Hello ';
  int _helloIndex = 0;
  bool _helloTypingComplete = false;
  final TextEditingController _usernameController = TextEditingController();
  Timer? _typeTimer;
  Timer? _cursorTimer;
  Timer? _helloTimer;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _checkExistingUsername();
    
    // Animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );
    
    _animationController.forward();
    
    // Blinking cursor effect
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          _showCursor = !_showCursor;
        });
      }
    });
    
    // Start typewriter effect after animation
    Timer(const Duration(milliseconds: 800), () {
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
        Timer(const Duration(milliseconds: 800), () {
          setState(() {
            _isTypingComplete = true;
          });
          // Check if username exists
          if (_username.isNotEmpty) {
            // Show welcome with typewriter effect
            setState(() {
              _showWelcome = true;
              _fullWelcomeText = '> Welcome, $_username';
            });
            _startWelcomeTypewriter();
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
      _startHelloTypewriter();
    }
  }

  void _startHelloTypewriter() {
    _helloTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_helloIndex < _fullHelloText.length) {
        setState(() {
          _helloText += _fullHelloText[_helloIndex];
          _helloIndex++;
        });
      } else {
        timer.cancel();
        setState(() {
          _helloTypingComplete = true;
        });
      }
    });
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
    
    // Show welcome message with typewriter
    setState(() {
      _username = username;
      _showUsernameInput = false;
      _showWelcome = true;
      _fullWelcomeText = '> Welcome, $username';
    });
    
    _startWelcomeTypewriter();
  }

  void _startWelcomeTypewriter() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_welcomeIndex < _fullWelcomeText.length) {
        setState(() {
          _welcomeText += _fullWelcomeText[_welcomeIndex];
          _welcomeIndex++;
        });
      } else {
        timer.cancel();
        // Navigate after typing complete
        Timer(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const PasscodeScreen()),
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _typeTimer?.cancel();
    _cursorTimer?.cancel();
    _helloTimer?.cancel();
    _animationController.dispose();
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
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo image
                  Center(
                    child: Image.asset(
                  'assets/images/logo.png',
                  width: 180,
                  height: 180,
                  color: kSoftWhite,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback if image not found
                    return Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        border: Border.all(color: kSoftWhite, width: 2),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'LVL',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: kSoftWhite,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
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
                      color: kSoftWhite,
                      letterSpacing: 4,
                    ),
                  ),
                  if (_showCursor && !_isTypingComplete)
                    Container(
                      margin: const EdgeInsets.only(left: 4),
                      width: 14,
                      height: 36,
                      color: kAccentColor,
                    ),
                ],
              ),
              
              // Username input section
              if (_showUsernameInput) ...[
                const SizedBox(height: 24),
                Row(
                  children: [
                    Text(
                      _helloText,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 20,
                        color: kSoftWhite,
                        letterSpacing: 2,
                      ),
                    ),
                    if (!_helloTypingComplete && _showCursor)
                      Container(
                        margin: const EdgeInsets.only(left: 4),
                        width: 10,
                        height: 20,
                        color: kAccentColor,
                      ),
                    if (_helloTypingComplete)
                      Expanded(
                        child: TextField(
                          controller: _usernameController,
                          autofocus: true,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 20,
                          color: kSoftWhite,
                          letterSpacing: 2,
                        ),
                        decoration: InputDecoration(
                          hintText: '___',
                          hintStyle: TextStyle(
                            fontFamily: 'monospace',
                            color: kSoftWhite.withOpacity(0.3),
                          ),
                          border: InputBorder.none,
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: kSoftWhite, width: 2),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: kAccentColor, width: 3),
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
              
              // Welcome message with typewriter
              if (_showWelcome) ...[
                const SizedBox(height: 24),
                Text(
                  _welcomeText,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 18,
                    color: kAccentColor,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
