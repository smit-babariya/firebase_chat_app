import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  final String chatId;
  const NewMessage(this.chatId, {super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  String _enteredMessage = "";

  void _sendMessage() async {
    FocusScope.of(context).unfocus();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    String username = userData.data()?['name'] ?? 'Anonymous';


    final chatRef = FirebaseFirestore.instance
    .collection('chats')
    .doc(widget.chatId);

    await chatRef.collection('messages').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'senderId': user.uid,
      'username':username,
      'userImage': userData.data()?['imageUrl'] ?? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQpZQ957SWJMN1tyvBK2xFRpdvOrJSFC2LhmXY7gIjhe2MydO98eXbYwTAvTgOaLWJ2Zdk&usqp=CAU',
    });

    await Future.delayed(Duration(seconds: 1));

     await chatRef.collection('messages').add({
       'text': "Hello! How can I help you today?🤖",
       'createdAt': Timestamp.now(),
       'senderId': 'bot',
       'username': 'Bot',
       'userImage': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRH2aDKd5BFP64-vbxpVwtLtqXfsejmsCUdRw&s'
     });



    _controller.clear();
    setState(() {
      _enteredMessage = "";
    });
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSMEGO3UGmsK2GqWNaX1HmvMda8YHRmW3c-7A&s',
            ),
            radius: 20,
            child: Image.network(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSMEGO3UGmsK2GqWNaX1HmvMda8YHRmW3c-7A&s',
              errorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/circle_img.png');
              },
            ),
          ),
          Expanded(
            child: TextField(
              autocorrect: true,
              enableSuggestions: true,
              textCapitalization: TextCapitalization.sentences,
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Send a message...",
              ),
              onChanged: (val) {
                setState(() {
                  _enteredMessage = val;
                });
              },
            ),
          ),
          IconButton(
            disabledColor: Colors.teal[200],
            color: Theme.of(context).primaryColor,
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
