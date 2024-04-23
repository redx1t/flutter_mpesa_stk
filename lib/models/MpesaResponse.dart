// ignore_for_file: file_names

class MpesaResponse {
  /// this  class is used to define the response from mpesa for stk push
  bool status;
  dynamic body;
  MpesaResponse(this.status, this.body);
}
