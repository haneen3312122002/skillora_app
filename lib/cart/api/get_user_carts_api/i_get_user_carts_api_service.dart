abstract class IGetUserCartsApiService {
  Future<List<Map<String, dynamic>>> getUserCarts(int userId);
}
