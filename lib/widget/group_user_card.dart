import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_password_manager/models/group.dart';
import 'package:flutter_password_manager/screen/group_chat_screen.dart';

import '../screen/splash_screen.dart';
class GroupUserCard extends StatefulWidget {
  final Group group;
  const GroupUserCard({super.key, required this.group});

  @override
  State<GroupUserCard> createState() => _GroupUserCardState();
}

class _GroupUserCardState extends State<GroupUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(horizontal: mq.width * 0.04, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_)=>GroupChatScreen
              ()));
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
            title: Text(widget.group.name),
            subtitle: Text(widget.group.lastMessage,style: const TextStyle(fontSize: 12), maxLines: 1),
            trailing: Container(width: 15,height: 15,decoration:BoxDecoration(color: Colors.green,borderRadius: BorderRadius.circular(10)),),
          )),
    );
  }
}
