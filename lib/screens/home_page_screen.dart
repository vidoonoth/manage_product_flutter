import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'login_screen.dart';
import 'note_screen.dart';
import 'product_screen.dart';
import '../services/product_prefs.dart'; // Tambahkan import ini

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [const ProductScreen(), const NoteScreen()];

  final List<String> _titles = ['Manajemen Produk', 'Catatan Aktivitas'];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex], style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255))),
        backgroundColor: Colors.blue[400], // Ubah warna AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color.fromARGB(255, 255, 255, 255)),
            onPressed: () async {
              await userProvider.signOut();
              await ProductPrefs.clearProducts();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue[400], // Ubah warna BottomNavigationBar
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_alt_sharp),
            label: "Catatan",
          ),
        ],
      ),
    );
  }
}
