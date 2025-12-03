import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  AuthProvider({required this.authRepository});

  // State
  AuthState _authState = AuthState.initial;
  User? _currentUser;
  String? _errorMessage;

  // Getters
  AuthState get authState => _authState;
  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _authState == AuthState.authenticated;
  bool get isLoading => _authState == AuthState.loading;

  Future<void> checkAuthStatus() async {
    _authState = AuthState.loading;
    notifyListeners();

    try {
      _currentUser = await authRepository.getCurrentUser();
      if (_currentUser != null) {
        _authState = AuthState.authenticated;
      } else {
        _authState = AuthState.unauthenticated;
      }
    } catch (e) {
      _authState = AuthState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _authState = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await authRepository.login(email, password);
      _authState = AuthState.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _authState = AuthState.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password, String phone) async {
    _authState = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await authRepository.register(name, email, password, phone);
      if (success) {
        _authState = AuthState.unauthenticated;
      } else {
        _authState = AuthState.error;
        _errorMessage = 'Registration failed';
      }
      notifyListeners();
      return success;
    } catch (e) {
      _authState = AuthState.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await authRepository.logout();
      _currentUser = null;
      _authState = AuthState.unauthenticated;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}