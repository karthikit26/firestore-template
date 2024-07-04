import 'package:chordify_assignment/controller/form_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessagesList extends StatelessWidget {
  final FormController _formController = Get.find<FormController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages List')),
      body: Obx(() {
        return _buildMessagesGrid(_formController.messages);
      }),
    );
  }

  Widget _buildMessagesGrid(List<Map<String, String>> messages) {
    if (messages.isEmpty) {
      return const Center(child: Text('No messages found'));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,  // Number of columns in the grid
        crossAxisSpacing: 8.0,  // Space between columns
        mainAxisSpacing: 8.0,  // Space between rows
        childAspectRatio: 1.0,  // Aspect ratio to maintain square cells
      ),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return Card(
          color: Colors.white,
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${message['firstName']} ${message['lastName']}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8.0),
                Text('${message['email']}'),
                const SizedBox(height: 8.0),
                Text('${message['message']}', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25.0),),
              ],
            ),
          ),
        );
      },
    );
  }
}
