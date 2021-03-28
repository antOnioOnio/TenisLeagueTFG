import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/application/widgets/showAlertDialog.dart';
import 'package:tenisleague100/models/ModelMessages.dart';
import 'package:tenisleague100/models/ModelUserLeague.dart';
import 'package:tenisleague100/services/database.dart';

import '../../../top_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageList extends StatefulWidget {
  final String currentUserId;
  final ModelUserLeague userChat;

  const MessageList({Key key, @required this.currentUserId,@required this.userChat}) : super(key: key);

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    final database = context.read<Database>(databaseProvider);
    return StreamBuilder<List<ModelMessage>>(
      stream: database.messagesStream(widget.userChat.id),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return circularLoadingBar();
          default:
            if (snapshot.hasError) {
              return showAlertDialog(
                context: context,
                title: 'Error',
                content: "Intentalo de nuevo más tarde",
                defaultActionText: 'OK',
                requiredCallback: false,
              );
            } else {
              final messages = snapshot.data;
              return filterMessages(messages);
            }
        }
      },
    );
  }

  Widget filterMessages(List<ModelMessage> list) {
    List<ModelMessage> msgToShow = [];
    if (list.isNotEmpty) {
      for (var obj in list) {
        if (obj.idUserSendTo == widget.currentUserId || obj.idUser == widget.currentUserId) {
          msgToShow.add(obj);
        }
      }
    }
    Timer(
      Duration(milliseconds: 100),
          () => _controller.jumpTo(_controller.position.minScrollExtent),
    );

    return msgToShow.isEmpty
        ? Center(child: Text("Esta conversación esta vacía.."))
        : ListView.builder(
      physics: BouncingScrollPhysics(),
      reverse: true,
      controller: _controller,
      itemCount: msgToShow.length,
      itemBuilder: (context, index) {
        return message(msgToShow[index]);
      },
    );
  }

  Widget message(ModelMessage message) {
    bool isMe = message.idUser == widget.currentUserId;
    Uint8List bytes = base64Decode(widget.userChat.image);
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        isMe ? SizedBox.shrink() : customAvatar(bytes),
        Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(5),
          decoration: messageDecoration(isMe),
          child: Text(
            message.message,
            style: TextStyle(color: isMe ? Colors.black : Colors.white),
            textAlign: isMe ? TextAlign.end : TextAlign.start,
          ),
        ),
      ],
    );
  }
}
