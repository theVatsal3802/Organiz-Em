import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/bottom_nav_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = user!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
      timer!.cancel();
    }
  }

  Future sendVerificationEmail() async {
    try {
      await user!.sendEmailVerification();
      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(
        const Duration(seconds: 5),
      );
      setState(() {
        canResendEmail = true;
      });
    } catch (e) {
      AlertDialog(
        title: const Text(
          "The following orror occurred! Please try again.",
          textScaler: TextScaler.noScaling,
        ),
        content: Text(
          e.toString(),
          textScaler: TextScaler.noScaling,
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "OK",
              textScaler: TextScaler.noScaling,
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const BottomNavScreen()
      : Scaffold(
          appBar: AppBar(
            title: const Text(
              "Verify Email",
            ),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "A Verification Email has been sent to your provided email address",
                    textScaler: TextScaler.noScaling,
                    style: Theme.of(context).textTheme.titleLarge,
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: canResendEmail ? sendVerificationEmail : null,
                    child: Text(
                      "Resend Email",
                      textScaler: TextScaler.noScaling,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    child: const Text(
                      "Change Email Id",
                      textScaler: TextScaler.noScaling,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
}
