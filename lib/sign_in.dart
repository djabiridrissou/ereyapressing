import 'package:ereyapressing/function.dart';
import 'package:ereyapressing/verification_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool loading = false;
  String phoneNumber = '';
  void sendOtpCode() {
    loading = true;
    setState(() {});
    final auth = FirebaseAuth.instance;
    if (phoneNumber.isNotEmpty) {
      authWithPhoneNumber(phoneNumber, onCodeSend: (verificationId, v) {
        loading = false;
        setState(() {});
        /* Navigator.of(context).push(MaterialPageRoute(
            builder: (c) => VerificationOtp(
                  verificationId: verificationId,
                  phoneNumber: phoneNumber,
                ))); */
      }, onAutoverify: (v) async {
        await auth.signInWithCredential(v);
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      }, onFailed: (e) {
        //print("Le code entré n'est pas le bon");
      }, autoRetrieval: (v) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(children: [
          const Text(
            "Identifiez-vous",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          IntlPhoneField(
            initialCountryCode: "TG",
            onChanged: (value) {
              // print(value.completeNumber);
              phoneNumber = value.completeNumber;
            },
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15)),
                  onPressed: loading ? null : sendOtpCode,
                  child: loading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        )
                      : const Text(
                          'Connexion',
                          style: TextStyle(fontSize: 20),
                        )),
            ],
          )
        ]),
      ),
    ));
  }
}
