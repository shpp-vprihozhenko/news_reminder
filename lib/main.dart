import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'globals.dart';
import 'workArea.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News reminder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const MyHomePage(),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isWeb => kIsWeb;

  TextEditingController tecEmail = TextEditingController();
  TextEditingController tecName = TextEditingController();
  TextEditingController tecConfirmationCode = TextEditingController();

  bool isWaitingForConfirmationCode = false;

  @override
  initState() {
    super.initState();
    _tryRestoreSharedPreferencesAndGoToWorkAreaIfOk();
  }

  @override
  void dispose() {
    tecName.dispose();
    tecEmail.dispose();
    tecConfirmationCode.dispose();
    super.dispose();
  }

  _tryRestoreSharedPreferencesAndGoToWorkAreaIfOk() async {
    print('_tryRestoreSharedPreferencesAndGoToWorkAreaIfOk');
    if (await restoreSharedPreferences()) {
      print('shared preferences restored ok');
      _gotoWorkArea();
    } else {
      print('no saved preferences');
    }
  }

  _gotoWorkArea() {
    print('goto workArea with email $glEmail name $glName code $glCode');
    Navigator.push(context,
      MaterialPageRoute(builder: (context) => const WorkArea())
    );
  }

  _ok() async {
    if (isWaitingForConfirmationCode) {
      if (await glCreateUserIfCorrectCode(tecEmail.text.trim(), tecName.text.trim(), tecConfirmationCode.text.trim())) {
        print('user created');
        _gotoWorkArea();
      } else {
        await glShowAlertPage(context, 'Code is incorrect.\nTry again.');
        tecConfirmationCode.text = '';
        setState((){});
      }
    } else {
      isWaitingForConfirmationCode = !isWaitingForConfirmationCode;
      setState((){});
      if (await glSendConfirmationCodeToEmail(tecEmail.text.trim())) {
        await glShowAlertPage(context, 'Confirmation code sent.\nCheck email please');
      } else {
        await glShowAlertPage(context, 'Something went wrong.\nTry again later please');
      }
    }
  }

  _changeEmail(){
    tecConfirmationCode.text = '';
    isWaitingForConfirmationCode = false;
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Login page'),
        ),
        body: SafeArea(
          minimum: const EdgeInsets.all(10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Please, sign in'),
                const SizedBox(height: 20,),
                TextField(
                  controller: tecEmail,
                  readOnly: isWaitingForConfirmationCode,
                  style: const TextStyle(color: Colors.blue),
                  textAlign: TextAlign.center,
                  showCursor: true,
                  autofocus: !isWaitingForConfirmationCode,
                  decoration: InputDecoration(
                    labelText: "Email",
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    //alignLabelWithHint: true,
                    //labelStyle: TextStyle(),
                    fillColor: Colors.white,
                    border:OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                const SizedBox(height: 12,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  onPressed: !isWaitingForConfirmationCode? _ok:null,
                  child: const Text('send confirmation code', textScaleFactor: 1.4,), //style: TextStyle(backgroundColor: Colors.green)
                ),
                const SizedBox(height: 12,),
                TextField(
                  controller: tecName,
                  style: const TextStyle(color: Colors.blue),
                  textAlign: TextAlign.center,
                  showCursor: true,
                  decoration: InputDecoration(
                    labelText: "Name",
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    fillColor: Colors.white,
                    border:OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                Column(
                      children: [
                        const SizedBox(height: 12,),
                        const Divider(thickness: 2,),
                        const SizedBox(height: 12,),
                        TextField(
                          controller: tecConfirmationCode,
                          style: const TextStyle(color: Colors.blue),
                          textAlign: TextAlign.center,
                          readOnly: !isWaitingForConfirmationCode,
                          showCursor: true,
                          autofocus: isWaitingForConfirmationCode,
                          decoration: InputDecoration(
                            labelText: "Confirmation code",
                            floatingLabelAlignment: FloatingLabelAlignment.center,
                            fillColor: Colors.white,
                            border:OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                        )
                      ],
                  ),
                const SizedBox(height: 22,),
                ElevatedButton(
                  onPressed: isWaitingForConfirmationCode? _ok:null,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text('OK', textScaleFactor: 1.4,),
                  ),
                ),
                const SizedBox(height: 22,),
                isWaitingForConfirmationCode?
                  ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.grey),
                  onPressed: _changeEmail,
                  child: const Text('change email', textScaleFactor: 1,),
                )
                :
                  SizedBox()
                ,
              ],
            ),
          ),
        ),
      ),
    );
  }

}