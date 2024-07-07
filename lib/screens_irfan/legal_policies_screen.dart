import 'package:flutter/material.dart';

class LegalPoliciesScreen extends StatefulWidget {
  @override
  _LegalPoliciesScreenState createState() => _LegalPoliciesScreenState();
}

class _LegalPoliciesScreenState extends State<LegalPoliciesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Term & Services',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        backgroundColor:
            Color.fromARGB(255, 214, 244, 245), // Updated color here
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(
              20.0), // Padding untuk memberikan ruang di sekitar konten
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Mulai dari kiri atas halaman
            children: <Widget>[
              Text(
                'Terms of Service',
                style: TextStyle(
                  fontSize: 20, // Ukuran judul
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Welcome to CareShare, a mobile application dedicated to mental health. By using our app, you agree to these terms. You must create an account with accurate information and are responsible for safeguarding your password. CareShare provides articles, discussion forums, and video calls with mentors for informational purposes only and should not replace professional medical advice.\n\nUse the app responsibly and legally, refraining from harmful or offensive behavior. Your privacy is important; please review our Privacy Policy. We may update these terms at any time, and continued use signifies acceptance. We may terminate your account for any breach. CareShare is provided "as is" without warranties, and we are not liable for indirect damages. These terms are governed by the laws of our operating jurisdiction. Thank you for choosing CareShare.',
                style: TextStyle(
                  fontSize: 14, // Ukuran subjudul
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 35),
              Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 20, // Ukuran judul
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'CareShare is committed to protecting your privacy. We collect personal information you provide, such as account details, and usage data like IP addresses and interaction history. This information helps us improve and personalize our services. We do not share your personal information with third parties except as needed for service provision, legal compliance, or protection of our rights. Aggregated, non-identifiable data may be used for research.\n\nWe take measures to secure your data but cannot guarantee absolute security. For questions about our privacy practices, contact us through the app. Thank you for trusting CareShare with your mental health journey.',
                style: TextStyle(
                  fontSize: 14, // Ukuran subjudul
                  color: Colors.black,
                ),
              ),
              // Spacer
            ],
          ),
        ),
      ),
    );
  }
}
