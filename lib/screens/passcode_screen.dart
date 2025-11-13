import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/passcode_service.dart';
import '../main.dart';

class PasscodeScreen extends StatefulWidget {
  const PasscodeScreen({super.key});

  @override
  State<PasscodeScreen> createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen> {
  final TextEditingController _passcodeController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool _isSetupMode = false;
  bool _isLoading = true;
  bool _obscureText = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkPasscodeStatus();
  }

  Future<void> _checkPasscodeStatus() async {
    final hasPasscode = await PasscodeService.hasPasscode();
    setState(() {
      _isSetupMode = !hasPasscode;
      _isLoading = false;
    });
  }

  Future<void> _handleSubmit() async {
    setState(() {
      _errorMessage = '';
    });

    if (_passcodeController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Passcode cannot be empty';
      });
      return;
    }

    // Validate passcode contains only digits
    if (!RegExp(r'^\d+$').hasMatch(_passcodeController.text)) {
      setState(() {
        _errorMessage = 'Passcode must contain only numbers';
      });
      return;
    }

    if (_isSetupMode) {
      // Setup mode - create new passcode
      if (_passcodeController.text != _confirmController.text) {
        setState(() {
          _errorMessage = 'Passcodes do not match';
        });
        return;
      }

      await PasscodeService.savePasscode(_passcodeController.text);
      
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => HomePage(passcode: _passcodeController.text),
          ),
        );
      }
    } else {
      // Login mode - verify passcode
      final isValid = await PasscodeService.verifyPasscode(_passcodeController.text);
      
      if (isValid) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => HomePage(passcode: _passcodeController.text),
            ),
          );
        }
      } else {
        setState(() {
          _errorMessage = 'Incorrect passcode';
        });
        _passcodeController.clear();
      }
    }
  }

  @override
  void dispose() {
    _passcodeController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                _isSetupMode ? '> SETUP MASTER PASSCODE' : '> ENTER MASTER PASSCODE',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _isSetupMode
                    ? 'Create a numeric passcode for encryption'
                    : 'Required to decrypt your messages',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.5),
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              
              // Passcode input
              TextField(
                controller: _passcodeController,
                obscureText: _obscureText,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(
                  fontFamily: 'monospace',
                  color: Colors.white,
                  fontSize: 18,
                  letterSpacing: 4,
                ),
                decoration: InputDecoration(
                  labelText: 'PASSCODE',
                  labelStyle: TextStyle(
                    fontFamily: 'monospace',
                    color: Colors.white.withOpacity(0.7),
                    letterSpacing: 2,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 3),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 3),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                onSubmitted: (_) => _isSetupMode ? null : _handleSubmit(),
              ),
              
              if (_isSetupMode) ...[
                const SizedBox(height: 24),
                TextField(
                  controller: _confirmController,
                  obscureText: _obscureText,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    color: Colors.white,
                    fontSize: 18,
                    letterSpacing: 4,
                  ),
                  decoration: InputDecoration(
                    labelText: 'CONFIRM PASSCODE',
                    labelStyle: TextStyle(
                      fontFamily: 'monospace',
                      color: Colors.white.withOpacity(0.7),
                      letterSpacing: 2,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 3),
                    ),
                  ),
                  onSubmitted: (_) => _handleSubmit(),
                ),
              ],
              
              const SizedBox(height: 32),
              
              // Submit button
              SizedBox(
                height: 56,
                child: OutlinedButton(
                  onPressed: _handleSubmit,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 2),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: Text(
                    _isSetupMode ? '> CREATE' : '> UNLOCK',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                ),
              ),
              
              // Error message
              if (_errorMessage.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2),
                  ),
                  child: Text(
                    '! ERROR: $_errorMessage',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      color: Colors.red,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              
              // Info box
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '> HOW IT WORKS:',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '1. Each digit shifts letters\n'
                      '2. Pattern repeats per character\n'
                      '3. Base64 encoding applied\n'
                      '4. ROT13 final layer',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 10,
                        height: 1.5,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
