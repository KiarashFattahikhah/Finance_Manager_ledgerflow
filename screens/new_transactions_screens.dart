import "dart:math";

import "package:currency_picker/currency_picker.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_project/constant.dart";
import "package:flutter_project/main.dart";
import "package:flutter_project/models/money.dart";
import "package:flutter_project/utils/extention.dart";
import "package:flutter_project/widgets/formatter.dart";
import "package:hive/hive.dart";
import 'package:flutter_project/data/categories.dart';

class NewTransactionsScreens extends StatefulWidget {
  const NewTransactionsScreens({super.key});

  static int groupId = 0;
  static TextEditingController descriptionController = TextEditingController();
  static TextEditingController priceController = TextEditingController();
  static bool isEditing = false;
  static int id = 0;

  static String date = 'Date';
  static String currency = 'Currency';

  // FIX: category must be nullable
  static String? category;

  @override
  State<NewTransactionsScreens> createState() => _NewTransactionsScreensState();
}

class _NewTransactionsScreensState extends State<NewTransactionsScreens> {
  String? descriptionError;
  String? priceError;
  String? currencyError;
  String? dateError;
  String? typeError;
  String? categoryError;

  bool validateInputs() {
    setState(() {
      descriptionError = NewTransactionsScreens.descriptionController.text.isEmpty
          ? "Description is required"
          : null;

      priceError = NewTransactionsScreens.priceController.text.isEmpty
          ? "Price is required"
          : null;

      currencyError = NewTransactionsScreens.currency == "Currency"
          ? "Select a currency"
          : null;

      dateError = NewTransactionsScreens.date == "Date"
          ? "Select a date"
          : null;

      typeError = NewTransactionsScreens.groupId == 0
          ? "Select Payment or Receipt"
          : null;

      // FIX: category must be checked for null
      categoryError = NewTransactionsScreens.category == null
          ? "Category is required"
          : null;
    });

    return descriptionError == null &&
        priceError == null &&
        currencyError == null &&
        dateError == null &&
        typeError == null &&
        categoryError == null;
  }

  Box<Money> hiveBox = Hive.box<Money>('moneyBox');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          margin: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                NewTransactionsScreens.isEditing ? 'Edit Transaction' : 'New Transaction',
                style: TextStyle(
                  fontSize: screenSize(context).screenWidth < 1004
                      ? 20
                      : screenSize(context).screenWidth * 0.015,
                ),
              ),

              // DESCRIPTION + CATEGORY
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyTextField(
                      hintText: 'Descriptions',
                      controller: NewTransactionsScreens.descriptionController,
                    ),
                    if (descriptionError != null)
                      Text(descriptionError!, style: TextStyle(color: Colors.red)),

                    SizedBox(height: 10),

                    // FIXED CATEGORY DROPDOWN
                    DropdownButtonFormField<String>(
                      value: NewTransactionsScreens.category,
                      decoration: const InputDecoration(
                        labelText: "Category",
                        border: OutlineInputBorder(),
                      ),
                      hint: Text("Select a category"),
                      items: appCategories.map((cat) {
                        return DropdownMenuItem(
                          value: cat.name,
                          child: Row(
                            children: [
                              Icon(cat.icon, size: 20),
                              SizedBox(width: 10),
                              Text(cat.name),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          NewTransactionsScreens.category = value;
                        });
                      },
                    ),

                    if (categoryError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(categoryError!, style: TextStyle(color: Colors.red)),
                      ),
                  ],
                ),
              ),

              // PRICE + CURRENCY
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyTextField(
                            hintText: 'Price',
                            type: TextInputType.number,
                            controller: NewTransactionsScreens.priceController,
                            inputFormatter: ThousandsSeparatorInputFormatter(),
                          ),
                          if (priceError != null)
                            Text(priceError!, style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              showCurrencyPicker(
                                context: context,
                                showFlag: true,
                                showCurrencyName: true,
                                showCurrencyCode: true,
                                onSelect: (Currency currency) {
                                  setState(() {
                                    NewTransactionsScreens.currency = currency.symbol;
                                  });
                                  Hive.box('settingsBox').put('currency', currency.symbol);
                                },
                              );
                            },
                            child: Text(
                              NewTransactionsScreens.currency,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: screenSize(context).screenWidth < 1004
                                    ? 12
                                    : screenSize(context).screenWidth * 0.01,
                              ),
                            ),
                          ),
                          if (currencyError != null)
                            Text(currencyError!, style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // TYPE + DATE
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: MyRadioBotton(
                            value: 1,
                            groupValue: NewTransactionsScreens.groupId,
                            onChanged: (value) {
                              setState(() {
                                NewTransactionsScreens.groupId = value!;
                              });
                            },
                            text: 'Payment',
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: MyRadioBotton(
                            value: 2,
                            groupValue: NewTransactionsScreens.groupId,
                            onChanged: (value) {
                              setState(() {
                                NewTransactionsScreens.groupId = value!;
                              });
                            },
                            text: 'Receipt',
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              OutlinedButton(
                                onPressed: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );
                                  if (picked == null) return;

                                  final year = picked.year.toString();
                                  final month = picked.month.toString().padLeft(2, '0');
                                  final day = picked.day.toString().padLeft(2, '0');

                                  setState(() {
                                    NewTransactionsScreens.date = "$year/$month/$day";
                                  });
                                },
                                child: Text(
                                  NewTransactionsScreens.date,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: screenSize(context).screenWidth < 1004
                                        ? 10
                                        : screenSize(context).screenWidth * 0.01,
                                  ),
                                ),
                              ),
                              if (dateError != null)
                                Text(dateError!, style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (typeError != null)
                      Text(typeError!, style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),

              // SUBMIT BUTTON
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: SizedBox(
                  height: screenSize(context).screenWidth < 1004
                      ? 40
                      : screenSize(context).screenWidth * 0.03,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: TextButton.styleFrom(
                      backgroundColor: kPurpleColor,
                      elevation: 0,
                    ),
                    child: Text(
                      NewTransactionsScreens.isEditing ? 'Editing' : 'Adding',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenSize(context).screenWidth < 1004
                            ? 18
                            : screenSize(context).screenWidth * 0.014,
                      ),
                    ),
                    onPressed: () {
                      if (!validateInputs()) return;

                      Money item = Money(
                        id: Random().nextInt(9999999),
                        title: NewTransactionsScreens.descriptionController.text,
                        price: NewTransactionsScreens.priceController.text,
                        date: NewTransactionsScreens.date,
                        currency: NewTransactionsScreens.currency,
                        category: NewTransactionsScreens.category!,
                        isReceived: NewTransactionsScreens.groupId == 1 ? false : true,
                      );

                      if (NewTransactionsScreens.isEditing) {
                        int index = 0;
                        MyApp.getData();
                        for (int i = 0; i < hiveBox.values.length; i++) {
                          if (hiveBox.values.elementAt(i).id == NewTransactionsScreens.id) {
                            index = i;
                          }
                        }
                        hiveBox.putAt(index, item);
                      } else {
                        hiveBox.add(item);
                      }

                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyRadioBotton extends StatelessWidget {
  final int value;
  final int groupValue;
  final Function(int?) onChanged;
  final String text;

  const MyRadioBotton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Radio(
            activeColor: kPurpleColor,
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: screenSize(context).screenWidth < 1004
                ? 14
                : screenSize(context).screenWidth * 0.01,
          ),
        ),
      ],
    );
  }
}

class MyTextField extends StatelessWidget {
  final String hintText;
  final TextInputType type;
  final TextEditingController controller;
  final TextInputFormatter? inputFormatter;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.type = TextInputType.text,
    this.inputFormatter,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: type,
      cursorColor: Colors.black38,
      inputFormatters: inputFormatter != null ? [inputFormatter!] : [],
      decoration: InputDecoration(
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: screenSize(context).screenWidth < 1004
              ? 14
              : screenSize(context).screenWidth * 0.012,
        ),
      ),
    );
  }
}
