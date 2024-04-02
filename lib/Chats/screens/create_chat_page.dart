import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/websocket_service.dart';

class CreateChatPage extends StatefulWidget {
  const CreateChatPage({Key? key}) : super(key: key);

  @override
  _CreateChatPageState createState() => _CreateChatPageState();
}

class _CreateChatPageState extends State<CreateChatPage> {
  late List<dynamic> _allUsers = [];
  late Set<String> _allUsernames = {};
  final List<dynamic> _selectedUsers = [];

  late String _selectedUserId = '';
  late String _selectedUserName = '';

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final response = await http
          .get(Uri.parse('https://cokie-chat-api.onrender.com/users/get'));
      if (response.statusCode == 200) {
        final List<dynamic> users = json.decode(response.body);
        setState(() {
          _allUsers = users;
          _allUsernames =
              users.map((user) => user['username'] as String).toSet();
        });
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Chat',
          style: TextStyle(
              color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _allUsernames.length,
                itemBuilder: (context, index) {
                  final username = _allUsernames.elementAt(index);
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: _selectedUsers.contains(username)
                          ? Colors.teal.shade200
                          : Colors.white,
                    ),
                    child: ListTile(
                      title: Text(username),
                      onTap: () {
                        setState(() {
                          if (_selectedUsers.contains(username)) {
                            _selectedUsers.remove(username);
                          } else {
                            _selectedUsers.add(username);
                          }
                        });
                        print('Usuario seleccionado: $username');
                      },
                      trailing: _selectedUsers.contains(username)
                          ? const Icon(Icons.check)
                          : null,
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (_selectedUsers.length >= 2) {
                    final userIds = _selectedUsers
                        .map((username) => _allUsers.firstWhere(
                            (user) => user['username'] == username)['_id'])
                        .toList();

                    print('$userIds');

                    await createChat(context, {'users': userIds});

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Chat created successfully!'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select at least 2 users'),
                      ),
                    );
                  }
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error creating chat: $error'),
                    ),
                  );
                }
              },
              child: const Text('Create'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
