import 'package:notes_tasks/cart/data/datasources/get_first_cart_remote_datasource.dart';
import 'package:notes_tasks/cart/domain/entities/cart_entity.dart';
import 'package:notes_tasks/cart/domain/repositories/get_first_cart_repo.dart';

class GetFirstCartRepoImpl implements IGetFirstCartRepo {
  final IGetFirstCartRemoteDataSource dataSource;

  GetFirstCartRepoImpl(this.dataSource);

  @override
  Future<CartEntity> getFirstCart() async {
    final model = await dataSource.getFirstCart();
    return model.toEntity();
  }
}
