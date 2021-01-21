import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_1/customer.dart';
import 'user.dart';
import 'account.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Money extends StatefulWidget {
  static const routename = '/money';
  String accno;
  Money(this.accno);

  @override
  _MoneyState createState() => _MoneyState();
}

List<person> conformationList = List<person>();

class person {
  String name, accno;
  int index, balance;
  person({this.name, this.index, this.accno, this.balance});
}

showAlertDialog1(BuildContext context, String topic, String accno,
    String toaccno, int bal, int tobal) {
  // set up the button
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Continue"),
    onPressed: () async {
      Navigator.popUntil(context, ModalRoute.withName('/account'));
      final dbreference = FirebaseDatabase.instance.reference();
      int account = int.parse(accno);
      int toaccount = int.parse(toaccno);
      await dbreference
          .child('user/${account}')
          .update({'balance': bal - int.parse(topic)}).then((value) {
        Fluttertoast.showToast(
            msg: 'Thankyou!',
            backgroundColor: Colors.black,
            textColor: Colors.white);
      });
      await dbreference
          .child('user/${toaccount}')
          .update({'balance': tobal + int.parse(topic)}).then((value) {
        Fluttertoast.showToast(
            msg: 'Successfully Transfered !',
            backgroundColor: Colors.black,
            textColor: Colors.white);
      });
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Confirm Transaction"),
    content: Text("Please continue to confirm the transaction"),
    actions: [cancelButton, continueButton],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertDialog(BuildContext context, String topic) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Input is Empty"),
    content: Text(topic),
    actions: [
      okButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class _MoneyState extends State<Money> {
  int id = 0;
  bool loading;
  static var radioItem = "";
  static var toaccno;
  static int bal = 0;
  static int tobal = 0;
  final _feedbackcontroller = TextEditingController();
  void work() async {
    final dbreference = FirebaseDatabase.instance.reference();
    await dbreference.child('user').once().then(
      (DataSnapshot data) {
        if (data != null) {
          conformationList.clear();
          int index = 0;
          print("hallo");
          print(data.value.keys);
          var keys = data.value.keys;
          print(keys.runtimeType);
          print(keys);
          print(widget.accno);
          print(widget.accno.runtimeType);

          var values = data.value;
          print(values[63456775]);
          for (var key in keys) {
            if (values[key]['accountno'].toString() != widget.accno) {
              print("got");
              index += 1;
              person p = person(
                  name: values[key]['name'].toString(),
                  index: index,
                  accno: values[key]['accountno'].toString(),
                  balance: values[key]['balance']);
              print('Name: ' +
                  values[key]['name'].toString() +
                  " accno:" +
                  values[key]['accountno'].toString());
              conformationList.add(p);
              print(conformationList);
            }
            if (values[key]['accountno'].toString() == widget.accno) {
              print("balance");
              bal = values[key]['balance'];
              print(bal);
            }
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
        appBar: AppBar(
          title: Text('Transaction details',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.teal,
        ),
        backgroundColor: Colors.teal[900],
        body: SafeArea(
            child: Center(
                child:

                    // Group Value for Radio Button.

                    Column(
          children: <Widget>[
            loading
                ? CircularProgressIndicator(
                    semanticsLabel: "Loading..",
                    semanticsValue: "Loading..",
                  )
                : Expanded(
                    child: Container(
                    height: 800.0,
                    child: Column(
                      children: conformationList
                          .map((data) => RadioListTile(
                                activeColor: Colors.white,
                                title: Text("${data.name}",
                                    style: TextStyle(color: Colors.white)),
                                groupValue: id,
                                value: data.index,
                                subtitle: Text("Account no: ${data.accno}",
                                    style: TextStyle(color: Colors.white)),
                                onChanged: (val) {
                                  setState(() {
                                    radioItem = data.name;
                                    id = data.index;
                                    toaccno = data.accno;
                                    tobal = data.balance;
                                  });
                                },
                              ))
                          .toList(),
                    ),
                  )),
            TextFormField(
              controller: _feedbackcontroller,
              style: TextStyle(color: Colors.white),
              decoration: new InputDecoration(
                fillColor: Colors.white,
                labelText: "Amount to be transfered",
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: RaisedButton(
                color: Colors.white,
                onPressed: () {
                  String data = _feedbackcontroller.text.trim();
                  if (id == 0) {
                    showAlertDialog(context, "Please select a account");
                  } else if (data == null || data == '') {
                    showAlertDialog(
                        context, "Please enter the amount to transfer");
                  } else {
                    showAlertDialog1(context, _feedbackcontroller.text,
                        widget.accno, toaccno, tobal, bal);
                  }
                },
                child: Text('Transfer', style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ))));
  }
}
