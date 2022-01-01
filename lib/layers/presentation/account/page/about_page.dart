import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:store_app/core/config/constants.dart';
import 'package:store_app/core/config/globals.dart';
import 'package:store_app/layers/presentation/account/notifier/about_notifier.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<AboutNotifier>().reset();
      context.read<AboutNotifier>().getPackageInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final packageInfo = context.select((AboutNotifier n) => n.packageInfo);

    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Image.asset(
                "assets/images/logo_long_color.png",
                height: 120,
              ),
            ),

            _buildPackageInfo(packageInfo: packageInfo),

            SizedBox(height: 48),
            _buildDeveloper()
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        "About"
      ),
    );
  }

  Widget _buildPackageInfo({PackageInfo packageInfo}) {
    return Column(
      children: [
        Text(
          packageInfo == null ? "" : packageInfo.appName,
          style: TextStyle(
            fontSize: 16
          ),
        ),
        SizedBox(height: 4),

        Text(
          packageInfo == null ? "" : "Version ${packageInfo.version}",
          style: TextStyle(
            fontSize: 14
          ),
        )
      ],
    );
  }

  Widget _buildDeveloper() {
    return Column(
      children: [
        Text(
          "Developer Information",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 12),

        Container(
          height: App.getWidth(context) * .5,
          child: AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(500)),
              child: Image.asset(
                "assets/images/dev_photo.jpg",
                fit: BoxFit.cover,
              ),
            )
          ),
        ),
        SizedBox(height: 20),

        Text(
          "Nino Fachrurozy",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        SizedBox(height: 4),

        Text(
          "Android & web developer",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(height: 12),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_on,
              size: 20,
              color: colorPrimary,
            ),
            SizedBox(width: 4),
            Text(
              "Surabaya, Indonesia",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.phone,
              size: 20,
              color: colorPrimary,
            ),
            SizedBox(width: 4),
            Text(
              "0896-1641-4200",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.mail,
              size: 20,
              color: colorPrimary,
            ),
            SizedBox(width: 4),
            Text(
              "nfach98@gmail.com",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),

        SizedBox(height: 20),
      ],
    );
  }
}
