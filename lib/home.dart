import 'package:ereyapressing/function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final nom = user.nom;
    return Scaffold(
      appBar: AppBar(
        title: const Text("reyaPressing"),
        actions: [
          IconButton(
              onPressed: () async {
                await logout();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Numéro de téléphone: ${user.phoneNumber ?? ""}"),
          Text("Nom: $nom"),
          Text("Uid: ${user.phoneNumber ?? ""}")
        ],
      ),
    );
  }
}
