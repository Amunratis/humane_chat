import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:humane_chat/widget/widget.dart';

import 'constants.dart';
import 'conversation_screen.dart';
import 'database.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController =
      new TextEditingController();

  QuerySnapshot? searchSnapshot;

  initiateSearch() {
    databaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  createChatRoomAndStartConversation({required String userName}) {
    String chatRoomId = generateChatRoomId(userName, Constants.myName);

    List<String> users = [userName, Constants.myName];
    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatroomId": chatRoomId
    };

    DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ConversationScreen()));
  }

  Widget searchTile({required String userName, String? userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SizedBox(
            height: 100,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      userName + " ",
                      style: myTextStyle(),
                    ),
                    Text(
                      userEmail!,
                      style: myTextStyle(),
                    )
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    createChatRoomAndStartConversation(userName: userName);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(30)),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text("Message"),
                  ),
                ),
                Spacer(),
              ],
            ),
          )
        ],
      ),
    );
  }

  generateChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return searchTile(
                userName: searchSnapshot!.docs[index].get("name"),
                userEmail: searchSnapshot!.docs[index].get("email"),
              );
            })
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    debugDumpRenderTree();
    return Scaffold(
      appBar: AppBarMain(context: context),
      body: Container(
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: searchTextEditingController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  hintText: "search username...",
                                  hintStyle: TextStyle(color: Colors.white54),
                                  border: InputBorder.none),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              initiateSearch();
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
                                  Image.asset("assets/images/search_white.png"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    searchList()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}