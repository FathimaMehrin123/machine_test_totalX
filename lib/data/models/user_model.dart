
import 'package:machine_test_totalx/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.phoneNumber,
    required super.isVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      phoneNumber: json['phoneNumber'] as String,
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'isVerified': isVerified,
    };
  }

  UserModel copyWith({
    String? phoneNumber,
    bool? isVerified,
  }) {
    return UserModel(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}