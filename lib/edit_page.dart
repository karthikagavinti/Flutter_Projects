import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class PdfEditing extends StatefulWidget {
  final String pdfPath;
  final String originRoute;

  const PdfEditing({
    super.key,
    required this.pdfPath,
    required this.originRoute,
  });

  @override
  State<PdfEditing> createState() => _PdfEditingState();
}

class _PdfEditingState extends State<PdfEditing> {
  final TextEditingController poNumberController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  Future<void> sendData() async {
    final String apiUrl = 'http://127.0.0.1:8000/documents/';

    final Map<String, dynamic> data = {
      'po_number': poNumberController.text,
      'date': dateController.text,
      'contact': contactController.text,
      'address': addressController.text,
    };

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print('Data sent successfully');
    } else {
      print('Failed to send data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset(
            "lib/assets/chevron-left",
            color: Colors.red,
            width: 32.w,
            height: 32.h,
          ),
          onPressed: () {
            Navigator.pop(context); // Navigate back to previous screen
          },
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: EdgeInsets.only(left: 70.w),
          child: Row(
            children: [
              Image.asset(
                'lib/assets/Doxie_logo.png',
                fit: BoxFit.contain,
                height: 30.h,
              ),
              SizedBox(width: 10.w),
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.white, Colors.white],
                  ).createShader(bounds);
                },
                child: Text(
                  'DOXIE',
                  style: TextStyle(
                    color: Color(0xFF0E0C0D),
                    fontSize: 20.sp,
                    letterSpacing: 6,
                    fontFamily: 'ROBOT',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: _buildForm(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 240.h,
      color: Colors.grey[300], // Light grey background color
      child: PDFView(
        filePath: widget.pdfPath, // Use the pdfPath passed from navigation
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: false,
        onError: (error) {
          print('PDFView error: $error');
        },
        onRender: (_pages) {
          print('Document rendered with $_pages pages');
        },
        onViewCreated: (PDFViewController pdfViewController) {
          print('PDF view created');
        },
        onPageChanged: (page, total) {
          // Handle page change if needed
        },
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        _buildFormHeader(),
        SizedBox(height: 4.h),
        _buildTextField(
          controller: poNumberController,
          hintText: "Enter the PO.NO",
          minLines: 1,
        ),
        SizedBox(height: 8.h),
        _buildLabel("Date"),
        SizedBox(height: 4.h),
        _buildTextField(
          controller: dateController,
          hintText: "Enter the Date",
          suffixIcon: Icons.calendar_month,
          suffixIconColor: Colors.black54,
          minLines: 1,
        ),
        SizedBox(height: 8.h),
        _buildLabel("Contact"),
        SizedBox(height: 4.h),
        _buildTextField(
          controller: contactController,
          hintText: "Enter the Contact NO",
          minLines: 1,
        ),
        SizedBox(height: 8.h),
        _buildLabel("Address"),
        SizedBox(height: 4.h),
        _buildTextField(
          controller: addressController,
          hintText: "Enter the Address",
          minLines: 5,
          maxLines: 5,
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildFormHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Please fill in the details",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
              Text(
                "PO",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
        ),
        _buildGradientButton()
      ],
    );
  }

  Widget _buildGradientButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFFD4552), // The color #FD4552 in hexadecimal
            Color(0xFFF5082A), // The color #F5082A in hexadecimal
          ],
        ),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: ElevatedButton(
        onPressed: () {
          sendData(); // Call the sendData method
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.r),
          ),
          elevation: 3,
        ),
        child: Text(
          'Save',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.white,
            fontFamily: 'Lato',
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.black87,
        fontSize: 18.sp,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int? maxLines,
    IconData? suffixIcon,
    Color? suffixIconColor,
    required int minLines,
  }) {
    return Container(
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        minLines: minLines,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.black54,
            fontSize: 18.sp,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 6.h,
          ),
          fillColor: Colors.grey[200],
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.r),
            borderSide: BorderSide(color: Colors.black), // Black border
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.r),
            borderSide: BorderSide(color: Colors.black), // Black border
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.r),
            borderSide: BorderSide(color: Colors.black), // Black border
          ),
          suffixIcon: suffixIcon != null
              ? IconTheme(
                  data: IconThemeData(color: suffixIconColor),
                  child: Icon(suffixIcon),
                )
              : null,
        ),
      ),
    );
  }
}
