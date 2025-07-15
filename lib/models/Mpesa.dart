// ignore_for_file: file_names

/// A model class representing an M-Pesa STK Push request.
///
/// This class encapsulates all the necessary data required to initiate
/// an M-Pesa STK Push transaction through the Daraja API. It contains
/// the payment amount, customer phone number, and optional metadata
/// for transaction tracking and description.
///
/// ## Usage Example
/// ```dart
/// // Basic usage with required fields only
/// Mpesa payment = Mpesa(1000, "254700000000");
///
/// // Advanced usage with optional fields
/// Mpesa payment = Mpesa(
///   1500,
///   "254700000000",
///   accountReference: "ORDER123",
///   transactionDesc: "Payment for online order"
/// );
/// ```
///
/// ## Properties
/// - [amount]: The payment amount in Kenyan Shillings (KES)
/// - [phoneNumber]: The customer's M-Pesa registered phone number
/// - [accountReference]: Optional reference for tracking the transaction
/// - [transactionDesc]: Optional description of the transaction
class Mpesa {
  /// The payment amount in Kenyan Shillings (KES).
  ///
  /// This field is required and must be a positive integer.
  /// The amount will be deducted from the customer's M-Pesa account
  /// when they approve the STK Push request.
  ///
  /// ## Example
  /// ```dart
  /// Mpesa payment = Mpesa(1000, "254700000000");
  /// // This will charge KES 1,000
  /// ```
  ///
  /// ## Validation
  /// - Must be a positive integer
  /// - Minimum amount: 1 KES
  /// - Maximum amount: Subject to M-Pesa limits
  final int amount;

  /// The customer's M-Pesa registered phone number.
  ///
  /// This field is required and must be in the correct format.
  /// The phone number should be the one registered with M-Pesa
  /// and will receive the STK Push notification.
  ///
  /// ## Format
  /// - Country code: 254 (Kenya)
  /// - Phone number: 7XXXXXXXX (9 digits)
  /// - Full format: 2547XXXXXXXX
  ///
  /// ## Examples
  /// ```dart
  /// // Correct format
  /// Mpesa payment = Mpesa(1000, "254700000000");
  ///
  /// // Also acceptable (will be formatted automatically)
  /// Mpesa payment = Mpesa(1000, "0700000000");
  /// ```
  ///
  /// ## Validation
  /// - Must be a valid Kenyan phone number
  /// - Should be registered with M-Pesa
  /// - Format: 2547XXXXXXXX or 07XXXXXXXX
  final String phoneNumber;

  /// Optional reference identifier for tracking the transaction.
  ///
  /// This field is optional and provides a way to associate the
  /// M-Pesa transaction with your internal order or account system.
  /// If not provided, it defaults to the customer's phone number.
  ///
  /// ## Use Cases
  /// - Order ID or reference number
  /// - Account number
  /// - Invoice number
  /// - Any unique identifier for your business
  ///
  /// ## Examples
  /// ```dart
  /// // With account reference
  /// Mpesa payment = Mpesa(
  ///   1000,
  ///   "254700000000",
  ///   accountReference: "ORDER123"
  /// );
  ///
  /// // Without account reference (uses phone number)
  /// Mpesa payment = Mpesa(1000, "254700000000");
  /// ```
  ///
  /// ## Best Practices
  /// - Use meaningful, unique identifiers
  /// - Keep it short and alphanumeric
  /// - Avoid special characters
  /// - Make it searchable for reconciliation
  String? accountReference;

  /// Optional description of the transaction.
  ///
  /// This field is optional and provides a human-readable description
  /// of what the payment is for. It appears in the customer's M-Pesa
  /// statement and helps them identify the transaction. If not provided,
  /// it defaults to the customer's phone number.
  ///
  /// ## Use Cases
  /// - Service description
  /// - Product name
  /// - Business name
  /// - Payment purpose
  ///
  /// ## Examples
  /// ```dart
  /// // With transaction description
  /// Mpesa payment = Mpesa(
  ///   1000,
  ///   "254700000000",
  ///   transactionDesc: "Payment for online order"
  /// );
  ///
  /// // Without description (uses phone number)
  /// Mpesa payment = Mpesa(1000, "254700000000");
  /// ```
  ///
  /// ## Best Practices
  /// - Keep it concise and clear
  /// - Use your business name
  /// - Avoid technical jargon
  /// - Make it customer-friendly
  String? transactionDesc;

  /// Creates a new M-Pesa transaction request.
  ///
  /// ## Parameters
  /// - [amount]: The payment amount in KES (required)
  /// - [phoneNumber]: Customer's M-Pesa phone number (required)
  /// - [accountReference]: Optional reference for tracking (optional)
  /// - [transactionDesc]: Optional transaction description (optional)
  ///
  /// ## Default Values
  /// If [accountReference] or [transactionDesc] are not provided,
  /// they will default to the customer's [phoneNumber].
  ///
  /// ## Example
  /// ```dart
  /// // All fields provided
  /// Mpesa payment = Mpesa(
  ///   1000,
  ///   "254700000000",
  ///   accountReference: "ORDER123",
  ///   transactionDesc: "Payment for online order"
  /// );
  ///
  /// // Only required fields
  /// Mpesa payment = Mpesa(1000, "254700000000");
  /// // accountReference and transactionDesc will be "254700000000"
  /// ```
  Mpesa(this.amount, this.phoneNumber,
      {this.accountReference, this.transactionDesc}) {
    accountReference ??= phoneNumber;
    transactionDesc ??= phoneNumber;
  }
}
