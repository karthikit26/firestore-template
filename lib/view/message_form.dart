import 'package:chordify_assignment/controller/form_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final FormController _formController = Get.find<FormController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submit Message')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Obx(() => TextFormField(
                      initialValue: _formController.firstName.value,
                      decoration: const InputDecoration(labelText: 'First Name', border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                      onChanged: (value) => _formController.firstName.value = value,
                    )),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Obx(() => TextFormField(
                      initialValue: _formController.lastName.value,
                      decoration: const InputDecoration(labelText: 'Last Name', border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                      onChanged: (value) => _formController.lastName.value = value,
                    )),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Obx(() => TextFormField(
                initialValue: _formController.email.value,
                decoration: const InputDecoration(labelText: 'Email ID', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email ID';
                  }
                  return null;
                },
                onChanged: (value) => _formController.email.value = value,
              )),
              const SizedBox(height: 20),
              Obx(() => TextFormField(
                initialValue: _formController.message.value,
                decoration: const InputDecoration(labelText: 'Message', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a message';
                  }
                  return null;
                },
                onChanged: (value) => _formController.message.value = value,
              )),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                        overlayColor:  MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) {
                              return Colors.black.withOpacity(0.05);
                            }
                            if (states.contains(MaterialState.focused) ||
                                states.contains(MaterialState.pressed)) {
                              return Colors.black.withOpacity(0.15);
                            }
                            return Colors.black; // Defer to the widget's default.
                          },
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _formController.submitForm().then((_) {
                            Get.snackbar('Success', 'Message submitted successfully');
                            Get.back(); // Navigate back to the previous screen
                          }).catchError((error) {
                            Get.snackbar('Error', 'Failed to submit message');
                          });
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
