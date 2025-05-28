import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:schooldynamics/theme/app_theme.dart';

import '../../utils/AppConfig.dart';
import '../../utils/Utils.dart';
import '../../utils/my_colors.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  AboutUsScreenState createState() => AboutUsScreenState();
}

class AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.primary,
      appBar: AppBar(
          backgroundColor: CustomTheme.primary,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light,
              statusBarColor: CustomTheme.primary),
          title: const Text("About", style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.verified, color: Colors.white),
              onPressed: () {},
            )
          ]),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FxText.titleMedium(
                "${AppConfig.APP_NAME} App",
                color: Colors.white,
              ),
              Container(height: 5),
              Container(width: 120, height: 3, color: Colors.white),
              Container(height: 15),
              FxText.bodyLarge('Version', color: MyColors.grey_20),
              FxText.bodyLarge('2.1.0', color: MyColors.grey_20),
              Container(height: 15),

              FxText.bodyLarge('Last Update', color: MyColors.grey_20),

              FxText.bodyLarge('February 2023', color: Colors.white),

              const FeatureItem('Attendance Tracking',
                  'Say goodbye to manual attendance records. "School Dynamics" simplifies the process by allowing teachers to effortlessly mark and track student attendance with just a few taps.'),
              const FeatureItem('Assignment Management',
                  'Streamline the assignment workflow with our intuitive assignment management system. Teachers can assign tasks, set deadlines, and track student progress, fostering a more organized and productive learning environment.'),
              const FeatureItem('Communication Hub',
                  'Enhance communication between schools, teachers, and parents through our dedicated communication hub. Receive real-time updates, announcements, and notifications, ensuring everyone stays informed and engaged.'),
              const FeatureItem('Gradebook',
                  'Keep track of student performance with our robust gradebook feature. Teachers can efficiently input and manage grades, while parents can monitor their child\'s progress and academic achievements.'),
              const FeatureItem('Event Calendar',
                  'Never miss an important event again. "School Dynamics" features a centralized event calendar that keeps everyone informed about upcoming school events, examinations, and extracurricular activities.'),
              const FeatureItem('Secure Messaging',
                  'Ensure secure and direct communication between teachers, students, and parents through our encrypted messaging system, promoting a collaborative and supportive educational ecosystem.'),
              const FeatureItem('Timetable Management',
                  'Simplify scheduling with our timetable management tool. Easily create and manage class schedules, reducing confusion and ensuring a smooth flow of daily activities.'),
              const SizedBox(height: 36),
              const Center(
                child: Text(
                  'Why "School Dynamics"?',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),

              // Why "School Dynamics"? List
              const WhyItem('User-Friendly Interface',
                  'We prioritize simplicity and ease of use, ensuring that all stakeholders, regardless of technical proficiency, can navigate the app effortlessly.'),
              const WhyItem('Data Security',
                  'Your data is of utmost importance to us. "School Dynamics" employs state-of-the-art security measures to protect sensitive information and ensure a safe digital environment.'),
              const WhyItem('Customizable Solutions',
                  'Recognizing that every school has unique needs, our app offers customizable features to adapt to the specific requirements of each educational institution.'),
              const SizedBox(height: 22),
              FxButton.outlined(
                backgroundColor: Colors.white,
                borderColor: Colors.white,
                borderRadius: BorderRadius.circular(4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                onPressed: () {
                  Utils.launchBrowser(AppConfig.TERMS);
                },
                child: FxText(
                  "Term of services",
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 22),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Widget for Feature Item
class FeatureItem extends StatelessWidget {
  final String title;
  final String description;

  const FeatureItem(this.title, this.description, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[300],
          ),
        ),
      ],
    );
  }
}

// Custom Widget for Why Item
class WhyItem extends StatelessWidget {
  final String title;
  final String description;

  const WhyItem(this.title, this.description, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Text(
          title,
          style: const TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[300],
          ),
        ),
      ],
    );
  }
}
