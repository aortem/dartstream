import 'package:firebase/screens/unlink_provider_screen/unlink_provider_screen_view_model.dart';
import 'package:firebase/shared/shared.dart';
import 'package:firebase/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UnlinkProviderScreen extends StatelessWidget {
  const UnlinkProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UnlinkProviderScreenViewModel(),
      child: Consumer<UnlinkProviderScreenViewModel>(
        builder: (context, value, child) => Scaffold(
          body: Padding(
            padding: 20.horizontal,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Button(
                  loading: value.loading,
                  onTap: () => value.unLinkProvider('google.com'),
                  title: 'Google',
                ),
                20.vSpace,
                Button(
                  loading: value.loading,
                  onTap: () => value.unLinkProvider('apple.com'),
                  title: 'Apple',
                ),
                20.vSpace,
                Button(
                  loading: value.loading,
                  onTap: () => value.unLinkProvider('facebook.com'),
                  title: 'Facebook',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
