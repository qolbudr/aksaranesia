import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:aks/page/list_chat.dart';
import 'package:aks/model/user_model.dart';
import 'package:provider/provider.dart';
import 'package:aks/function/get_timeline.dart';
import 'package:aks/page/create_post.dart';
import 'package:readmore/readmore.dart';
import 'package:aks/page/view_writing.dart';

class TabHome extends StatelessWidget {
  final DateTime todaysDate = DateTime.now();

  Widget build(BuildContext context) {
  	UserData user = context.watch<UserNotifier>().user;
    return GestureDetector(
      onHorizontalDragEnd: (details) => {
        if (details.primaryVelocity > 0) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return CreatePost();
          }))
        } else if (details.primaryVelocity < 0) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return ListChat();
          }))
        }
      },

      child: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: HomeData.writingSnapshot(user.classCode),
              builder: (context, snapshot) {
                if(snapshot.data == null) {
                  return LinearProgressIndicator(minHeight: 2);
                } else {
                  var data = snapshot.data.docs;
                  return Container(
                    height: 200,
                    padding: EdgeInsets.all(15),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.length + 1,
                      itemBuilder: (context, index) {
                        if(index == 0) {
                          return Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black,
                                ),
                                padding: EdgeInsets.all(15),
                                margin: EdgeInsets.only(right: 15),
                                width: 120,
                                child: InkWell(
                                  onTap:() {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return CreatePost();
                                      }
                                    ));
                                  },
                                  child: Center(
                                    child: Icon(Icons.add, size: 23, color: Colors.white)
                                  ),
                                )
                              ),
                            ],
                          );
                        } else {
                          return Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black,
                                ),
                                padding: EdgeInsets.all(15),
                                margin: EdgeInsets.only(right: 15),
                                width: 120,
                                child: InkWell(
                                  onTap:() {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => ViewWriting(id: data[index-1].id)
                                    ));
                                  },
                                  child: Center(
                                    child: Text(
                                      data[index-1]['title'].length > 30 ? data[index-1]['title'].substring(0, 30) + '...' : data[index-1]['title'], 
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                  ),
                                )
                              ),
                              StreamBuilder<DocumentSnapshot>(
                                stream: HomeData.getUserData(data[index-1]['userId']),
                                builder: (context, users) {
                                  if(users.data == null) {
                                    return Container();
                                  } else {
                                    var user = users.data;
                                    return Positioned(
                                      top: 15,
                                      left: 15,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        radius: 15,
                                        child: ClipOval(
                                          child:
                                            user['photoURL'] != '' ?
                                              FadeInImage(image: NetworkImage(user['photoURL']), placeholder: AssetImage('assets/images/user.png'))
                                            :
                                              FadeInImage(image: AssetImage('assets/images/user.png'), placeholder: AssetImage('assets/images/user.png'))
                                        ),
                                      ),
                                    );
                                  }
                                }
                              )
                            ],
                          );
                        }
                      },
                    )
                  );
                }
              }
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: StreamBuilder<QuerySnapshot>(
                stream: HomeData.storySnapshot(user.classCode),
                builder: (context, story) {
                  if(story.data == null) {
                    return Container();
                  } else {
                    var stories = story.data.docs;
                    if(stories.length <= 0) {
                      return Center(
                        child: Column(
                          children: [
                            Image.asset('assets/images/empty.png', width: 200),
                            Text("Wah masih belum ada story nih...")
                          ],
                        ),
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: stories.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return StreamBuilder<DocumentSnapshot>(
                            stream: HomeData.getUserData(stories[index]['userId']),
                            builder: (context, user) {
                              if(user.data == null) {
                                return Container();
                              } else {
                                var users = user.data;
                                DateTime date = stories[index]['created'].toDate();
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 40,
                                                height: 40,
                                                child: users['photoURL'] == '' ?
                                                  FadeInImage(image: AssetImage('assets/images/user.png'), placeholder: AssetImage('assets/images/user.png'))
                                                :
                                                  FadeInImage(image: NetworkImage(users['photoURL']), placeholder: AssetImage('assets/images/user.png'))

                                              ),
                                              SizedBox(width: 10),
                                              Text(users['displayName'])
                                            ],
                                          ),
                                          Text("${date.day}/${date.month}/${date.year}"),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Card(
                                            elevation: 0,
                                            child: Container(
                                              padding: EdgeInsets.all(20),
                                              child: ReadMoreText(
                                                "${stories[index]['text']}",
                                                colorClickableText: Colors.blue.withOpacity(0.7),
                                                trimMode: TrimMode.Line,
                                                trimLines: 3,
                                                trimCollapsedText: "...Lanjutkan Membaca",
                                                trimExpandedText: "\n\nCiutkan",
                                                delimiter: "",
                                                style: TextStyle(fontSize: 13)
                                              )
                                            )
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                  ],
                                );
                              }
                            }
                          );
                        },
                      );
                    }
                  }
                }
              ),
            ),
          ],
        ),
      )
    );
  }
}