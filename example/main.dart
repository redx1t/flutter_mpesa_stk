import 'package:flutter/material.dart';
import 'package:flutter_mpesa_stk/flutter_mpesa_stk.dart';
import 'package:flutter_mpesa_stk/models/Mpesa.dart';
import 'package:flutter_mpesa_stk/models/MpesaResponse.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Mpesa STK Plugin Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Mpesa STK Plugin Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final amountController = TextEditingController();
  final phoneNumberController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    phoneNumberController.dispose();
  }

  bool loading = false;
  void setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }

  void notify(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  processSTK() async {
    if (loading) {
      return;
    }
    setLoading(true);
    int amount = 0;
    try {
      amount = int.parse(amountController.value.text);
    } catch (e) {
      setLoading(false);
      notify("Enter a valid amount");
      return;
    }

    // preferrably to wrap this in a try and catch if the value inputted is not a valid int
    if (amount < 0) {
      notify("Enter a valid amount");
      setLoading(false);
      return;
    }
    //var instead of strong typing to ensure we validate phone number or get false if it fails
    MpesaResponse response = await FlutterMpesaSTK(
            "consumerKey",
            "consumerSecret",
            "stkPassword",
            "shortcode",
            "callbackURL",
            "default Message")
        .stkPush(Mpesa(amount, phoneNumberController.value.text));
    if (response.status) {
      print(response.body);
      notify("successful stk push. please enter pin");
    } else {
      print(response.body);
      notify("failed. please try again");
    }
    setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Click the button to trigger an STK push',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter the mpesa amount *',
                  hintText: 'Amount',
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: phoneNumberController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter the phone number *',
                  hintText: 'Amount',
                ),
              ),
              TextButton(
                  onPressed: () async {
                    if (loading) {
                      notify("processing");
                      return;
                    }
                    await processSTK();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: const Text(
                      "Trigger STK push",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
