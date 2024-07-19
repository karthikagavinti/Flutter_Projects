import 'package:doxie/edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NextPage extends StatefulWidget {
  const NextPage({super.key});

  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  late Future<String> _pdfPath;
  TextEditingController poNumberController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController addressController = TextEditingController();

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
        await rootBundle.load('lib/assets/2-invoice for accouting.PDF');
    final Directory tempDir = await getTemporaryDirectory();
    final File tempFile = File('${tempDir.path}/sample.pdf');
    await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
    return tempFile.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                          height: 240.h, // Use .h to adapt height
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasError ||
                          !snapshot.hasData ||
                          snapshot.data!.isEmpty) {
                        print('Error loading PDF: ${snapshot.error}');
                        return SizedBox(
                          height: 240.h, // Use .h to adapt height
                          child: Center(child: Text('Error loading PDF')),
                        );
                      } else {
                        return Column(
                          children: [
                            GestureDetector(
                              onHorizontalDragEnd: (details) {
                                if (details.velocity.pixelsPerSecond.dx < 0) {
                                  // Swiped left
                                  _navigateToOtherPage(context, snapshot.data!);
                                }
                              },
                              child: SizedBox(
                                height: 240.h, // Use .h to adapt height
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
                                    print(
                                        'Document rendered with $pages pages');
                                  },
                                  onViewCreated:
                                      (PDFViewController pdfViewController) {
                                    print('PDF view created');
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  );
                } else {
                  return SizedBox(
                    height: 240.h, // Use .h to adapt height
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
            SizedBox(height: 16.h), // Use .h to adapt height
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w), // Use .w to adapt width
              child: _buildForm(),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToOtherPage(BuildContext context, String pdfPath) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PdfEditing(
          // onSave: () {
          //   // Perform any action needed on save, like refreshing data
          //   print("Data saved, perform any necessary actions here.");
          // },
          originRoute: 'NextPage',
          pdfPath: pdfPath,
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFormHeader(),
        SizedBox(height: 4.h), // Use .h to adapt height
        _buildTextField(
          hintText: "118289",
          minLines: 1,
        ),
        SizedBox(height: 8.h), // Use .h to adapt height
        _buildLabel("Date"),
        SizedBox(height: 4.h), // Use .h to adapt height
        _buildTextField(
          hintText: "05-16-2024",
          suffixIcon: Icons.calendar_month,
          suffixIconColor: Colors.black54,
          minLines: 1,
        ),
        SizedBox(height: 8.h), // Use .h to adapt height
        _buildLabel("Contact"),
        SizedBox(height: 4.h), // Use .h to adapt height
        _buildTextField(
          hintText: "(303) 555-1 105",
          minLines: 1,
        ),
        SizedBox(height: 8.h), // Use .h to adapt height
        _buildLabel("Address"),
        SizedBox(height: 4.h), // Use .h to adapt height
        _buildTextField(
          hintText: "3517 W. Gray St. Utica, Pennsylvania 57867",
          minLines: 5,
          maxLines: 5,
        ),
        SizedBox(height: 16.h), // Use .h to adapt height
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
                fontSize: 18.sp, // Use .sp to adapt font size
              ),
            ),
            Text(
              "PO",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18.sp, // Use .sp to adapt font size
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
        fontSize: 18.sp, // Use .sp to adapt font size
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
            fontSize: 18.sp, // Use .sp to adapt font size
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w, // Use .w to adapt width
            vertical: 6.h, // Use .h to adapt height
          ),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.r), // Use .r to adapt radius
            borderSide: BorderSide(color: Colors.black), // Black border
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.r), // Use .r to adapt radius
            borderSide: BorderSide(color: Colors.black), // Black border
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.r), // Use .r to adapt radius
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
