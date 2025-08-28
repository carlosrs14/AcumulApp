import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final int minimumQuantity;
  final bool email;
  final bool password;
  final bool opcional;
  final String? hintText;

  const CustomTextFormField({
    super.key,
    required this.controller,
    this.minimumQuantity = 1,
    this.email = false,
    this.password = false,
    this.opcional = false,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: TextFormField(
        obscureText: password,
        controller: controller,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        decoration: InputDecoration(
          hintText: hintText,
          fillColor: Theme.of(context).colorScheme.surface,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        validator: (value) {
          if (opcional) {
            return null;
          }
          if (value == null || value.trim().isEmpty) {
            return 'Este campo es obligatorio';
          } else if (value.length < minimumQuantity) {
            return 'Requiere una cantidad minima de $minimumQuantity caracteres';
          } else if (email &&
              !(value.contains("@") && value.contains(".com"))) {
            return 'Debe ser un correo';
          }
          return null;
        },
      ),
    );
  }
}
