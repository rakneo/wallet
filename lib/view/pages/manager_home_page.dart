import 'package:flutter/material.dart';
import 'package:wallet/domain/entities/user.dart';
import 'package:wallet/domain/entities/wallet.dart';
import 'package:wallet/domain/repositories/wallet_repository.dart';
import 'package:wallet/domain/usecases/create_wallet_usecase.dart';
import 'package:wallet/domain/usecases/deposit_money_usecase.dart';
import 'package:wallet/view/widgets/error_dialog.dart';

class ManagerHomePage extends StatelessWidget {
  final User managerUser;
  final CreateWalletUseCase createWalletUseCase;
  final DepositMoneyUseCase depositMoneyUseCase;
  final WalletRepository walletRepository; // Add this line


  ManagerHomePage({
    required this.managerUser,
    required this.createWalletUseCase,
    required this.depositMoneyUseCase,
    required this.walletRepository,
  });

  TextEditingController userIdController = TextEditingController();
  TextEditingController walletIdController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  void _createWallet(BuildContext context) async {
    final userId = userIdController.text.trim();
    final walletId = walletIdController.text.trim();

    if (managerUser.id != userId) {
      showDialog(
        context: context,
        builder: (BuildContext context) => ErrorDialog(message: 'Manager cannot create wallets for other users.'),
      );
      return;
    }

    final wallet = Wallet(id: walletId, userId: userId, balance: 0);
    await createWalletUseCase(wallet);

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Success'),
        content: Text('Wallet created successfully.'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _depositMoney(BuildContext context) async {
    final userId = userIdController.text.trim();
    final walletId = walletIdController.text.trim();
    final amount = double.tryParse(amountController.text.trim());

    if (amount == null || amount <= 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) => ErrorDialog(message: 'Invalid amount.'),
      );
      return;
    }

    final wallets = await walletRepository.getWallets(userId);
    final wallet = wallets.firstWhere((w) => w.id == walletId);

    if (wallet == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) => ErrorDialog(message: 'Invalid user ID or wallet ID.'),
      );
      return;
    }

    await depositMoneyUseCase(wallet, amount);

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Success'),
        content: Text('Money deposited successfully.'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manager Home')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: userIdController, decoration: InputDecoration(labelText: 'User ID')),
            TextField(controller: walletIdController, decoration: InputDecoration(labelText: 'Wallet ID')),
            TextField(controller: amountController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Amount')),
            ElevatedButton(
              onPressed: () => _createWallet(context),
              child: Text('Create Wallet'),
            ),
            ElevatedButton(
              onPressed: () => _depositMoney(context),
              child: Text('Deposit Money'),
            ),
          ],
        ),
      ),
    );
  }
}
