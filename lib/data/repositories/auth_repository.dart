import '../../core/network/dio_helper.dart';
import '../models/user_model.dart';
import '../../core/cache/cache_helper.dart';


class AuthRepository {
  Future<UserModel> login({required String email, required String password}) async {
// Replace with real endpoint
    final response = await DioHelper.post('/auth/login', data: {'email': email, 'password': password});
// Assuming response.data contains token, id, email
    final user = UserModel.fromJson(response.data);
    await CacheHelper.saveData(key: 'token', value: user.token);
    return user;
  }


  Future<UserModel> register({required String email, required String password}) async {
    final response = await DioHelper.post('/auth/register', data: {'email': email, 'password': password});
    final user = UserModel.fromJson(response.data);
    await CacheHelper.saveData(key: 'token', value: user.token);
    return user;
  }


  Future<void> logout() async {
    await CacheHelper.removeData(key: 'token');
  }
}