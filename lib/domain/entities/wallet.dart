class Wallet {
  final String id;
  final String userId;
  double balance;

  Wallet({required this.id, required this.userId, required this.balance});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'balance': balance,
    };
  }
}
