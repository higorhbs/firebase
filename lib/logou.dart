import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class Logou extends StatefulWidget {
  const Logou({Key? key}) : super(key: key);

  @override
  State<Logou> createState() => _LogouState();
}

class _LogouState extends State<Logou> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  String _userMessage = '';
  String _userPhotoUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      String email = FirebaseAuth.instance.currentUser?.email ?? 'unknown';
      DocumentSnapshot userDoc =
          await db.collection('usuarios').doc(email).get();
      setState(() {
        _userMessage = userDoc['Mensagem'] ?? '';
        _userPhotoUrl = userDoc['photoUrl'] ?? '';
      });
    } catch (e) {
      print("Erro ao carregar dados do usuário: $e");
    }
  }

  Future<void> _uploadPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      try {
        String email = FirebaseAuth.instance.currentUser?.email ?? 'unknown';
        String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        Reference storageReference =
            FirebaseStorage.instance.ref().child('$email/$fileName');

        // Iniciar o upload
        UploadTask uploadTask = storageReference.putFile(file);

        // Aguarde a conclusão do upload
        await uploadTask.whenComplete(() async {
          try {
            // Obtenha a URL do arquivo após o upload
            String photoUrl = await storageReference.getDownloadURL();
            await db.collection('usuarios').doc(email).update({
              'photoUrl': photoUrl, // Atualize apenas o campo 'photoUrl'
            });
            setState(() {
              _userPhotoUrl = photoUrl;
            });

            // Exibir a mensagem de sucesso no centro da tela
            _showCenterMessage('Imagem enviada com sucesso!');
          } catch (e) {
            print("Erro ao obter URL da imagem: $e");
          }
        });
      } catch (e) {
        print("Erro ao enviar imagem: $e");
      }
    } else {
      print('Nenhuma imagem selecionada');
    }
  }

  Future<void> _updateUserMessage(String message) async {
    try {
      String email = FirebaseAuth.instance.currentUser?.email ?? 'unknown';
      await db.collection('usuarios').doc(email).set({
        'Mensagem': message, // Atualize apenas o campo 'Mensagem'
      });
      setState(() {
        _userMessage = message;
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

  void _showCenterMessage(String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height / 2 - 30, // Centro vertical
        left: MediaQuery.of(context).size.width / 2 - 150, // Centro horizontal
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );

    // Adiciona a mensagem no overlay
    overlay.insert(overlayEntry);

    // Remove a mensagem após 2 segundos
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  Widget _uploadButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.camera_alt,
          size: 50, color: Colors.white), // Ícone da câmera
      onPressed: _uploadPhoto,
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
    // Obtém o e-mail do usuário atual e extrai a parte antes do '@'
    String email = FirebaseAuth.instance.currentUser?.email ?? 'unknown';
    String displayName = email.split('@')[0]; // Obtém a parte antes do '@'

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
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                    children: [
                      const TextSpan(
                        text: '',
                        style: TextStyle(color: Colors.white), // Cor padrão
                      ),
                      TextSpan(
                        text: displayName, // Nome de usuário em verde
                        style: const TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              if (_userPhotoUrl.isNotEmpty)
                Center(
                  child: Image.network(
                    _userPhotoUrl,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 20),
              if (_userMessage.isNotEmpty)
                Center(
                  child: Text(
                    _userMessage,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  _mostrarCaixa(context);
                },
                child: const Text("Digitar mensagem"),
              ),
              const SizedBox(height: 20),
              _uploadButton(context),
              const SizedBox(height: 60),
              deletar(context),
              const SizedBox(height: 20),
              _sair(context),
            ],
          ),
        ),
      ),
    );
  }
}
