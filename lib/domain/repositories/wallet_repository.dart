import 'package:wallet/domain/entities/wallet.dart';

abstract class WalletRepository {
  Future<List<Wallet>> getWallets(String userId);
  Future<void> createWallet(Wallet wallet);
  Future<void> updateWallet(Wallet wallet);
  Future<void> deleteWallet(Wallet wallet);
}
