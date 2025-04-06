import 'package:benchy/styling/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final List<bool> _expanded = List.generate(9, (_) => false);

  final List<Map<String, String>> _faqItems = [
    {
      'question': 'Is Benchy really free?',
      'answer': 'Benchy will always be 100% free. Forever.',
      'icon': 'monetization_on',
    },
    {
      'question': 'Can I create my own exercises?',
      'answer':
          'Yes, you can create custom exercises tailored to your workout routine.',
      'icon': 'fitness_center',
    },
    {
      'question': 'Does Benchy work without internet?',
      'answer':
          'Yes, Benchy is designed to work entirely offline, allowing you to track your workouts without an internet connection.',
      'icon': 'wifi_off',
    },
    {
      'question': 'What data does the app collect?',
      'answer':
          'Benchy does not collect any personal data or send it to third parties. All your workout data, settings, and preferences are stored locally on your device and are not accessible by us or anyone else.',
      'icon': 'lock',
    },
    {
      'question': 'How do I backup my progress?',
      'answer':
          'Benchy does not automatically sync or store your data in the cloud. To backup your progress, you can export your data from the settings menu and save it to a secure location. You can then import this data back into the app if needed.',
      'icon': 'sync',
      'link': 'https://github.com/AAR072/benchy/wiki/syncing'
    },
    {
      'question': 'Can you add____?',
      'answer':
          'We are open to feature requests. Please tell us what you want us to hear.',
      'icon': 'feature',
      'link': 'https://github.com/AAR072/benchy/wiki/request'
    },
    {
      'question': 'Is the code open-source?',
      'answer': 'Yes, Benchy\'s code is open-source and available on GitHub.',
      'link': 'https://github.com/AAR072/benchy',
      'icon': 'code',
    },
    {
      'question': 'How can I contribute to the app?',
      'answer':
          'We welcome contributions! You can submit bug reports, suggest features, or contribute code.',
      'link': 'https://github.com/AAR072/benchy/wiki/contributing',
      'icon': 'group_add',
    },
  ];

  IconData _getIconByName(String name) {
    switch (name) {
      case 'monetization_on':
        return Icons.monetization_on;
      case 'wifi_off':
        return Icons.network_wifi_1_bar;
      case 'lock':
        return Icons.lock;
      case 'sync':
        return Icons.sync_outlined;
      case 'code':
        return Icons.code;
      case 'group_add':
        return Icons.group_add;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'straighten':
        return Icons.straighten;
      case 'feature':
        return Icons.psychology;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.primaryBackground,
      appBar: AppBar(
        backgroundColor: Palette.secondaryBackground,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 30,
        surfaceTintColor: Colors.transparent,
        leading: Transform.translate(
          offset: Offset(0, -4),
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.keyboard_arrow_left_sharp),
          ),
        ),
        title: Opacity(
          opacity: 1,
          child: Text(
            "Frequently Asked Questions",
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
        ),
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: ListView.builder(
          itemCount: _faqItems.length,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          itemBuilder: (context, index) {
            final item = _faqItems[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: EdgeInsets.zero,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ExpansionTile(
                    backgroundColor: Colors.transparent,
                    collapsedBackgroundColor: Colors.transparent,
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    visualDensity: VisualDensity(vertical: -1),
                    leading: Icon(
                      _getIconByName(item['icon']!),
                      color: Palette.inverseThemeColor,
                    ),
                    title: Text(
                      item['question']!,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    trailing: Icon(
                      _expanded[index]
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right_sharp,
                      color: Palette.inverseThemeColor,
                    ),
                    onExpansionChanged: (bool expanded) {
                      setState(() {
                        _expanded[index] = expanded;
                      });
                    },
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['answer']!,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                          if (item['link'] != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: RichText(
                                text: TextSpan(
                                  text: 'Learn more: ',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: item['link'],
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          final url = Uri.parse(item['link']!);
                                          if (await canLaunchUrl(url)) {
                                            await launchUrl(url);
                                          }
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
