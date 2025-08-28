import 'package:flutter/material.dart';

class AddStampDialog extends StatefulWidget {
  final int remainingStamps;
  final Function(int) onAdd;

  const AddStampDialog({
    super.key,
    required this.remainingStamps,
    required this.onAdd,
  });

  @override
  State<AddStampDialog> createState() => _AddStampDialogState();
}

class _AddStampDialogState extends State<AddStampDialog> {
  final _formKey = GlobalKey<FormState>();
  final _stampController = TextEditingController();

  @override
  void dispose() {
    _stampController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add stamps'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sellos restantes ${widget.remainingStamps}, ingresa la cantidad de sellos que vas a añadir',
            ),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: _buildStampTextField(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState?.validate() == true) {
              widget.onAdd(int.parse(_stampController.text));
              Navigator.pop(context, true);
            }
          },
          child: const Text('Agregar'),
        ),
      ],
    );
  }

  Widget _buildStampTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: TextFormField(
        controller: _stampController,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          errorMaxLines: 2,
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Este campo es obligatorio';
          }
          final parsed = int.tryParse(value);
          if (parsed == null) {
            return 'Debe ser un número válido';
          } else if (parsed > widget.remainingStamps) {
            return 'Debe ser menor o igual a los sellos restantes';
          }
          return null;
        },
      ),
    );
  }
}
