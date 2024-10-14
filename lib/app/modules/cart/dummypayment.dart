import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

import 'package:http/http.dart' as http;

class PhonePePayment extends StatefulWidget {
  const PhonePePayment({super.key});

  @override
  State<PhonePePayment> createState() => _PhonePePaymentState();
}

class _PhonePePaymentState extends State<PhonePePayment> {
  String environment = "SANDBOX";
  String appId = "";
  String transactionId = DateTime.now().millisecondsSinceEpoch.toString();
/**
 MID: DEMOUAT
SaltKey: 2a248f9d-db24-4f2d-8512-61449a31292f
SaltIndex: 1
 */
  String merchantId = "DEMOUAT";
  bool enableLogging = true;
  String checksum = "";
  String saltKey = "2a248f9d-db24-4f2d-8512-61449a31292f";

  String saltIndex = "1";

  String callbackUrl =
      "https://webhook.site/f63d1195-f001-474d-acaa-f7bc4f3b20b1";

  String body = "";
  String apiEndPoint = "/pg/v1/pay";

  Object? result;

  getChecksum() {
    final requestData = {
      "merchantId": merchantId,
      "merchantTransactionId": transactionId,
      "merchantUserId": "90223250",
      "amount": 1000,
      "mobileNumber": "8058965210",
      "callbackUrl": callbackUrl,
      "paymentInstrument": {"type": "PAY_PAGE"}
    };

    String base64Body = base64.encode(utf8.encode(json.encode(requestData)));

    checksum =
        '${sha256.convert(utf8.encode(base64Body + apiEndPoint + saltKey)).toString()}###$saltIndex';
    print("checksum :: $checksum");
    return base64Body;
  }

  @override
  void initState() {
    super.initState();

    phonepeInit();
//environment, appId, merchantId, enableLogging
    print("environment :: $environment");
    print("appId :: $appId");
    print("merchantId :: $merchantId");
    print("enableLogging :: $enableLogging");
    print("transactionId :: $transactionId");
    body = getChecksum().toString();
    print("body :: $body");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Phonepe Payment Gateway"),
        ),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                startPgTransaction();
              },
              child: Text("Start Transaction"),
            ),
            const SizedBox(
              height: 20,
            ),
            Text("Result \n $result")
          ],
        ),
      ),
    );
  }

  void phonepeInit() {
    PhonePePaymentSdk.init(environment, appId, merchantId, enableLogging)
        .then((val) => {
              setState(() {
                result = 'PhonePe SDK Initialized - $val';
              })
            })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }

  void startPgTransaction() async {
    try {
      String base64Body = base64.encode(utf8.encode(json.encode(body)));
      print("base64Body :: $base64Body");
      var response = PhonePePaymentSdk.startTransaction(
          base64Body, callbackUrl, checksum, 'com.phonepe');
      response.then((val) async {
        print("startPgTransaction success!");
        if (val != null) {
          String status = val['status'].toString();
          String error = val['error'].toString();

          if (status == 'SUCCESS') {
            result = "Flow complete - status : SUCCESS";

            await checkStatus();
          } else {
            result = "Flow complete - status : $status and error $error";
          }
        } else {
          result = "Flow Incomplete";
        }
      }).catchError((error) {
        handleError(error);
        return <dynamic>{};
      });
    } catch (error) {
      handleError(error);
    }
  }

  void handleError(error) {
    setState(() {
      result = {"error": error};
    });
  }

  checkStatus() async {
    try {
      String url =
          "https://api-preprod.phonepe.com/apis/pg-sandbox/pg/v1/status/$merchantId/$transactionId"; // Test

      String concatenatedString =
          "/pg/v1/status/$merchantId/$transactionId$saltKey";

      var bytes = utf8.encode(concatenatedString);
      var digest = sha256.convert(bytes);
      String hashedString = digest.toString();

      String xVerify = "$hashedString###$saltIndex";

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "X-MERCHANT-ID": merchantId,
        "X-VERIFY": xVerify,
      };

      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        Map<String, dynamic> res = jsonDecode(response.body);
        // Log the entire response for debugging
        print("Response: ${res}");

        if (res["code"] == "PAYMENT_SUCCESS" &&
            res['data']['responseCode'] == "SUCCESS") {
          Fluttertoast.showToast(msg: res["message"]);
        } else {
          Fluttertoast.showToast(
              msg: "Something went wrong: ${res['message']}");
        }
      } else {
        Fluttertoast.showToast(
            msg: "Failed to get status: ${response.reasonPhrase}");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }
}
