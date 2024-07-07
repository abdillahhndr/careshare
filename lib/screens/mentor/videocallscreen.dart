import 'package:careshareapp2/utils/keys.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends StatefulWidget {
  final String url;
  CallPage(this.url, {Key? key}) : super(key: key);

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  final _formKey = GlobalKey<FormState>();
  String id = "", username = "";
  final _idController = TextEditingController(text: '321');
  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      username = pref.getString("username") ?? '';
      // print('id $id');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    // getProduct();
    getSession();
    super.initState();
  }

  // final String callID;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _idController,
                  readOnly: true,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text('Call'),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CallPageScreen(
                callID: _idController.text.toString(), uName: username),
          ));
        },
      ),
    );
  }
}

class CallPageScreen extends StatelessWidget {
  const CallPageScreen({Key? key, required this.callID, required this.uName})
      : super(key: key);
  final String callID;
  final String uName;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
        appID:
            APP_ID, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
        appSign: APP_SIGN,
        userID: uName,
        userName: uName,
        callID: callID,
        // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall());
  }
}
