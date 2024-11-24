import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_password_manager/models/chat_user.dart';
import 'package:flutter_password_manager/screen/chat_screen.dart';
import 'package:flutter_password_manager/screen/splash_screen.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(horizontal: mq.width * 0.04, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatScreen(user: widget.user)));
          },
          child: ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            tileColor: Colors.white,
            style: ListTileStyle.drawer,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(mq.height*.3),
              child: CachedNetworkImage(
                width: mq.height*.055,
                height: mq.height*.055,
                fit: BoxFit.fill,
                imageUrl: "http://via.placeholder.com/350x150",
                errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.green),
              ),
            ),
            title: Text(widget.user.name),
            subtitle: Text(widget.user.about,style: const TextStyle(fontSize: 12), maxLines: 1),
            trailing: Container(width: 15,height: 15,decoration:BoxDecoration(color: Colors.green,borderRadius: BorderRadius.circular(10)),),
          )),
    );
  }
}
