// Ignore: file_names
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cookie_flutter_app/labarra_brava.dart';

class FeedPage extends StatelessWidget {
  final String token;

  const FeedPage({Key? key, required this.token}) : super(key: key);

  Future<void> _logout(BuildContext context, String token) async {
    const String logoutUrl = 'https://cokie-chat-api.onrender.com/users/logout';

    final http.Response response = await http.get(
      Uri.parse(logoutUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // ignore: avoid_print
      print('Sesión cerrada exitosamente');
    } else {
      // ignore: avoid_print
      print('Error al cerrar sesión: ${response.statusCode}');
    }

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ignore: prefer_const_constructors
          Center(
            // ignore: prefer_const_constructors
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // ignore: prefer_const_literals_to_create_immutables
              children: <Widget>[
                const Text(
                  'User feed',
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              // ignore: prefer_const_constructors
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                // ignore: prefer_const_constructors
                icon: Icon(Icons.logout, color: Colors.white),
                onPressed: () {
                  _logout(context, token);
                },
              ),
            ),
          ),
          const barrrra(title: 'Cookie'),
        ],
      ),
    );
  }
}
