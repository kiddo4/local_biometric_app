import 'package:biometric_flutter/widgets/keypad_button_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class PasscodeScreen extends StatefulWidget {
  final String passcode;

  const PasscodeScreen({super.key, required this.passcode});

  @override
  State createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen> {
  String confirmPasscode = '';
  final int passcodeLength = 4;
  final LocalAuthentication auth = LocalAuthentication();
  bool isBiometricAvailable = false;

  @override
  void initState() {
    super.initState();
    checkBiometricAvailability();
  }

  Future<void> checkBiometricAvailability() async {
    try {
      // Check if the device supports biometric authentication
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      bool isDeviceSupported = await auth.isDeviceSupported();

      // Get the available biometrics
      List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();

      // Check if fingerprint or face authentication is available
      if (canCheckBiometrics &&
          isDeviceSupported &&
          (availableBiometrics.contains(BiometricType.fingerprint) ||
              availableBiometrics.contains(BiometricType.face))) {
        setState(() {
          isBiometricAvailable = true;
        });
      }
    } on PlatformException catch (e) {
      // Handle any errors and print for debugging
      print("Error checking biometric availability: $e");
    }
  }

  void addDigit(String digit) {
    HapticFeedback.vibrate();
    if (confirmPasscode.length < passcodeLength) {
      setState(() {
        confirmPasscode += digit;
        if (confirmPasscode.length == passcodeLength) {
          if (confirmPasscode == widget.passcode) {
            // Passcode is correct, proceed
            print('Passcode is correct!');
          } else {
            // Passcode is incorrect, reset it
            confirmPasscode = '';
            print('Incorrect passcode. Try again.');
          }
        }
      });
    }
  }

  void deleteDigit() {
    if (confirmPasscode.isNotEmpty) {
      setState(() {
        confirmPasscode = confirmPasscode.substring(0, confirmPasscode.length - 1);
      });
    }
  }

  Future<void> authenticateWithBiometrics() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Authenticate to access your account',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (authenticated) {
        // Biometric authentication was successful
        print('Biometric authentication successful!');
        // Proceed to the next action, e.g., unlocking content or navigating
      }
    } on PlatformException catch (e) {
      // Handle any errors during authentication
      print('Biometric authentication error: $e');
    }
  }

  Widget buildPasscodeField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        passcodeLength,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: confirmPasscode.length > index ? Colors.yellow : Colors.grey,
            ),
            color: confirmPasscode.length > index ? Colors.yellow : Colors.white,
          ),
          child: Center(
            child: Text(
              confirmPasscode.length > index ? confirmPasscode[index] : '',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildKeypad() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: 12,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (context, index) {
        if (index < 9) {
          return KeypadButton(
            text: '${index + 1}',
            onPressed: () => addDigit('${index + 1}'),
          );
        } else if (index == 9) {
          return const SizedBox.shrink(); // Empty button
        } else if (index == 10) {
          return KeypadButton(
            text: '0',
            onPressed: () => addDigit('0'),
          );
        } else {
          return KeypadButton(
            iconImage: const Padding(
              padding: EdgeInsets.all(19.0),
              child: Icon(Icons.arrow_back_ios_new_rounded),
            ),
            icon: Icons.backspace,
            onPressed: deleteDigit,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://img.freepik.com/free-psd/3d-illustration-human-avatar-profile_23-2150671142.jpg?size=338&ext=jpg&ga=GA1.1.1887574231.1729209600&semt=ais_hybrid',
                ),
                radius: 80,
              ),
              const SizedBox(height: 10),
              const Text(
                'Enter Passcode',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Enter passcode to view balance',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 40),
              buildPasscodeField(),
              const SizedBox(height: 20),
              if (isBiometricAvailable)
                IconButton(
                  icon: const Icon(
                    Icons.fingerprint,
                    size: 40,
                    color: Colors.blueAccent,
                  ),
                  onPressed: authenticateWithBiometrics,
                  tooltip: 'Authenticate with Face ID or Fingerprint',
                ),
              const SizedBox(height: 20),
              Expanded(child: buildKeypad()),
            ],
          ),
        ),
      ),
    );
  }
}
