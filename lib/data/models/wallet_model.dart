import 'package:wallet/domain/entities/wallet.dart';

class WalletModel extends Wallet {
  WalletModel({required String id, required String userId, required double balance})
      : super(id: id, userId: userId, balance: balance);

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'],
      userId: json['userId'],
      balance: json['balance'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'balance': balance,
    };
  }
}
