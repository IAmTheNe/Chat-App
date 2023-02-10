import 'package:chat_app/utils/firebase_auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/exceptions.dart';
import '../widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  static const routeName = '/register';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 32.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Text(
              'Welcome!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.sp,
              ),
            ),
            Text(
              'Register with your email and password',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                color: Colors.black38,
              ),
            ),
            SizedBox(
              height: 32.h,
            ),
            const RegisterForm(),
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
              onPressed: () {},
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _displayNameController;

  bool _isShowPassword = false;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _displayNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  void onSubmitForm() async {
    bool result = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    bool isSuccess = false;
    if (result) {
      try {
        final user =
            await FirebaseAuthServices.instance!.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          displayName: _displayNameController.text.trim(),
        );
        isSuccess = true;
        print(user);
      } on CreateAccountException catch (e) {
        String message = 'An error occured, please check your credential!';

        if (e.code == 'email-already-in-use') {
          message = 'This email is already in use. Please try again!';
        }
        isSuccess = false;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              message,
            ),
          ),
        );
      }
      if (isSuccess) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
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
            controller: _displayNameController,
            validator: (val) {
              if (val!.isEmpty) {
                return 'Please enter your name!';
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
              hintText: 'Enter your full name',
              hintStyle: const TextStyle(
                color: Colors.black38,
              ),
              label: const Text(
                'Display Name',
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              focusColor: Colors.black,
              prefixIcon: const Icon(
                Icons.person,
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
            text: 'Register',
            onPressed: onSubmitForm,
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text.rich(
              TextSpan(
                text: 'Have an account?',
                style: const TextStyle(
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: ' Sign In',
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
    );
  }
}
