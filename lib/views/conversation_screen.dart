import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:humane_chat/helper/constants.dart';
import 'package:humane_chat/services/database.dart';
import 'package:humane_chat/widget/widget.dart';

class ConversationScreen extends StatefulWidget {
  late final String chatRoomid;
  ConversationScreen(this.chatRoomid);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();

  late Stream<QuerySnapshot<Object?>>? chatMessagesStream;

  Widget ChatMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatMessagesStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return MessageTile(
                    snapshot.data!.docs[index].get("message").toString(),
                  );
                },
              )
            : Container();
      },
    );
  }

  Widget MessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatMessagesStream,
      builder: (context, snapshot) {
        return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return MessageTile(
                snapshot.data!.docs[index].get("message").toString(),
              );
            });
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomid, messageMap);

      /**Leaving this commented out will disable instant message send. This could prevent
       * and potentially teach users to send
       * longer messages rather than sending many in a short period of time which is
       * annoying to some and detrimental to productivity in general. Later it could be
       * changed so that each time the user clicks "send" the message gets updated,
       * however the notification is sent only once, when the message is first sent */
      messageController.clear();
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomid).then((value) {
      setState(() {
        if (value != null) {
          chatMessagesStream = value as Stream<QuerySnapshot<Object?>>?;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarMain(context: context),
      body: Container(
        child: Stack(
          children: [
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Column(
                        children: [
                          Container(
                            color: Color(0x54FFFFFF),
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: messageController,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        hintText: "Send",
                                        hintStyle:
                                            TextStyle(color: Colors.white54),
                                        border: InputBorder.none),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    sendMessage();
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(0x36FFFFFF),
                                          const Color(0x0FFFFFFF)
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    padding: EdgeInsets.all(12),
                                    child:
                                        Image.asset("assets/images/send.png"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  const MessageTile(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(message, style: mediumTextStyle()),
    );
  }
}
