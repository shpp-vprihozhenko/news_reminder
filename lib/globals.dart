import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

String glNodeUrl = kIsWeb?'http://localhost:6635' : 'http://173.212.250.234:6635';
String glEmail='', glName='', glCode = '';

class Search {
  String id = '';
  String keywords = '';
  String site = '';

  @override
  String toString() {
    return '$keywords site $site id $id';
  }
}

Future <List<Search>> glGetExistingSearches() async {
  print('send req to $glNodeUrl/getSearchList');
  var response = await http.post(Uri.parse('$glNodeUrl/getSearchList'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(
        <String, dynamic> {
          "email": glEmail,
          "code": glCode,
        }
    ),
  );
  print('got response status: ${response.statusCode} body ${response.body}');
  if (response.statusCode == 200) {
    try {
      var j = jsonDecode(response.body);
      print('got j\n$j');
      List <Search> ls = [];
      j.forEach((el){
        Search search = Search();
        search.id = el['id'];
        search.keywords = el['keywords'];
        search.site = el['site'] ?? '';
        ls.add(search);
      });
      return ls;
    } catch(e){
      print('got e $e');
    }
  }
  return [];
}

Future <String> delSearch(id) async {
  print('send req to $glNodeUrl/delSearch');
  var response = await http.post(Uri.parse('$glNodeUrl/delSearch'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(
      <String, dynamic> {
        "email": glEmail,
        "code": glCode,
        "id": id
      }
    ),
  );
  print('got response status: ${response.statusCode} body ${response.body}');
  if (response.statusCode != 200) {
    return response.body;
  }
  return '';
}

Future <bool> glUpdtSearch(context, Search search) async {
  print('send req to $glNodeUrl/editSearch');
  var response = await http.post(Uri.parse('$glNodeUrl/editSearch'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(
        <String, dynamic> {
          "email": glEmail,
          "code": glCode,
          "keywords": search.keywords,
          "site": search.site,
          "id": search.id
        }
    ),
  );
  print('got response status: ${response.statusCode} body ${response.body}');
  if (response.statusCode != 200) {
    await glShowAlertPage(context, 'Error on edit. ${response.body}');
    return false;
  }
  return true;
}

Future <String> glAddSearch(context, Search search) async {
  print('send req to $glNodeUrl/addSearch');
  var response = await http.post(Uri.parse('$glNodeUrl/addSearch'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(
        <String, dynamic> {
          "email": glEmail,
          "code": glCode,
          "keywords": search.keywords,
          "site": search.site
        }
    ),
  );
  print('got response status: ${response.statusCode} body ${response.body}');
  if (response.statusCode != 200) {
    await glShowAlertPage(context, 'Error on add. ${response.body}');
    return '';
  }
  return response.body;
}

Future <bool> glSendConfirmationCodeToEmail(email) async {
  print('send req to $glNodeUrl/checkEmail');
  var response = await http.post(Uri.parse('$glNodeUrl/checkEmail'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(
        <String, dynamic> {
          "email": email,
        }
    ),
  );
  print('got response status: ${response.statusCode} body ${response.body}');
  return response.statusCode == 200;
}

glCreateUserIfCorrectCode(email, name, code) async {
  print('send req to $glNodeUrl/addEmail');
  var response = await http.post(Uri.parse('$glNodeUrl/addEmail'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(
        <String, dynamic> {
          "email": email,
          "name": name,
          "code": code
        }
    ),
  );
  print('got response status: ${response.statusCode} body ${response.body}');
  if (response.statusCode == 200) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('name', name);
    await prefs.setString('code', code);
    glEmail = email;
    glName = name;
    glCode = code;
  }
  return response.statusCode == 200;
}

glShowAlertPage(context, String msg) async {
  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(msg, textAlign: TextAlign.center,),
        );
      }
  );
}

Future <bool> glAskYesNo(context, String msg) async {
  var result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SelectableText(msg, textAlign: TextAlign.center,),
          actions: [
            Container(
              color: Colors.greenAccent[200],
              child: OutlinedButton(
                  onPressed: (){
                    Navigator.pop(context, true);
                  },
                  child:  Text('YES')
              ),
            ),
            Container(
              color: Colors.red[200],
              child: OutlinedButton(
                  onPressed: (){
                    Navigator.pop(context, false);
                  },
                  child:  Text('NO')
              ),
            ),
          ],
        );
      }
  );
  if (result == null) {
    return false;
  }
  return result;
}

Future <bool> restoreSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  glEmail = prefs.getString('email') ?? '';
  if (glEmail == '') {
    return false;
  }
  glName = prefs.getString('name') ?? '';
  glCode = prefs.getString('code') ?? '';
  return true;
}