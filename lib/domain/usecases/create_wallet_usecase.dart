import 'package:wallet/domain/entities/wallet.dart';
import 'package:wallet/domain/repositories/wallet_repository.dart';

class CreateWalletUseCase {
  final WalletRepository walletRepository;

  CreateWalletUseCase({required this.walletRepository});

  Future<void> call(Wallet wallet) async {
    await walletRepository.createWallet(wallet);
  }
}
