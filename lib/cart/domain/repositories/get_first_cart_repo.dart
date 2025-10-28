import 'package:notes_tasks/cart/domain/entities/cart_entity.dart';

abstract class IGetFirstCartRepo {
  Future<CartEntity> getFirstCart();
}
