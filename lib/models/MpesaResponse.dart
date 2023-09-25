///this  class is used to define the response from mpesa for stk push

class MpesaResponse {
  bool status;
  dynamic body;
  MpesaResponse(this.status, this.body);
}
