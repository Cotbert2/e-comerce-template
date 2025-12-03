import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<bool> register(String name, String email, String password, String phone);
}

abstract class AuthLocalDataSource {
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final GraphQLClient client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> login(String email, String password) async {
    const String mutation = '''
      query Login(\$data: UserInput!) {
        login(data: \$data) {
          id
          name
          email
          phone
        }
      }
    ''';

    final QueryOptions options = QueryOptions(
      document: gql(mutation),
      variables: {
        'data': {
          'email': email,
          'password': password,
        }
      },
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final userData = result.data?['login'];
    if (userData == null) {
      throw Exception('Login failed');
    }

    return UserModel.fromJson(userData);
  }

  @override
  Future<bool> register(String name, String email, String password, String phone) async {
    const String mutation = '''
      mutation Signup(\$data: UserInput!) {
        singup(data: \$data)
      }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(mutation),
      variables: {
        'data': {
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'role': 'customer', // Add the required role field
        }
      },
    );

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    return result.data?['singup'] == true;
  }
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _userKey = 'cached_user';

  @override
  Future<UserModel?> getCachedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);
    
    if (userData == null) return null;
    
    // In a real app, you'd decode from JSON
    // For simplicity, we'll return null here
    return null;
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    // In a real app, you'd encode to JSON
    await prefs.setString(_userKey, user.toJson().toString());
  }

  @override
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}