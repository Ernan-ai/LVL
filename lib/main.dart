import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/encryption_service.dart';
import 'services/storage_service.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const EncrypApp());
}

class EncrypApp extends StatelessWidget {
  const EncrypApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LVL Encryp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.white,
          surface: Colors.black,
          error: Colors.red,
          onPrimary: Colors.black,
          onSecondary: Colors.black,
          onSurface: Colors.white,
          onError: Colors.white,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontFamily: 'monospace',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 3,
          ),
        ),
        cardTheme: const CardThemeData(
          color: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            side: BorderSide(color: Colors.white, width: 2),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.black,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: Colors.white, width: 3),
          ),
          labelStyle: const TextStyle(
            fontFamily: 'monospace',
            color: Colors.white,
            letterSpacing: 2,
          ),
          hintStyle: TextStyle(
            fontFamily: 'monospace',
            color: Colors.white.withOpacity(0.3),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'monospace', color: Colors.white),
          bodyMedium: TextStyle(fontFamily: 'monospace', color: Colors.white),
          bodySmall: TextStyle(fontFamily: 'monospace', color: Colors.white),
          titleLarge: TextStyle(fontFamily: 'monospace', color: Colors.white, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontFamily: 'monospace', color: Colors.white, fontWeight: FontWeight.bold),
          titleSmall: TextStyle(fontFamily: 'monospace', color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            textStyle: const TextStyle(
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        tabBarTheme: const TabBarThemeData(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.white,
          labelStyle: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontFamily: 'monospace'),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  final String passcode;
  
  const HomePage({super.key, required this.passcode});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String _passcode;
  
  @override
  void initState() {
    super.initState();
    _passcode = widget.passcode;
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('> LVL ENCRYP'),
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '> ENCRYPT'),
            Tab(text: '> DECRYPT'),
            Tab(text: '> SAVED'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          EncryptTab(passcode: _passcode),
          DecryptTab(passcode: _passcode),
          SavedCredentialsTab(passcode: _passcode),
        ],
      ),
    );
  }
}

class EncryptTab extends StatefulWidget {
  final String passcode;
  
  const EncryptTab({super.key, required this.passcode});

  @override
  State<EncryptTab> createState() => _EncryptTabState();
}

class _EncryptTabState extends State<EncryptTab> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  String _encryptedText = '';
  
  @override
  void dispose() {
    _inputController.dispose();
    _titleController.dispose();
    super.dispose();
  }
  
  void _encrypt() {
    if (_inputController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('! ERROR: Please enter text to encrypt'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    setState(() {
      _encryptedText = EncryptionService.encrypt(_inputController.text, widget.passcode);
    });
  }
  
  void _copyToClipboard() {
    if (_encryptedText.isEmpty) return;
    Clipboard.setData(ClipboardData(text: _encryptedText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('> COPIED TO CLIPBOARD'),
        backgroundColor: Colors.white,
        duration: Duration(seconds: 1),
      ),
    );
  }
  
  Future<void> _saveCredential() async {
    if (_titleController.text.isEmpty || _inputController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('! ERROR: Please enter title and password'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    List<Map<String, String>> credentials = await StorageService.loadCredentials();
    credentials.add({
      'title': _titleController.text,
      'username': '',
      'password': _encryptedText.isEmpty 
        ? EncryptionService.encrypt(_inputController.text, widget.passcode) 
        : _encryptedText,
    });
    
    await StorageService.saveCredentials(credentials);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('> CREDENTIAL SAVED'),
          backgroundColor: Colors.white,
        ),
      );
      _titleController.clear();
      _inputController.clear();
      setState(() {
        _encryptedText = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '> INPUT TEXT',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _inputController,
                    maxLines: 5,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'enter_text_here...',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _encrypt,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('> ENCRYPT'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_encryptedText.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '> ENCRYPTED OUTPUT',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        IconButton(
                          onPressed: _copyToClipboard,
                          icon: const Icon(Icons.copy),
                          tooltip: 'Copy',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: SelectableText(
                        _encryptedText,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          color: Colors.greenAccent,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '> SAVE CREDENTIAL',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _titleController,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'title_name',
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _saveCredential,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text('> SAVE'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class DecryptTab extends StatefulWidget {
  final String passcode;
  
  const DecryptTab({super.key, required this.passcode});

  @override
  State<DecryptTab> createState() => _DecryptTabState();
}

class _DecryptTabState extends State<DecryptTab> {
  final TextEditingController _inputController = TextEditingController();
  String _decryptedText = '';
  
  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
  
  void _decrypt() {
    if (_inputController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('! ERROR: Please enter text to decrypt'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    setState(() {
      _decryptedText = EncryptionService.decrypt(_inputController.text, widget.passcode);
    });
  }
  
  void _copyToClipboard() {
    if (_decryptedText.isEmpty) return;
    Clipboard.setData(ClipboardData(text: _decryptedText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('> COPIED TO CLIPBOARD'),
        backgroundColor: Colors.white,
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '> ENCRYPTED INPUT',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _inputController,
                    maxLines: 5,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'paste_encrypted_text...',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _decrypt,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('> DECRYPT'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_decryptedText.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '> DECRYPTED OUTPUT',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        IconButton(
                          onPressed: _copyToClipboard,
                          icon: const Icon(Icons.copy, color: Colors.white),
                          tooltip: '[COPY]',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: SelectableText(
                        _decryptedText,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          color: Colors.greenAccent,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class SavedCredentialsTab extends StatefulWidget {
  final String passcode;
  
  const SavedCredentialsTab({super.key, required this.passcode});

  @override
  State<SavedCredentialsTab> createState() => _SavedCredentialsTabState();
}

class _SavedCredentialsTabState extends State<SavedCredentialsTab> {
  List<Map<String, String>> _credentials = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }
  
  Future<void> _loadCredentials() async {
    setState(() => _isLoading = true);
    _credentials = await StorageService.loadCredentials();
    setState(() => _isLoading = false);
  }
  
  Future<void> _deleteCredential(int index) async {
    _credentials.removeAt(index);
    await StorageService.saveCredentials(_credentials);
    setState(() {});
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('> CREDENTIAL DELETED'),
          backgroundColor: Colors.white,
        ),
      );
    }
  }
  
  void _showDecryptedPassword(String encryptedPassword) {
    String decrypted = EncryptionService.decrypt(encryptedPassword, widget.passcode);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: Colors.white, width: 2),
        ),
        title: const Text(
          '> DECRYPTED PASSWORD',
          style: TextStyle(
            fontFamily: 'monospace',
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        content: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            border: Border.all(color: Colors.white, width: 1),
          ),
          child: SelectableText(
            decrypted,
            style: const TextStyle(
              fontFamily: 'monospace',
              color: Colors.greenAccent,
              fontSize: 16,
            ),
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: decrypted));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('> PASSWORD COPIED'),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              );
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
              '> COPY',
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white, width: 2),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
            child: const Text(
              '> CLOSE',
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
    
    if (_credentials.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.lock_outline,
                size: 64,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '> NO SAVED CREDENTIALS',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'encrypt_and_save_your_login_details',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _credentials.length,
      itemBuilder: (context, index) {
        final credential = _credentials[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Center(
                child: Text(
                  credential['title']![0].toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: Text(
              '> ${credential['title']!.toUpperCase()}',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
            subtitle: Text(
              credential['password']!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility, color: Colors.white),
                  onPressed: () => _showDecryptedPassword(credential['password']!),
                  tooltip: '[VIEW]',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: () => _deleteCredential(index),
                  tooltip: '[DELETE]',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
