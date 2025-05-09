import 'package:flutter/material.dart';
export 'product.dart';

// criação de variáveis para armazenar os dados dos produtos
class Product {
  final String name;
  final String price;
  final String description;
  final String imageName;

  Product(this.name, this.price, this.description, this.imageName);
  AssetImage get image => AssetImage('assets/images/$imageName.png');
}


// lista de produtos
List<Product> products = <Product>[
  Product('Camiseta', 'R\$39,90', 'Camiseta branca', 'camiseta'),
  Product('Calça', 'R\$59,90', 'Calça jeans', 'calca'),
  Product('Bermuda', 'R\$49,90', 'Bermuda verde', 'bermuda'),
  Product('Sapato', 'R\$89,90', 'Sapato preto', 'sapato'),
  Product('Boné', 'R\$29,90', 'Boné cinza', 'bone'),
];
