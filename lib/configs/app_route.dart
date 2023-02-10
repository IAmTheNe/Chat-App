import 'package:chat_app/views/views.dart';

/// It's a class that contains static constants that are used to navigate to different screens in the
/// app.
class AppRoute {
  /// Used to navigate to the EmailSignInScreen.
  static const emailSignIn = EmailSignInScreen.routeName;

  /// Used to navigate to the RegisterScreen.
  static const register = RegisterScreen.routeName;

  /// Used to navigate to the SplashScreen
  static const splash = SplashScreen.routeName;

  /// Used to navigate to the ChatScreen
  static const chat = ChatScreen.routeName;

  static const searchFriend = SearchScreen.routeName;
}
