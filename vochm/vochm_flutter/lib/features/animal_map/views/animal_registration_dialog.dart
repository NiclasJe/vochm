import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../service_locator.dart';
import '../controllers/animal_map_controller.dart';

class AnimalRegistrationDialog extends StatefulWidget {
  const AnimalRegistrationDialog({super.key});

  @override
  State<AnimalRegistrationDialog> createState() => _AnimalRegistrationDialogState();
}

class _AnimalRegistrationDialogState extends State<AnimalRegistrationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  late final AnimalMapController controller;

  @override
  void initState() {
    super.initState();
    controller = getIt<AnimalMapController>();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await controller.addAnimal(_nameController.text.trim());
    if (mounted && controller.errorMessage == null) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnimalMapController, AnimalMapState>(
      bloc: controller,
      builder: (context, state) {
        return AlertDialog(
          title: const Text('Register animal'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              key: const Key('animalNameField'),
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
              key: const Key('submitAnimalButton'),
              onPressed: state.isSubmitting ? null : _submit,
              child: state.isSubmitting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
