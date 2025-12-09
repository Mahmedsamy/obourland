import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';


part 'auth_state.dart';


class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repo;
  AuthCubit(this._repo) : super(AuthInitial());


  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _repo.login(email: email, password: password);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }


  Future<void> register(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _repo.register(email: email, password: password);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }


  Future<void> logout() async {
    await _repo.logout();
    emit(AuthInitial());
  }
}