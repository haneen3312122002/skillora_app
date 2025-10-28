import 'package:notes_tasks/cart/data/datasources/get_cart_by_id_remote_datasource.dart';
import 'package:notes_tasks/cart/domain/entities/cart_entity.dart';
import 'package:notes_tasks/cart/domain/repositories/get_cart_by_id_repo.dart';

class GetCartByIdRepoImpl implements IGetCartByIdRepo {
  final IGetCartByIdRemoteDataSource dataSource;

  GetCartByIdRepoImpl(this.dataSource);

  @override
  Future<CartEntity> getCartById(int id) async {
    final model = await dataSource.getCartById(id);
    return model.toEntity();
  }
}
