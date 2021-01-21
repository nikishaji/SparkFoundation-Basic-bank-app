import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_1/customer.dart';
import 'money.dart';
import 'user.dart';
import 'transfer.dart';

List<String> detail = List<String>();

class Account extends StatefulWidget {
  static const routename = '/account';
  String accno;
  Account(this.accno);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool loading;
  void work() async {
    final dbreference = FirebaseDatabase.instance.reference();
    await dbreference.child('user').once().then((DataSnapshot data) {
      if (data != null) {
        print("hallo");
        var keys = data.value.keys;
        print(data.value.keys);
        var values = data.value;
        print(widget.accno);
        detail.clear();
        for (var key in keys) {
          print(values[key]);
          if ((values[key]['accountno'].toString()) == widget.accno) {
            print("got");
            detail.addAll([
              values[key]['name'].toString(),
              values[key]['accountno'].toString(),
              values[key]['age'].toString(),
              values[key]['mobileno'].toString(),
              values[key]['branch'].toString(),
              values[key]['emailid'].toString(),
              values[key]['balance'].toString()
            ]);

            break;
          }
        }
      }
    });
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    loading = true;
    work();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Dashboard', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.teal,
        ),
        backgroundColor: Colors.teal[900],
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
              Text("Account Details",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center),
              ClipOval(
                  child: Image.asset(
                'assets/person.png',
                width: 200,
                height: 200,
              )),
              loading
                  ? CircularProgressIndicator(
                      semanticsLabel: "Loading..",
                    )
                  : Text(
                      'Name: ${detail[0]}\nAccount no: ${detail[1]}\nAge: ${detail[2]}\nMobile no: ${detail[3]}\nBranch: ${detail[4]}\nEmail id: ${detail[5]}\nBalance: ${detail[6]}',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Money.routename,
                          arguments: detail[1])
                      .then((value) {
                    loading = true;
                    work();
                  });
                },
                color: Colors.white,
                child: Text('Transfer Money'),
                textColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              )
            ])));
  }
}
