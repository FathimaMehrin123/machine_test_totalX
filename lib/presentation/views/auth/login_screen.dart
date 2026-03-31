import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:machine_test_totalx/core/constants/appcolors.dart';
import 'package:machine_test_totalx/core/constants/appstrings.dart';
import 'package:machine_test_totalx/core/widgets/custom_button.dart';
import 'package:machine_test_totalx/core/widgets/custom_text.dart';
import 'package:machine_test_totalx/core/widgets/custom_textfield.dart';
import 'package:machine_test_totalx/presentation/viewmodels/auth_viewmodel.dart';
import 'package:machine_test_totalx/presentation/views/users/home_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    context.read<AuthProvider>().removeListener(_handleAuthStateChange);
    _phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().addListener(_handleAuthStateChange);
    });
  }

  void _handleAuthStateChange() {
    final state = context.read<AuthProvider>().state;
    if (state == AuthState.otpSent) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>HomeScreen() ,));
      context.read<AuthProvider>().resetToIdle();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final viewModel = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.06),

              // Logo
              Center(
                child: Image.asset(
                  'assets/images/auth_logo.png',
                  height: size.height * 0.25,
                ),
              ),

              SizedBox(height: size.height * 0.04),

              // Title
              const CustomText(
                AppStrings.enterPhoneTitle,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),

              SizedBox(height: size.height * 0.02),

              // Phone field
              CustomTextField(
                hintText: AppStrings.phoneHint,
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                prefixText: '+91 ',
              ),

              SizedBox(height: size.height * 0.015),

              // Terms text
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.black,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    const TextSpan(text: AppStrings.termsPrefix),
                    TextSpan(
                      text: AppStrings.terms,
                      style: const TextStyle(
                        color: AppColors.textLink,
                        fontWeight: FontWeight.w600,
                         fontFamily: 'Montserrat',
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                    const TextSpan(text: ' & '),
                    TextSpan(
                      text: AppStrings.privacy,
                      style: const TextStyle(
                        color: AppColors.textLink,
                        fontWeight: FontWeight.w600,
                         fontFamily: 'Montserrat',
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                  ],
                ),
              ),

              SizedBox(height: size.height * 0.025),

              // Button
              CustomButton(
                text: AppStrings.getOtp,
                isLoading: viewModel.state == AuthState.loading,
                onPressed: () {
                  if (_phoneController.text.length == 10) {
                    context.read<AuthProvider>().sendOtp(
                      _phoneController.text.trim(),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text(AppStrings.invalidPhone)),
                    );
                  }
                },
              ),

              // Error message
              if (viewModel.state == AuthState.error)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: CustomText(
                    viewModel.errorMessage,
                    color: AppColors.textError,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
