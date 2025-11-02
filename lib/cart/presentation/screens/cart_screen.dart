import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/cart/domain/entities/cart_entity.dart';
import 'package:notes_tasks/cart/presentation/viewmodels/get_first_cart_viewmodel.dart';
import 'package:notes_tasks/cart/presentation/widgets/product_item.dart';
import 'package:notes_tasks/cart/presentation/widgets/cart_summary.dart';

class FirstCartScreen extends ConsumerStatefulWidget {
  const FirstCartScreen({super.key});

  @override
  ConsumerState<FirstCartScreen> createState() => _FirstCartScreenState();
}

class _FirstCartScreenState extends ConsumerState<FirstCartScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(getFirstCartViewModelProvider.notifier).fetchFirstCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(getFirstCartViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('🛒 First Cart')),
      body: cartState.when(
        data: (CartEntity? cart) {
          if (cart == null) {
            return Center(child: Text('no_cart_found'.tr()));
          }

          return RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(getFirstCartViewModelProvider.notifier)
                  .fetchFirstCart();
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                CartSummary(cart: cart),
                const Divider(height: 30),
                ...cart.products.map((p) => ProductItem(product: p)),
              ],
            ),
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 40),
              const SizedBox(height: 8),
              Text(
                'Failed to load cart: $e',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => ref
                    .read(getFirstCartViewModelProvider.notifier)
                    .fetchFirstCart(),
                icon: const Icon(Icons.refresh),
                label: Text('retry'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
