import 'package:flutter/material.dart';

import '../controllers/animal_map_controller.dart';

class AnimalRegistrationDialog extends StatefulWidget {
  const AnimalRegistrationDialog({
    super.key,
    required this.controller,
  });

  final AnimalMapController controller;

  @override
  State<AnimalRegistrationDialog> createState() => _AnimalRegistrationDialogState();
}

class _AnimalRegistrationDialogState extends State<AnimalRegistrationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await widget.controller.addAnimal(_nameController.text.trim());
    if (mounted && widget.controller.errorMessage == null) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Register animal'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Animal name'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a name';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: widget.controller.isSubmitting ? null : _submit,
          child: widget.controller.isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}

