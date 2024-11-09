import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'help_page.dart';

class CurrencyConverterPage extends StatefulWidget {
  final Map<String, String> currencyValues;
  const CurrencyConverterPage({super.key, required this.currencyValues});

  @override
  _CurrencyConverterPageState createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  final _amountController = TextEditingController();
  String _convertedAmount = '';
  String _fromCurrency = 'USD'; // Default to USD
  String _toCurrency = 'EUR';   // Default to EUR

  @override
  void initState() {
    super.initState();
    if (widget.currencyValues.isNotEmpty) {
      _fromCurrency = 'USD'; // Default to USD for simplicity
      _toCurrency = widget.currencyValues.keys.first;
    }
  }

  void _convert() {
    double amount = double.tryParse(_amountController.text) ?? 0;

    // Ensure USD conversion works by assigning the rate of USD to itself as 1
    double fromRate = (_fromCurrency == 'USD')
        ? 1
        : double.tryParse(widget.currencyValues[_fromCurrency]!) ?? 1;

    double toRate = (_toCurrency == 'USD')
        ? 1
        : double.tryParse(widget.currencyValues[_toCurrency]!) ?? 1;

    // Handle invalid cases where rates are not properly retrieved
    if (fromRate == 0 || toRate == 0) {
      setState(() {
        _convertedAmount = 'Invalid rates for the selected currencies';
      });
      return;
    }

    setState(() {
      // Calculate conversion
      _convertedAmount = (amount * toRate / fromRate).toStringAsFixed(2);
    });
  }



  @override
  Widget build(BuildContext context) {
    // Create a list of currencies ensuring USD is included once
    List<String> currencyList = List.from(widget.currencyValues.keys);
    currencyList.insert(0, 'USD'); // Ensure USD is included in the dropdown

    return Scaffold (
      appBar: AppBar(
        title: const Text('Currency Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter amount',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: _fromCurrency,
              items: currencyList.map((currency) {
                return DropdownMenuItem(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _fromCurrency = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: _toCurrency,
              items: currencyList.map((currency) {
                return DropdownMenuItem(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _toCurrency = value!;
                });
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _convert,
              child: const Text('Convert'),
            ),
            const SizedBox(height: 32),
            Text(
              'Converted Amount: $_convertedAmount',
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 20, right: 20), // Adjust position
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HelpCenter()),
            );
          },
          child: Text(
            'Customer service',
            style: TextStyle(fontSize: 18),
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            backgroundColor: Colors.blue,
          ),
        ),
      ),
    );
  }
}