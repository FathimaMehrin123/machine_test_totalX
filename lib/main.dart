import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:machine_test_totalx/core/config/env_config.dart';
import 'package:machine_test_totalx/data/repositories/auth_repository.dart';
import 'package:machine_test_totalx/data/repositories/user_repository.dart';
import 'package:machine_test_totalx/firebase_options.dart';
import 'package:machine_test_totalx/presentation/viewmodels/auth_viewmodel.dart';
import 'package:machine_test_totalx/presentation/viewmodels/user_viewmodel.dart';
import 'package:machine_test_totalx/presentation/views/auth/login_screen.dart';
import 'package:machine_test_totalx/presentation/views/users/home_screen.dart';
import 'package:provider/provider.dart';

late final AuthRepository _authRepository;
late final UserRepository _userRepository;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load(fileName: ".env");
   await Firebase.initializeApp(             // add this
    options: DefaultFirebaseOptions.currentPlatform,
  );


  _authRepository = AuthRepository(
    widgetId: EnvConfig.msg91WidgetId,
    authToken: EnvConfig.msg91AuthToken,
  );
  _authRepository.initialize();
  _userRepository = UserRepository();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(repository: _authRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(repository: _userRepository),
        ),
      ],
      child: MaterialApp(
        home: LoginScreen(),
        debugShowCheckedModeBanner: false,
        // initialRoute: AppRoutes.login,
        // onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
