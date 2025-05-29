import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'home_page_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.blue.shade50, // Ubah dari deepPurple ke blue
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo atau Icon Aplikasi
              CircleAvatar(
                radius: 48,
                backgroundColor:
                    Colors.blue.shade100, // Ubah dari deepPurple ke blue
                child: Icon(
                  Icons.inventory_2_rounded,
                  size: 56,
                  color: Colors.blue[400], // Ubah dari deepPurple ke blue
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Manajemen Produk',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700], // Ubah dari deepPurple ke blue
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Kelola produk dan catatan aktivitas Anda dengan mudah',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue[400], // Ubah dari deepPurple ke blue
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                icon: Image.asset(
                  'assets/google_logo.png', // Pastikan Anda punya logo Google di assets
                  height: 24,
                  width: 24,
                ),
                label: const Text(
                  'Login dengan Google',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor:
                      Colors.blue[400], // Ubah dari deepPurple ke blue
                  minimumSize: const Size(double.infinity, 48),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(
                    color: Colors.blue[400]!,
                    width: 1.2,
                  ), // Ubah dari deepPurple ke blue
                  shadowColor:
                      Colors.blue.shade100, // Ubah dari deepPurple ke blue
                ),
                onPressed: () async {
                  try {
                    await authProvider.signInWithGoogle();
                    if (authProvider.user != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Login gagal: $e')));
                  }
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Akses aman & cepat menggunakan akun Google Anda',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.blue[300], // Ubah dari deepPurple ke blue
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
