void main() {
  List<String> students = ['Иванов', 'Петров', 'Сидоров', 'Смирнов', 'Кузнецов', 'Попов'];
  List<String> subjects = ['Математика', 'Физика', 'Информатика', 'История', 'Литература'];
  
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

  for (var student in students) {
    var g = grades[student]!.values;
    double avg = g.reduce((a, b) => a + b) / g.length;
    
    if (avg >= 4.5) {
      scores['Отличники (ср.балл ≥ 4.5)']!.add(student);
    }
    else if (avg >= 3.5) {
      scores['Хорошисты (3.5 ≤ ср.балл < 4.5)']!.add(student);
    }
    else {
      scores['Остальные (ср.балл < 3.5)']!.add(student);
    }
  }

  scores.forEach((cat, list) {
    print('  $cat: ${list.isEmpty ? 'нет' : list.join(', ')}');
  });
  print('');

  print('Статистика оценок:');
  
  Map<int, int> gradeCount = {};
  
  for (var g in grades.values) {
    for (var grade in g.values) {
      gradeCount[grade] = (gradeCount[grade] ?? 0) + 1;
    }
  }
  
  for (var grade in gradeCount.keys) {
    print('  Оценка $grade: ${gradeCount[grade]} раз(а)');
  }
  print('');

  print('Студенты получившие 5 по предметам:');
  
  for (var sub in subjects) {
    List<String> excellent = [];
    
    for (var s in students) {
      if (grades[s]![sub] == 5) {
        excellent.add(s);
      }
    }
    print('  $sub: ${excellent.isEmpty ? 'нет' : excellent.join(', ')}');
  }
  print('');

  print('Предметы без двоек:');
  
  List<String> noTwos = [];
  
  for (var sub in subjects) {
    bool hasTwo = false;
    
    for (var s in students) {
      if (grades[s]![sub] == 2) {
        hasTwo = true;
      }
    }
    if (!hasTwo) {
      noTwos.add(sub);
    }
  }
  print('  ${noTwos.isEmpty ? 'нет таких предметов' : noTwos.join(', ')}');
  print('');

  print('Предметы с наибольшим количеством двоек:');
  
  Map<String, int> twoCount = {};
  int maxTwos = 0;
  List<String> worst = [];
  
  for (var sub in subjects) {
    int count = 0;
    
    for (var s in students) {
      if (grades[s]![sub] == 2) {
        count++;
      }
    }
    twoCount[sub] = count;
    
    if (count > maxTwos) {
      maxTwos = count;
      worst = [sub];
    }
    else if (count == maxTwos && count > 0) {
      worst.add(sub);
    }
  }
  
  if (maxTwos == 0) {
    print('  Двоек нет ни по одному предмету');
  }
  else {
    print('  ${worst.join(', ')} — $maxTwos двоек');
  }
  print('');

  print('Студенты с наибольшим количеством пятерок:');
  
  Map<String, int> fiveCount = {};
  int maxFives = 0;
  List<String> best = [];
  
  for (var s in students) {
    int count = 0;
    
    for (var g in grades[s]!.values) {
      if (g == 5) {
        count++;
      }
    }
    fiveCount[s] = count;
    
    if (count > maxFives) {
      maxFives = count;
      best = [s];
    }
    else if (count == maxFives && count > 0) {
      best.add(s);
    }
  }
  
  if (maxFives == 0) {
    print('  Пятерок нет ни у одного студента');
  }
  else {
    print('  ${best.join(', ')} — $maxFives пятерок');
  }
  print('');

  print('Студенты с предметами, где оценка ниже 4:');
  
  for (var s in students) {
    List<String> low = [];
    
    for (var entry in grades[s]!.entries) {
      if (entry.value < 4) {
        low.add('${entry.key} (${entry.value})');
      }
    }
    if (low.isEmpty) {
      print('  $s: нет предметов с оценкой ниже 4');
    }
    else {
      print('  $s (${low.length} предмета): ${low.join(', ')}');
    }
  }
  print('');

  print('Пары «студент — предмет», по которым стоит 5:');
  
  List<String> pairs = [];
  
  for (var s in students) {
    for (var entry in grades[s]!.entries) {
      if (entry.value == 5) {
        pairs.add('$s — ${entry.key}');
      }
    }
  }
}
