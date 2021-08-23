import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aks/function/get_message.dart';
import 'package:aks/ui/elements.dart';
import 'package:aks/function/validate_form.dart';

class ChatPage extends StatefulWidget {
  ChatPage(this.userId, this.photoURL, this.displayName);
  final String userId, photoURL, displayName;
  @override
  _ChatPage createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final textMessage = TextEditingController();
  String messageId;
  bool isEnabled = false;

  @override
  void initState() {
    super.initState();
    getMessageId();
  }

  void getMessageId() {
    Message.retrieveMessageId(widget.userId, _auth.currentUser.uid).then((value) {
      setState(() {
        messageId = value;
      });
    });
  }

  @override
  void dispose() {
    textMessage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 15,
              child: ClipOval(
                child: widget.photoURL == "" ? 
                  FadeInImage(image: AssetImage('assets/images/user.png'), placeholder: AssetImage('assets/images/user.png'))
                :
                  FadeInImage(image: NetworkImage(widget.photoURL), placeholder: AssetImage('assets/images/user.png')),
              ),
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.displayName, style: TextStyle(fontSize: 15)),
              ]
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: Message.getMessageData(messageId),
            builder: (context, chat) {
              if(chat.data == null) {
                return Expanded(
                  child: Column(
                    children: [
                      LinearProgressIndicator(minHeight: 2),
                      Expanded(
                        child: Container()
                      )
                    ],
                  ),
                );
              } else {
                var chatData = chat.data.docs;
                if(chatData.length <= 0) {
                  return Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/empty.png", width: 200),
                          Text("Wah belum ada pesan nih...")
                        ]
                      )
                    ),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(20),
                      reverse: true,
                      itemCount: chatData.length,
                      itemBuilder: (context, index) {
                        if(chatData[index]["sender"] == _auth.currentUser.uid) {
                          return Row(
                            children: [
                              Expanded(child: SizedBox()),
                              Container(
                                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  color: Colors.blue,
                                ),
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                margin: EdgeInsets.only(bottom: 10),
                                child: Text(chatData[index]["message"], style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          );
                        } else {
                          return Row(
                            children: [
                              Container(
                                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  color: Theme.of(context).cardColor,
                                ),
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                margin: EdgeInsets.only(bottom: 10),
                                child: Text(chatData[index]["message"]),
                              ),
                              Expanded(child: SizedBox()),
                            ],
                          );
                        }
                      },
                    )
                  );
                }
              }
            },
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(20),
            color: Theme.of(context).appBarTheme.backgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InputChanged(controller: textMessage, hintText:"Tulis pesan anda...", icon: Icons.message_outlined,
                    changed: (value) {
                      if(trim(value) == "") {
                        setState(() {
                          isEnabled = false;
                        });
                      } else {
                        setState(() {
                          isEnabled = true;
                        });
                      }
                    },
                  )
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<CircleBorder>(
                      CircleBorder(
                        side: BorderSide.none
                      )
                    )
                  ),
                  onPressed: isEnabled ? () {
                    Message.send(textMessage.value.text, widget.userId, _auth.currentUser.uid, messageId);
                    textMessage.text = "";
                    setState(() {
                      isEnabled = false;
                    });
                  } : null,
                  child: Icon(Icons.send),
                )
              ],
            ),
          ),
        ]
      )
    );
  }
}