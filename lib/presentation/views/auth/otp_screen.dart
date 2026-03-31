import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:machine_test_totalx/core/constants/appcolors.dart';
import 'package:machine_test_totalx/core/constants/appstrings.dart';
import 'package:machine_test_totalx/core/widgets/custom_button.dart';
import 'package:machine_test_totalx/core/widgets/custom_text.dart';
import 'package:machine_test_totalx/presentation/viewmodels/auth_viewmodel.dart';
import 'package:machine_test_totalx/routes/app_routes.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();

  int _secondsRemaining = 59;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
    // ADD THIS
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().addListener(_handleAuthStateChange);
    });
  }

  void _handleAuthStateChange() {
    final state = context.read<AuthProvider>().state;
    if (state == AuthState.verified) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.homescreen,
        (route) => false,
      );
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() => _secondsRemaining = 59);
    _startTimer();
  }

  @override
  void dispose() {
    context.read<AuthProvider>().removeListener(_handleAuthStateChange);
    _pinController.dispose();
    _focusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final viewModel = context.watch<AuthProvider>();

    final defaultPinTheme = PinTheme(
      width: 44,
      height: 44,
      textStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        fontFamily: 'Montserrat',
        color: AppColors.textError,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(8),
      ),
    );
    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.06),

              Center(
                child: Image.asset(
                  'assets/images/auth_logo.png',
                  height: size.height * 0.22,
                ),
              ),

              SizedBox(height: 31),

              // Title
              const CustomText(
                AppStrings.otpTitle,

                fontWeight: FontWeight.w600,
              ),

              SizedBox(height: 24),

              // Subtitle
              CustomText(
                '${AppStrings.otpSubtitle} +91 ****${viewModel.phoneNumber.substring(6)}',

                color: Colors.grey,
              ),

              SizedBox(height: 24),

              // Pinput OTP field
              Center(
                child: Pinput(
                  controller: _pinController,
                  focusNode: _focusNode,
                  length: 4,
                  autofocus: true,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                ),
              ),

              SizedBox(height: 12),

              // Timer
              Center(
                child: CustomText(
                  _secondsRemaining > 0 ? '$_secondsRemaining Sec' : '00 Sec',
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 24),

              // Resend
              Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: CustomText(
                          AppStrings.dontGetOtp,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: GestureDetector(
                          onTap: _secondsRemaining == 0
                              ? () {
                                  _pinController.clear();
                                  context.read<AuthProvider>().retryOtp();
                                  _resetTimer();
                                }
                              : null,
                          child: CustomText(
                            AppStrings.resend,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _secondsRemaining == 0
                                ? const Color(0xFF2873F0)
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 17),

              // Verify button
              CustomButton(
                text: AppStrings.verify,
                isLoading: viewModel.state == AuthState.loading,
                onPressed: () {
                  if (_pinController.text.length == 4) {
                    context.read<AuthProvider>().verifyOtp(_pinController.text);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text(AppStrings.enterOtpError)),
                    );
                  }
                },
              ),

              // Error
              if (viewModel.state == AuthState.error)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Center(
                    child: CustomText(
                      viewModel.errorMessage,
                      color: AppColors.textError,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
