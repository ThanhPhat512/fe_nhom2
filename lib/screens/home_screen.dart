import 'package:flutter/cupertino.dart';
import 'package:fe_nhom2/theme/home_app_theme.dart';
import 'package:fe_nhom2/models/tabIcon_data.dart';
import 'package:fe_nhom2/screens/home/good_food/good_food_screen.dart';
import 'package:fe_nhom2/screens/Product/product_screen.dart';
import 'package:fe_nhom2/screens/bottom_navigation_view/bottom_bar_view.dart';
import 'package:flutter/material.dart';

import 'User/userScreen.dart';


class homeScreen extends StatefulWidget {
  @override
  _homeScreenState createState() => _homeScreenState();

}

class _homeScreenState extends State<homeScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: FitnessAppTheme.background,
  );

  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = GoodFoodScreen(animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
         Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => productScreen(animationController: animationController)
              ),
            );
          },
          changeIndex: (int index) {
            if (index == 0 ) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {return; }
                setState(() {
                });
                tabBody = GoodFoodScreen(animationController: animationController);
              });
            } else if (index == 1 ) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) { return;}
                setState(() {
                  tabBody = GoodFoodScreen(animationController: animationController);
                });
              });
            } else if (index == 2 ) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) { return;}
                setState(() {
                  tabBody = productScreen(animationController: animationController);
                });
              });
            } else if (index == 3 ) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) { return;}
                setState(() {
                  tabBody = UserScreen(animationController: animationController);
                });
              });
            }
          },
        ),
      ],
    );
  }
}
