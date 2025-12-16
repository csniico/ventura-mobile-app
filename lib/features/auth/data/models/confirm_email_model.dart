class ConfirmEmailModel {
  final String message;
  final String shortToken;

  ConfirmEmailModel({required this.message, required this.shortToken});

  factory ConfirmEmailModel.fromJson(Map<String, dynamic> map) {
    return ConfirmEmailModel(
      message: map['message'] ?? '',
      shortToken: map['id'] ?? '',
    );
  }
}