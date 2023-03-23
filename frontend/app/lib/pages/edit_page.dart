import 'package:app/UI/colors.dart';
import 'package:app/pages/SUlogin_page.dart';
import 'package:app/widgets/app_large_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/app_text.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  List entries = [
    "Address A",
    "Address B",
    "Address C",
    "Address D",
  ];

  var login = false;
  @override
  Widget build(BuildContext context) {
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
                        onPressed: () {},
                        icon: CircleAvatar(
                          radius: 130,
                          backgroundColor: AppColors.starColor,
                          backgroundImage:
                              const AssetImage("assets/images/avatar.jpeg"),
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
                onPressed: () {
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
}
