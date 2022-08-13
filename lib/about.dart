import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  runApp(
      const MediaQuery(
          data: MediaQueryData(),
          child: MaterialApp(home: About())
      )
  );
}

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
                      const Text('News catcher', textScaleFactor: 1.3,),
                      Row(
                        children: const [
                          Expanded(
                              child: Text("""

This program is intended to help you catching important events or news.
After registering you can add a new search with the Plus button <+>. 
Specify needed keywords, news websites (optional) and relax.
As soon as news with such keywords appear, a special server will send you a letter with direct links to them.
With the <Touch> button you can test your keywords and get the list of links to the latest news.
Rescan of news is processed every day.
  
  """)
                          ),
                        ],
                      ),
                      const Text('Author and programmer -\nVolodymyr Prykhozhenko', textAlign: TextAlign.center,),
                      Image.asset('assets/v1.jpg'),
                      const SizedBox(height: 16,),
                      const Text('Wishes and recommendations please send to', textAlign: TextAlign.center,),
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
                      const SizedBox(height: 46,),
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