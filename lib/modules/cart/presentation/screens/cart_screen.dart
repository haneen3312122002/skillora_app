import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/widgets/primary_button.dart';
import 'package:notes_tasks/modules/cart/domain/entities/cart_entity.dart';
import 'package:notes_tasks/modules/cart/presentation/viewmodels/get_first_cart_viewmodel.dart';
import 'package:notes_tasks/modules/cart/presentation/widgets/product_item.dart';
import 'package:notes_tasks/modules/cart/presentation/widgets/cart_summary.dart';
import 'package:notes_tasks/core/widgets/app_scaffold.dart';
import 'package:notes_tasks/core/widgets/empty_vieq.dart';
import 'package:notes_tasks/core/widgets/error_view.dart';
import 'package:notes_tasks/core/widgets/loading_indicator.dart';

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

    return AppScaffold(
      title: '${'first_cart'.tr()}',
      scrollable: false,
      body: cartState.when(
        data: (CartEntity? cart) {
          if (cart == null) {
            return const EmptyView(message: 'no_cart_found');
          }

          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await ref
                        .read(getFirstCartViewModelProvider.notifier)
                        .fetchFirstCart();
                  },

                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),

                    padding: const EdgeInsets.all(16),

                    children: [
                      const Divider(height: 30),

                      ...cart.products.map((p) => ProductItem(product: p)),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),

                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // <--- هام: لنشر العناصر

                  children: [
                    // 1. ملخص السلة (يحتل مساحة أكبر قليلاً)
                    Expanded(
                      flex: 3, // نمنحه وزن 3

                      child: CartSummary(cart: cart),
                    ),

                    const SizedBox(
                      width: 16,
                    ), // <--- إضافة مسافة بين الملخص والزر
                    // 2. زر إتمام الطلب (يحتل مساحة أقل)
                    Expanded(
                      flex: 4, // نمنحه وزن 4 (لأن زر الشراء مهم ويحتاج مساحة)

                      child: AppPrimaryButton(
                        label: 'checkout'.tr(),

                        onPressed: () {
                          print('Proceeding to Checkout!');
                        },

                        icon: Icons.shopping_bag_outlined,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const LoadingIndicator(
          withBackground: false,
          message: 'loading_msg',
        ),
        error: (e, _) => ErrorView(
          message: 'error_general'.tr() + '\n$e',
          onRetry: () =>
              ref.read(getFirstCartViewModelProvider.notifier).fetchFirstCart(),
        ),
      ),
      actions: [],
    );
  }
}
