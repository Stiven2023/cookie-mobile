import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void showPostsModal(BuildContext context) async {
  final response = await http
      .get(Uri.parse('https://cookie-beta-post-mobile-m5j8.onrender.com/post'));

  if (response.statusCode == 200) {
    final posts = jsonDecode(response.body);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: 400,
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      // Actualiza el estado con el nuevo texto de búsqueda
                    },
                    decoration: const InputDecoration(
                      labelText: 'Buscar por nombre de usuario',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        if (post['FullName'].toLowerCase().contains('')) {
                          return ListTile(
                            title: Text(post['Post']['Content']),
                            subtitle: Text(post['FullName']),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  } else {
    throw Exception('Failed to load posts');
  }
}
