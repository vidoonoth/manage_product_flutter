import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../config/config.dart';
import '../config/logger.dart';

class ApiService {
  
  static Future<List<Product>> getProduct() async {
    final response = await http.get(Uri.parse('${Config.baseUrl}/read.php'));
    logger.i('Attempting to call API at: $response');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    } else {      
      throw Exception('Gagal memuat data produk');
    }
  }

  static Future<bool> addProduct(
    String nama,
    String deskripsi,
    int harga,
  ) async {
    final response = await http.post(
      Uri.parse('${Config.baseUrl}/create.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nama': nama, 'deskripsi': deskripsi, 'harga': harga}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['success'] == true;
    } else {
      return false;
    }
  }

  static Future<bool> editProduct(
    String id,
    String nama,
    String deskripsi,
    int harga,
  ) async {
    final response = await http.post(
      Uri.parse('${Config.baseUrl}/update.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': id,
        'nama': nama,
        'deskripsi': deskripsi,
        'harga': harga,
      }),
    );

    final data = json.decode(response.body);
    return data['message'] == "Product berhasil diperbarui";
  }

  static Future<bool> deleteProduct(String id) async {
    final response = await http.post(
      Uri.parse('${Config.baseUrl}/delete.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['success'] == true;
    } else {
      return false;
    }
  }
}
