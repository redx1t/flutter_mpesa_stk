import 'package:flutter_mpesa_stk/models/Mpesa.dart';
import 'package:flutter_mpesa_stk/models/MpesaResponse.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_mpesa_stk/flutter_mpesa_stk.dart';

void main() {
  test('this test should fail', () async {
    final MpesaResponse mpesaResponse =
        await FlutterMpesaSTK("", "", "", "", "", "").stkPush(Mpesa(10, ""));
    expect(mpesaResponse.status, false);
  });
}
