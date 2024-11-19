import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'message_bubble.dart';

class Messages extends StatelessWidget {
  final String chatId;

  const Messages(this.chatId, {super.key});

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chats")
          .doc(chatId)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .snapshots(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.teal.shade900,
              semanticsLabel: 'Loading Messages...',
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              "No messages yet. Start the conversation!",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          reverse: true,
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final message = docs[index];
            final isBot = message['senderId'] == 'bot';

            return GestureDetector(
              onLongPress: () {
                _showDeleteDialog(message.id, context);
              },
              child: MessageBubble(
                message['text'],
                message['username'],
                message['userImage'],
                isBot,
                key: ValueKey(message.id),
              ),
            );
          },
        );
      },
    );
  }

  void _showDeleteDialog(String messageId, BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Delete Message"),
        content: Text("Are you sure you want to delete this message?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(), // Cancel deletion
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              _deleteMessage(messageId, context); // Perform deletion
              Navigator.of(ctx).pop(); // Close the dialog
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _deleteMessage (String messageId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
         .collection('chats')
         .doc(chatId)
         .collection('messages')
         .doc(messageId)
         .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Message deleted successfully!'),
          backgroundColor: Colors.blue,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete message!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
