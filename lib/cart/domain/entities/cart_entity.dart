import 'package:notes_tasks/cart/domain/entities/product_entity.dart';

class CartEntity {
  final int id;
  final double total;
  final double discountedTotal;
  final int userId;
  final int totalProducts;
  final int totalQuantity;
  final List<ProductEntity> products;

  const CartEntity({
    required this.id,
    required this.total,
    required this.discountedTotal,
    required this.userId,
    required this.totalProducts,
    required this.totalQuantity,
    required this.products,
  });
}
