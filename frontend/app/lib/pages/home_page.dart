import 'package:app/misc/colors.dart';
import 'package:app/pages/profile_page.dart';
import 'package:app/widgets/app_large_text.dart';
import 'package:app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List entries = [
    "Transaction A",
    "Transaction B",
    "Transaction C",
    "Transaction D",
    "Transaction E"
  ];
  var connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
          name: 'SuPayment',
          description: 'An app for a new payment.',
          url: 'https://walletconnect.org'
        //icons: [
        //  'https://files.gitbook.com/v0/b/gitbook-legacy-files/o/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
        //]
      ));

  var _uri, _session;

  loginUsingMetamask(BuildContext context) async {
    if (!connector.connected) {
      try {
        var session = await connector.createSession(onDisplayUri: (uri) async {
          _uri = uri;
          await launchUrlString(uri, mode: LaunchMode.externalApplication);
        });
        print(session.accounts[0]);
        print(session.chainId);
        setState(() {
          _session = session;
        });
      } catch (exp) {
        print(exp);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const profilePage()),
            );
          },
          icon: CircleAvatar(
                backgroundColor: AppColors.starColor,
                backgroundImage: const AssetImage("assets/images/avatar.jpeg"),
              ),

        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               const SizedBox(height: 10),
               TextButton(
                  onPressed: () => loginUsingMetamask(context),
                  child: Container(
                      height: 40,
                      width: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.buttonBackground
                      ),
                      child: Center(child: AppText(text: "Connect to Metamask", color: Colors.white,))),
                ),
               Divider(
                color: AppColors.textColor2,
                thickness: 1,
                 height: 1,
              ),
              const SizedBox(height: 30,),
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
                      children:[
                        AppLargeText(text:"Account Balance",color: AppColors.bigTextColor,size: 15),
                        AppLargeText(text: "25 ETH", color: AppColors.bigTextColor, size: 15,)
                      ]
                      ,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Divider(
                color: AppColors.textColor2,
                thickness: 1,
                height: 1,
              ),
              const SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppLargeText(text: "Recent Transactions",size: 24,),
                ],
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  height: height * .50,
                  child: ListView.separated(
                      itemCount: entries.length,
                    padding: const EdgeInsets.all(2),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.buttonBackground,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          height: 50,
                          child: Center(child: AppText(text: "${entries[index]}",color: Colors.white,)),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => const Divider(height: 7,),

              ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
