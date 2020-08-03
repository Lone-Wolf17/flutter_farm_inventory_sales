import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_farm_inventory/add_stock_sell_stock_pages.dart';
import 'package:flutter_farm_inventory/drawer_util.dart';
import 'package:flutter_farm_inventory/welcome_page.dart';
import 'package:intl/intl.dart';

import 'farm_records_page.dart';
import 'sales_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light().copyWith(primaryColor: Colors.brown),
      home: WelcomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        drawer: DrawerUtil(),
        body:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <
                Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 8,
              child: Container(
                height: 200,
                child: StreamBuilder(
                    stream: Firestore.instance
                        .collection("farm_records")
                        .where("action", isEqualTo: "sale")
                        .orderBy("dateTime", descending: true)
                        .limit(5)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: ListView(
                            children: <Widget>[
                              CircularProgressIndicator(),
                              Padding(
                                  padding: const EdgeInsets.only(top: 10.0)),
                              Text("Loading...")
                            ],
                          ),
                        );
                      }
                      List sales = List.generate(snapshot.data.documents.length,
                          (index) => snapshot.data.documents[index]['price']);
                      int totalSales = sales.fold(0,
                          (previousValue, current) => previousValue + current);
                      print(snapshot.data.documents[0]['dateTime']);
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          Container(
                            color: Colors.brown[100],
                            width: 350,
                            child: ListView.builder(
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot documentSnap =
                                    snapshot.data.documents[index];
                                Timestamp dateStamp = documentSnap['dateTime'];
//                                print(dateStamp);
                                DateTime date = dateStamp.toDate();
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd - kk:mm')
                                        .format(date);
//                                String formattedTime = DateFormat('kk:mm').format(date);
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 3,
                                        child: Text(formattedDate),
                                      ),
//                                      Expanded(
//                                        child: Text(formattedTime),
//                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          documentSnap['product'],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(documentSnap['quantity']
                                            .toString()),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                            documentSnap['price'].toString()),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            color: Colors.blue,
                            width: 350,
                            child:
                                Center(child: Text("Total Sales: $totalSales")),
                          )
                        ],
                      );
                    }),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => RecordPage()));
                },
                child: Text("Stocks"),
              ),
              RaisedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SalesPage()));
                  },
                  child: Text("Sales"))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SellStockPage()));
                },
                child: Text("Sell"),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AddStockPage()));
                },
                child: Text("Add Stock"),
              )
            ],
          )
        ]));
  }
}
