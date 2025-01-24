import 'package:flutter/material.dart';
import 'package:cook_and_shop/ui/pages/login.dart';
import 'package:cook_and_shop/ui/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

import '../../domain/user.dart';
import '../../services/auth_service.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();

  void SignOut() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      authService.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  void _editProfile(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Edit your profile"),
            content: Wrap(children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(
                    hintText: "Username",
                    obscure: false,
                    controller: usernameController,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    hintText: "Email",
                    obscure: false,
                    controller: emailController,
                  ),
                  const SizedBox(height: 16),
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    height: 50,
                    color: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Center(
                      child: Text(
                        "Edit",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Conta",
          style: TextStyle(fontSize: 22, color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Image.asset(
                    height: 150, width: 150, "assets/images/avatar.png"),
                Text(
                  "${User.currentUserName}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                Text(
                  "${User.currentUserEmail}",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                MaterialButton(
                  onPressed: () {
                    _editProfile(context);
                  },
                  height: 50,
                  color: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Center(
                    child: Text(
                      "Editar Perfil",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                IconButton(
                    onPressed: () {
                      SignOut();
                    },
                    icon: const Icon(Icons.logout))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
