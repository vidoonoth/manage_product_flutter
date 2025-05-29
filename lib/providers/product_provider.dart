import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/product_prefs.dart';
import '../config/logger.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts({bool fromCache = false}) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (fromCache) {
        _products = await ProductPrefs.loadProducts();
      } else {
        _products = await ApiService.getProduct();
        await ProductPrefs.saveProducts(_products);
      }
    } catch (e) {
      logger.e('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addProduct(String nama, String deskripsi, int harga) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await ApiService.addProduct(nama, deskripsi, harga);
      if (result) {
        await fetchProducts();
      }
      return result;
    } catch (e) {
      logger.e('Error adding product: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProduct(
    String id,
    String nama,
    String deskripsi,
    int harga,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await ApiService.editProduct(id, nama, deskripsi, harga);
      if (result) {
        await fetchProducts();
      }
      return result;
    } catch (e) {
      logger.e('Error updating product: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteProduct(String id) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await ApiService.deleteProduct(id);
      if (result) {
        await fetchProducts();
      }
      return result;
    } catch (e) {
      logger.e('Error deleting product: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
