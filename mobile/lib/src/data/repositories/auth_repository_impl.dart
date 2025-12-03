import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<User> login(String email, String password) async {
    try {
      final user = await remoteDataSource.login(email, password);
      await localDataSource.cacheUser(user);
      return user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<bool> register(String name, String email, String password, String phone) async {
    try {
      return await remoteDataSource.register(name, email, password, phone);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      return await localDataSource.getCachedUser();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await localDataSource.clearUser();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }
}