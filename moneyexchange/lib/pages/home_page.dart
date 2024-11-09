import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'checkcurrency.dart';

void main() {
  runApp(const CurrencyApp());
}

class CurrencyApp extends StatelessWidget {
  const CurrencyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Exchange',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,  // Primary color set to blue
        fontFamily: 'SF Pro',
        scaffoldBackgroundColor: Colors.blue[50], // Light blue background
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 20),
          bodyMedium: TextStyle(fontSize: 18, color: Colors.black87),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[600], // Blue AppBar
          foregroundColor: Colors.white,  // White text on AppBar
        ),
      ),
      home: const CurrencyHomePage(),
    );
  }
}

class CurrencyHomePage extends StatefulWidget {
  const CurrencyHomePage({super.key});

  @override
  _CurrencyHomePageState createState() => _CurrencyHomePageState();
}

class _CurrencyHomePageState extends State<CurrencyHomePage> {
  Map<String, String> currencyValues = {
    'EUR': '',
    'EGP': '',
    'CNY': '',
    'AED': '',
    'SAR': '',
    'LBP': '',
    'RUB': ''
  };
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchCurrencyData();
  }

  Future<void> fetchCurrencyData() async {
    const apiKey = '872e1e4f2a91c5e7ed7ad47a46e269d7';
    final url =
        'https://apilayer.net/api/live?access_key=$apiKey&currencies=EUR,EGP,CNY,AED,SAR,LBP,RUB,USD';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('Response from API: $jsonResponse');  // Debug print
        setState(() {
          _populateCurrencyValues(jsonResponse['quotes']);
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
        print('Failed to load data, Status Code: ${response.statusCode}');  // Debug print
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
      print('Error: $e');  // Debug print
    }
  }

  void _populateCurrencyValues(Map<String, dynamic> quotes) {
    setState(() {

      currencyValues['EUR'] = quotes['USDEUR'].toString();
      currencyValues['EGP'] = quotes['USDEGP'].toString();
      currencyValues['CNY'] = quotes['USDCNY'].toString();
      currencyValues['AED'] = quotes['USDAED'].toString();
      currencyValues['SAR'] = quotes['USDSAR'].toString();
      currencyValues['LBP'] = quotes['USDLBP'].toString();
      currencyValues['RUB'] = quotes['USDRUB'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Exchange', style: TextStyle(fontWeight: FontWeight.w500)),
        elevation: 0,
        backgroundColor: Colors.blue[600],  // Blue AppBar
        foregroundColor: Colors.white,  // White text on AppBar
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : hasError
            ? const Text('Failed to load data')
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...currencyValues.keys.map((currency) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: _buildRateText(
                      'USD to $currency', currencyValues[currency]!),
                );
              }).toList(),
              const SizedBox(height: 30),
              _buildButton(
                label: 'Currency Converter',
                color: Colors.blueAccent,  // Blue button
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CurrencyConverterPage(
                        currencyValues: currencyValues,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              _buildButton(
                label: 'Exit',
                color: Colors.redAccent, // Red exit button
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MoneyExchangeApp()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRateText(String label, String rate) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16), // Rounded corners
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          label,
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
        ),
        trailing: Text(
          rate,
          style: const TextStyle(color: Colors.black54, fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildButton({required String label, required Color color, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}