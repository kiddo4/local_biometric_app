import 'package:biometric_flutter/screens/passcode_screen.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class HomeScreeen extends StatefulWidget {
  const HomeScreeen({super.key});

  @override
  State<HomeScreeen> createState() => _HomeScreeenState();
}

class _HomeScreeenState extends State<HomeScreeen> {
  final LocalAuthentication _auth = LocalAuthentication();

  bool _isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _authButton(),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your Vault balance is',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '£ 20,000',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _authButton() {
    return FloatingActionButton(
      onPressed: () async {
      Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => PasscodeScreen(passcode: '1234',)));
      },
      child: Icon(_isAuthenticated ? Icons.lock : Icons.lock_open),
    );
  }
}
