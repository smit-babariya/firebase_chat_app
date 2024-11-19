import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _messages = [];

  List<Map<String, dynamic>> get messages => _messages;

  Future<void> fetchMessages(String chatId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt',descending: true)
        .get();

    _messages.clear();
    for (var doc in snapshot.docs) {
      _messages.add(doc.data());
    }
    notifyListeners();
  }

  Future<void> sendMessage(String chatId, String message, String chatPartnerId) async {
    final user = FirebaseAuth.instance.currentUser;

    if(user == null) return;

    final userData = await FirebaseFirestore.instance
    .collection('users')
    .doc(user.uid)
    .get();

    final chatRef =
        FirebaseFirestore.instance.collection('chats').doc(chatId);

    await chatRef.collection('messages').add({
      'text': message,
      'createdAt': Timestamp.now(),
      'senderId': user.uid,
      'username': userData.data()?['name'] ?? 'Anonymous',
      'userImage': userData.data()?['imageUrl'] ??
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSMEGO3UGmsK2GqWNaX1HmvMda8YHRmW3c-7A&s',
    });

    await Future.delayed(Duration(seconds: 1));
    await chatRef.collection('messages').add({
      'text': "Hello! How can I help you today?🤖",
      'createdAt': Timestamp.now(),
      'senderId': 'bot',
      'username': 'Bot',
      'userImage':
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRH2aDKd5BFP64-vbxpVwtLtqXfsejmsCUdRw&s',
    });

    await fetchMessages(chatId);
  }
}