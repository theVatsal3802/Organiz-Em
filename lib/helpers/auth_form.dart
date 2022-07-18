import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _email = '';
  String _password = '';
  String _username = '';
  bool isLogin = false;
  bool _isLoading = false;

  void startAuthentication() {
    FocusScope.of(context).unfocus();
    final validity = _formKey.currentState!.validate();
    if (!validity) {
      return;
    }
    _formKey.currentState!.save();
    _submitForm(
      _email.trim().toLowerCase(),
      _password.trim(),
      _username.trim().toLowerCase(),
    );
  }

  void _submitForm(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    UserCredential userCredential;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        userCredential = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        userCredential = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String uid = userCredential.user!.uid;
        String users = dotenv.get("USERS_COLLECTION", fallback: "");
        await FirebaseFirestore.instance.collection(users).doc(uid).set({
          "username": username,
          "email": email,
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
          "An Error Occurred! Please try again.",
          textScaleFactor: 1,
        ),
        action: SnackBarAction(
            label: "OK",
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            }),
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    "assets/images/todo.png",
                    height: 200,
                    width: 200,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Organiz'Em",
                    textScaleFactor: 1,
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.headline2!.fontSize,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  if (!isLogin)
                    TextFormField(
                      enableSuggestions: true,
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      key: const ValueKey("username"),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(),
                        ),
                        labelText: "Username",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter your Username";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _username = value!;
                      },
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    enableSuggestions: false,
                    autocorrect: true,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.emailAddress,
                    key: const ValueKey("email"),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(),
                      ),
                      labelText: "Email",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter your Email";
                      } else if (!(value.contains("@"))) {
                        return "Please Enter a Valid Email";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    enableSuggestions: true,
                    textCapitalization: TextCapitalization.none,
                    autocorrect: false,
                    obscureText: true,
                    key: const ValueKey("password"),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(),
                      ),
                      labelText: "Password",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter a Passwrod";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (_isLoading) const CircularProgressIndicator.adaptive(),
                  if (!_isLoading)
                    ElevatedButton(
                      onPressed: startAuthentication,
                      child: Text(
                        isLogin ? "Login" : "SignUp",
                        textScaleFactor: 1,
                      ),
                    ),
                  if (!_isLoading)
                    const SizedBox(
                      height: 10,
                    ),
                  if (!_isLoading)
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(
                        isLogin ? "SignUp Instead" : "Login Instead",
                        textScaleFactor: 1,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
