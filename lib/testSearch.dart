import 'package:continous_data_searcher/globals.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TestSearch extends StatefulWidget {
  const TestSearch({Key? key}) : super(key: key);

  @override
  State<TestSearch> createState() => _TestSearchState();
}

class _TestSearchState extends State<TestSearch> {
  TextEditingController tecDaysToScan = TextEditingController();
  TextEditingController tecKeywordsToScan = TextEditingController();
  TextEditingController tecSitesToScan = TextEditingController();
  bool isLoading = false;
  List <News> news = [];

  @override
  initState() {
    super.initState();
    tecKeywordsToScan.text = glSearch.keywords;
    tecSitesToScan.text = glSearch.site;
    tecDaysToScan.text = '5';
    _trySearch();
  }

  @override
  void dispose() {
    tecDaysToScan.dispose();
    tecKeywordsToScan.dispose();
    tecSitesToScan.dispose();
    super.dispose();
  }

  _trySearch() async {
    isLoading = true; setState((){});
    news = await glTrySearch(tecKeywordsToScan.text, tecSitesToScan.text, tecDaysToScan.text);
    isLoading = false; setState((){});
  }

  List <Widget> linksW () {
    List <Widget> lst = [];
    lst.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text('search results:', textAlign: TextAlign.center, textScaleFactor: 1.3,),
    ));
    for (int idx=0; idx<news.length; idx++) {
      News n = news[idx];
      lst.add(ListTile(
        title: GestureDetector(
          onTap: (){
            print('launching ${n.link}');
            launchUrl(Uri.parse(n.link));
          },
          child: Container(
            color: idx%2==0? Colors.white : Colors.white24,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: Text(n.title, textScaleFactor: 1.1,)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: Text(n.link, textScaleFactor: 0.9,)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ));
      lst.add(Divider(thickness: 2,));
    }
    return lst;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Keywords test'),
          ],
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 12,),
              TextField(
                controller: tecKeywordsToScan,
                style: const TextStyle(color: Colors.blue),
                textAlign: TextAlign.center,
                showCursor: true,
                decoration: InputDecoration(
                  labelText: "keywords",
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                  fillColor: Colors.white,
                  border:OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
              const SizedBox(height: 12,),
              TextField(
                controller: tecSitesToScan,
                style: const TextStyle(color: Colors.blue),
                textAlign: TextAlign.center,
                showCursor: true,
                decoration: InputDecoration(
                  labelText: "sites (coma delimiter)",
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                  fillColor: Colors.white,
                  border:OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
              const SizedBox(height: 12,),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tecDaysToScan,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.blue),
                      textAlign: TextAlign.center,
                      showCursor: true,
                      decoration: InputDecoration(
                        labelText: "deep days to scan",
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        fillColor: Colors.white,
                        border:OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black, width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                  isLoading?
                  CircularProgressIndicator()
                      :
                  IconButton(
                    onPressed: _trySearch,
                    icon: Icon(Icons.search, size: 40, color: Colors.blueAccent,)
                  ),
                ],
              ),
              const SizedBox(height: 12,),
              ...linksW(),
            ],
          ),
        ),
      ),
    );
  }
}
