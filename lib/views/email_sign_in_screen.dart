import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../configs/app_route.dart';
import '../models/exceptions.dart';
import '../utils/firebase_auth_services.dart';
import '../widgets/styled_button.dart';

class EmailSignInScreen extends StatelessWidget {
  const EmailSignInScreen({super.key});

  static const routeName = '/email-sign-in';

  @override
  Widget build(BuildContext context) {
    return const SignInView();
  }
}

class SignInView extends StatelessWidget {
  const SignInView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 32.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Text(
              'Welcome back!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.sp,
              ),
            ),
            Text(
              'Enter your email and password',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                color: Colors.black38,
              ),
            ),
            SizedBox(
              height: 32.h,
            ),
            const EmailSignInForm(),
            const Spacer(
              flex: 2,
            ),
            const Divider(
              thickness: .5,
            ),
            const Center(
              child: Text(
                'Or sign in with',
                style: TextStyle(
                  color: Colors.black45,
                ),
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            StyledButton(
              text: 'Sign in with Google',
              icon: FontAwesomeIcons.google,
              onPressed: () {
                FirebaseAuthServices.instance!.signInWithGoogle();
              },
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class EmailSignInForm extends StatefulWidget {
  const EmailSignInForm({
    Key? key,
  }) : super(key: key);

  @override
  State<EmailSignInForm> createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;

  final _formKey = GlobalKey<FormState>();
  bool _isShowPassword = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void onSubmitForm() async {
    final result = _formKey.currentState!.validate();

    /// Closing the keyboard.
    FocusScope.of(context).unfocus();
    if (result) {
      try {
        final user =
            await FirebaseAuthServices.instance!.signInWithEmailPassword(
          email: _usernameController.text,
          password: _passwordController.text,
        );
        print(user);
      } on SignInException catch (e) {
        String message = 'An error occured, please check your credential!';

        switch (e.code) {
          case 'user-not-found':
            message = 'Your email is not corrected! Please try again!';
            break;
          case 'wrong-password':
            message = 'Your password is wrong! Please try again!';
            break;
        }

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(message),
            ),
          );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _usernameController,
              validator: (val) {
                if (val!.isEmpty || !val.contains('@')) {
                  return 'Please enter a valid email!';
                }
                return null;
              },
              decoration: InputDecoration(
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: 'Enter your email',
                hintStyle: const TextStyle(
                  color: Colors.black38,
                ),
                label: const Text(
                  'Email',
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                focusColor: Colors.black,
                prefixIcon: const Icon(
                  Icons.email,
                ),
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            TextFormField(
              controller: _passwordController,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Please enter your password!';
                }
                if (val.length < 3) {
                  return 'Your password must be greater than 3 characters!';
                }

                return null;
              },
              obscureText: !_isShowPassword,
              obscuringCharacter: '*',
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: 'Enter your password',
                hintStyle: const TextStyle(
                  color: Colors.black38,
                ),
                label: const Text(
                  'Password',
                  style: TextStyle(),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                prefixIcon: const Icon(
                  Icons.lock,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isShowPassword = !_isShowPassword;
                    });
                  },
                  icon: Icon(
                    !_isShowPassword
                        ? FontAwesomeIcons.eye
                        : FontAwesomeIcons.eyeSlash,
                    size: 18.sp,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 32.h,
            ),
            StyledButton(
              text: 'Login',
              onPressed: onSubmitForm,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoute.register);
              },
              child: Text.rich(
                TextSpan(
                  text: 'Don\'t have an account?',
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: ' Sign Up',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
