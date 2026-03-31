import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:machine_test_totalx/core/config/env_config.dart';
import 'package:machine_test_totalx/data/repositories/auth_repository.dart';
import 'package:machine_test_totalx/presentation/viewmodels/auth_viewmodel.dart';
import 'package:machine_test_totalx/presentation/views/users/home_screen.dart';
import 'package:provider/provider.dart';


late final AuthRepository _authRepository;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  _authRepository = AuthRepository(
    widgetId: EnvConfig.msg91WidgetId,
    authToken: EnvConfig.msg91AuthToken,
  );
  _authRepository.initialize();

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
      ],
      child: MaterialApp(
        home: HomeScreen(),
        debugShowCheckedModeBanner: false,
        // initialRoute: AppRoutes.login,
        // onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
