import 'package:flutter/material.dart';
import 'package:event_planner_buisness/constant.dart';
import '../screens/vp_profile_screen.dart';

class MainDrawer extends StatelessWidget {
  final void Function(BuildContext context) logoutFun;
  final BuildContext ctx;

  MainDrawer({required this.logoutFun, required this.ctx});

  Widget buildListTile(String text, IconData icon, Function()? onTap) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: kdarkTeal),
      title: Text(
        text,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10, left: 10),
            color: kdarkTeal,
            width: double.infinity,
            height: 150,
            child: SafeArea(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('assets/images/ep.PNG'),
                  ),
                  SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to',
                        style: TextStyle(
                          fontSize: 20,
                          color: kaccentColor,
                        ),
                      ),
                      Text(
                        'Event Planner',
                        style: TextStyle(
                          fontSize: 20,
                          color: kaccentColor,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          buildListTile(
            'Your Profile',
            Icons.account_circle,
            () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, VPProfileScreen.VpProfileScreen);
            },
          ),
          SizedBox(height: 10),
          buildListTile(
            'Privacy Policy',
            Icons.privacy_tip,
            () {},
          ),
          SizedBox(height: 10),
          buildListTile(
            'About Us',
            Icons.assignment,
            () {},
          ),
          SizedBox(height: 10),
          buildListTile(
            'Logout',
            Icons.logout,
            () {
              Navigator.of(context).pop();
              logoutFun!(ctx!);
            },
          ),
        ],
      ),
    );
  }
}
