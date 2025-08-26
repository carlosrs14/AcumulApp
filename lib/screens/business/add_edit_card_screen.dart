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
  final ScrollController _scrollController = ScrollController();
  late int _maxStamp;
  late int _expiration;
  late String _description;
  late String _name;
  late String _rewards;
  late String _restrictions;

  @override
  void initState() {
    super.initState();
    _description = widget.card?.description ?? '';
    _maxStamp = widget.card?.maxStamp ?? 0;
    _expiration = widget.card?.expiration ?? 0;
    _name = widget.card?.name ?? '';
    _rewards = widget.card?.reward ?? '';
    _restrictions = widget.card?.restrictions ?? '';
  }

  void _saveCard() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newCard = BusinessCard(
        widget.card?.id ?? 0, // Se ignora en el backend al crear
        widget.idBusiness,
        _expiration,
        _maxStamp,
        _name,
        _description,
        _restrictions,
        _rewards,
        true
      );

      bool success = false;
      if (widget.card == null) {
        // Crear
        final createdCard = await _cardProvider.create(newCard);
        if (!mounted) return;
        if (createdCard != null) {
          success = true;
        }
      } else {
        // Editar
        final updatedCard = await _cardProvider.update(newCard);

        if (!mounted) return;

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
    await Future.delayed(Duration(milliseconds: 100));
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.card == null ? 'Añadir Tarjeta' : 'Editar Tarjeta'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: _description,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                onSaved: (value) => _description = value!,
              ),
              TextFormField(
                initialValue: _maxStamp.toString(),
                decoration: const InputDecoration(
                  labelText: 'Máximo de Sellos',
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                onSaved: (value) => _maxStamp = int.parse(value!),
              ),
              TextFormField(
                initialValue: _expiration.toString(),
                decoration: const InputDecoration(
                  labelText: 'Expiración (días)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                onSaved: (value) => _expiration = int.parse(value!),
              ),
              TextFormField(
                initialValue: _rewards,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Recompensa'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                onSaved: (value) => _rewards = value!,
              ),
              TextFormField(
                initialValue: _restrictions,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Restricciones'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                onSaved: (value) => _restrictions = value!,
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
