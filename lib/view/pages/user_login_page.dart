import 'package:flutter/material.dart';
import 'package:wallet/domain/usecases/login_usecase.dart';
import 'package:wallet/view/widgets/error_dialog.dart';

class UserLoginPage extends StatelessWidget {
  final LoginUseCase loginUseCase;




  UserLoginPage({required this.loginUseCase});
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _login(BuildContext context) async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    final user = await loginUseCase(username, password);

    if (user != null) {
      // Navigate to the manager or user home page based on user role
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => ErrorDialog(message: 'Invalid username or password.'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: usernameController, decoration: InputDecoration(labelText: 'Username')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password')),
            ElevatedButton(
              onPressed: () => _login(context),
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
