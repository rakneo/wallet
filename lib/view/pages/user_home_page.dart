import 'package:flutter/material.dart';
import 'package:wallet/domain/entities/wallet.dart';
import 'package:wallet/domain/usecases/deposit_money_usecase.dart';
import 'package:wallet/domain/usecases/withdraw_money_usecase.dart';
import 'package:wallet/view/widgets/error_dialog.dart';

class UserHomePage extends StatelessWidget {
  final List<Wallet> wallets;
  final DepositMoneyUseCase depositMoneyUseCase;
  final WithdrawMoneyUseCase withdrawMoneyUseCase;

  UserHomePage({
    required this.wallets,
    required this.depositMoneyUseCase,
    required this.withdrawMoneyUseCase,
  });

  TextEditingController walletIdController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  void _depositMoney(BuildContext context) async {
    final walletId = walletIdController.text.trim();
    final amount = double.tryParse(amountController.text.trim());

    if (amount == null || amount <= 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) => ErrorDialog(message: 'Invalid amount.'),
      );
      return;
    }

    final wallet = wallets.firstWhere((w) => w.id == walletId);

    if (wallet == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) => ErrorDialog(message: 'Invalid wallet ID.'),
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

  void _withdrawMoney(BuildContext context) async {
    final walletId = walletIdController.text.trim();
    final amount = double.tryParse(amountController.text.trim());

    if (amount == null || amount <= 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) => ErrorDialog(message: 'Invalid amount.'),
      );
      return;
    }

    final wallet = wallets.firstWhere((w) => w.id == walletId);

    if (wallet == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) => ErrorDialog(message: 'Invalid wallet ID.'),
      );
      return;
    }

    // Check if the balance is enough before withdrawing money

    await withdrawMoneyUseCase(wallet, amount);

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Success'),
        content: Text('Money withdrawn successfully.'),
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
      appBar: AppBar(title: Text('User Home')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display the list of wallets and their balances
            // ...
            TextField(controller: walletIdController, decoration: InputDecoration(labelText: 'Wallet ID')),
            TextField(controller: amountController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Amount')),
            ElevatedButton(
              onPressed: () => _depositMoney(context),
              child: Text('Deposit Money'),
            ),
            ElevatedButton(
              onPressed: () => _withdrawMoney(context),
              child: Text('Withdraw Money'),
            ),
          ],
        ),
      ),
    );
  }
}
