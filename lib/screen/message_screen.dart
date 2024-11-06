import 'package:flutter/material.dart';
import 'package:linkjo/config/routes.dart';

class MessageScreen extends StatelessWidget {
  MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: ListView.builder(
        itemCount: chatList.length,
        itemBuilder: (context, index) {
          final chat = chatList[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Text(
                chat.senderName[0], // Inisial pengirim
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(chat.senderName),
            subtitle: Text(
              chat.lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey),
            ),
            trailing: Text(
              chat.time,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.chat,
              );
            },
          );
        },
      ),
    );
  }

  // Dummy data chat list
  final List<Chat> chatList = [
    Chat(
      senderName: 'Cak Maman',
      lastMessage: 'Nanti malam jualan ya!',
      time: '19:45',
    ),
    Chat(
      senderName: 'Bu Asih',
      lastMessage: 'Terima kasih ya!',
      time: '17:30',
    ),
    Chat(
      senderName: 'Pak Budi',
      lastMessage: 'Besok ketemuan?',
      time: '16:15',
    ),
  ];
}

class Chat {
  final String senderName;
  final String lastMessage;
  final String time;

  Chat({
    required this.senderName,
    required this.lastMessage,
    required this.time,
  });
}
