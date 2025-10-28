import 'package:notes_tasks/cart/api/get_first_cart_api/i_get_first_cart_api_service.dart';
import 'package:notes_tasks/cart/data/models/cart_model.dart';

abstract class IGetFirstCartRemoteDataSource {
  Future<CartModel> getFirstCart();
}

class GetFirstCartRemoteDataSource implements IGetFirstCartRemoteDataSource {
  final IGetFirstCartApiService api;

  GetFirstCartRemoteDataSource(this.api);

  @override
  Future<CartModel> getFirstCart() async {
    final data = await api.getFirstCart();
    return CartModel.fromMap(data);
  }
}
