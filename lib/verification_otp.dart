import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import 'function.dart';

class VerificationOtp extends StatefulWidget {
  final String verificationId;
  const VerificationOtp(
      {Key? key,
      required this.verificationId,
      required this.numeroTelephone,
      required this.nom,
      required this.prenom,
      required this.mail})
      : super(key: key);
  final String numeroTelephone;
  final String nom;
  final String prenom;
  final String mail;

  @override
  State<VerificationOtp> createState() => _VerificationOtpState();
}

class _VerificationOtpState extends State<VerificationOtp> {
  String smsCode = "";
  bool loading = false;
  bool resend = false;
  int count = 60;
  final auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    decompte();
  }

  late Timer timer;
  void decompte() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (count < 1) {
        timer.cancel();
        count = 60;
        resend = true;
        if (mounted) {
          setState(() {});
        }
        return;
      }
      count--;
      if (mounted) {
        setState(() {});
      }
    });
  }

  void onResendSmsCode() {
    resend = false;
    setState(() {});
    authWithPhoneNumber(widget.numeroTelephone,
        onCodeSend: (verificationId, v) {
      loading = false;
      resend = false;
      decompte();
      setState(() {});
    }, onAutoverify: (v) async {
      await auth.signInWithCredential(v);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }, onFailed: (e) {
      // print("Le code entré n'est pas le bon");
    }, autoRetrieval: (v) {});
  }

  void onVerifySmsCode() async {
    loading = true;
    setState(() {});
    await validateOtp(smsCode, widget.verificationId);
    loading = true;
    setState(() {});
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    print("Vérification effectué avec succès");
    User user = FirebaseAuth.instance.currentUser!;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    await users.doc(user.uid).set({
      'nom': widget.nom,
      'prenom': widget.prenom,
      'email': widget.mail,
      'numeroTelephone': widget.numeroTelephone,
    });
  }

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
              Pinput(
                length: 6,
                onChanged: (value) {
                  smsCode = value;
                  //print(smsCode);
                  setState(() {});
                },
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: !resend ? null : onResendSmsCode,
                  child: Text(!resend
                      ? "00:${count.toString().padLeft(2, "0")}"
                      : "Renvoyer le code"),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15)),
                    onPressed:
                        smsCode.length < 6 || loading ? null : onVerifySmsCode,
                    child: loading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          )
                        : const Text(
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
