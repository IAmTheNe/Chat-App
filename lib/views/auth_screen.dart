import 'package:chat_app/utils/firebase_auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

import '../configs/app_route.dart';
import '../widgets/widgets.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: LottieBuilder.asset(
              'assets/raws/message.json',
            ),
          ),
          Text.rich(
            TextSpan(
              text: 'Welcome\n\r',
              children: const [
                TextSpan(
                  text: 'to ',
                ),
                TextSpan(
                  text: 'Chatty Box',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              style: TextStyle(
                fontSize: 20.sp,
              ),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20.h,
          ),
          StyledButton(
            text: 'Sign in with Google',
            icon: FontAwesomeIcons.google,
            onPressed: () {
              FirebaseAuthServices.instance!.signInWithGoogle();
            },
          ),
          SizedBox(
            height: 16.h,
          ),
          StyledButton(
            text: 'Continue with Email',
            icon: Icons.email,
            buttonBackgroundColor: Colors.white,
            textColor: Colors.black,
            iconColor: Colors.black,
            onPressed: () {
              Navigator.pushNamed(context, AppRoute.emailSignIn);
            },
          ),
          SizedBox(
            height: .1.sh,
          ),
        ],
      ),
    );
  }
}
