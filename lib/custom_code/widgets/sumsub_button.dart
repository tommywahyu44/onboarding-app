// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';

import 'package:flutter_idensic_mobile_sdk_plugin/flutter_idensic_mobile_sdk_plugin.dart';

class SumsubButton extends StatefulWidget {
  const SumsubButton({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<SumsubButton> createState() => _SumsubButtonState();
}

class _SumsubButtonState extends State<SumsubButton> {
  SNSMobileSDK? snsMobileSDK;

  var useDismissTimer = false;
  var useApplicantConf = false;
  var usePreferredDocumentDefinitions = false;
  var useDisableAnalytics = false;
  var useCustomStrings = false;
  var useCustomTheme = false;
  var useDisableAutoCloseOnApprove = false;

  void launchSDK() async {
    //
    // From your backend get an access token for the applicant to be verified.
    // The token must be generated with `levelName` and `userId`,
    // where `levelName` is the name of a level configured in your dashboard.
    //
    // The sdk will work in the production or in the sandbox environment
    // depend on which one the `accessToken` has been generated on.
    //
    final String accessToken =
        "_act-sbx-jwt-eyJhbGciOiJub25lIn0.eyJqdGkiOiJfYWN0LXNieC1hMWEwNTc4OS04ODk1LTQ2NjMtODE0Ni03YjFkOTc5ZTZjMjYtdjIiLCJ1cmwiOiJodHRwczovL2FwaS5zdW1zdWIuY29tIn0.-v2";

    // The access token has a limited lifespan and when it's expired, you must provide another one.
    // So be prepared to get a new token from your backend.
    //
    final onTokenExpiration = () async {
      // call your backend to fetch a new access token (this is just an example)
      return Future<String>.delayed(
          Duration(seconds: 2), () => "your new access token");
    };

    final builder = SNSMobileSDK.init(accessToken, onTokenExpiration);

    setupOptionalHandlers(builder);
    setupTheme(builder);

    snsMobileSDK = builder
        .withLocale(Locale(
            "en")) // https://api.flutter.dev/flutter/dart-ui/Locale-class.html
        .withDebug(true) // set debug mode if required
        .build();

    final result = await snsMobileSDK!.launch();

    print("Completed with result: $result");
  }

  void setupOptionalHandlers(SNSMobileSDKBuilder builder) {
    if (useApplicantConf) {
      builder
          .withApplicantConf({"email": "test@test.com", "phone": "123456789"});
    }

    if (usePreferredDocumentDefinitions) {
      builder.withPreferredDocumentDefinitions({
        "IDENTITY": {"idDocType": "PASSPORT", "country": "USA"},
        "IDENTITY2": {"idDocType": "DRIVERS", "country": "FRA"}
      });
    }

    if (useDisableAnalytics) {
      builder.withAnalyticsEnabled(false);
    }

    if (useCustomStrings) {
      builder.withStrings({"sns_general_poweredBy": "Custom watermark"});
    }

    if (useDisableAutoCloseOnApprove) {
      builder.withAutoCloseOnApprove(0);
    }

    final SNSStatusChangedHandler onStatusChanged =
        (SNSMobileSDKStatus newStatus, SNSMobileSDKStatus prevStatus) {
      print("onStatusChanged: $prevStatus -> $newStatus");

      // just to show how dismiss() method works
      if (useDismissTimer && prevStatus == SNSMobileSDKStatus.Ready) {
        new Timer(Duration(seconds: 10), () {
          snsMobileSDK?.dismiss();
        });
      }
    };

    final SNSEventHandler onEvent = (SNSMobileSDKEvent event) {
      print("onEvent: $event");
    };

    final SNSActionResultHandler onActionResult =
        (SNSMobileSDKActionResult result) {
      print("onActionResult: $result");

      // you must return a `Future` that in turn should be completed with a value of `SNSActionResultHandlerReaction` type
      // you could pass `.Cancel` to force the user interface to close, or `.Continue` to proceed as usual
      return Future.value(SNSActionResultHandlerReaction.Continue);
    };

    builder.withHandlers(
        onStatusChanged: onStatusChanged,
        onActionResult: onActionResult,
        onEvent: onEvent);
  }

  void setupTheme(SNSMobileSDKBuilder builder) {
    if (!useCustomTheme) {
      return;
    }

    builder.withTheme({
      "universal": {
        "fonts": {
          "assets": [
            // refers to the ttf/otf files (ios needs them to register fonts before they could be used)
            {"name": "Scriptina", "file": "assets/fonts/SCRIPTIN.ttf"},
            {
              "name": "Caslon Antique",
              "file": "assets/fonts/Caslon Antique.ttf"
            },
            {"name": "Requiem", "file": "assets/fonts/Requiem.ttf"},
            {"name": "DAGGERSQUARE", "file": "assets/fonts/DAGGERSQUARE.otf"},
            {"name": "Plasma Drip (BRK)", "file": "assets/fonts/plasdrip.ttf"}
          ],
          "headline1": {
            "name":
                "Scriptina", // use ttf's `Full Name` or the name of any system font installed, or omit the key to keep the default font-face
            "size": 40 // in points
          },
          "headline2": {"size": 22},
          "subtitle1": {"name": "DAGGERSQUARE", "size": 20},
          "subtitle2": {"name": "Plasma Drip (BRK)", "size": 18},
          "body": {"name": "Caslon Antique", "size": 16},
          "caption": {"name": "Requiem", "size": 12}
        },
        "images": {
          "iconMail":
              "assets/img/mail-icon.png", // either an image name or a path to the image (the size in points equals the size in pixels)
          "iconClose": {
            "image": "assets/img/cross-icon.png",
            "scale":
                3, // adjusts the "logical" size (in points), points=pixels/scale
            "rendering": "template" // "template" or "original"
          },
          "verificationStepIcons": {
            "identity": {"image": "assets/img/robot-icon.png", "scale": 3},
          }
        },
        "colors": {
          "navigationBarItem": {
            "light": "#FF000080", // #RRGGBBAA - white with 50% alpha
            "dark": "0x80FF0000" // 0xAARRGGBB - white with 50% alpha
          },
          "alertTint":
              "#FF000080", // sets both light and dark to the same color
          "backgroundCommon": {"light": "#FFFFFF", "dark": "#1E232E"},
          "backgroundNeutral": {
            "light": "#A59A8630" // keeps default `dark`
          },
          "backgroundInfo": {"light": "#9E95C0"},
          "backgroundSuccess": {"light": "#749C6F30"},
          "backgroundWarning": {"light": "#F1BE4F30"},
          "backgroundCritical": {"light": "#BB362A30"},
          "contentLink": {"light": "#DD8B35"},
          "contentStrong": {"light": "#4F4945"},
          "contentNeutral": {"light": "#7F877B"},
          "contentWeak": {"light": "#A59A86"},
          "contentInfo": {"light": "#1B1F4E"},
          "contentSuccess": {"light": "#749C6F"},
          "contentWarning": {"light": "#F1BE4F"},
          "contentCritical": {"light": "#BB362A"},
          "primaryButtonBackground": {"light": "#558387"},
          "primaryButtonBackgroundHighlighted": {"light": "#44696B"},
          "primaryButtonBackgroundDisabled": {"light": "#8AA499"},
          "primaryButtonContent": {"light": "#fff"},
          "primaryButtonContentHighlighted": {"light": "#fff"},
          "primaryButtonContentDisabled": {"light": "#fff"},
          "secondaryButtonBackground": {},
          "secondaryButtonBackgroundHighlighted": {"light": "#8AA499"},
          "secondaryButtonBackgroundDisabled": {},
          "secondaryButtonContent": {"light": "#558387"},
          "secondaryButtonContentHighlighted": {"light": "#fff"},
          "secondaryButtonContentDisabled": {"light": "#8AA499"},
          "cameraBackground": {"light": "#222"},
          "cameraContent": {"light": "#D2C5A5"},
          "fieldBackground": {"light": "#F9F1CB80"},
          "fieldBorder": {},
          "fieldPlaceholder": {"light": "#8F8376"},
          "fieldContent": {"light": "#32302F"},
          "fieldTint": {"light": "#558387"},
          "listSeparator": {"light": "#8F837680"},
          "listSelectedItemBackground": {"light": "#D2C5A580"},
          "bottomSheetHandle": {"light": "#8AA499"},
          "bottomSheetBackground": {"light": "#FFFFFF", "dark": "#4F4945"}
        }
      },
      "ios": {
        "metrics": {
          "commonStatusBarStyle": "default",
          "activityIndicatorStyle": "medium",
          "screenHorizontalMargin": 16,
          "buttonHeight": 48,
          "buttonCornerRadius": 8,
          "buttonBorderWidth": 1,
          "cameraStatusBarStyle": "default",
          "fieldHeight": 48,
          "fieldCornerRadius": 0,
          "viewportBorderWidth": 8,
          "bottomSheetCornerRadius": 16,
          "bottomSheetHandleSize": {"width": 36, "height": 4},
          "verificationStepCardStyle": "filled",
          "supportItemCardStyle": "filled",
          "documentTypeCardStyle": "filled",
          "selectedCountryCardStyle": "bordered",
          "cardCornerRadius": 16,
          "cardBorderWidth": 2,
          "listSectionTitleAlignment": "natural"
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => launchSDK(),
      child: Text("Launch Sumsub SDK"),
    );
  }
}
