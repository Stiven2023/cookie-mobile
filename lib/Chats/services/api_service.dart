import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchChats(BuildContext context) async {
  const String apiUrl = 'https://cokie-chat-api.onrender.com';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> chats = [];

      for (var item in data) {
        chats.add(item as Map<String, dynamic>);
      }

      return chats;
    } else {
      throw Exception('Failed to load chats');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $e'),
        backgroundColor: Colors.red,
      ),
    );
    return [];
  }
}
