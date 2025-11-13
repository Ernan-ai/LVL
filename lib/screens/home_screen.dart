import 'package:flutter/material.dart';
import 'dart:io';
import '../services/storage_service.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, int> _stats = {};
  String? _username;
  String? _profilePicturePath;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final stats = await StorageService.getStatistics();
    final username = await StorageService.getUsername();
    final profilePic = await StorageService.getProfilePicture();
    setState(() {
      _stats = stats;
      _username = username;
      _profilePicturePath = profilePic;
      _isLoading = false;
    });
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: kSoftWhite),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      color: kAccentColor,
      backgroundColor: Colors.black,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                width: 80,
                height: 80,
                color: kSoftWhite,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: kSoftWhite, width: 2),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'LVL',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: kSoftWhite,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            // Welcome header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Profile picture
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(color: kSoftWhite, width: 2),
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
                                width: 40,
                                height: 40,
                                color: kSoftWhite,
                                errorBuilder: (context, error, stackTrace) {
                                  return Text(
                                    _username != null && _username!.isNotEmpty
                                        ? _username![0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: kSoftWhite,
                                    ),
                                  );
                                },
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '> Welcome back,',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              color: kSoftWhite.withOpacity(0.7),
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _username?.toUpperCase() ?? 'USER',
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
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Statistics title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Text(
                '> STATISTICS',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: kSoftWhite,
                  letterSpacing: 2,
                ),
              ),
            ),
            
            // Stats cards
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: kSoftWhite, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.lock,
                              color: kSoftWhite,
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${_stats['encryptCount'] ?? 0}',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: kSoftWhite,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'ENCRYPTED',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 10,
                              color: kSoftWhite.withOpacity(0.6),
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: kSoftWhite, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.lock_open,
                              color: kSoftWhite,
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${_stats['decryptCount'] ?? 0}',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: kSoftWhite,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'DECRYPTED',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 10,
                              color: kSoftWhite.withOpacity(0.6),
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Data volume card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '> DATA VOLUME',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: kSoftWhite.withOpacity(0.9),
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Encrypted',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 11,
                                  color: kSoftWhite.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatBytes(_stats['encryptedBytes'] ?? 0),
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: kSoftWhite,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: kSoftWhite.withOpacity(0.3),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Decrypted',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 11,
                                  color: kSoftWhite.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatBytes(_stats['decryptedBytes'] ?? 0),
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: kSoftWhite,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            // Total operations card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: kSoftWhite,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.analytics,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Operations',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              color: kSoftWhite.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${(_stats['encryptCount'] ?? 0) + (_stats['decryptCount'] ?? 0)}',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: kSoftWhite,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
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
}
