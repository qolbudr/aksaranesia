import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ViewWeb extends StatelessWidget {
	ViewWeb({this.url});
	final String url;

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text("Web", style: TextStyle(fontSize: 18)),
				elevation: 0
			),
			body: SafeArea(
			  child: Column(
			  	children: [
			  		Expanded(
			  			child: WebView(
			  				initialUrl: url,
			  				javascriptMode: JavascriptMode.unrestricted,
			  			),
			  		)
			  	]
			  ),
			)
		);
	}
}
