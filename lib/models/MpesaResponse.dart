/// this  class is used to define the response from mpesa for stk push

// ignore_for_file: file_names

class MpesaResponse {
  bool status;
  dynamic body;
  MpesaResponse(this.status, this.body);
}
