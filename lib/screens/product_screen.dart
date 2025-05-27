import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/product_card.dart';
import 'create_product.dart';
import '../providers/product_provider.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Produk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateProductScreen()),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => productProvider.fetchProducts(),
        child: productProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : productProvider.products.isEmpty
                ? const Center(child: Text("Tidak ada data"))
                : ListView.builder(
                    itemCount: productProvider.products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        product: productProvider.products[index],
                      );
                    },
                  ),
      ),
    );
  }
}