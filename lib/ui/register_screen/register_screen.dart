import 'package:flutter/material.dart';
import 'package:tic_tac_game/ui/game_screen/game_screen.dart';

import '../widgets/global_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController player1Controller = TextEditingController();
  final TextEditingController player2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF323D5B),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter players name!',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: GlobalTextField(
                  controller: player1Controller,
                  hintText: 'First Player',
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.person,
                  caption: '',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name of first player!';
                    }
                    return null;
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: GlobalTextField(
                  controller: player2Controller,
                  hintText: 'Second Player',
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.person,
                  caption: '',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name of second player!';
                    }
                    return null;
                  }),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GameScreen(
                              player1: player1Controller.text,
                              player2: player2Controller.text)));
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white, width: 5)),
                child: const Text(
                  'Start the Game',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
