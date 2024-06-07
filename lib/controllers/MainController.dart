// ignore: file_names
// ignore: file_names
import 'package:get/get.dart';
import 'package:schooldynamics/models/MyClasses.dart';

import '../models/EnterpriseModel.dart';
import '../models/MySubjects.dart';
import '../models/UserModel.dart';

class MainController extends GetxController {
  var count = 0.obs;

  // ignore: non_constant_identifier_names
  RxList<dynamic> my_classes = <MyClasses>[].obs;
  RxList<dynamic> my_top_classes = <MyClasses>[].obs;
  RxList<dynamic> my_subjects = <MySubjects>[].obs;
  RxList<dynamic> my_students = <UserModel>[].obs;
  RxList<dynamic> my_top_students = <UserModel>[].obs;
  RxList<dynamic> my_top_subjects = <MySubjects>[].obs;

  EnterpriseModel ent = EnterpriseModel();

  init() async {
    await getEnt();
    await getMyClasses();
    await getMySubjects();
    await getMyStudents();
  }

  Future<void> getEnt() async {
    try {
      ent = await EnterpriseModel.getEnt();
    } catch (e) {

    }
  }

  getMyStudents() async {
    await fetchMyStudents();
    my_top_students.clear();
    my_students.shuffle();

    int i = 0;
    for (UserModel x in my_students) {
      i++;
      my_top_students.add(x);
      if (i > 4) {
        break;
      }
    }
    update();
  }

  RxList<dynamic> exams = <ExamAndSubjectModel>[].obs;

  getMySubjects() async {
    await fetchMySubjects();
    my_top_subjects.clear();
    exams.clear();
    my_subjects.shuffle();
    int i = 0;
    for (MySubjects x in my_subjects) {
      if (exams.length < 4) {
        for (var ex in x.exams) {
          if (ex.marks_pending > 0 && exams.length < 4) {
            exams.add(ex);
          }
        }
      }

      if (my_top_subjects.length < 5) {
        my_top_subjects.add(x);
      }
      i++;
    }
    update();
  }

  getMyClasses() async {
    await fetchMyClasses();
    my_top_classes.clear();
    my_classes.shuffle();
    int i = 0;
    for (MyClasses x in my_classes) {
      i++;
      my_top_classes.add(x);
      if (i > 2) {
        break;
      }
    }
    update();
  }

  fetchMyClasses() async {
    my_classes.clear();
    (await MyClasses.getItems()).forEach((element) {
      my_classes.add(element);
    });
  }

  fetchMySubjects() async {
    my_subjects.clear();
    (await MySubjects.getItems()).forEach((element) {
      my_subjects.add(element);
    });
  }

  fetchMyStudents() async {
    my_students.clear();
    (await UserModel.getItems()).forEach((element) {
      my_students.add(element);
    });
  }

  increment() => count++;

  decrement() => count--;
}
