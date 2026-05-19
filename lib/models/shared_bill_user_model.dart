class SharedBillUserModel {
  final int userId;
  final String userName;
  final String avatar;
  final double amount;

  SharedBillUserModel({
    required this.userId,
    required this.userName,
    required this.avatar,
    required this.amount,
  });

  factory SharedBillUserModel.fromJson(Map<String, dynamic> json) =>
      SharedBillUserModel(
        userId: json['userId'],
        userName: json['userName'],
        avatar: json['avatar'],
        amount: json['amount'],
      );

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'userName': userName,
    'avatar': avatar,
    'amount': amount,
  };
}
