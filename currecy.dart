// lib/main.dart
import 'package:flutter/material.dart'; // FIX: Changed 'material.' to 'material.dart'

void main() => runApp(CurrencyConverterApp());

class CurrencyConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: CurrencyConverterHome(),
    );
  }
}

class CurrencyConverterHome extends StatefulWidget {
  @override
  _CurrencyConverterHomeState createState() => _CurrencyConverterHomeState();
}

class _CurrencyConverterHomeState extends State<CurrencyConverterHome> {
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'INR';
  double _result = 0.0;

  final Map<String, double> _usdRates = {
    'USD': 1.0,
    'INR': 83.0,
    'EUR': 0.93,
    'JPY': 151.2,
    'GBP': 0.78,
  };

  void _convertCurrency() {
    double? amount = double.tryParse(_amountController.text);
    if (amount == null) {
      _showMessage('Enter a valid number!');
      return;
    }

    // Handle potential division by zero or null rates, though unlikely with fixed rates
    if (_usdRates[_fromCurrency] == null || _usdRates[_fromCurrency] == 0) {
      _showMessage('Invalid "From" currency rate.');
      return;
    }
    if (_usdRates[_toCurrency] == null) {
      _showMessage('Invalid "To" currency rate.');
      return;
    }


    double usdAmount = amount / _usdRates[_fromCurrency]!;
    double converted = usdAmount * _usdRates[_toCurrency]!;

    setState(() {
      _result = converted;
    });
  }

  void _swapCurrencies() {
    setState(() {
      String temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
    });
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('💱 Currency Converter'),
        centerTitle: true,
      ),
      body: SingleChildScrollView( // FIX: Wrap with SingleChildScrollView to prevent overflow
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Enter amount',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.currency_exchange),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _fromCurrency, // Use 'value' for controlled dropdown
                      decoration: InputDecoration(
                        labelText: 'From',
                        border: OutlineInputBorder(),
                      ),
                      items: _usdRates.keys.map((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _fromCurrency = newValue!;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.swap_horiz, size: 32, color: Colors.indigo),
                    onPressed: _swapCurrencies,
                  ),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _toCurrency, // Use 'value' for controlled dropdown
                      decoration: InputDecoration(
                        labelText: 'To',
                        border: OutlineInputBorder(),
                      ),
                      items: _usdRates.keys.map((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _toCurrency = newValue!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _convertCurrency,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  'Convert',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: Text(
                  _result == 0
                      ? 'Converted value will appear here'
                      : '$_fromCurrency → $_toCurrency = ${_result.toStringAsFixed(2)} $_toCurrency',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 10),
              Text(
                'Supported currencies: USD, INR, EUR, GBP, JPY',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}