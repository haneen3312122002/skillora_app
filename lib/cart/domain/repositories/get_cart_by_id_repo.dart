import 'package:notes_tasks/cart/domain/entities/cart_entity.dart';

abstract class IGetCartByIdRepo {
  Future<CartEntity> getCartById(int id);
}
