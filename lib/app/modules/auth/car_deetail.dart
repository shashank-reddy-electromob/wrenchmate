import 'package:flutter/material.dart';

class CarDetails extends StatefulWidget {
  const CarDetails({super.key});

  @override
  State<CarDetails> createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails> {
  final TextEditingController _controller = TextEditingController();
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 100,),
              TextField(
                controller: _controller,
                readOnly: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Select an option',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.arrow_drop_down),
                    onPressed: () {
                      setState(() {
                        _selectedValue = _selectedValue == null ? '' : null;
                      });
                    },
                  ),
                ),
              ),
              if (_selectedValue == null)
                Container(
                  height: 120,
                  color: Colors.pinkAccent,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      ListTile(
                        title: Text('Option 1'),
                        onTap: () {
                          _controller.text = 'Option 1';
                          setState(() {
                            _selectedValue = 'Option 1';
                          });
                        },
                      ),
                      ListTile(
                        title: Text('Option 2'),
                        onTap: () {
                          _controller.text = 'Option 2';
                          setState(() {
                            _selectedValue = 'Option 2';
                          });
                        },
                      ),
                    ],
                  ),
                ),
              Container(color: Colors.blue,
              height: 100,width: 200,)
            ],
          ),
        ),
      ),
    );
  }
}