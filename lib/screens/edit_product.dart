import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController _namaController;
  late TextEditingController _deskripsiController;
  late TextEditingController _hargaController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.product.nama);
    _deskripsiController = TextEditingController(
      text: widget.product.deskripsi,
    );
    _hargaController = TextEditingController(
      text: widget.product.harga.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Produk")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: 'Nama Produk'),
              validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
            ),
            TextFormField(
              controller: _deskripsiController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
              validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
            ),
            TextFormField(
              controller: _hargaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Harga'),
              validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 20),
            productProvider.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: () async {
                    final navigator = Navigator.of(
                      context,
                    ); 
                    final messenger = ScaffoldMessenger.of(context);

                    if (_namaController.text.isEmpty ||
                        _deskripsiController.text.isEmpty ||
                        _hargaController.text.isEmpty) {
                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text('Semua field harus diisi'),
                        ),
                      );
                      return;
                    }

                    final id = widget.product.id;
                    final nama = _namaController.text;
                    final deskripsi = _deskripsiController.text;
                    final harga = int.tryParse(_hargaController.text) ?? 0;

                    final result = await productProvider.updateProduct(
                      id,
                      nama,
                      deskripsi,
                      harga,
                    );

                    if (!mounted) return;
                    if (result) {
                      navigator.pop(); 
                    }
                  },
                  child: const Text('Perbarui'),
                ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _hargaController.dispose();
    super.dispose();
  }
}
