import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/cart/domain/entities/cart_entity.dart';
import 'package:notes_tasks/cart/domain/usecases/get_first_cart_usecase.dart';
import 'package:notes_tasks/cart/presentation/providers/cart_providers.dart';

final getFirstCartViewModelProvider =
    AsyncNotifierProvider<GetFirstCartViewModel, CartEntity?>(
      GetFirstCartViewModel.new,
    );

class GetFirstCartViewModel extends AsyncNotifier<CartEntity?> {
  late final GetFirstCartUseCase _getFirstCartUseCase = ref.read(
    getFirstCartUseCaseProvider,
  );

  @override
  FutureOr<CartEntity?> build() async => null;

  Future<void> fetchFirstCart() async {
    state = const AsyncLoading();
    try {
      final cart = await _getFirstCartUseCase.call();
      state = AsyncData(cart);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void clearCart() => state = const AsyncData(null);
}
