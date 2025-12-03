import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<bool> register(String name, String email, String password, String phone);
  Future<User?> getCurrentUser();
  Future<void> logout();
}