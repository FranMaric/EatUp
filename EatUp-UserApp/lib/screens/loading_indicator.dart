import 'package:EatUpUserApp/widgets/logo.dart';
import 'package:flutter/material.dart';

import 'package:EatUpUserApp/constants.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: EatUpLogo(),
        backgroundColor: kAccentColor,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
