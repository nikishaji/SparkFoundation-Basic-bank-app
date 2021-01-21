import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_1/money.dart';
import 'user.dart';
import 'account.dart';

List<person> customerList = List<person>();

class Customer extends StatefulWidget {
  static const routename = '/customer';

  @override
  _CustomerState createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  bool loading;
  work() async {
    final dbreference = FirebaseDatabase.instance.reference();
    await dbreference.child('user').once().then(
      (DataSnapshot data) {
        if (data != null) {
          customerList.clear();
          print("hallo");
          print(data.value.keys);
          var keys = data.value.keys;
          print(keys.runtimeType);
          print(keys);
          var values = data.value;
          for (var key in keys) {
            person p = person(
                values[key]['name'].toString(),
                values[key]['accountno'].toString(),
                values[key]['balance'].toString());
            print('Name: ' +
                values[key]['name'].toString() +
                " accno:" +
                values[key]['accountno'].toString() +
                " balance:" +
                values[key]['balance'].toString());
            customerList.add(p);
            print(customerList);
          }
        }
      },
    );
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
        backgroundColor: Colors.teal[900],
        appBar: AppBar(
          title: Text('View Customers', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.teal,
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
              loading
                  ? CircularProgressIndicator(
                      semanticsLabel: "Loading..",
                      semanticsValue: "Loading..",
                    )
                  : Text("Select a customer to view details",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center),
              for (var s in customerList)
                ListTile(
                  title: Text(
                    'Name: ${s.name}\nAccno: ${s.accountno}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  trailing: Text('Balance: ${s.balance}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                  tileColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onTap: () => {
                    print(s.accountno),
                    Navigator.pushNamed(context, Account.routename,
                            arguments: s.accountno)
                        .then((value) {
                      loading = true;
                      work();
                    })
                  },
                )
              /*
                  );
                    },
                  )*/
            ])));
  }
}

class person {
  String name, accountno, balance;
  person(this.name, this.accountno, this.balance);
}
