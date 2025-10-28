import 'package:notes_tasks/cart/api/get_cart_by_id_api/i_get_cart_by_id_api_service.dart';
import 'package:notes_tasks/cart/data/models/cart_model.dart';

abstract class IGetCartByIdRemoteDataSource {
  Future<CartModel> getCartById(int id);
}

class GetCartByIdRemoteDataSource implements IGetCartByIdRemoteDataSource {
  final IGetCartByIdApiService api;

  GetCartByIdRemoteDataSource(this.api);

  @override
  Future<CartModel> getCartById(int id) async {
    final data = await api.getCartById(id);
    return CartModel.fromMap(data);
  }
}
