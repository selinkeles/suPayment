import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as io;

class ServerConnector {
  final httpClient = http.Client();
  final url = "https://566a-159-20-68-5.eu.ngrok.io";
  late String endpoint;
  late Uri uri;
  late String userAddress;
  late io.Socket socket;

  // constructor
  ServerConnector(this.userAddress) {
    socket =
        io.io(url, io.OptionBuilder().setTransports(["websocket"]).build());
  }

  io.Socket getSocket() {
    return socket;
  }

  // get: url/
  Future<bool> getHome() async {
    endpoint = "/";
    uri = Uri.parse(url + endpoint);
    final response = await httpClient.get(uri);
    if (response.statusCode != 200) {
      return false;
    }
    return true;
  }

  // endpoints
  Future<List<dynamic>> getUsers() async {
    endpoint = "/users";
    uri = Uri.parse(url + endpoint);
    final response = await httpClient.get(uri);
    final List<dynamic> dataList = jsonDecode(response.body);
    List<String> new_entries = [];
    for (var element in dataList) {
      new_entries.add(element['email']);
    }
    return dataList;
  }

  Future<dynamic> getProfile(String userAddress) async {
    late String query = "?user_address=$userAddress";
    endpoint = "/profile";
    uri = Uri.parse(url + endpoint + query);
    final response = await httpClient.get(uri);
    final profileInfo = jsonDecode(response.body);

    // late String address = profile_info['address'];
    // late String image_url = profile_info['image_url'];
    // late String name = profile_info['name'];

    return profileInfo;
  }

  Future<int> postLink(String userAddres, String email) async {
    endpoint = "/link";
    uri = Uri.parse(url + endpoint);
    final data = {"userAddres": userAddres, "email": email};
    final body = jsonEncode(data);
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    };
    final response = await httpClient.post(uri, headers: headers, body: body);
    final statusCode = response.statusCode;
    return statusCode;
  }

  Future<int> postSubscribe(String userAddress) async {
    endpoint = "/subscribe";
    uri = Uri.parse(url + endpoint);
    final data = {"userAddres": userAddress};
    final body = jsonEncode(data);
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    };
    final response = await httpClient.post(uri, headers: headers, body: body);
    final statusCode = response.statusCode;
    return statusCode;
  }

  Future<int> putEdit(
      String userAddress, String? imageUrl, String? name) async {
    endpoint = "/edit";
    uri = Uri.parse(url + endpoint);
    final data = {"userAddres": userAddress};
    final body = jsonEncode(data);
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    };
    final response = await httpClient.put(uri, headers: headers, body: body);
    final statusCode = response.statusCode;
    return statusCode;
  }
}
