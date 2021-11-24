import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:nb_utils/src/extensions/context_extensions.dart';
import 'package:saffrun_app/constants/theme_color.dart';
import 'components/profile_list_item.dart';

class ProfileUserPage extends StatefulWidget {
  const ProfileUserPage({Key? key}) : super(key: key);

  @override
  _ProfileUserPageState createState() => _ProfileUserPageState();
}

class _ProfileUserPageState extends State<ProfileUserPage> {



  @override
  Widget build(BuildContext context) {


    return Scaffold(
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: context.height() * 0.025,
                                        horizontal: context.width() * 0.05),
          children: <Widget>[
            buildTop(),
            const ProfileListItems(),
      ],
        ));
  }

  Widget buildTop() {
    double coverHeight = context.height() * 0.3;
    double profileHeight = context.height() * 0.2;
    final top = coverHeight - profileHeight/2;
    final bottom = profileHeight/2;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(margin: EdgeInsets.only(bottom: bottom),child: buildCoverImage(coverHeight)),
        Positioned(
          right: 50,
          top: top,
          child: buildProfileImage(profileHeight),
        ),

      ],
    );
  }




  Widget buildCoverImage(double coverHeight) => Container(
        color: colorPallet5,
        height: coverHeight,
      );

  Widget buildProfileImage(double profileHeight) =>
  Container(
    width: profileHeight,
    height: profileHeight,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      image: const DecorationImage(
        image: ExactAssetImage('images/mafia1.jpg'),
        fit: BoxFit.cover,
      ),
      border: Border.all(
        color: Colors.white,
        width: 4.0,
      ),
    ),
  );
}

class ProfileListItems extends StatelessWidget {
  const ProfileListItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: context.height() * 0.05,),
        const ProfileListItem(
          icon: LineAwesomeIcons.user_shield,
          // icon: Icons.home,
          text: 'امنیت',
        ),
        const ProfileListItem(
          icon: LineAwesomeIcons.history,
          text: 'سابقه خرید',
        ),
        const ProfileListItem(
          icon: LineAwesomeIcons.question_circle,
          text: 'راهنما و پشتیبانی',
        ),
        const ProfileListItem(
          icon: LineAwesomeIcons.cog,
          text: 'تنظیمات',
        ),
        const ProfileListItem(
          icon: LineAwesomeIcons.user_plus,
          text: 'دعوت دوستان',
        ),
        const ProfileListItem(
          icon: LineAwesomeIcons.alternate_sign_out,
          text: 'خروج',
          hasNavigation: false,
        ),
      ],
    );
  }
}