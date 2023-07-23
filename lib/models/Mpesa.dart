class Mpesa {
  int amount;
  String phoneNumber;
  String? accountReference;
  String? transactionDesc;

  /// if account reference || transactionDesc is not defined its replaced with the phone number
  
  Mpesa(this.amount, this.phoneNumber,
      {this.accountReference, this.transactionDesc}) {
    accountReference ??= phoneNumber;
    transactionDesc ??= phoneNumber;
  }
}
