import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:glucose_monitoring/api_wrapper.dart';
import 'package:glucose_monitoring/auth_service.dart';
import 'package:glucose_monitoring/controller/data_controller.dart';
import 'package:glucose_monitoring/main_screen.dart';
import 'package:country_picker/country_picker.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen(
      {super.key,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.password});
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final List<String> sexOptions = ['Not Set', 'Male', 'Female', 'Other'];
  int selectedSexIndex = 0;

  final List<String> pregnancyOptions = ['Not Set', 'Yes', 'No', 'Not Certain'];
  int selectedPregnancyIndex = 0;

  int selectedAge = 0;
  String selectedNationality = 'Not Set';

  String? ageError, sexError, pregnancyError, nationalityError;

  bool isConfirmed = false; // Controls the animation

  void _validateAndContinue() async {
    print("HERE");
    setState(() {
      ageError = selectedAge == 0 ? "Please select your age" : null;
      sexError = selectedSexIndex == 0 ? "Please select your sex" : null;
      pregnancyError =
          selectedPregnancyIndex == 0 ? "Please select an option" : null;
      nationalityError = selectedNationality == 'Not Set'
          ? "Please select your nationality"
          : null;
    });

    if (ageError == null &&
        sexError == null &&
        pregnancyError == null &&
        nationalityError == null) {
      setState(() => isConfirmed = true); // Show animation
      Response response = await AuthService().register(
          age: selectedAge,
          sex: sexOptions[selectedSexIndex],
          nationality: selectedNationality,
          pregnancy: pregnancyOptions[selectedPregnancyIndex],
          firstName: widget.firstName,
          lastName: widget.lastName,
          email: widget.email,
          password: widget.password);
      if (response.statusCode == 201) {
        DataController dataController = Get.put(DataController());
        dataController.setUserData(response.data);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainScreen())); 
      } else {
        Get.snackbar("Error", "Failed to register",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }

  void _showPicker(
      List<String> options, int selectedIndex, Function(int) onSelected) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          child: CupertinoPicker(
            itemExtent: 40,
            scrollController:
                FixedExtentScrollController(initialItem: selectedIndex),
            onSelectedItemChanged: onSelected,
            children: options.map((item) => Center(child: Text(item))).toList(),
          ),
        );
      },
    );
  }

  void _showAgePicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          child: CupertinoPicker(
            itemExtent: 40,
            scrollController: FixedExtentScrollController(
                initialItem: selectedAge > 0 ? selectedAge - 1 : 17),
            onSelectedItemChanged: (index) {
              setState(() {
                selectedAge = index + 1;
                ageError = null;
              });
            },
            children: List.generate(
                100, (index) => Center(child: Text('${index + 1}'))),
          ),
        );
      },
    );
  }

  void _showNationalityPicker() {
    showCountryPicker(
      context: context,
      showWorldWide: false,
      onSelect: (Country country) {
        setState(() {
          selectedNationality = country.name;
          nationalityError = null;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Center(
                    child: Text(
                      'Welcome, ${widget.firstName}',
                      style: TextStyle(fontSize: 32, color: Color(0xFF18786F)),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: Text(
                      "Let's fill in your details.",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
                    ),
                  ),
                  const SizedBox(height: 80),
                  _buildPickerRow(
                      "Age",
                      selectedAge > 0 ? selectedAge.toString() : "Not Set",
                      _showAgePicker,
                      ageError),
                  const SizedBox(height: 10),
                  _buildPickerRow("Sex", sexOptions[selectedSexIndex], () {
                    _showPicker(sexOptions, selectedSexIndex, (index) {
                      setState(() {
                        selectedSexIndex = index;
                        sexError = null;
                      });
                    });
                  }, sexError),
                  const SizedBox(height: 10),
                  _buildPickerRow(
                      "Pregnancy", pregnancyOptions[selectedPregnancyIndex],
                      () {
                    _showPicker(pregnancyOptions, selectedPregnancyIndex,
                        (index) {
                      setState(() {
                        selectedPregnancyIndex = index;
                        pregnancyError = null;
                      });
                    });
                  }, pregnancyError),
                  const SizedBox(height: 10),
                  _buildPickerRow("Nationality", selectedNationality,
                      _showNationalityPicker, nationalityError),
                  const SizedBox(height: 100),
                  Center(
                    child: ElevatedButton(
                      onPressed: _validateAndContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF18786F),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                      ),
                      child: Text("Continue",
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              opacity: isConfirmed ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
              child: isConfirmed
                  ? Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check, size: 80, color: Colors.white),
                    )
                  : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerRow(
      String label, String value, VoidCallback onTap, String? errorText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(
                  color: errorText == null ? Colors.grey.shade300 : Colors.red),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w200)),
                Text(value,
                    style: TextStyle(fontSize: 20, color: Colors.black)),
              ],
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 5),
            child: Text(
              errorText,
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
      ],
    );
  }
}
