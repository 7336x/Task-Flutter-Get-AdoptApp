import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';
import 'package:adopt_app/widgets/add_form.dart'; // Import the AddForm widget

class AddPage extends StatelessWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Pet"),
      ),
      body: const AddForm(), // Render the AddForm widget
    );
  }
}
