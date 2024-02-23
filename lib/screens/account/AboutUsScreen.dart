import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:schooldynamics/theme/app_theme.dart';

import '../../utils/AppConfig.dart';
import '../../utils/Utils.dart';
import '../../utils/my_colors.dart';
import '../../utils/my_text.dart';

class AboutUsScreen extends StatefulWidget {
  AboutUsScreen({super.key});

  @override
  AboutUsScreenState createState() => new AboutUsScreenState();
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
              Text("${AppConfig.APP_NAME} App",
                  style: MyText.display1(context)!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w300)),
              Container(height: 5),
              Container(width: 120, height: 3, color: Colors.white),
              Container(height: 15),
              Text("Version",
                  style:
                      MyText.body1(context)!.copyWith(color: MyColors.grey_20)),
              Text("2.1.0",
                  style: MyText.body1(context)!.copyWith(color: Colors.white)),
              Container(height: 15),
              Text("Last Update",
                  style:
                      MyText.body1(context)!.copyWith(color: MyColors.grey_20)),
              Text("February 2023",
                  style: MyText.body1(context)!.copyWith(color: Colors.white)),

              FeatureItem('Attendance Tracking',
                  'Say goodbye to manual attendance records. "School Dynamics" simplifies the process by allowing teachers to effortlessly mark and track student attendance with just a few taps.'),
              FeatureItem('Assignment Management',
                  'Streamline the assignment workflow with our intuitive assignment management system. Teachers can assign tasks, set deadlines, and track student progress, fostering a more organized and productive learning environment.'),
              FeatureItem('Communication Hub',
                  'Enhance communication between schools, teachers, and parents through our dedicated communication hub. Receive real-time updates, announcements, and notifications, ensuring everyone stays informed and engaged.'),
              FeatureItem('Gradebook',
                  'Keep track of student performance with our robust gradebook feature. Teachers can efficiently input and manage grades, while parents can monitor their child\'s progress and academic achievements.'),
              FeatureItem('Event Calendar',
                  'Never miss an important event again. "School Dynamics" features a centralized event calendar that keeps everyone informed about upcoming school events, examinations, and extracurricular activities.'),
              FeatureItem('Secure Messaging',
                  'Ensure secure and direct communication between teachers, students, and parents through our encrypted messaging system, promoting a collaborative and supportive educational ecosystem.'),
              FeatureItem('Timetable Management',
                  'Simplify scheduling with our timetable management tool. Easily create and manage class schedules, reducing confusion and ensuring a smooth flow of daily activities.'),
              SizedBox(height: 36),
              Center(
                child: Text(
                  'Why "School Dynamics"?',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),

              // Why "School Dynamics"? List
              WhyItem('User-Friendly Interface',
                  'We prioritize simplicity and ease of use, ensuring that all stakeholders, regardless of technical proficiency, can navigate the app effortlessly.'),
              WhyItem('Data Security',
                  'Your data is of utmost importance to us. "School Dynamics" employs state-of-the-art security measures to protect sensitive information and ensure a safe digital environment.'),
              WhyItem('Customizable Solutions',
                  'Recognizing that every school has unique needs, our app offers customizable features to adapt to the specific requirements of each educational institution.'),
              SizedBox(height: 22),
              FxButton.outlined(
                backgroundColor: Colors.white,
                borderColor: Colors.white,
                borderRadius: BorderRadius.circular(4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                onPressed: () {
                  Utils.launchBrowser(AppConfig.TERMS);
                },
                child: Text("Term of services",
                    style:
                        MyText.body1(context)!.copyWith(color: Colors.white)),
              ),
              SizedBox(height: 22),
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

  FeatureItem(this.title, this.description);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15),
        Text(
          title,
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
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

  WhyItem(this.title, this.description);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15),
        Text(
          title,
          style: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
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
