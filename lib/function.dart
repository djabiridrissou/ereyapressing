import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ereyapressing/inscription.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';

import 'home.dart';

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
  await auth
      .signInWithCredential(credential)
      .then((userCredential) {})
      .catchError((e) {
    return;
    //print("Authentication failed: $e");
  });
  //checkUserDetailsExistence();
}

Future<void> logout() async {
  await auth.signOut();
  return;
}

User? get user => auth.currentUser;

extension CustomUserExtension on User {
  String get displayNameOrEmail {
    return displayName ?? email ?? 'Utilisateur inconnu';
  }

  String get nom {
    return nom;
  }

  String get prenom {
    return prenom;
  }
}

/* Future<Widget> checkUserDetailsExistence() async {
  User user = FirebaseAuth.instance.currentUser!;
  String userId = user.uid;
  print("avant get");
  DocumentSnapshot doc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
  print("après get");
  Map<String, dynamic> data =
      Map<String, dynamic>.from(doc.data() as Map<String, dynamic>? ?? {});

  if (data.containsKey('firstName') && data.containsKey('lastName')) {
    return const Home();
  }
  return const UserDetailsPage();
}
 */

Future<void> saveUserInfo(String nom, String prenom, String email,
    String numeroTelephone, User user) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  await users.doc(user.uid).set({
    'nom': nom,
    'prenom': prenom,
    'email': email,
    'numeroTelephone': numeroTelephone,
  });
}

Future<void> _enregistrerUtilisateur() async {
  try {
    print("aprés sendotp");
    User user = FirebaseAuth.instance.currentUser!;
    /* saveUserInfo(_nom, _prenom, _email, _numeroTelephone, user);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Utilisateur enregistré avec succès"),
        ),
      ); */
  } catch (e) {
    print("Erreur dans enregisUti" + e.toString());
    /* ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur: $e"),
        ),
      ); */
  }
}
