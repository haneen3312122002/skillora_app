import 'package:notes_tasks/auth/data/models/auth_model.dart';

abstract class ILoginApiService {
  Future<AuthModel> login({required String username, required String password});
}
