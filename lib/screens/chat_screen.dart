import 'package:demo/provider/user_provider.dart';
import 'package:demo/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/chat/messages.dart';
import '../widgets/chat/new_message.dart';

class ChatScreen extends StatelessWidget {
  final String chatPartnerId;


  String getChatId(String user1Id, String user2Id) {
    return ([user1Id, user2Id]..sort()).join('_');
  }

  ChatScreen({required this.chatPartnerId}){}


  @override
  Widget build(BuildContext context) {
    final user = Provider
        .of<UserProvider>(context)
        .user;
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final chatId = getChatId(currentUserId, chatPartnerId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("ChatBook Room"),
        centerTitle: true,
        actions: [
          DropdownButton(
              underline: Container(),
              iconEnabledColor: Colors.teal,
              icon: Icon(
                Icons.more_vert,
                color: Theme
                    .of(context)
                    .primaryIconTheme
                    .color,
              ),
              items: [
                DropdownMenuItem(
                  child: Row(
                    children: [
                      Icon(
                        Icons.info,
                        color: Colors.teal.shade900,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "About Me!",
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                  value: 'aboutMe',
                ),
                DropdownMenuItem(
                  child: Row(
                    children: [
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.teal.shade900,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Logout",
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                  value: 'logout',
                ),
              ],
              onChanged: (itemIdentifier) {
                if (itemIdentifier == 'logout') {
                  _logout(context);
                } else if (itemIdentifier == 'aboutMe') {
                  _showAboutDialog(context);
                }
              }
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Messages(chatId),
          ),
          NewMessage(chatId),
        ],
      ),
    );
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Provider.of<UserProvider>(context, listen: false).clearUser();


  Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => SigninScreen()),
      (route) => false,
  );
}

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("About Me!"),
        content: Text(
          "This Simple Chat App Was Developed By Smit Patel\n\nIf You Wanna Know More About Me or Wanna Make Project Requests!\nFeel Free To DM Me On\nTelegram & Any Platform: @Smit Patel",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              "Thank You!",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black),
            ),
          )
        ],
        backgroundColor: Colors.blue,
      ),
    );
  }
}