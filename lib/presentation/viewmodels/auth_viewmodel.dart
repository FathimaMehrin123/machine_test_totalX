import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';

enum AuthState { idle, loading, otpSent, verified, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  AuthProvider({required AuthRepository repository}) : _repository = repository;

  AuthState _state = AuthState.idle;
  String _errorMessage = '';
  String _reqId = '';
  String _phoneNumber = '';

  AuthState get state => _state;
  String get errorMessage => _errorMessage;
  String get reqId => _reqId;
  String get phoneNumber => _phoneNumber;

  Future<void> sendOtp(String phoneNumber) async {
    _state = AuthState.loading;
    _phoneNumber = phoneNumber;
    notifyListeners();

    try {
      final reqId = await _repository.sendOtp(phoneNumber);
      if (reqId != null) {
        _reqId = reqId;
        _state = AuthState.otpSent;
      } else {
        _errorMessage = 'Failed to send OTP. Try again.';
        _state = AuthState.error;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _state = AuthState.error;
    }
    notifyListeners();
  }

  Future<void> verifyOtp(String otp) async {
    _state = AuthState.loading;
    notifyListeners();

    try {
      final success = await _repository.verifyOtp(reqId: _reqId, otp: otp);
      if (success) {
        _state = AuthState.verified;
      } else {
        _errorMessage = 'Invalid OTP. Please try again.';
        _state = AuthState.error;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _state = AuthState.error;
    }
    notifyListeners();
  }

  Future<void> retryOtp() async {
    _state = AuthState.loading;
    notifyListeners();

    try {
      await _repository.retryOtp(_reqId);
      _state = AuthState.otpSent;
    } catch (e) {
      _errorMessage = e.toString();
      _state = AuthState.error;
    }
    notifyListeners();
  }

 
  void resetToIdle() {
  _state = AuthState.idle;
  notifyListeners();
}
}
