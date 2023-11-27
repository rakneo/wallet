import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet/data/models/user_model.dart';
import 'package:wallet/domain/entities/user.dart';
import 'package:wallet/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final SharedPreferences sharedPreferences;

  UserRepositoryImpl({required this.sharedPreferences});

  @override
  Future<User?> getUser(String username, String password) async {
    final users = await getUsers();
    try {
      return users.firstWhere((user) => user.username == username && user.password == password);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> createUser(User user) async {
    final users = await getUsers();

    // Check if user already exists
    if (users.any((existingUser) => existingUser.username == user.username)) {
      throw Exception('Username already exists.');
    }
    users.add(user);

    await saveUsers(users);
  }

  @override
  Future<List<User>> getUsers() async {
    final userJsonList = sharedPreferences.getStringList('users') ?? [];
    return userJsonList.map((userJson) => UserModel.fromJson(userJson as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> updateUser(User user) async {
    final users = await getUsers();

    final index = users.indexWhere((existingUser) => existingUser.id == user.id);
    if (index != -1) {
      users[index] = user;
      await saveUsers(users);
    }
  }

  @override
  Future<void> deleteUser(User user) async {
    final users = await getUsers();

    users.removeWhere((existingUser) => existingUser.id == user.id);
    await saveUsers(users);
  }


  Future<void> saveUsers(List<User> users) async {
    final userJsonList = users.map((user) => user.toJson()).toList();
    final userStringList = userJsonList.map((json) => jsonEncode(json)).toList();
    await sharedPreferences.setStringList('users', userStringList);
  }


}
