import 'dart:convert';

import 'package:app/UI/colors.dart';
import 'package:app/pages/SUlogin_page.dart';
import 'package:app/pages/edit_page.dart';
import 'package:app/widgets/app_large_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import '../misc/wallet.dart';
import '../widgets/app_text.dart';
import 'package:http/http.dart' as http;


class ProfilePage extends StatefulWidget {
  ProfilePage({ Key? key, }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();

}

class _ProfilePageState extends State<ProfilePage> {
  var connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
          name: 'SU Wallet',
          description: 'An app for a new payment.',
          url: 'https://walletconnect.org',
          icons: []));
  var _uri, _session, account, _signature, chainId;

  var accountBalance = 0.0;
  var _wallet_id;

  void listenTx(String address) async {
    var client = http.Client();
    try {
      var response = await client.post(
        Uri.parse("http://10.0.2.2:3000/subscribe"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'addr': address}),
      );
      var decResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      var uri = Uri.parse(decResponse['uri'] as String);
      print(await client.get(uri));
    } finally {
      client.close();
    }
  }

  void _setWallet(BuildContext context, String id) {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);

    Wallett wallet = Wallett(
      wallet_id: id,
    );

    walletProvider.setWallet(wallet);
  }

  loginUsingMetamask(BuildContext context) async {
    if (!connector.connected) {
      try {
        var session = await connector.createSession(onDisplayUri: (uri) async {
          _uri = uri;
          await launchUrlString(uri, mode: LaunchMode.externalApplication);
        });
        listenTx(session.accounts[0]);
        setState(() {
          _session = session;
          account = session.accounts[0];
          _setWallet(context, session.accounts[0]);
        });
      } catch (exp) {
        // print(exp);
      }
    }
  }
  Future<bool> _getConnectedValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('connector_connected') ?? false;
  }

  List entries = [
    "Address A",
    "Address B",
    "Address C",
    "Address D",
  ];

  
  @override
  void initState() {
    super.initState();
    // Send GET request when the page is first loaded
    sendGetRequest();
  }
  String _imageUrl = "assets/images/avatar.jpeg";
  String _name = "Your name..";
  String walletId = "";

  Future<void> sendGetRequest() async {
    // Replace the URL with the endpoint you want to hit
    final String baseUrl = "https://2320-159-20-68-5.eu.ngrok.io/profile";
    walletId = Provider.of<WalletProvider>(context, listen: false).wallet!.wallet_id;

    Uri url = Uri.parse(baseUrl + "?wallet_id=" + walletId);
    try {
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse the JSON response body into a Map<String, dynamic>
        Map<String, dynamic> responseBody = json.decode(response.body);
        print(responseBody);
        // Extract the "image_url" and "name" values from the response body
        
        if(responseBody['image_url'] == null) {
          _imageUrl = "assets/images/avatar.jpeg";
        }
        else {
          _imageUrl = responseBody['image_url'];
        }
        _name = responseBody['name'];

        // Handle successful response
        print("Image URL: $_imageUrl");
        print("Name: $_name");
      } else {
        // Handle error response
        print('Request failed with status: ${response.statusCode}.');
        
      }
    }
    catch (error){
      _imageUrl = "assets/images/avatar.jpeg";
      print(error);
    }
  }

  @override
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isConnected', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
  }



  var isLogin = false;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    final walletProvider = Provider.of<WalletProvider>(context);
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
       appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(
            fontSize: 25,
            color: Colors.white70,
          ),
        ),
        backgroundColor: AppColors.mainColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_sharp),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          (walletProvider.wallet?.wallet_id != null)?Row(
            children: [
              Center(
                child: Container(
                  child: AppText(text: "Edit",color: Colors.white70,),
                )
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: InkWell(
                    splashColor: AppColors.mainColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditPage()),
                      );
                    },
                    child: const Icon(
                      Icons.edit,
                      size: 25,
                      color: Colors.white70,
                    ),
                  ),
                ),
            ],
          ):const SizedBox(height: 0, width: 0,),

        ],
      ),
      body: (walletProvider.wallet?.wallet_id != null)?SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        iconSize: 130,
                        onPressed: () {},
                        icon: CircleAvatar(
                          radius: 130,
                          backgroundColor: AppColors.starColor,
                          backgroundImage:
                              AssetImage(_imageUrl),
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 37,
                      ),
                      AppText(
                        text: _name,
                        size: 20,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: width * .45,
                        child: AppText(
                          text: "ID: "+ walletId,
                          color: Colors.black54,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  border: Border.all(color: AppColors.mainColor, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppLargeText(
                          text: "Account Balance",
                          color: AppColors.bigTextColor,
                          size: 15),
                      AppLargeText(
                        text: "25 ETH",
                        color: AppColors.bigTextColor,
                        size: 15,
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            AppLargeText(
              text: "Wallet Adresses:",
              size: 25,
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                padding: const EdgeInsets.fromLTRB(8, 5, 8, 0),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.mainColor, width: 3),
                    borderRadius: BorderRadius.circular(12)),
                height: entries.length*60,
                child: ListView.separated(
                  itemCount: entries.length,
                  padding: const EdgeInsets.all(2),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BoxDecoration(
                          color: AppColors.buttonBackground,
                          borderRadius: BorderRadius.circular(10)),
                      height: 50,
                      child: Center(
                          child: AppText(
                        text: "${entries[index]}",
                        color: Colors.white,
                      )),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                    height: 7,
                    thickness: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            AppLargeText(
              text: "Contact List:",
              size: 25,
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                padding: const EdgeInsets.fromLTRB(8, 5, 8, 0),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.mainColor, width: 3),
                    borderRadius: BorderRadius.circular(12)),
                height: entries.length*60,
                child: ListView.separated(
                  itemCount: entries.length,
                  padding: const EdgeInsets.all(2),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BoxDecoration(
                          color: AppColors.buttonBackground,
                          borderRadius: BorderRadius.circular(10)),
                      height: 50,
                      child: Center(
                          child: AppText(
                        text: "${entries[index]}",
                        color: Colors.white,
                      )),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                    height: 7,
                    thickness: 1,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height*0.03,
            ),
            /*Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30)
                  ),
                  height: height*0.05,
                  width: width*0.60,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => AppColors.buttonBackground,
                      ),
                    ),
                      onPressed: () => {logout()},
                      child: AppText(text: "Logout from Metamask", color: Colors.white,)
                  ),
                )
              ],
            ),*/
            SizedBox(
              height: height*0.1,
            )
          ]),
        ),
      ):Container(
        padding: const EdgeInsets.symmetric(horizontal:25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppLargeText(text: "You are not logged in via Metamask. Please log in.",),
            SizedBox(height: 30,),
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: AppColors.starColor,width: 1)
              ),
              child: IconButton(
                onPressed: () => {loginUsingMetamask(context)},
                icon: CircleAvatar(
                  radius: 50,
                  backgroundColor: (walletProvider.wallet?.wallet_id != null)?Colors.green:Colors.white,
                  backgroundImage: const AssetImage("assets/images/metamask_logo.png"),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isLogin == false
          ? Container(
              height: 40,
              width: 200,
              child: FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                elevation: 3,
                backgroundColor: AppColors.starColor,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const suloginPage()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppText(
                    text: "Login via Sabanci CAS",
                    size: 15,
                    color: Colors.black54,
                  ),
                ),
              ),
            )
          : Container(
              height: 0,
              width: 0,
            ),
    );
  }
}
