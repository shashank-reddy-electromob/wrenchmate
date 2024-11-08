import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wrenchmate_user_app/app/modules/auth/car_deetail.dart';
import 'package:wrenchmate_user_app/app/widgets/appbar.dart';
import 'package:wrenchmate_user_app/app/widgets/blueButton.dart';
import 'package:wrenchmate_user_app/app/widgets/bluebuttoncircular.dart';
import 'package:wrenchmate_user_app/utils/color.dart';
import 'package:wrenchmate_user_app/utils/textstyles.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Color borderColor = Color(0xffF5F5F5);
  int _selectedCardIndex = 1;
  int _selectedUpiIndex = 1;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cardnumberController = TextEditingController();
  final TextEditingController expireDateController = TextEditingController();
  final TextEditingController securityCodeController = TextEditingController();
  final TextEditingController upiIdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Payment',
        onBackButtonPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Cards',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Raleway'),
            ),
            SizedBox(height: 10),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColor),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: ListTile(
                        dense: true,
                        leading: Image.network(
                            'https://i.pinimg.com/736x/38/2f/0a/382f0a8cbcec2f9d791702ef4b151443.jpg',
                            width: 50),
                        title: Text(
                          'Axis Bank **** **** **** 8395',
                          style: AppTextStyle.mediumgreyRaleway12,
                        ),
                        trailing: Radio(
                          value: 1,
                          groupValue: _selectedCardIndex,
                          onChanged: (value) {
                            setState(() {
                              _selectedCardIndex = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColor),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: ListTile(
                        dense: true,
                        leading: Image.network(
                            'https://w7.pngwing.com/pngs/646/268/png-transparent-visa-credit-card-debit-card-visa-blue-text-trademark.png',
                            width: 50),
                        title: Text(
                          'HDFC Bank **** **** **** 6246',
                          style: AppTextStyle.mediumgreyRaleway12,
                        ),
                        trailing: Radio(
                          value: 2,
                          groupValue: _selectedCardIndex,
                          onChanged: (value) {
                            setState(() {
                              _selectedCardIndex = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        dense: true,
                        leading: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffD2EAFF),

                            // border: Border.all(color: borderColor),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.add, color: Colors.blue),
                          ),
                        ),
                        title: Text('Add New Cards',
                            style: TextStyle(
                                color: Color(0xff606060),
                                fontSize: 14,
                                fontFamily: 'Raleway')),
                        onTap: () {
                          _showAddCardBottomSheet(context);
                        },
                      )),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'UPI',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Raleway'),
            ),
            SizedBox(height: 10),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColor),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: ListTile(
                        dense: true,
                        leading: Image.network(
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/480px-Google_%22G%22_logo.svg.png',
                            width: 24,
                            height: 24),
                        title: Text(
                          'Google Pay',
                          style: AppTextStyle.mediumgreyRaleway12,
                        ),
                        trailing: Radio(
                          value: 1,
                          groupValue: _selectedUpiIndex,
                          onChanged: (value) {
                            setState(() {
                              _selectedUpiIndex = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColor),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: ListTile(
                        dense: true,
                        leading: Image.network(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvfA-R2BKVmud5D-BOkkDhkRI2HeaB_HBPoZWD88o-FuzFczqNzlO8F2-YdWOqnEiYxFk&usqp=CAU',
                            width: 24,
                            height: 24),
                        title: Text(
                          'PhonePe',
                          style: AppTextStyle.mediumgreyRaleway12,
                        ),
                        trailing: Radio(
                          value: 2,
                          groupValue: _selectedUpiIndex,
                          onChanged: (value) {
                            setState(() {
                              _selectedUpiIndex = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        dense: true,
                        leading: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffD2EAFF),

                            // border: Border.all(color: borderColor),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.add, color: Colors.blue),
                          ),
                        ),
                        title: Text('Add New UPI',
                            style: TextStyle(
                                color: Color(0xff606060),
                                fontSize: 14,
                                fontFamily: 'Raleway')),
                        onTap: () {
                          _showAddUpiBottomSheet(context);
                        },
                      )),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'More Payment Options',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Raleway'),
            ),
            SizedBox(height: 10),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColor),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: ListTile(
                        dense: true,
                        leading:
                            Icon(Icons.account_balance, color: Colors.blue),
                        title: Text(
                          'Net Banking',
                          style: AppTextStyle.mediumgreyRaleway12,
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {},
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColor),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: ListTile(
                        dense: true,
                        leading: Icon(Icons.local_shipping, color: Colors.blue),
                        title: Text(
                          'Cash on Delivery',
                          style: AppTextStyle.mediumgreyRaleway12,
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('₹12,000',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins')),
                        Text(
                          'View detailed bill',
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: BlueButton(
                      buttonHeight: 8,
                      text: "Proceed",
                      onTap: () {},
                    ),
                  ),
                  // Container(
                  //   // width: double.infinity,
                  //   height: 50,
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(56),
                  //       ),
                  //       padding: EdgeInsets.zero,
                  //     ),
                  //     onPressed: () {},
                  //     child: Ink(
                  //       decoration: BoxDecoration(
                  //         color: Color(0xff3778F2),
                  //         // gradient: LinearGradient(
                  //         //   colors: [
                  //         //     Color(0xFF51B6FF),
                  //         //     Color(0xFF2A5EE3),
                  //         //   ],
                  //         //   begin: Alignment.topLeft,
                  //         //   end: Alignment.bottomRight,
                  //         // ),
                  //         borderRadius: BorderRadius.circular(16),
                  //       ),
                  //       child: Container(
                  //         alignment: Alignment.center,
                  //         child: Padding(
                  //           padding: const EdgeInsets.symmetric(
                  //               vertical: 8.0, horizontal: 16),
                  //           child: Text(
                  //             'Proceed to Pay',
                  //             style: TextStyle(
                  //                 fontSize: 16,
                  //                 fontWeight: FontWeight.bold,
                  //                 color: Colors.white),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCardBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Center(
                        child: Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          'Add Card',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins'),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          'Start typing to add your credit card details.\nEverything will update according to your data.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: textgrey,
                              fontFamily: 'Raleway',
                              fontSize: 14),
                        ),
                      ),
                      SizedBox(height: 20),
                      Card(
                        // width: double.infinity,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                'https://i.pinimg.com/736x/38/2f/0a/382f0a8cbcec2f9d791702ef4b151443.jpg',
                                width: 80,
                              ),
                              SizedBox(height: 40),
                              Text(
                                '1244 1234 1345 3255',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins'),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Card Holder',
                                        style: TextStyle(
                                            color: textgrey,
                                            fontFamily: 'Poppins',
                                            fontSize: 12),
                                      ),
                                      Text(
                                        'Yessie',
                                        style: TextStyle(
                                            color: textgrey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'Expires',
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: textgrey,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        '02/25',
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: textgrey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                        controller: cardnumberController,
                        hintText: 'Card Number',
                      ),
                      SizedBox(height: 5),

                      CustomTextField(
                        controller: nameController,
                        hintText: 'Card Holder',
                      ),
                      SizedBox(height: 5),

                      CustomTextField(
                        controller: expireDateController,
                        hintText: 'Expiry Date',
                      ),
                      SizedBox(height: 5),

                      CustomTextField(
                        controller: securityCodeController,
                        hintText: 'Security Code',
                      ),
                      // TextField(
                      //   decoration: InputDecoration(
                      //     labelText: 'Card Number',
                      //     labelStyle: TextStyle(color: Colors.black),
                      //   ),
                      // ),
                      // TextField(
                      //   decoration: InputDecoration(
                      //     labelText: 'Card Holder',
                      //     labelStyle: TextStyle(color: Colors.black),
                      //   ),
                      // ),
                      // TextField(
                      //   decoration: InputDecoration(
                      //     labelText: 'Expiry Date',
                      //     labelStyle: TextStyle(color: Colors.black),
                      //   ),
                      // ),
                      // TextField(
                      //   decoration: InputDecoration(
                      //     labelText: 'Security Code',
                      //     labelStyle: TextStyle(color: Colors.black),
                      //   ),
                      // ),
                      SizedBox(height: 20),
                      Center(
                        child: blueButtonCircular(
                          text: "Save",
                          onTap: () {},
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

// }
  void _showAddUpiBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Center(
                        child: Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          'Add UPI',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins'),
                        ),
                      ),
                      SizedBox(height: 40),
                      Center(
                        child: Text(
                          'Start typing to add your UPI ID.\nEverything will update according to your data.',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: textgrey, fontFamily: 'Raleway'),
                        ),
                      ),
                      SizedBox(height: 50),
                      Center(
                        child: Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e1/UPI-Logo-vector.svg/640px-UPI-Logo-vector.svg.png',
                          height: 100,
                        ),
                      ),
                      SizedBox(height: 50),
                      CustomTextField(
                          controller: upiIdController,
                          hintText: 'Enter your UPI'),
                      SizedBox(height: 20),
                      Center(
                        child: blueButtonCircular(
                          text: "Save",
                          onTap: () {
                            _showCongratulationsDialog(context);
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showCongratulationsDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (context, animation1, animation2) {
        return CongratulationsDialog();
      },
    );
  }
// }
}

class CongratulationsDialog extends StatefulWidget {
  @override
  _CongratulationsDialogState createState() => _CongratulationsDialogState();
}

class _CongratulationsDialogState extends State<CongratulationsDialog>
    with SingleTickerProviderStateMixin {
  double _imageSize = 0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _imageSize = 150;
      });
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.close),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.ios_share,
                    ),
                    color: Colors.white,
                    onPressed: () {
                      // Navigator.pop(context);
                    },
                  ),
                  // Icon(
                  //   Icons.ios_share,
                  //   color: Colors.white,
                  // )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 6,
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOut,
                width: _imageSize,
                height: _imageSize,
                child: Image.asset(
                  'assets/images/congratulations.jpg',
                  // fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Column(
                children: [
                  Text(
                    'Ta-da!',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Raleway',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Congratulations',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Raleway',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'You’re now part of our family, enjoy your special offers.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
