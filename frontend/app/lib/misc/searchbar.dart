import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class SearchBar extends StatefulWidget {
  final List<String>? userList;

  const SearchBar({Key? key, this.userList}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String? _selectedUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("Select Receiver"),
                ),
                Container(
                    child: SearchField(
                  hint: 'Search',
                  searchInputDecoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
                          borderRadius: BorderRadius.circular(10))),
                  itemHeight: 50,
                  maxSuggestionsInViewPort: 6,
                  suggestionsDecoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  onSubmit: (value) {
                    setState(() {
                      _selectedUser = value;
                    });
                  },
                  suggestions: widget.userList!
                      .map((e) => SearchFieldListItem(e))
                      .toList(),
                ))
              ],
            )),
        Container(
          height: 90,
          padding: EdgeInsets.only(right: 20, left: 20, bottom: 20),
          decoration: BoxDecoration(color: Colors.white),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _selectedUser == null
                ? Text("Select a user")
                : Text(_selectedUser!),
            MaterialButton(
              onPressed: () {},
              padding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              child: Icon(Icons.arrow_back_ios),
            ),
          ]),
        )
      ],
    )));
  }
}
