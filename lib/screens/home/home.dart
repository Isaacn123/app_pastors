import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home/scanner.dart';
import 'package:http/io_client.dart';
import 'package:http/io_client.dart';
import 'package:http/io_client.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({super.key, required this.title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  String? qrText;
  Map<String, dynamic>? pastorInfo;

  Future<void> _launchScanner() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const QRScannerPage()),
    );

    if (result != null) {
      setState(() {
        qrText = result;
        _getPastorInfo(result);
      });
    }
    print("user data: ${qrText}");
  }


  Future<void> _getPastorInfo(result) async{
    String scannedText = result;
    final idLine = scannedText.split('\n').firstWhere(
          (line) => line.startsWith('ID:'),
      orElse: () => '',
    );
    // final id = idLine.replaceAll('ID:', '').trim();
    final id = RegExp(r'\d+').stringMatch(scannedText) ?? '';
    var url =  "https://kayanja1.org/get_pastor_confirmation/${Uri.encodeComponent(id)}";

    try{
     final response =  await http.get(Uri.parse(url),
       headers: {
         'User-Agent':'PostmanRuntime/7.28.4',
         'Accept': 'application/json'
       }
     );

    if (response.statusCode == 200) {
      final data = response.body;
      final Info = jsonDecode(data);
      if (kDebugMode) {
        print("✅ Pastor Info: ${pastorInfo}");
      }
      setState(() {
        qrText = data; // Or parse as needed
        pastorInfo = Info;
      });
       }else{
      setState(() {
        qrText = "❌ No record for this ID";
      });
    }
    } catch (e) {
      setState(() {
        qrText = "⚠️ Error connecting to server";
      });
      print("❌ Exception: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Image.asset('assets/images/benny_Hinn_banner.png'),
          Expanded(
            flex: 1,
            child: Center(
              child: qrText != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Scanned Data:",
                            style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        // Text(qrText!, textAlign: TextAlign.center),
                pastorInfo != null
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "✅ Pastor Found",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text("📛 Name: ${pastorInfo!['name']}"),
                    Text("📧 Email: ${pastorInfo!['email']}"),
                    Text("📱 Phone: ${pastorInfo!['phone']}"),
                    Row(
                      children: [
                        Text("🧾 Scans: ${pastorInfo!['scans']} ",style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                        Text("🛐 STATUS: ${(pastorInfo?['status'] == true) ? 'Already Entered' : 'Not Yet Entered'} ",style: const TextStyle(fontSize: 16,color: Colors.green,fontWeight: FontWeight.w600),),
                      ],
                    ),
                    Text("⛪ CHURCH: ${pastorInfo!['church']}", style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                    Text("🆔 ID: ${pastorInfo!['identificationID']}"),
                  ],
                )
                    : const Text("Loading Scan details wait..."),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => _launchScanner(),
                          child: const Text('Scan Again'),
                        ),
                      ],
                    )
                  : ElevatedButton(
                      onPressed: () => _launchScanner(),
                      child: const Text('Scan a QR code')),
            ),
          )
        ],
      ),
    );
  }
}
