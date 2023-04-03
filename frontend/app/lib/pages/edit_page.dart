import 'package:app/UI/colors.dart';
import 'package:app/pages/SUlogin_page.dart';
import 'package:app/widgets/app_large_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';

import '../../misc/wallet.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;



import '../widgets/app_text.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key}) : super(key: key);
  

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  File? _imageFile;


  List entries = [
    "Address A",
    "Address B",
    "Address C",
    "Address D",
  ];

  var login = false;
  void _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);
    final _controller = TextEditingController();


    final FocusNode _focusNode = FocusNode();
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
       appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Edit Your Profile",
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
      ),
      body: SingleChildScrollView(
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
                      onPressed: _pickImage,
                      icon: CircleAvatar(
                        radius: 130,
                        backgroundColor: AppColors.starColor,
                        backgroundImage: _imageFile != null ? FileImage(_imageFile!) as ImageProvider<Object> : const AssetImage("assets/images/avatar.jpeg"),
                      ),
                    ),

                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 37,
                      ),
                      Container(
                        width: width*.5,
                        child: AppText(
                          color: Colors.black,
                          text: "Click the avatar to update your profile picture",
                          size: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ],
              ),
              
            ),
            Divider(
              height: 1,
              thickness: 1.5,
              color: Color.fromARGB(255, 155, 156, 165).withOpacity(0.5),
            ),
            SizedBox(
              height: 30,
            ),
            AppText(text: "Update your username:",color: Colors.black,),
            SizedBox(
              height: 10,
            ),
            Container(
              width: width*.7,
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  labelText: 'Your username',
                  border: OutlineInputBorder(),
                ),
                onTap: () {
                  if (_focusNode.hasFocus) {
                    _focusNode.unfocus();
                  }
                },
              ),

            ),
          ]),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: login == false
          ? Container(
              height: 40,
              width: 100,
              child: FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                elevation: 3,
                backgroundColor: AppColors.starColor,
                onPressed: () async {
                  // Get the wallet ID and profile picture URL from the WalletProvider
                  String walletId = Provider.of<WalletProvider>(context, listen: false).wallet!.wallet_id;
                  String pictureUrl = _imageFile != null ? _imageFile!.path : "assets/images/avatar.jpeg"; // If no image is selected, set an empty string as the picture URL
                  String username = _controller.text;

                  // Send the POST request
                  http.Response response = await linkWallet(pictureUrl , username,  walletId);

                  // Handle the response
                  if (response.statusCode == 200) {
                    // The request was successful, do something
                  } else {
                    // The request failed, handle the error
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppText(
                    text: "Update",
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
    Future<http.Response> linkWallet(String pictureUrl, String name, String wallet_id) {
    var url = Uri.parse('https://2320-159-20-68-5.eu.ngrok.io/edit');
    return http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'wallet_id': wallet_id,
        'name': name,
        'picture_url': pictureUrl,
      }),
    );
 }

}
