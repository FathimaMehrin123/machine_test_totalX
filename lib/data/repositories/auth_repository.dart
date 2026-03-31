import 'package:machine_test_totalx/core/config/env_config.dart';
import 'package:machine_test_totalx/domain/repositories/auth_repository_interface.dart';
import 'package:sendotp_flutter_sdk/sendotp_flutter_sdk.dart';

class AuthRepository implements AuthRepositoryInterface {
 

  final String widgetId;
  final String authToken;

  AuthRepository({required this.widgetId, required this.authToken});




  /// Initialize MSG91 OTP Widget
  void initialize() {
    OTPWidget.initializeWidget(widgetId, authToken);
  }

  /// Send OTP → returns reqId
  Future<String?> sendOtp(String phoneNumber) async {
    try {
      final data = {'identifier': '${EnvConfig.countryCode}$phoneNumber'};

      final response = await OTPWidget.sendOTP(data);

      if (response != null && response['type'] == 'success') {
        return response['message'] as String; //  message IS the reqId
      } else {
        throw Exception(response?['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      throw Exception("Send OTP Error: $e");
    }
  }

  /// Verify OTP using reqId + otp
  Future<bool> verifyOtp({required String reqId, required String otp}) async {
    try {
      final data = {'reqId': reqId, 'otp': otp};

      final response = await OTPWidget.verifyOTP(data);

      if (response != null && response['type'] == 'success') {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception("Verify OTP Error: $e");
    }
  }

  /// Retry OTP
  Future<void> retryOtp(String reqId) async {
    try {
      final data = {
        'reqId': reqId,
        'retryChannel': 11, // Resend OTP using SMS channel
      };

      await OTPWidget.retryOTP(data);
    } catch (e) {
      throw Exception("Retry OTP Error: $e");
    }
  }
}


