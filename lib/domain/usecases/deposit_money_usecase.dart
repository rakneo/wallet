import 'package:wallet/domain/entities/wallet.dart';
import 'package:wallet/domain/repositories/wallet_repository.dart';

class DepositMoneyUseCase {
  final WalletRepository walletRepository;

  DepositMoneyUseCase({required this.walletRepository});

  Future<void> call(Wallet wallet, double amount) async {
    wallet.balance += amount;
    await walletRepository.updateWallet(wallet);
  }
}
