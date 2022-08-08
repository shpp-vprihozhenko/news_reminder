import 'package:flutter/material.dart';

import 'globals.dart';

class WorkArea extends StatefulWidget {
  const WorkArea({Key? key}) : super(key: key);

  @override
  State<WorkArea> createState() => _WorkAreaState();
}

class _WorkAreaState extends State<WorkArea> {
  List <Search> searches = [];

  @override
  initState() {
    super.initState();
    _getExistingSearches();
  }

  _getExistingSearches() async {
    searches = await glGetExistingSearches();
    setState((){});
  }

  _addNewSearch() async {
    TextEditingController tecKeywords = TextEditingController();
    TextEditingController tecSite = TextEditingController();
    var result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Add new search'),
                const SizedBox(height: 22,),
                TextField(
                  autofocus: true,
                  controller: tecKeywords,
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
                const SizedBox(height: 16,),
                TextField(
                  controller: tecSite,
                  style: const TextStyle(color: Colors.blue),
                  textAlign: TextAlign.center,
                  showCursor: true,
                  decoration: InputDecoration(
                    labelText: "sites (optional)",
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    fillColor: Colors.white,
                    border:OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                const SizedBox(height: 24,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green
                      ),
                      onPressed: (){
                        Navigator.pop(context, 'ok');
                      },
                      child: const Text('Ok')
                    ),
                    const SizedBox(width: 40,),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey
                        ),
                        onPressed: (){
                          Navigator.pop(context, 'cancel');
                        },
                        child: const Text('Cancel')
                    ),
                  ],
                ),
              ],
            ),
          );
        }
    );
    if (result == null || result == 'cancel') {
      return;
    }
    Search search = Search();
    search.keywords = tecKeywords.text.trim();
    search.site = tecSite.text.trim();
    print('add new search $search');
    String newId = await glAddSearch(context, search);
    if (newId != '') {
      search.id = newId;
      searches.add(search);
      setState((){});
    }
  }

  _editSearch(Search element) async {
    print('edit $element');
    TextEditingController tecKeywords = TextEditingController();
    TextEditingController tecSite = TextEditingController();
    tecKeywords.text = element.keywords;
    tecSite.text = element.site;
    var result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Edit search'),
                const SizedBox(height: 22,),
                TextField(
                  autofocus: true,
                  controller: tecKeywords,
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
                const SizedBox(height: 16,),
                TextField(
                  controller: tecSite,
                  style: const TextStyle(color: Colors.blue),
                  textAlign: TextAlign.center,
                  showCursor: true,
                  decoration: InputDecoration(
                    labelText: "sites (optional)",
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    fillColor: Colors.white,
                    border:OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                const SizedBox(height: 24,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green
                        ),
                        onPressed: (){
                          Navigator.pop(context, 'ok');
                        },
                        child: const Text('Ok')
                    ),
                    const SizedBox(width: 40,),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey
                        ),
                        onPressed: (){
                          Navigator.pop(context, 'cancel');
                        },
                        child: const Text('Cancel')
                    ),
                  ],
                ),
              ],
            ),
          );
        }
    );
    if (result == null || result == 'cancel') {
      return;
    }
    element.keywords = tecKeywords.text.trim();
    element.site = tecSite.text.trim();
    print('updt new search $element');
    if (await glUpdtSearch(context, element)) {
    if (!mounted) {
      return;
    }
    setState((){});
    }
  }

  _delSearch(Search element) async {
    print('del $element');
    TextEditingController tecKeywords = TextEditingController();
    TextEditingController tecSite = TextEditingController();
    tecKeywords.text = element.keywords;
    tecSite.text = element.site;
    var result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Are you sure to delete?'),
                const SizedBox(height: 22,),
                TextField(
                  controller: tecKeywords,
                  style: const TextStyle(color: Colors.blue),
                  textAlign: TextAlign.center,
                  showCursor: false,
                  readOnly: true,
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
                const SizedBox(height: 16,),
                TextField(
                  controller: tecSite,
                  style: const TextStyle(color: Colors.blue),
                  textAlign: TextAlign.center,
                  showCursor: false,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "site",
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    fillColor: Colors.white,
                    border:OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                const SizedBox(height: 24,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green
                        ),
                        onPressed: (){
                          Navigator.pop(context, 'ok');
                        },
                        child: const Text('yes')
                    ),
                    const SizedBox(width: 40,),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey
                        ),
                        onPressed: (){
                          Navigator.pop(context, 'cancel');
                        },
                        child: const Text('no')
                    ),
                  ],
                ),
              ],
            ),
          );
        }
    );
    if (result == null || result == 'cancel') {
      return;
    }
    String onDelMsg = await delSearch(element.id);
    if (onDelMsg == '') {
      int idToDel = searches.indexWhere((el) => el.id == element.id);
      searches.removeAt(idToDel);
      setState((){});
    } else {
      if (mounted) {
        glShowAlertPage(context, 'Error on delete.\n$onDelMsg');
      }
    }
  }

  _testSearch(element){
    print('test $element');
  }

  List <Widget> existingSearches () {
    List <Widget> lw = [];
    int idx=0;
    for (var element in searches) {
      idx++;
      lw.add(Container(
        color: idx%2==0? Colors.white: Colors.white24,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: (){
                  _testSearch(element);
                },
                child: Text(element.keywords+
                  (element.site == ''? '' : '\n${element.site}')
                ),
              ),
            ),
            IconButton(
              onPressed: (){
                _editSearch(element);
              },
              icon: const Icon(Icons.edit, color: Colors.green,),
            ),
            IconButton(
              onPressed: (){
                _delSearch(element);
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ));
      lw.add(const Divider(thickness: 2, height: 5,));
    }
    lw.add(const SizedBox(height: 50,));
    return lw;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: null,
        title: Row(
          children: [
            const Text('Your searches'),
            const Spacer(),
            Text('Hello,\n$glName', textScaleFactor: 0.8,),
            IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.exit_to_app)
            ),
          ],
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(12),
        child: ListView(
          children: [
            ...existingSearches()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewSearch,
        child: const Icon(Icons.add),
      ),
    );
  }
}
