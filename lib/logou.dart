import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Logou extends StatefulWidget {
  const Logou({Key? key}) : super(key: key);

  @override
  State<Logou> createState() => _LogouState();
}

class _LogouState extends State<Logou> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();

  Future<void> _updateUserMessage(String message) async {
    try {
      await db
          .collection('usuarios')
          .doc('${FirebaseAuth.instance.currentUser?.email}')
          .update({
        'Mensagem': message,
      });
    } catch (e) {
      print("Error updating user message: $e");
    }
  }

  // Função para exibir o AlertDialog
  void _mostrarCaixa(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.deepPurple,
        content: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: TextFormField(
            controller: _messageController,
            style: const TextStyle(color: Colors.white, fontSize: 30),
            decoration: const InputDecoration(
              labelText: "Mensagem",
              labelStyle: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              Navigator.of(context).pop(); // Fechar o diálogo primeiro
              await _updateUserMessage(_messageController.text);
            },
          ),
        ],
      ),
    );
  }

  Widget deletar(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        minimumSize: const Size(double.infinity, 60),
        elevation: 0,
      ),
      onPressed: () async {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );
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
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );
        await AuthService().signout(
          context: context,
        );
      },
      child: const Text(
        "Sair",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
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
              ElevatedButton(
                onPressed: () {
                  _mostrarCaixa(context);
                },
                child: const Text("Digitar mensagem"),
              ),
              const Padding(
                padding: EdgeInsets.only(
                    top: 20.0), // Ajuste o espaçamento conforme necessário
              ),
              deletar(context),
              const Padding(
                padding:
                    EdgeInsets.only(top: 20.0), // Espaçamento entre os botões
              ),
              _sair(context),
            ],
          ),
        ),
      ),
    );
  }
}
