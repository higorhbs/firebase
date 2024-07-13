import 'package:flutter/material.dart';

class Chegou extends StatefulWidget {
  const Chegou({super.key});

  @override
  State<Chegou> createState() => ChegouState();
}

class ChegouState extends State<Chegou> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              autofocus: true,
              style: const TextStyle(color: Colors.white, fontSize: 40),
              decoration: const InputDecoration(
                labelText: "Parabéns!",
                labelStyle: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
