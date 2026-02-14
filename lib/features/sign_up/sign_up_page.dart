import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/features/home/home_page.dart';
import 'package:myapp/features/sign_in/sign_in_page.dart';
import 'package:myapp/services/firebase/auth_service.dart';
import 'package:myapp/services/shared_preference/prefs.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool obscure = true;
  var _isLoading = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void signUpUser() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    setState(() {
      _isLoading = true;
    });

    AuthService.signUpUser(
      context,
      name,
      email,
      password,
    ).then((user) => {_getFirebaseUser(user)});
  }

  void _getFirebaseUser(User? user) async {
    setState(() {
      _isLoading = false;
    });
    if (user != null) {
      await Prefs.saveUserId(user.uid);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AllPostPage()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Check all the details")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(hintText: "Name"),
                  validator: (value) {
                    if (value == null) {
                      return "The name must be entered";
                    }
                    if (value.isEmpty) {
                      return "The name can't be empty";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(hintText: "Email"),
                  validator: (value) {
                    if (value == null) {
                      return "The email must be entered";
                    }
                    if (value.isEmpty) {
                      return "The email can't be empty";
                    }
                    if (!value.contains("@")) {
                      return "Enter valid email";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: "Password",
                    suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          obscure = !obscure;
                        });
                      },
                      icon: obscure
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                    ),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return "The password must be entered";
                    }
                    if (value.isEmpty) {
                      return "The password can't be empty";
                    }
                    if (value.length < 8) {
                      return "The password must be at least 8 characters";
                    }
                    return null;
                  },
                  obscureText: obscure,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    _isLoading ? null : signUpUser();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    minimumSize: Size(250, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text("Sign Up", style: TextStyle(color: Colors.white)),
                ),
                OverflowBar(
                  children: [
                    Text("Alraedy have an account"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      },
                      child: Text("Sign in"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
