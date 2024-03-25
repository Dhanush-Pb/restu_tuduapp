import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Addto extends StatefulWidget {
  const Addto({Key? key}) : super(key: key);

  @override
  State<Addto> createState() => _AddtoState();
}

class _AddtoState extends State<Addto> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text('Add Todo'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            keyboardType: TextInputType.multiline,
            minLines: 3,
            maxLines: 5,
            decoration: InputDecoration(hintText: 'Description'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await submitData();
              Navigator.of(context)
                  .pop(true); // Passing true indicates data has been added
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 5, 226, 255),
            ),
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> submitData() async {
    final title = titleController.text;
    final description = descriptionController.text;

    final body = {
      "title": title,
      "description": description,
      "is_completed": "false", // Convert boolean to string
    };

    final url = 'https://api.nstack.in/v1/todos';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}
