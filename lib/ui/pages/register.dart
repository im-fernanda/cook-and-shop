import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:cook_and_shop/domain/user.dart';
import 'package:cook_and_shop/ui/pages/home.dart';
import 'package:cook_and_shop/ui/pages/login.dart';
import 'package:cook_and_shop/ui/widgets/custom_password_field.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../widgets/custom_text_field.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();

  void signUp() async {
    if (passwordController.value.text != rePasswordController.value.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("As senhas não coincidem.")),
      );
      return;
    }

    final AuthService authService =
        Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signUpWithEmailAndPassword(
          emailController.value.text, passwordController.value.text);

      User.addUser(emailController.value.text);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              colorScheme.secondary,
              colorScheme.secondary.withOpacity(0.8),
              colorScheme.secondary.withOpacity(0.2),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: SizedBox(
            height: screenHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.1),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        child: Text("COOK & SHOP",
                            style: TextStyle(
                                fontFamily: 'Telma',
                                color: colorScheme.surface,
                                fontSize: screenHeight * 0.045)),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1300),
                        child: Text(
                          "Crie uma conta",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  color: Theme.of(context).colorScheme.surface),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: screenHeight * 0.06),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1400),
                            child: Container(
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        colorScheme.secondary.withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  CustomTextField(
                                    hintText: "Email",
                                    obscure: false,
                                    controller: emailController,
                                  ),
                                  CustomPasswordFormField(
                                    hintText: "Senha",
                                    controller: passwordController,
                                  ),
                                  CustomPasswordFormField(
                                    hintText: "Repita a senha",
                                    controller: rePasswordController,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.04),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1500),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Login(),
                                  ),
                                );
                              },
                              child: Text.rich(
                                TextSpan(
                                  text: "Já tem uma conta? ",
                                  style: TextStyle(color: Colors.grey),
                                  children: [
                                    TextSpan(
                                      text: "Entrar",
                                      style: TextStyle(
                                        color: colorScheme.tertiary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.04),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1600),
                            child: MaterialButton(
                              onPressed: signUp,
                              height: screenHeight * 0.06,
                              minWidth: screenWidth * 0.8,
                              color: colorScheme.secondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Text(
                                  "Criar conta",
                                  style: TextStyle(
                                    color: colorScheme.surface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
