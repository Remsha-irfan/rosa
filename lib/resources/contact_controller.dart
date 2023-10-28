import 'package:url_launcher/url_launcher.dart';

class ContactController {
  Future launchURL(Uri url) async {
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    } catch (error) {
      print(error);
    }
  }

  Future sendMail(email) async {
    Uri uri = Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters(<String, String>{
        'subject': 'Writing mail to user',
        'body': 'type mail here'
      }),
    );
    await launchURL(uri);
  }

  String? encodeQueryParameters(Map<String, String> params) {
    print('object');
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)} = ${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  Future makeCall(contact) async {
    Uri uri = Uri(
      scheme: 'tel',
      path: contact,
    );
    await launchURL(uri);
  }

  Future doSMS(contact) async {
    Uri uri = Uri(
      scheme: 'sms',
      path: contact,
      queryParameters: <String, String>{'body': Uri.encodeComponent('Message')},
    );
    await launchURL(uri);
  }
}
