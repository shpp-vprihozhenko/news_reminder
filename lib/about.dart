import 'package:flutter/material.dart';
import 'globals.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children:[
                      Row(
                        children: const [
                          Expanded(
                              child: Text("""

  This program is designed to monitor the health of Internet resources (websites and servers).
  After registering in the AdminPage window, click <+> and specify the URL of the Internet resource, the type of request, and the necessary headers or request body (for servers).
  After that, the server part of the program will start checking the activity of the Internet resource at a specified frequency, and if the resource does not give a positive response to the server request, you will receive an email notifying you of this.
  You can specify the port after the colon into url if needed.
  The maximum resource check frequency for users without a subscription is 2 requests per day.
    
    Subscription.
  
  When paying for a monthly subscription, you can:
    - set rescan frequency up to 1 request per minute,
    - receive additional notification to the telegram channel.
    - say "thanks" to developer:)
  
  It costs only \$1 per month!

  To receive messages on the telegram channel, you need to go to the telegram channel""")
                          ),
                        ],
                      ),
                      const SizedBox(height: 16,),
                      const Text('Wishes and recommendations please write to', textAlign: TextAlign.center,),
                      GestureDetector(
                        child: Container(
                          color: Colors.lightGreen[200],
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('vprihogenko@gmail.com', textAlign: TextAlign.center,),
                          ),
                        ),
                        onTap: () {
                          Clipboard.setData(const ClipboardData(text: 'vprihogenko@gmail.com'));
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('email copied to clipboard')));
                        },
                      ),
                    ],
                  ),
                )
              ],
            )
        ),
      ),
    );
  }
}