abstract class AuthRepositoryInterface {
  Future<String?> sendOtp(String phoneNumber);
  Future<bool> verifyOtp({required String reqId, required String otp});
  Future<void> retryOtp(String reqId);
}