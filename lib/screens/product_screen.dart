import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../components/product_card.dart';
import '../screens/create_product.dart';
import '../providers/product_provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final productProvider = Provider.of<ProductProvider>(
        context,
        listen: false,
      );
      productProvider.fetchProducts(fromCache: true);
      productProvider.fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50, 
              Colors.blue.shade100,
            ],
          ),
        ),
        child: Stack(
          children: [
            RefreshIndicator(
              color: Colors.deepPurple,
              onRefresh: () => productProvider.fetchProducts(),
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver:
                        productProvider.isLoading
                            ? SliverFillRemaining(
                              child: Center(
                                child: SpinKitFadingCircle(
                                  color: theme.primaryColor,
                                  size: 50.0,
                                ),
                              ),
                            )
                            : productProvider.products.isEmpty
                            ? SliverFillRemaining(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.inventory_2_outlined,
                                      size: 64,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      "Belum ada produk",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Tambahkan produk pertama Anda",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            : SliverList(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: ProductCard(
                                    product: productProvider.products[index],
                                  ),
                                );
                              }, childCount: productProvider.products.length),
                            ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 24,
              right: 24,
              child: FloatingActionButton.extended(
                backgroundColor: Colors.blue[400], // Ubah warna FAB
                foregroundColor: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateProductScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text("Tambah Produk"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
