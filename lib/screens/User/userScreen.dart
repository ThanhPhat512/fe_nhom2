import 'package:fe_nhom2/screens/User/ui_view/userVỉew.dart';
import 'package:flutter/material.dart';
import 'package:fe_nhom2/theme/home_app_theme.dart';
import 'package:fe_nhom2/screens/home/ui_view/title_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Product/product_screen.dart';
import '../home_screen.dart';
import '../introduction_infomation/introduction_screen.dart';
import 'account_info_screen.dart';

class userScreen extends StatefulWidget {
  const userScreen({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;

  @override
  _userScreenState createState() => _userScreenState();
}

class _userScreenState extends State<userScreen> with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  String userName = 'Người Dùng';

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

    fetchUserName();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  void addAllListData() {
    const int count = 3;

    listViews.add(
      TitleView(
        titleTxt: 'Thông tin của bạn',
        animationController: widget.animationController,
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: widget.animationController!,
            curve: const Interval(0, 1.0, curve: Curves.fastOutSlowIn),
          ),
        ),
        onSubTxtTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => homeScreen(),
            ),
          );
        },
      ),
    );

    listViews.add(
      UserView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
  }

  Future<void> fetchUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('username') ?? 'Người Dùng';
    });
  }

  // Hàm xóa token khỏi SharedPreferences khi người dùng đăng xuất
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('userId');

    // Điều hướng về màn hình login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const IntroductionAnimationScreen()),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController?.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: FitnessAppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: FitnessAppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                userName,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22 + 6 - 6 * topBarOpacity,
                                  letterSpacing: 1.2,
                                  color: FitnessAppTheme.nearlyBlue,
                                ),
                              ),
                            ),

                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  await logout(); // Gọi hàm logout
                                },
                                borderRadius: BorderRadius.circular(8.0), // Hiệu ứng bo góc khi nhấn
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Căn chỉnh padding
                                  decoration: BoxDecoration(
                                    color: FitnessAppTheme.nearlyBlue.withOpacity(0.1), // Nền nhạt
                                    borderRadius: BorderRadius.circular(8.0), // Bo góc
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center, // Căn giữa nội dung
                                    children: [
                                      const Icon(
                                        Icons.logout, // Biểu tượng Logout
                                        color: FitnessAppTheme.nearlyBlue,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8), // Khoảng cách giữa biểu tượng và text
                                      Text(
                                        'Đăng Xuất', // Văn bản nút
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: FitnessAppTheme.fontName,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          letterSpacing: 0.8,
                                          color: FitnessAppTheme.nearlyBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),


                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
