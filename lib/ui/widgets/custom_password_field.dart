import 'package:flutter/material.dart';

class CustomPasswordFormField extends StatefulWidget {
  final String hintText;
  final String? Function(String?)? validateFunction;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  CustomPasswordFormField({
    super.key,
    required this.hintText,
    this.validateFunction,
    this.controller,
    this.keyboardType,
  });

  @override
  State<CustomPasswordFormField> createState() =>
      _CustomPasswordFormFieldState();
}

class _CustomPasswordFormFieldState extends State<CustomPasswordFormField> {
  late bool obscured = true;

  @override
  void initState() {
    super.initState();
    obscured = true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        validator: widget.validateFunction,
        style: TextStyle(color: Colors.black),
        obscureText: obscured,
        decoration: InputDecoration(
          suffixIconColor: Theme.of(context).colorScheme.primary,
          suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  obscured = !obscured;
                });
              },
              child: obscured
                  ? const Icon(Icons.remove_red_eye_rounded,
                      color: Colors.black)
                  : const Icon(Icons.remove_red_eye_outlined,
                      color: Colors.black)),
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
