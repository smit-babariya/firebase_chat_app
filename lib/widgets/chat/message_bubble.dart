import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.message,
      this.username,
      this.userImage,
      this.isBot,
      {required this.key});

  final Key key;
  final String message;
  final String username;
  final String userImage;
  final bool isBot;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
          isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isBot ? Colors.teal : Colors.blue,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                    bottomLeft:
                    !isBot ? Radius.circular(0) : Radius.circular(14),
                    bottomRight:
                    isBot ? Radius.circular(0) : Radius.circular(14)),
              ),
              width: 170,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                crossAxisAlignment:
                isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: isBot ? Colors.black : Colors.white),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                        color: isBot ? Colors.black : Colors.white),
                    textAlign: isBot ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          right: isBot ? 150 : null,
          left: !isBot? 150 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(userImage),
          ),
        ),
      ],
    );
  }
}