import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:xivah/constants/konstants.dart';
import 'package:xivah/farming/firebaseController.dart';
import 'package:xivah/farming/pageRouteController.dart';
import 'package:xivah/lands/loginPage.dart';

class SideAppDrawer extends StatefulWidget {
  @override
  _SideAppDrawerState createState() => _SideAppDrawerState();
}

class _SideAppDrawerState extends State<SideAppDrawer> {
  FirebaseUserController _firebaseUserController;

  @override
  void initState() {
    _firebaseUserController = FirebaseUserController.loginCheck();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Colors.blueGrey[500],
          Colors.blueGrey[900],
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      )),
      height: height,
      width: width,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              width: width,
              child: FutureBuilder(
                future: _firebaseUserController.getUser(),
                builder: (BuildContext context,
                    AsyncSnapshot<FirebaseUser> snapshot) {
                  if (snapshot.hasData) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          height: 60.0,
                          width: 60.0,
                          child: AspectRatio(
                            aspectRatio: 1 / 1,
                            child: ClipOval(
                              child: FadeInImage.memoryNetwork(
                                fit: BoxFit.cover,
                                placeholder: kTransparentImage,
                                fadeOutCurve: Curves.bounceOut,
                                image: snapshot.data.photoUrl,
                              ),
                            ),
                          ),
                        ),
                        Konstants.sizedBoxw5,
                        Container(
                          height: 60.0,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _headings(snapshot.data.displayName, 14.0,
                                  FontWeight.w700),
                              _headings(
                                  snapshot.data.email, 12.0, FontWeight.w500)
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return Konstants.nothing;
                },
              ),
            ),
            ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    child: _alertExit(
                        firebaseUserController: _firebaseUserController,
                        context: context));
              },
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              title: Text(
                "Sign out",
                style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.beenhere,
                color: Colors.white,
              ),
              title: Text("Namaskar",
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w700)),
              subtitle: Text("Stay Home, Stay safe !",
                  style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Function _headings = (label, fontSize, fontWeight) => Expanded(
        child: Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );

  Function _alertExit = (
          {FirebaseUserController firebaseUserController,
          BuildContext context}) =>
      AlertDialog(
        elevation: 8.0,
        title: Text(
          "Account logout",
          style: Konstants.textStyleHeading,
        ),
        content: Text(
          "Are you sure ?",
          style: Konstants.textStyleSubHead,
        ),
        actions: <Widget>[
          OutlineButton(
            borderSide: BorderSide(color: Colors.red),
            onPressed: () async {
              await firebaseUserController.signOut().then((_) =>
                  Navigator.of(context).pushAndRemoveUntil(
                      PageRouteControll(LoginPage()), (route) => false));
            },
            child: Text("Yes"),
            textColor: Colors.red,
            splashColor: Colors.red[200],
          ),
        ],
      );
}
