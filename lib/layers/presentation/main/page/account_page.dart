import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/core/config/constants.dart';
import 'package:store_app/core/config/globals.dart';
import 'package:store_app/layers/domain/entities/user.dart';
import 'package:store_app/layers/presentation/account/page/about_page.dart';
import 'package:store_app/layers/presentation/account/page/edit_page.dart';
import 'package:store_app/layers/presentation/auth/notifier/auth_notifier.dart';
import 'package:store_app/layers/presentation/auth/page/login_page.dart';
import 'package:store_app/layers/presentation/main/notifier/account_notifier.dart';
import 'package:store_app/layers/presentation/main/widget/item_account_setting.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final user = context.select((AccountNotifier n) => n.user);
    final isLoadingUser = context.select((AccountNotifier n) => n.isLoadingUser);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildProfile(
                user: user
              ),

              ItemAccountSetting(
                text: "Edit",
                icon: Icon(
                  Icons.edit,
                  size: 24,
                  color: colorPrimary,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => EditPage())
                  );
                },
              ),
              ItemAccountSetting(
                text: "Setting",
                icon: Icon(
                  Icons.settings,
                  size: 24,
                  color: colorPrimary,
                ),
              ),
              ItemAccountSetting(
                text: "About",
                icon: Icon(
                  Icons.info,
                  size: 24,
                  color: colorPrimary,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AboutPage())
                  );
                },
              ),
              ItemAccountSetting(
                text: "Logout",
                color: Colors.red,
                icon: Icon(
                  Icons.exit_to_app,
                  size: 24,
                  color: Colors.red,
                ),
                onPressed: () {
                  context.read<AuthNotifier>().logout().then((status) {
                    if (status) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => LoginPage())
                      );
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfile({User user}) {
    return Container(
      padding: EdgeInsets.all(20),
      color: colorPrimary,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: App.getWidth(context) * .2,
            child: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                child: Image.asset(
                  user == null || user.avatar == null
                    ? "assets/images/no_image.png"
                    : user.avatar,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user == null ? "" : user.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 4),
                Text(
                  user == null ? "" : user.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          )
        ],
      ),
    );
  }
}
