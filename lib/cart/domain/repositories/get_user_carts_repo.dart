import 'package:notes_tasks/cart/domain/entities/cart_entity.dart';

abstract class IGetUserCartsRepo {
  Future<List<CartEntity>> getUserCarts(int userId);
}
