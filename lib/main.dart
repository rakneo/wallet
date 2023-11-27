import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet/data/repositories/user_repository_impl.dart';
import 'package:wallet/data/repositories/wallet_repository_impl.dart';
import 'package:wallet/domain/usecases/create_wallet_usecase.dart';
import 'package:wallet/domain/usecases/deposit_money_usecase.dart';
import 'package:wallet/domain/usecases/login_usecase.dart';
import 'package:wallet/domain/usecases/withdraw_money_usecase.dart';
import 'package:wallet/view/pages/manager_home_page.dart';
import 'package:wallet/view/pages/user_home_page.dart';
import 'package:wallet/view/pages/user_login_page.dart';

import 'domain/entities/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that Flutter has initialized

  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  runApp(MyApp(
    userRepository: UserRepositoryImpl(sharedPreferences: sharedPreferences),
    walletRepository: WalletRepositoryImpl(sharedPreferences: sharedPreferences),
  ));
}

class MyApp extends StatelessWidget {

  final UserRepositoryImpl userRepository;
  final WalletRepositoryImpl walletRepository;
  final LoginUseCase loginUseCase;
  final CreateWalletUseCase createWalletUseCase;
  final DepositMoneyUseCase depositMoneyUseCase;
  final WithdrawMoneyUseCase withdrawMoneyUseCase;


  MyApp({
    required this.userRepository,
    required this.walletRepository,
  })  : loginUseCase = LoginUseCase(userRepository: userRepository),
        createWalletUseCase = CreateWalletUseCase(walletRepository: walletRepository),
        depositMoneyUseCase = DepositMoneyUseCase(walletRepository: walletRepository),
        withdrawMoneyUseCase = WithdrawMoneyUseCase(walletRepository: walletRepository);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallet App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (BuildContext context) => UserLoginPage(loginUseCase: loginUseCase),
        '/manager': (BuildContext context) => ManagerHomePage(
          managerUser: User(id: '1', username: 'manager', password: 'password'),
          createWalletUseCase: createWalletUseCase,
          depositMoneyUseCase: depositMoneyUseCase,
          walletRepository: walletRepository,
        ),
        '/user': (BuildContext context) => UserHomePage(
          wallets: [], // Pass user's wallets list
          depositMoneyUseCase: depositMoneyUseCase,
          withdrawMoneyUseCase: withdrawMoneyUseCase,
        ),
      },
    );
  }
}
