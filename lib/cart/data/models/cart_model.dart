import 'package:notes_tasks/cart/domain/entities/cart_entity.dart';
import 'package:notes_tasks/cart/data/models/product_model.dart';

class CartModel extends CartEntity {
  const CartModel({
    required super.id,
    required super.total,
    required super.discountedTotal,
    required super.userId,
    required super.totalProducts,
    required super.totalQuantity,
    required super.products,
  });

  factory CartModel.fromMap(Map<String, dynamic> map) {
    final List productsData = map['products'] ?? [];

    return CartModel(
      id: map['id'] ?? 0,
      total: (map['total'] ?? 0).toDouble(),
      discountedTotal: (map['discountedTotal'] ?? 0).toDouble(),
      userId: map['userId'] ?? 0,
      totalProducts: map['totalProducts'] ?? 0,
      totalQuantity: map['totalQuantity'] ?? 0,
      products: productsData.map((p) => ProductModel.fromMap(p)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'total': total,
    'discountedTotal': discountedTotal,
    'userId': userId,
    'totalProducts': totalProducts,
    'totalQuantity': totalQuantity,
    'products': products.map((p) {
      if (p is ProductModel) return p.toJson();
      return {
        'id': p.id,
        'title': p.title,
        'price': p.price,
        'quantity': p.quantity,
        'total': p.total,
        'discountPercentage': p.discountPercentage,
        'discountedTotal': p.discountedTotal,
        'thumbnail': p.thumbnail,
      };
    }).toList(),
  };

  CartEntity toEntity() => this;
}
