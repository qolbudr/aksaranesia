import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import "package:flutter_slidable/flutter_slidable.dart";
import "package:aks/function/get_profiledata.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:readmore/readmore.dart";
import "package:aks/page/chat_page.dart";
import "package:aks/page/view_writing.dart";

class ViewProfile extends StatefulWidget {
	@override
	ViewProfile(this.userId, this.photoURL, this.points, this.bio, this.displayName);
	final String userId, photoURL, bio, displayName;
	final int points;
	_ViewProfile createState() => _ViewProfile();
}

class _ViewProfile extends State<ViewProfile> with SingleTickerProviderStateMixin {
	TabController _controller;
	FirebaseAuth _auth = FirebaseAuth.instance;

	@override
  void initState() {
    super.initState();
    _controller = new TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(elevation: 0, title: 
        Row(
          children: [
            Text(widget.displayName, style: TextStyle(fontSize: 18)),
          ],
        )
      ),
		  body: Column(
		  	children: [
		  		Container(
		  			width: double.infinity,
		  			padding: EdgeInsets.all(15),
		  			color: Theme.of(context).primaryColor,
		  			child: Row(
		  				mainAxisAlignment: MainAxisAlignment.spaceBetween,
		  				crossAxisAlignment: CrossAxisAlignment.start,
		  			  children: [
		  			    Expanded(
		  			      child: Row(
		  			      	crossAxisAlignment: CrossAxisAlignment.start,
		  			      	children: [
		  			      		CircleAvatar(
		  		              backgroundColor: Colors.grey,
		  		              radius: 30,
		  		              child: ClipOval(
		  		                child: widget.photoURL == "" ? 
		  		                  FadeInImage(image: AssetImage('assets/images/user.png'), placeholder: AssetImage('assets/images/user.png'))
		  		                :
		  		                  FadeInImage(image: NetworkImage(widget.photoURL), placeholder: AssetImage('assets/images/user.png')),
		  		              ),
		  			          ),
		  			          SizedBox(width: 10),
		  			          Expanded(
		  			            child: Column(
		  			            	crossAxisAlignment: CrossAxisAlignment.start,
		  			            	children: [
		  			            		Text(widget.displayName, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
		  			            		SizedBox(height: 5),
		  			            		Text((widget.bio == "" || widget.bio == null) ? "-" : widget.bio, style: TextStyle(color: Colors.white))
		  			            	]
		  			            ),
		  			          ),
		  			      	]
		  			      ),
		  			    ),
		  			    Column(
		  			    	children: [
		  			    		Text("${widget.points} pts", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
		  			    		SizedBox(height: 5),
		  			    		Image.asset('assets/images/medal.png', height: 25),
		  			    	],
		  			    )
		  			  ],
		  			)
		  		),
		  		Container(
            color: Theme.of(context).appBarTheme.backgroundColor,
            child: TabBar(
            controller: _controller,
            tabs: [
               Tab(child: Text("Status")),
               Tab(child: Text("Bacaan")),
               Tab(child: Text("Tulisan")),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: [
                Column(
                	children: [
                		StreamBuilder<QuerySnapshot>(
                		  stream: ProfileData.getStatusById(widget.userId),
                		  builder: (context, status) {
                		    if(status.data == null) {
                		    	return SizedBox(
                		    		width: double.infinity,
                						height: 2,
                						child: LinearProgressIndicator(minHeight: 2)
                					);
                		    } else {
                		    	var statuses = status.data.docs;
                		    	if(statuses.length <= 0) {
                		    		return Expanded(
                		    		  child: Center(
                		    		  	child: Column(
                		    		  		mainAxisAlignment: MainAxisAlignment.center,
                		    		  		children: [
                		    		  			Image.asset("assets/images/empty.png", width: 200),
                		    		  			Text("Wah belum ada status nih...")
                		    		  		]
                		    		  	)
                		    		  ),
                		    		);
                		    	} else {
                		    		return Expanded(
                		    		  child: ListView.builder(
		  														itemCount: statuses.length,
		  														padding: EdgeInsets.only(top: 15, left: 15, right: 15),
		  														itemBuilder: (context, index) {
		  															DateTime date = statuses[index]['created'].toDate();
		  															return Slidable(
		  															  actionPane: SlidableDrawerActionPane(),
		  															  actionExtentRatio: 0.25,
		  															  child: Column(
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
		                                                  child: widget.photoURL == "" ?
		                                                    FadeInImage(image: AssetImage('assets/images/user.png'), placeholder: AssetImage('assets/images/user.png'))
		                                                  :
		                                                    FadeInImage(image: NetworkImage(widget.photoURL), placeholder: AssetImage('assets/images/user.png'))

		                                                ),
		                                                SizedBox(width: 10),
		                                                Text(widget.displayName)
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
		                                                	"${statuses[index]['text']}",
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
		                                  ),
		  															);
		  														},
		  													),
                		    		);
                		    	}
                		    }
                		  }
                		)
                	],
                ),
                Column(
                	children: [
                		Expanded(
							  			child: Column(
							  				mainAxisAlignment: MainAxisAlignment.center,
							  				crossAxisAlignment: CrossAxisAlignment.center,
							  				children: [
						  						Image.asset("assets/images/comingSoon.png", width: 200),
						  						Container(
						  							child: Padding(
						  							  padding: const EdgeInsets.symmetric(horizontal: 30),
						  							  child: Text("Kami sedang mempersiapkan fitur unik untuk kamu", textAlign: TextAlign.center),
						  							)
						  						)
						  					],
						  				)
						  			)
                	],
                ),
                Column(
                	children: [
                		StreamBuilder<QuerySnapshot>(
                			stream: ProfileData.getWritingById(widget.userId),
                			builder: (context, write) {
                				if(write.data == null) {
                					return SizedBox(
                						width: double.infinity,
                						height: 2,
                						child: LinearProgressIndicator(minHeight: 2)
                					);
            						} else {
              							var writes = write.data.docs;
              							if(writes.length <= 0) {
              								return Expanded(
              								  child: Center(
		                  		    			child: Column(
		                  		    				mainAxisAlignment: MainAxisAlignment.center,
		                  		    				children: [
	                		    					Image.asset("assets/images/empty.png", width: 200),
	                		    					Text("Wah belum ada tulisan nih...")
	                		    				]
	                		    			)
                		    			),
              							);
          								} else {
          									return Expanded(
          									  child: ListView.separated(
          									  	separatorBuilder: (context, index) => SizedBox(height:5),
          									  	itemCount: writes.length,
          									  	padding: EdgeInsets.only(top: 15, left: 15, right: 15),
          									  	itemBuilder: (context, index) {
          									  		return ListTile(
          									  			onTap: () => Navigator.push(context, MaterialPageRoute(
          									  				builder: (context) => ViewWriting(id: writes[index].id)
          									  			)),
	  														  	tileColor: Theme.of(context).cardColor,
	  														  	leading: CircleAvatar(
	  													        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
	  													        child: Icon(Icons.book_outlined),
	  													        foregroundColor: Theme.of(context).primaryColor,
	  													      ),
	  													      title: Text(writes[index]["title"]),
	  													      subtitle: Text(widget.displayName),
	  														  );
        									  	},
        									  ),
        									);
        								}
          						}
              			}
              		)
              	],
              ),
            ]
          ),
        )
		  	]
		  ),
			floatingActionButton: _auth.currentUser.uid ==  widget.userId ? SizedBox() :
			FloatingActionButton(
				child: Icon(Icons.message_outlined),
				onPressed: () => Navigator.push(context, MaterialPageRoute(
					builder: (context) {
						return ChatPage(widget.userId, widget.photoURL, widget.displayName);
					}
				))
			),
		);
	}
}
