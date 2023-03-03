import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import 'home.dart';

class VerificationOtp extends StatefulWidget {
  final String verificationId;
  const VerificationOtp({Key? key, required this.verificationId})
      : super(key: key);

  @override
  State<VerificationOtp> createState() => _VerificationOtpState();
}

class _VerificationOtpState extends State<VerificationOtp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        // Empechez les retours en arriere de l'utilisateur
        onWillPop: () async {
          return true;
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const Text(
                "Vérifiez votre numéro",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.green,
                ),
              ),
              const Text(
                "Consultez vous messages pour avoir le code",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.green,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Pinput(
                length: 6,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Renvoyer le code"),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15)),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (c) => const Home()));
                    },
                    child: const Text(
                      'Vérifier',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
