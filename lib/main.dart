import 'package:flutter/material.dart';
import 'customer.dart';
import 'account.dart';
import 'user.dart';
import 'money.dart';
import 'package:firebase_database/firebase_database.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CID Bank',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Raleway',
      ),
      home: MyHomePage(title: 'CID'),
      onGenerateRoute: (settings) {
        if (settings.name == Customer.routename) {
          final args = settings.arguments;
          return MaterialPageRoute(builder: (context) {
            return Customer();
          });
        } else if (settings.name == Account.routename) {
          final args = settings.arguments;
          return (MaterialPageRoute(
              settings: RouteSettings(name: '/account'),
              builder: (context) {
                return Account(args as String);
              }));
        } else if (settings.name == Money.routename) {
          final args = settings.arguments;
          return (MaterialPageRoute(builder: (context) {
            return Money(args as String);
          }));
        }
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  var globaldata;
  User user;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  void func() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[900],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                  width: 150,
                  height: 150,
                  child: ClipOval(child: Image.asset('assets/bank.jpg'))),
              Text(
                "CID Bank\nCash In Dollar",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              Text(
                "'Transfer Money at a click'",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () =>
                    {Navigator.pushNamed(context, Customer.routename)},
                child: Text("Transfer Money"),
                textColor: Colors.black,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
