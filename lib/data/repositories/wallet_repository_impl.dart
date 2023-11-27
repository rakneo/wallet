import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet/data/models/wallet_model.dart';
import 'package:wallet/domain/entities/wallet.dart';
import 'package:wallet/domain/repositories/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  final SharedPreferences sharedPreferences;

  WalletRepositoryImpl({required this.sharedPreferences});

  @override
  Future<List<Wallet>> getWallets(String userId) async {
    final wallets = await getAllWallets();
    return wallets.where((wallet) => wallet.userId == userId).toList();
  }

  @override
  Future<void> createWallet(Wallet wallet) async {
    final wallets = await getAllWallets();

    // Check if wallet ID already exists
    if (wallets.any((existingWallet) => existingWallet.id == wallet.id)) {
      throw Exception('Wallet ID already exists.');
    }
    wallets.add(wallet);

    await saveWallets(wallets);
  }

  @override
  Future<void> updateWallet(Wallet wallet) async {
    final wallets = await getAllWallets();

    final index = wallets.indexWhere((existingWallet) => existingWallet.id == wallet.id);
    if (index != -1) {
      wallets[index] = wallet;
      await saveWallets(wallets);
    }
  }

  @override
  Future<void> deleteWallet(Wallet wallet) async {
    final wallets = await getAllWallets();

    wallets.removeWhere((existingWallet) => existingWallet.id == wallet.id);
    await saveWallets(wallets);
  }

  Future<List<Wallet>> getAllWallets() async {
    final walletJsonList = sharedPreferences.getStringList('wallets') ?? [];
    return walletJsonList.map((walletJson) => WalletModel.fromJson(walletJson as Map<String, dynamic>)).toList();
  }

  Future<void> saveWallets(List<Wallet> wallets) async {
    final walletJsonList = wallets.map((wallet) => wallet.toJson()).toList();
    final walletStringList = walletJsonList.map((json) => jsonEncode(json)).toList();
    await sharedPreferences.setStringList('wallets', walletStringList);
  }

}
