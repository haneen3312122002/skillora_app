import 'package:flutter/material.dart';
import 'package:notes_tasks/cart/domain/entities/cart_entity.dart';

class CartSummary extends StatelessWidget {
  final CartEntity cart;

  const CartSummary({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Products: ${cart.totalProducts} | Quantity: ${cart.totalQuantity}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        Text(
          'Total: \$${cart.discountedTotal.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}
