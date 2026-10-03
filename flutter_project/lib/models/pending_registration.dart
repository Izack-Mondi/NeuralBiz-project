class PendingRegistration {
  const PendingRegistration({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.verificationCode,
  });

  final String fullName;
  final String email;
  final String phoneNumber;
  final String? verificationCode;

  PendingRegistration copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? verificationCode,
  }) {
    return PendingRegistration(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      verificationCode: verificationCode ?? this.verificationCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'verificationCode': verificationCode,
    };
  }
}
