import 'package:firebase_auth/firebase_auth.dart';

final auth = FirebaseAuth.instance;
void authWithPhoneNumber(String phone,
    {required Function(String value, int? value1) onCodeSend,
    required Function(PhoneAuthCredential value) onAutoverify,
    required Function(FirebaseAuthException value) onFailed,
    required Function(String value) autoRetrieval}) async {
  auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 20),
      verificationCompleted: onAutoverify,
      verificationFailed: onFailed,
      codeSent: onCodeSend,
      codeAutoRetrievalTimeout: autoRetrieval);
}

Future<void> validateOtp(String smsCode, String verificationId) async {
  // La clé qui permet de s'authentifier chez firebase
  final credential = PhoneAuthProvider.credential(
      verificationId: verificationId, smsCode: smsCode);
  auth.signInWithCredential(credential);
}
