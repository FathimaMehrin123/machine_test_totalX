import 'package:machine_test_totalx/core/services/otp_service.dart';
import 'package:machine_test_totalx/domain/repositories/auth_repository_interface.dart';

class AuthRepository implements AuthRepositoryInterface {
  final OtpService otpService;

  AuthRepository({required this.otpService});

  @override
  Future<String?> sendOtp(String phoneNumber) {
    return otpService.sendOtp(phoneNumber);
  }

  @override
  Future<bool> verifyOtp({required String reqId, required String otp}) {
    return otpService.verifyOtp(reqId: reqId, otp: otp);
  }

  @override
  Future<void> retryOtp(String reqId) {
    return otpService.retryOtp(reqId);
  }
}
