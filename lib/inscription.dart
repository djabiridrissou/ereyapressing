// ignore_for_file: use_build_context_synchronously

import 'package:ereyapressing/verification_otp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'function.dart';

class Inscription extends StatefulWidget {
  const Inscription({Key? key}) : super(key: key);
  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool loading = false;
  String _nom = "";
  String _prenom = "";
  String _numeroTelephone = "";
  String _email = "";

  void sendOtpCode() {
    loading = true;
    setState(() {});
    final auth = FirebaseAuth.instance;
    if (_numeroTelephone.isNotEmpty) {
      authWithPhoneNumber(_numeroTelephone, onCodeSend: (verificationId, v) {
        loading = false;
        setState(() {});
        Navigator.of(context).push(MaterialPageRoute(
            builder: (c) => VerificationOtp(
                  verificationId: verificationId,
                  numeroTelephone: _numeroTelephone,
                  nom: _nom,
                  prenom: _prenom,
                  mail: _email,
                )));
      }, onAutoverify: (v) async {
        await auth.signInWithCredential(v);
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      }, onFailed: (e) {
        print("Le code entré n'est pas le bon");
      }, autoRetrieval: (v) {});
    }
  }

  Future<void> _geolocaliserUtilisateur() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // ici, vous pouvez faire ce que vous voulez avec la position de l'utilisateur,
      // par exemple l'enregistrer dans la base de données Firebase

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Position de l'utilisateur géolocalisée avec succès"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inscription"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextFormField(
              onChanged: (value) {
                setState(() {
                  _nom = value;
                });
              },
              decoration: const InputDecoration(
                labelText: "Nom",
              ),
            ),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  _prenom = value;
                });
              },
              decoration: const InputDecoration(
                labelText: "Prénom",
              ),
            ),
            IntlPhoneField(
              initialCountryCode: "TG",
              onChanged: (value) {
                // print(value.completeNumber);
                _numeroTelephone = value.completeNumber;
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
              decoration: const InputDecoration(
                labelText: "Adresse mail",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: loading ? null : sendOtpCode,
                child: loading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      )
                    : const Text(
                        'Inscription',
                        style: TextStyle(fontSize: 20),
                      )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _geolocaliserUtilisateur,
              child: const Text("Géolocaliser ma position"),
            ),
          ],
        ),
      ),
    );
  }
}
