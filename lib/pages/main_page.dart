import 'package:doxie/edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future<String> _pdfPath;

  @override
  void initState() {
    super.initState();
    _pdfPath = _loadPDF();
  }

  Future<void> requestPermissions() async {
    if (await Permission.storage.request().isGranted) {
      // Permissions are granted, continue with your task
    } else {
      // Handle the case when permissions are not granted
    }
  }


  Future<String> _loadPDF() async {
    final ByteData data =
        await rootBundle.load('lib/assets/1-purchase order sal011742.pdf');
    final Directory tempDir = await getTemporaryDirectory();
    final File tempFile = File('${tempDir.path}/sample.pdf');
    await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
    return tempFile.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<void>(
              future: requestPermissions(), // Request permissions
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return FutureBuilder<String>(
                    future: _pdfPath,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          height: 240.h,
                          child:
                              const Center(child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasError ||
                          !snapshot.hasData ||
                          snapshot.data!.isEmpty) {
                        print('Error loading PDF: ${snapshot.error}');
                        return SizedBox(
                          height: 240.h,
                          child: const Center(child: Text('Error loading PDF')),
                        );
                      } else {
                        return GestureDetector(
                          // Detect swipe gestures
                          onHorizontalDragUpdate: (details) {
                            // Check if the user swiped to the left
                            if (details.delta.dx < 0) {
                              // Navigate to another page when swiped left
                              _navigateToPdfEditingPage(
                                  context, snapshot.data!);
                            }
                          },
                          child: SizedBox(
                            height: 240.h,
                            child: PDFView(
                              filePath: snapshot.data!,
                              enableSwipe: true,
                              swipeHorizontal: true,
                              autoSpacing: false,
                              pageFling: false,
                              onError: (error) {
                                print('PDFView error: $error');
                              },
                              onRender: (pages) {
                                print('Document rendered with $pages pages');
                              },
                              onViewCreated:
                                  (PDFViewController pdfViewController) {
                                print('PDF view created');
                              },
                              onPageChanged: (page, total) {
                                // Handle page change if needed
                              },
                            ),
                          ),
                        );
                      }
                    },
                  );
                } else {
                  return SizedBox(
                    height: 240.h,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildForm(),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPdfEditingPage(BuildContext context, String pdfPath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfEditing(
          pdfPath: pdfPath,
          // onSave: () {
          //   // Your save logic here
          //   print('PDF editing save logic');
          // },
          originRoute: 'MainPage',
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(height: 16.h),
        _buildFormHeader(),
        SizedBox(height: 4.h),
        _buildTextField(
          hintText: "118289",
          minLines: 1,
        ),
        SizedBox(height: 8.h),
        _buildLabel("Date"),
        SizedBox(height: 4.h),
        _buildTextField(
          hintText: "05-16-2024",
          suffixIcon: Icons.calendar_month,
          suffixIconColor: Colors.black54,
          minLines: 1,
        ),
        SizedBox(height: 8.h),
        _buildLabel("Contact"),
        SizedBox(height: 4.h),
        _buildTextField(
          hintText: "(303) 555-1 105",
          minLines: 1,
        ),
        SizedBox(height: 8.h),
        _buildLabel("Address"),
        SizedBox(height: 4.h),
        _buildTextField(
          hintText: "3517 W. Gray St. Utica, Pennsylvania 57867",
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
        Column(
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
      ],
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
    required String hintText,
    int? maxLines,
    IconData? suffixIcon,
    Color? suffixIconColor,
    required int minLines,
  }) {
    return Container(
      child: TextField(
        readOnly: true, // Set readOnly to true to disable editing
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
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.r),
            borderSide: const BorderSide(color: Colors.black), // Black border
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.r),
            borderSide: const BorderSide(color: Colors.black), // Black border
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.r),
            borderSide: const BorderSide(color: Colors.black), // Black border
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
