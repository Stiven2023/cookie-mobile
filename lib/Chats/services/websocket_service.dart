import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

const String baseUrl = 'https://cokie-chat-api.onrender.com';

Future<Map<String, dynamic>> createMessage(
    BuildContext context, Map<String, dynamic> messageData) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/messages'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(messageData),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> message = json.decode(response.body);
      return message;
    } else {
      throw Exception('Failed to create message');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error creating message: $e'),
        backgroundColor: Colors.red,
      ),
    );
    return {};
  }
}

Future<Map<String, dynamic>> createChat(
    BuildContext context, Map<String, dynamic> chatData) async {
  print('Data received in createChat: $chatData');

  try {
    final response = await http.post(
      Uri.parse('$baseUrl/chats'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(chatData),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> chat = json.decode(response.body);
      return chat;
    } else {
      throw Exception('Failed to create chat');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error creating chat: $e'),
        backgroundColor: Colors.red,
      ),
    );
    return {};
  }
}

Future<List<Map<String, dynamic>>> getAllChats(BuildContext context) async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/chats'));

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
        content: Text('Error getting chats: $e'),
        backgroundColor: Colors.red,
      ),
    );
    return [];
  }
}

void joinChat(BuildContext context, String chatId, String userId) {
  // Lógica para unirse a un chat
  // Puedes emitir un evento al servidor de WebSocket indicando la acción de unirse a un chat
}

Future<Map<String, dynamic>> updateChat(BuildContext context, String chatId,
    Map<String, dynamic> updateData) async {
  try {
    final response = await http.put(
      Uri.parse('$baseUrl/chats/$chatId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updateData),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> updatedChat = json.decode(response.body);
      return updatedChat;
    } else {
      throw Exception('Failed to update chat');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error updating chat: $e'),
        backgroundColor: Colors.red,
      ),
    );
    return {};
  }
}

Future<void> deleteChat(BuildContext context, String chatId) async {
  try {
    final response = await http.delete(
      Uri.parse('$baseUrl/chats/$chatId'),
    );

    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to delete chat');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error deleting chat: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

void connectToWebSocket() {
  final channel =
      IOWebSocketChannel.connect('wss://cokie-chat-api.onrender.com');

  channel.stream.listen(
    (message) {
      print('Received message: $message');
    },
    onError: (error) {
      print('WebSocket error: $error');
    },
    onDone: () {
      print('WebSocket connection closed');
    },
  );
}
