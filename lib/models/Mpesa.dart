class Mpesa {
  int amount;
  String phoneNumber;
  String? accountReference;
  String? transactionDesc;
  Mpesa(this.amount, this.phoneNumber,
      {this.accountReference, this.transactionDesc}) {
    // if account reference || transactionDesc is not defined its replaced with the phone number
    accountReference ??= phoneNumber;
    transactionDesc ??= phoneNumber;
  }
}
