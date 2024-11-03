import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/model_home.dart';

class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {

  //get data API
  Future<List<ModelHome>> fetchData() async {
    var url = Uri.parse('https://fake-coffee-api.vercel.app/api');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);

      double iJumlah = 0.0;

      for (var i = 0; i < jsonResponse.length; i++) {
        if (iJumlah == 0) {
          iJumlah = double.parse(jsonResponse[i]['price'].toString());
        }
        else {
          iJumlah = iJumlah + double.parse(jsonResponse[i]['price'].toString());
        }
      }

      final Map<String, dynamic> mapTot = Map<String, dynamic>();
      mapTot['name'] = 'Total Harga';
      mapTot['price'] = iJumlah.toInt();
      mapTot['region'] = '';
      jsonResponse.add(mapTot);

      return jsonResponse.map((data) => ModelHome.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SUM DataTable Example'),
      ),
        body: FutureBuilder<List<ModelHome>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.resolveWith((states) => Colors.green),
                      border: const TableBorder(
                        bottom: BorderSide(color: Colors.green),
                        horizontalInside: BorderSide(color: Colors.green)
                      ),
                    columns: const [
                      DataColumn(
                          label: Text(
                            'Name',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          )
                      ),
                      DataColumn(
                          label: Text(
                            'Price',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          )
                      ),
                      DataColumn(
                        label: Text(
                          'Region',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                    rows: List.generate(
                      snapshot.data!.length, (index) {
                        var data = snapshot.data![index];
                        var lastData = index == snapshot.data!.length - 1;

                        return DataRow(
                            color: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                              return Colors.white;
                            }),
                            cells: [
                              DataCell(
                                Text(data.name.toString(),
                                    style: TextStyle(
                                        fontWeight: lastData ? FontWeight.bold : FontWeight.normal,
                                        color: lastData ? Colors.redAccent : Colors.black)
                                ),
                              ),
                              DataCell(
                                Text('\$${data.price}',
                                    style: TextStyle(
                                        fontWeight: lastData ? FontWeight.bold : FontWeight.normal,
                                        color: lastData ? Colors.redAccent : Colors.black)
                                ),
                              ),
                              DataCell(
                                Text(data.region),
                              ),
                            ]
                        );
                      },
                    ).toList(),
                    showBottomBorder: true,
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return const Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
                )
            );
          },
        )
    );
  }
}
