import "package:flutter/material.dart";

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _formKey = GlobalKey<FormState>();
  String? _city;
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;

  void _submit() {
    setState(() {
      //used to notify flutter that the autoValidadeMode state has changed
      autoValidateMode = AutovalidateMode.always;
    });
    final form = _formKey.currentState;

    if (form != null && form.validate()) {
      //returns true if every input inside the form has NO errors
      form.save();
      Navigator.pop(context, _city!.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather App"),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: autoValidateMode,
        child: Column(
          children: [
            const SizedBox(height: 60.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: TextFormField(
                autofocus: true,
                style: const TextStyle(fontSize: 20.0),
                decoration: const InputDecoration(
                  labelText: "City Name",
                  hintText: "Enter a city name...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                validator: (String? input) {
                  if (input == null || input.trim().length < 2) {
                    return "City name must be at least 2 characters long";
                  }
                  return null;
                },
                onSaved: (String? input) {
                  _city = input;
                },
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
                onPressed: _submit,
                child: const Text(
                  "How's Weather?",
                  style: TextStyle(fontSize: 20.0),
                ))
          ],
        ),
      ),
    );
  }
}
