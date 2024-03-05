import 'package:flutter/material.dart';
import 'package:esewa_flutter/esewa_flutter.dart';
import 'package:flutter/foundation.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String refId = '';
  String hasError = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Esewa Payment'),
      ),
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Example Use case - 1
            EsewaPayButton(
              paymentConfig: ESewaConfig.dev(
                su: 'https://www.marvel.com/hello',
                amt: 10,
                fu: 'https://www.marvel.com/hello',
                pid: '1212',
              ),
              width: 100,
              onFailure: (result) async {
                setState(() {
                  refId = '';
                  hasError = result;
                });
                if (kDebugMode) {
                  print(result);
                }
              },
              onSuccess: (result) async {
                setState(() {
                  hasError = '';
                  refId = result.refId!;
                });
                if (kDebugMode) {
                  print(result.toJson());
                }
              },
            ),

            if (refId.isNotEmpty)
              Text('Console: Payment Success, Ref Id: $refId'),
            if (hasError.isNotEmpty)
              Text('Console: Payment Failed, Message: $hasError'),
          ],
        ),
      ),
    );
  }
}
