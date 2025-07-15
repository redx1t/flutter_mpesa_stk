# Flutter M-Pesa STK Plugin

[![MIT License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![pub package](https://img.shields.io/pub/v/flutter_mpesa_stk.svg)](https://pub.dev/packages/flutter_mpesa_stk)
[![GitHub stars](https://img.shields.io/github/stars/redx1t/flutter_mpesa_stk)](https://github.com/redx1t/flutter_mpesa_stk/stargazers)
[![GitHub issues](https://img.shields.io/github/issues/redx1t/flutter_mpesa_stk)](https://github.com/redx1t/flutter_mpesa_stk/issues)
[![GitHub pull requests](https://img.shields.io/github/issues-pr/redx1t/flutter_mpesa_stk)](https://github.com/redx1t/flutter_mpesa_stk/pulls)
[![Last Updated](https://img.shields.io/github/last-commit/redx1t/flutter_mpesa_stk)](https://github.com/redx1t/flutter_mpesa_stk/commits/main)

A comprehensive Flutter plugin that seamlessly integrates **Safaricom M-Pesa STK Push** functionality into your Flutter applications using the official **Daraja API**. This plugin simplifies the implementation of mobile money payments in Kenya, providing a robust and easy-to-use solution for developers.

## 🚀 Features

- **STK Push Integration**: Complete implementation of Safaricom's STK Push for paybills
- **Environment Support**: Built-in support for both sandbox (testing) and production environments
- **Error Handling**: Comprehensive error handling with detailed response messages
- **Type Safety**: Full Dart null safety support with proper model classes
- **Logging**: Built-in logging system for debugging and monitoring
- **Minimal Setup**: Quick integration with minimal configuration required

## 📋 Prerequisites

Before using this plugin, you need to obtain the following credentials from the **Safaricom Daraja Developer Portal**:

1. **Create a Developer Account**: Visit [Safaricom Daraja Developer Portal](https://developer.safaricom.co.ke/)
2. **Create an App**: Go to [MyApp Page](https://developer.safaricom.co.ke/MyApps) and create a new application
3. **Get Credentials**:
   - **Consumer Key**: Your app's consumer key
   - **Consumer Secret**: Your app's consumer secret
   - **STK Password**: Get from [Mpesa Express Simulate Page](https://developer.safaricom.co.ke/APIs/MpesaExpressSimulate)

![Mpesa Express Checkout page](https://raw.githubusercontent.com/redx1t/flutter_mpesa/main/assets/mpesa-express%20simulate.png)

## 📦 Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_mpesa_stk: ^latest
```

Then run:

```bash
flutter pub get
```



## 🔧 Configuration

You'll need the following values to use the M-Pesa STK service:

- `consumerKey` - Your Daraja app consumer key
- `consumerSecret` - Your Daraja app consumer secret  
- `stkPassword` - Your M-Pesa Express password
- `shortCode` - Your paybill number (use "174379" for testing)
- `callbackURL` - URL to receive transaction callbacks

## 💻 Usage

### Basic Implementation

```dart
import 'package:flutter_mpesa_stk/flutter_mpesa_stk.dart';
import 'package:flutter_mpesa_stk/models/Mpesa.dart';
import 'package:flutter_mpesa_stk/models/MpesaResponse.dart';

// Initialize the M-Pesa STK service
MpesaResponse response = await FlutterMpesaSTK(
  consumerKey, 
  consumerSecret, 
  stkPassword,
  "174379", // Paybill number (use "174379" for testing)
  "https://your-callback-url.com/api/callback", // Callback URL
  "Transaction failed. Please try again.", // Default error message
  env: "testing" // Use "production" for live environment
).stkPush(
  Mpesa(
    amount, // Amount to charge
    phoneNumber, // Customer's phone number
    accountReference: "Account123", // Optional: Account reference
    transactionDesc: "Payment for services" // Optional: Transaction description
  )
);

// Handle the response
if (response.status) {
  // STK Push successful - customer will receive prompt on their phone
  print("STK Push sent successfully");
  print("Response: ${response.body}");
  // Show success message to user
  showSuccessMessage("Please check your phone and enter M-Pesa PIN");
} else {
  // STK Push failed
  print("STK Push failed");
  print("Error: ${response.body}");
  // Show error message to user
  showErrorMessage("Payment failed. Please try again.");
}
```

### Complete Example with UI

```dart
class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final amountController = TextEditingController();
  final phoneController = TextEditingController();
  bool isLoading = false;

  Future<void> initiatePayment() async {
    if (isLoading) return;

    setState(() => isLoading = true);

    try {
      final amount = int.parse(amountController.text);
      final phoneNumber = phoneController.text;

      final response = await FlutterMpesaSTK(
        "YOUR_CONSUMER_KEY",
        "YOUR_CONSUMER_SECRET", 
        "YOUR_STK_PASSWORD",
        "174379", // Test paybill
        "https://your-callback-url.com/callback",
        "Payment failed. Please try again.",
        env: "testing"
      ).stkPush(
        Mpesa(
          amount,
          phoneNumber,
          accountReference: "Order123",
          transactionDesc: "Payment for order"
        )
      );

      if (response.status) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please check your phone and enter M-Pesa PIN"))
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment failed: ${response.body}"))
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"))
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("M-Pesa Payment")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: "Amount (KES)",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
                hintText: "254700000000",
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : initiatePayment,
              child: isLoading 
                ? CircularProgressIndicator(color: Colors.white)
                : Text("Pay with M-Pesa"),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 🔄 Environment Configuration

The plugin supports both testing and production environments:

```dart
// For testing (sandbox environment)
FlutterMpesaSTK(..., env: "testing")

// For production (live environment)  
FlutterMpesaSTK(..., env: "production")
```

## 📱 Response Handling

The plugin returns a `MpesaResponse` object with:

- `status`: Boolean indicating success/failure
- `body`: Response data or error message

```dart
if (response.status) {
  // Success - customer receives STK push
  final responseData = response.body;
  // Handle success
} else {
  // Failure - handle error
  final errorMessage = response.body;
  // Handle error
}
```

## 🔒 Security Considerations

- **Never commit credentials** to version control
- **Use environment variables** for sensitive data
- **Validate phone numbers** before sending STK push
- **Implement proper error handling** for production apps
- **Use HTTPS** for callback URLs in production

## 🧪 Testing

For testing purposes, use the following credentials:

- **Short Code**: `174379` (Safaricom test paybill)
- **Environment**: `"testing"`
- **Phone Numbers**: Use test phone numbers from Daraja documentation

## 📚 Documentation

For more information about the Daraja API and production setup:

- [Safaricom Daraja Documentation](https://developer.safaricom.co.ke/Documentation)
- [M-Pesa Express API Reference](https://developer.safaricom.co.ke/APIs/MpesaExpressSimulate)
- [Daraja Developer Portal](https://developer.safaricom.co.ke/)

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. **Report Issues**: [Create an issue](https://github.com/redx1t/flutter_mpesa_stk/issues) for bugs or feature requests
2. **Fork the Repository**: [Fork on GitHub](https://github.com/redx1t/flutter_mpesa_stk)
3. **Create Feature Branch**: `git checkout -b feature/amazing-feature`
4. **Commit Changes**: `git commit -m 'Add amazing feature'`
5. **Push to Branch**: `git push origin feature/amazing-feature`
6. **Open Pull Request**: [Submit a PR](https://github.com/redx1t/flutter_mpesa_stk/pulls)

### Development Setup

```bash
# Clone the repository
git clone https://github.com/redx1t/flutter_mpesa_stk.git

# Navigate to the project
cd flutter_mpesa_stk

# Install dependencies
flutter pub get

# Run tests
flutter test

# Run the example app
cd example
flutter run
```

## 🐛 Bug Reports

- **Security Issues**: Email [muthomi@muthomikathurima.com](mailto:muthomi@muthomikathurima.com)
- **General Issues**: [File an issue on GitHub](https://github.com/redx1t/flutter_mpesa_stk/issues)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Muthomi Kathurima**

- GitHub: [@redx1t](https://github.com/redx1t)
- Email: [muthomi@muthomikathurima.com](mailto:muthomi@muthomikathurima.com)

## 🙏 Acknowledgments

- Safaricom for providing the Daraja API
- The Flutter community for excellent tooling and documentation
- All contributors who have helped improve this plugin

---

⭐ **If this plugin helps you, please give it a star on [GitHub](https://github.com/redx1t/flutter_mpesa_stk)!**