import 'package:flutter/material.dart';

// My Widgets

import 'package:cookie_flutter_app/Chats/chats_page.dart';
import 'package:cookie_flutter_app/Posts/posts_page.dart';

class barrrra extends StatefulWidget {
  const barrrra({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<barrrra> createState() => _barrrraState();
}

class _barrrraState extends State<barrrra> {
  //* Theme
  bool _isDarkTheme = false;
  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }

  //* Navegation
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    PostPage(),
    ChatsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cookie Beta for Stadistics ',
      theme: _isDarkTheme
          ? ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black)
          : ThemeData.light().copyWith(scaffoldBackgroundColor: Colors.white),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: _isDarkTheme ? Colors.black : Colors.white,
          title: const Text('Cookie'),
          actions: [
            IconButton(
              icon:
                  Icon(_isDarkTheme ? Icons.brightness_7 : Icons.brightness_3),
              onPressed: _toggleTheme,
            ),
          ],
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          backgroundColor: _isDarkTheme ? Colors.black : Colors.white,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _isDarkTheme
                      ? const Color(0xFF111111)
                      : const Color.fromARGB(255, 243, 243, 243),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.post_add),
              ),
              label: 'Post',
            ),
            BottomNavigationBarItem(
              icon: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _isDarkTheme
                      ? const Color(0xFF111111)
                      : const Color.fromARGB(255, 243, 243, 243),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.chat),
              ),
              label: 'Chats',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
