import json
import csv
# задача 1

# dannye = {
#     "Название страны": "франция",
#     "Столица": "Париж",
#     "Население": "670тыс человек"
# }

# with open('country.json', 'w', encoding='utf-8') as file:
#     json.dump(dannye, file, ensure_ascii=False, indent=4)
    

# with open('country.json', 'r', encoding='utf-8') as file:
#     yazik = json.load(file)

# yazik["Язык"] = "Французский"

# with open('country.json', 'w', encoding='utf-8') as file:
#     json.dump(yazik, file, ensure_ascii=False, indent=4)

#задача 2

dannyes = {
    "Имя": "Павел",
    "Возраст": 18,
    "Город": "Москва"
}

with open('test_json.json', 'w', encoding='utf-8') as file:
    json.dump(dannyes, file, ensure_ascii=False, indent=4)

with open('test_json.json', 'r', encoding='utf-8') as file:
    stroka = json.load(file)

csv_file = 'employees_with_salary.csv'
headers = ["Имя", "Возраст", "Город", "Должность", "Зарплата"]
new_row = {
    "Имя": stroka["Имя"],
    "Возраст": stroka["Возраст"],
    "Город": stroka["Город"],
    "Должность": "Стажёр",
    "Зарплата": 50000
}

try:
    with open(csv_file, 'r', encoding='utf-8') as file:
        # Если файл существует, просто добавляем строку
        write_header = False
except FileNotFoundError:
    # Если файла нет — нужно записать заголовок
    write_header = True

mode = 'a' if not write_header else 'w'

with open(csv_file, mode, encoding='utf-8', newline='') as file:
    writer = csv.DictWriter(file, fieldnames=headers)
    if write_header:
        writer.writeheader()
    writer.writerow(new_row)
