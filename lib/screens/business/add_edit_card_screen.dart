
import 'package:acumulapp/models/card.dart';
import 'package:acumulapp/providers/card_provider.dart';
import 'package:flutter/material.dart';

class AddEditCardScreen extends StatefulWidget {
  final BusinessCard? card;
  final int idBusiness;

  const AddEditCardScreen({super.key, this.card, required this.idBusiness});

  @override
  State<AddEditCardScreen> createState() => _AddEditCardScreenState();
}

class _AddEditCardScreenState extends State<AddEditCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final CardProvider _cardProvider = CardProvider();

  late String _description;
  late int _maxStamp;
  late int _expiration;

  @override
  void initState() {
    super.initState();
    _description = widget.card?.description ?? '';
    _maxStamp = widget.card?.maxStamp ?? 0;
    _expiration = widget.card?.expiration ?? 0;
  }

  void _saveCard() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newCard = BusinessCard(
        widget.card?.id ?? 0, // Se ignora en el backend al crear
        widget.idBusiness,
        _expiration,
        _maxStamp,
        _description,
      );

      bool success = false;
      if (widget.card == null) {
        // Crear
        final createdCard = await _cardProvider.create(newCard);
        if (createdCard != null) {
          success = true;
        }
      } else {
        // Editar
        final updatedCard = await _cardProvider.update(newCard);
        if (updatedCard != null) {
          success = true;
        }
      }

      if (success) {
        Navigator.pop(context, true); // Devuelve true para indicar éxito
      } else {
        // Mostrar error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar la tarjeta')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.card == null ? 'Añadir Tarjeta' : 'Editar Tarjeta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                onSaved: (value) => _description = value!,
              ),
              TextFormField(
                initialValue: _maxStamp.toString(),
                decoration: const InputDecoration(labelText: 'Máximo de Sellos'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                onSaved: (value) => _maxStamp = int.parse(value!),
              ),
              TextFormField(
                initialValue: _expiration.toString(),
                decoration: const InputDecoration(labelText: 'Expiración (días)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                onSaved: (value) => _expiration = int.parse(value!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCard,
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
