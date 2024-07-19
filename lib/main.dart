import 'package:doxie/pages/afternext.dart';
import 'package:flutter/material.dart';
import 'package:doxie/pages/main_page.dart';
import 'package:doxie/pages/next_page.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _loadPageIndex();
  }

  Future<void> _loadPageIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int savedIndex = prefs.getInt('currentIndex') ?? 0;
    setState(() {
      _currentIndex = savedIndex;
      if (_currentIndex != 0) {
        _pageController.jumpToPage(_currentIndex);
      }
    });
  }

  Future<void> _savePageIndex(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentIndex', index);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomeScreen(
            pageController: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
                _savePageIndex(index);
              });
            },
            currentIndex: _currentIndex,
          ),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  final PageController pageController;
  final Function(int) onPageChanged;
  final int currentIndex;

  const HomeScreen({
    super.key,
    required this.pageController,
    required this.onPageChanged,
    required this.currentIndex,
  });

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
          onPressed: () {},
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
              SizedBox(
                width: 10.w,
              ),
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
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            onPageChanged: onPageChanged,
            children: const <Widget>[
              AfterNextPage(),
              NextPage(),
              MainPage(),
            ],
          ),
        ],
      ),
    );
  }
}
