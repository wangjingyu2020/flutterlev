import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String appName = 'App';
  String version = '';
  String buildNumber = '';

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appName = info.appName;
      version = info.version;
      buildNumber = info.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.info_outline, size: 80, color: Colors.blue),
              const SizedBox(height: 16),
              Text(
                appName,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'Version $version (Build $buildNumber)',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              const Text(
                'Developer',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Icon(Icons.person, size: 28, color: Colors.black54),
              const Text('Jingyu Wang',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              const Text('Software Developer',
                  style: TextStyle(fontSize: 13, color: Colors.grey)),

              const SizedBox(height: 16),
              const Icon(Icons.email, size: 24, color: Colors.black54),
              const Text('jingyu@example.com',
                  style: TextStyle(fontSize: 14, color: Colors.blue)),

              const SizedBox(height: 32),
              const Text(
                'License',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'This app is provided as-is without any guarantees or warranty. '
                      'Use it at your own risk. All rights reserved © 2024.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
