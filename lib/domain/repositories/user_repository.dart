import 'package:wallet/domain/entities/user.dart';

abstract class UserRepository {
  Future<User?> getUser(String username, String password);
  Future<void> createUser(User user);
  Future<List<User>> getUsers();
  Future<void> updateUser(User user);
  Future<void> deleteUser(User user);
}
