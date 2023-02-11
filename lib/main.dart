import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'configs/app_route.dart';
import 'firebase_options.dart';
import 'views/views.dart';

void main() async {
  /// A method that is called to ensure that the binding has been initialized.
  WidgetsFlutterBinding.ensureInitialized();

  /// Initializing the Firebase app.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /// Running the app.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chatty Box',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          colorScheme: const ColorScheme.light().copyWith(
            primary: const Color(0xFF6282f1),
            onPrimary: const Color(0xFF6282f1),
          ),
          scaffoldBackgroundColor: const Color(0xFFF6FBFE),
          fontFamily: 'Nunito',
          useMaterial3: true,
        ),
        routes: {
          '/auth': (context) => const AuthenticationScreen(),
          AppRoute.emailSignIn: (context) => const EmailSignInScreen(),
          AppRoute.register: (context) => const RegisterScreen(),
          AppRoute.splash: (context) => const SplashScreen(),
          AppRoute.chat: (context) => const ChatScreen(),
          AppRoute.searchFriend: (context) => const SearchScreen(),
          '/': (context) => const HomeScreen(),
        },
        initialRoute: AppRoute.splash,
      ),
    );
  }
}
