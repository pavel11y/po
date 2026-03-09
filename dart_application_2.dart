void main() {
  List<String> students = [
    'Иванов', 'Петров', 'Сидоров', 'Смирнов', 'Кузнецов', 'Попов'
  ];
  
  List<String> subjects = [
    'Математика', 'Физика', 'Информатика', 'История', 'Литература'
  ];
  
  Map<String, Map<String, int>> grades = {
    'Иванов': {'Математика': 5, 'Физика': 4, 'Информатика': 5, 'История': 3, 'Литература': 4},
    'Петров': {'Математика': 3, 'Физика': 3, 'Информатика': 4, 'История': 3, 'Литература': 2},
    'Сидоров': {'Математика': 5, 'Физика': 5, 'Информатика': 5, 'История': 5, 'Литература': 5},
    'Смирнов': {'Математика': 4, 'Физика': 4, 'Информатика': 4, 'История': 4, 'Литература': 4},
    'Кузнецов': {'Математика': 5, 'Физика': 5, 'Информатика': 5, 'История': 4, 'Литература': 3},
    'Попов': {'Математика': 2, 'Физика': 3, 'Информатика': 3, 'История': 3, 'Литература': 3}
  };

  print('Разделение студентов по среднему баллу:');
  
  Map<String, List<String>> scores = {
    'Отличники (ср.балл ≥ 4.5)': [],
    'Хорошисты (3.5 ≤ ср.балл < 4.5)': [],
    'Остальные (ср.балл < 3.5)': []
  };

  Map<String, double> averageScores = {};

  for (var student in students) {
    var studentGrades = grades[student]!.values;
    double average = studentGrades.reduce((a, b) => a + b) / studentGrades.length;
    averageScores[student] = average;
    
    if (average >= 4.5) {
      scores['Отличники (ср.балл ≥ 4.5)']!.add(student);
    } 
    else if (average >= 3.5) {
      scores['Хорошисты (3.5 ≤ ср.балл < 4.5)']!.add(student);
    } 
    else {
      scores['Остальные (ср.балл < 3.5)']!.add(student);
    }
  }

  scores.forEach((category, studentsList) {
    print('  $category: ${studentsList.isEmpty ? 'нет' : studentsList.join(', ')}');
  });
  print('');

  print('Статистика оценок:');
  
  Map<int, int> gradeCount = {2: 0, 3: 0, 4: 0, 5: 0};
  
  for (var studentGrades in grades.values) {
    for (var grade in studentGrades.values) {
      gradeCount[grade] = gradeCount[grade]! + 1;
    }
  }
  
  gradeCount.forEach((grade, count) {
    print('  Оценка $grade: $count раз(а)');
  });
  print('');

  print('Студенты получившие 5 по предметам:');
  
  for (var subject in subjects) {
    List<String> excellentStudents = [];
    for (var student in students) {
      if (grades[student]![subject] == 5) {
        excellentStudents.add(student);
      }
    }
    print('  $subject: ${excellentStudents.isEmpty ? 'нет' : excellentStudents.join(', ')}');
  }
  print('');

  print('Предметы без двоек:');
  
  List<String> subjectsWithoutTwos = [];
  
  for (var subject in subjects) {
    bool hasTwo = false;
    for (var student in students) {
      if (grades[student]![subject] == 2) {
        hasTwo = true;
        break;
      }
    }
    if (!hasTwo) {
      subjectsWithoutTwos.add(subject);
    }
  }
  
  print('  ${subjectsWithoutTwos.isEmpty ? 'нет таких предметов' : subjectsWithoutTwos.join(', ')}');
  print('');

  print('Предметы с наибольшим количеством двоек:');
  
  Map<String, int> twosCount = {};
  int maxTwos = 0;
  List<String> subjectsWithMaxTwos = [];
  
  for (var subject in subjects) {
    int count = 0;
    for (var student in students) {
      if (grades[student]![subject] == 2) {
        count++;
      }
    }
    twosCount[subject] = count;
    
    if (count > maxTwos) {
      maxTwos = count;
      subjectsWithMaxTwos = [subject];
    } else if (count == maxTwos && count > 0) {
      subjectsWithMaxTwos.add(subject);
    }
  }
  
  if (maxTwos == 0) {
    print('  Двоек нет ни по одному предмету');
  } else {
    print('  ${subjectsWithMaxTwos.join(', ')} — $maxTwos двоек');
  }
  print('');

  print('Студенты с наибольшим количеством пятерок:');
  
  Map<String, int> fivesCount = {};
  int maxFives = 0;
  List<String> studentsWithMaxFives = [];
  
  for (var student in students) {
    int count = 0;
    for (var grade in grades[student]!.values) {
      if (grade == 5) count++;
    }
    fivesCount[student] = count;
    
    if (count > maxFives) {
      maxFives = count;
      studentsWithMaxFives = [student];
    } else if (count == maxFives && count > 0) {
      studentsWithMaxFives.add(student);
    }
  }
  
  if (maxFives == 0) {
    print('  Пятерок нет ни у одного студента');
  } else {
    print('  ${studentsWithMaxFives.join(', ')} — $maxFives пятерок');
  }
  print('');

  print('Студенты с предметами, где оценка ниже 4:');
  
  for (var student in students) {
    List<String> lowGrades = [];
    for (var entry in grades[student]!.entries) {
      if (entry.value < 4) {
        lowGrades.add('${entry.key} (${entry.value})');
      }
    }
    
    if (lowGrades.isNotEmpty) {
      print('  $student (${lowGrades.length} предмета): ${lowGrades.join(', ')}');
    } else {
      print('  $student: нет предметов с оценкой ниже 4');
    }
  }
  print('');

  print('Пары «студент — предмет», по которым стоит 5:');
  
  List<String> excellentPairs = [];
  for (var student in students) {
    for (var entry in grades[student]!.entries) {
      if (entry.value == 5) {
        excellentPairs.add('$student — ${entry.key}');
      }
    }
  }
  
  if (excellentPairs.isEmpty) {
    print('  Нет пар с оценкой 5');
  } else {
    for (var pair in excellentPairs) {
      print('  $pair');
    }
  }
}
