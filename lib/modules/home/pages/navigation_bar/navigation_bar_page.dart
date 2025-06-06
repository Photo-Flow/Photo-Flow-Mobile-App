import 'package:flutter/material.dart';
import 'package:photo_flow_mobile_app/modules/feed/pages/feed/feed_page.dart';
import 'package:photo_flow_mobile_app/modules/photo-upload/pages/photo_upload/photo_upload_page.dart';
import 'package:photo_flow_mobile_app/modules/profile/pages/my_profile/my_profile_page.dart';
import 'package:photo_flow_mobile_app/shared/utils/colors/photo_flow_colors.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({super.key});

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  final pages = [const FeedPage(), const PhotoUploadPage(), const MyProfilePage()];

  int index = 0;

  void changeIndex(int value) {
    index = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: pages.elementAt(index)),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
        selectedItemColor: PhotoFlowColors.photoFlowButton,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedItemColor: Colors.grey,
        backgroundColor: PhotoFlowColors.photoFlowBackground,
        currentIndex: index,
        onTap: (value) => changeIndex(value),
      ),
    );
  }
}
