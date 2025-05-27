class Product {
  final String id;
  final String nama;
  final String deskripsi;
  final int harga;

  Product({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.harga,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      nama: json['nama'],
      deskripsi: json['deskripsi'],    
      harga: int.parse(json['harga'].toString()), 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'deskripsi': deskripsi,
      'harga': harga,
    };
  }
}
