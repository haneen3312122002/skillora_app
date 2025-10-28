import 'package:notes_tasks/cart/api/get_user_carts_api/i_get_user_carts_api_service.dart';
import 'package:notes_tasks/cart/data/models/cart_model.dart';

abstract class IGetUserCartsRemoteDataSource {
  Future<List<CartModel>> getUserCarts(int userId);
}

class GetUserCartsRemoteDataSource implements IGetUserCartsRemoteDataSource {
  final IGetUserCartsApiService api;

  GetUserCartsRemoteDataSource(this.api);

  @override
  Future<List<CartModel>> getUserCarts(int userId) async {
    final data = await api.getUserCarts(userId);
    return data.map((e) => CartModel.fromMap(e)).toList();
  }
}
