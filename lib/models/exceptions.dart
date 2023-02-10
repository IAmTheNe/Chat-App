class SignInException implements Exception {
  String? code;
  SignInException([String? errorCode]) {
    code = errorCode;
  }

  @override
  String toString() {
    return '${SignInException().runtimeType.toString()} - $code';
  }
}

class CreateAccountException implements Exception {
  String? code;
  CreateAccountException([String? errorCode]) {
    code = errorCode;
  }

  @override
  String toString() {
    return '${CreateAccountException().runtimeType.toString()} - $code';
  }
}
