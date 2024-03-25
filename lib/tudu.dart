import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tuduproject/addto.dart';

class Todu extends StatefulWidget {
  const Todu({Key? key}) : super(key: key);

  @override
  State<Todu> createState() => _ToduState();
}

class _ToduState extends State<Todu> {
  bool isLoading = true;
  List items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(221, 87, 86, 86),
        centerTitle: true,
        title: const Text('Tudo Lsis'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const Addto()));
          if (result != null && result == true) {
            fetchTodo(); // Refresh data if data has been added
          }
        },
        label: const Text('add'),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: () => fetchTodo(), // Call fetchTodo when refreshing
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index] as Map;

              final id = item['_id'] as String;
              return ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(item['title']),
                subtitle: Text(item['description']),
                trailing: PopupMenuButton(onSelected: (value) {
                  if (value == 'edit') {
                  } else if (value == 'delete') {
                    deleteByid(id);
                  }
                }, itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: Text('edit'),
                      value: 'edit',
                    ),
                    PopupMenuItem(
                      child: Text('delete'),
                      value: 'delete',
                    ),
                  ];
                }),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchTodo(); // Call fetchTodo when initializing the screen
  }

  Future<void> fetchTodo() async {
    print('Fetching todo list...');
    // ignore: prefer_const_declarations
    final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map;
      final result = jsonData['items'] as List;

      setState(() {
        items = result;
        isLoading = false;
      });

      print('Updated items: $items');
    }
  }

  Future<void> deleteByid(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';

    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {}
  }
}
