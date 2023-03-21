import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
      ),
      body: const Center(
        child: Text('Contenu de la page d\'accueil'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Commande',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Facture',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Portefeuille',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/commande');
              break;
            case 1:
              Navigator.pushNamed(context, '/facture');
              break;
            case 2:
              Navigator.pushNamed(context, '/portefeuille');
              break;
            case 3:
              Navigator.pushNamed(context, '/profil');
              break;
          }
        },
      ),
    );
  }
}
