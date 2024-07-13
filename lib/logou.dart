import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';

class Logou extends StatefulWidget {
  const Logou({Key? key}) : super(key: key);

  @override
  State<Logou> createState() => _LogouState();
}

Widget deletar(BuildContext context) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.red,
      minimumSize: const Size(double.infinity, 60),
      elevation: 0,
    ),
    onPressed: () async {
      await AuthService().excluirUser(
        context: context,
      );
    },
    child: const Text(
      "EXCLUIR CONTA",
    ),
  );
}

Widget _sair(BuildContext context) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(double.infinity, 60),
      elevation: 0,
    ),
    onPressed: () async {
      await AuthService().signout(
        context: context,
      );
    },
    child: const Text(
      "Sair",
    ),
  );
}

class _LogouState extends State<Logou> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                'Você logou ${FirebaseAuth.instance.currentUser?.email}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            const SizedBox(height: 20),
            deletar(context),
            const SizedBox(height: 20),
            _sair(context),
          ],
        ),
      ),
    );
  }
}
