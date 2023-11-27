import 'package:wallet/domain/entities/user.dart';
import 'package:wallet/domain/repositories/user_repository.dart';

class LoginUseCase {
  final UserRepository userRepository;

  LoginUseCase({required this.userRepository});

  Future<User?> call(String username, String password) async {
    return await userRepository.getUser(username, password);
  }
}
