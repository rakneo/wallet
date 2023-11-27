import 'package:wallet/domain/entities/wallet.dart';
import 'package:wallet/domain/repositories/wallet_repository.dart';

class WithdrawMoneyUseCase {
  final WalletRepository walletRepository;

  WithdrawMoneyUseCase({required this.walletRepository});

  Future<void> call(Wallet wallet, double amount) async {
    if (amount <= 0) {
      throw Exception('Invalid amount.');
    }
    if (wallet.balance < amount) {
      throw Exception('Insufficient balance.');
    }

    wallet.balance -= amount;
    await walletRepository.updateWallet(wallet);
  }
}
