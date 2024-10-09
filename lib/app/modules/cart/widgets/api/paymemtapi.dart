import 'dart:convert';
import 'package:crypto/crypto.dart'; 
import 'package:http/http.dart' as http;
import 'package:wrenchmate_user_app/app/modules/cart/widgets/api/apikey.dart';

class PaymentService {
  
  final String testMerchantId = "PGTESTPAYUAT";
  final String testApiKey = "099eb0cd-02cf-4e2a-8aca-3e6c6aff0399";
  final int testApiKeyIndex = 1;
  final String testHostUrl = "https://api-preprod.phonepe.com/apis/pg-sandbox/pg/v1/pay";
  final String testSaltKey = "099eb0cd-02cf-4e2a-8aca-3e6c6aff0399";

  final String prodMerchantId = "M22JKU8ER0YL4";
  String? prodApiKey; 
  final int prodApiKeyIndex = 1;
  final String prodHostUrl = "https://api.phonepe.com/apis/hermes/pg/v1/pay";
  final String prodSaltKey = "c4682fa3-53ab-4edc-b433-cd4c4c63c0a1";

  PaymentService() {
    _loadProdApiKey();
  }

  Future<void> _loadProdApiKey() async {
    prodApiKey = await ApiKeyService.loadApiKey();
  }

  Future<void> makeProdPayment(String transactionId, String userId, int amount, String callbackUrl) async {
    if (prodApiKey == null) {
      print("Production API Key is not loaded yet.");
      return;
    }

    try {
      String payload = _generatePayload(prodMerchantId, transactionId, userId, amount, callbackUrl);
      String checksum = _generateChecksum(payload, "/pg/v1/pay", prodSaltKey, prodApiKeyIndex);

      var response = await http.post(
        Uri.parse(prodHostUrl),
        headers: {
          "Content-Type": "application/json",
          "X-VERIFY": checksum,
        },
        body: jsonEncode({"request": base64Encode(utf8.encode(payload))}),
      );

      if (response.statusCode == 200) {
        print("Payment initiated: ${response.body}");
      } else {
        print("Failed to initiate payment: ${response.body}");
      }
    } catch (e) {
      print("Error in Production Payment: $e");
    }
  }

  Future<void> makeTestPayment(String transactionId, String userId, int amount, String callbackUrl) async {
    try {
      String payload = _generatePayload(testMerchantId, transactionId, userId, amount, callbackUrl);
      String checksum = _generateChecksum(payload, "/pg/v1/pay", testSaltKey, testApiKeyIndex);

      var response = await http.post(
        Uri.parse(testHostUrl),
        headers: {
          "Content-Type": "application/json",
          "X-VERIFY": checksum,
        },
        body: jsonEncode({"request": base64Encode(utf8.encode(payload))}),
      );

      if (response.statusCode == 200) {
        print("Payment initiated: ${response.body}");
      } else {
        print("Failed to initiate payment: ${response.body}");
      }
    } catch (e) {
      print("Error in Test Payment: $e");
    }
  }

  String _generatePayload(String merchantId, String transactionId, String userId, int amount, String callbackUrl) {
    Map<String, dynamic> payload = {
      "merchantId": merchantId,
      "merchantTransactionId": transactionId,
      "merchantUserId": userId,
      "amount": amount,
      "redirectUrl": "https://your-redirect-url.com",
      "redirectMode": "REDIRECT",
      "callbackUrl": callbackUrl,
      "paymentInstrument": {
        "type": "PAY_PAGE"
      }
    };
    return jsonEncode(payload);
  }

  String _generateChecksum(String payload, String apiPath, String saltKey, int saltIndex) {
    String base64Payload = base64Encode(utf8.encode(payload));
    String toBeHashed = "$base64Payload$apiPath$saltKey";
    var bytes = utf8.encode(toBeHashed);
    var digest = sha256.convert(bytes);
    return "$digest###$saltIndex";
  }

}
