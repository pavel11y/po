a = int(input('введите число А: '))
b = int(input('введите число Б: '))
des = input('если хотите посчитать, введите действие из списка +, -, *, /, **, //, %: ')
dess = ['+', '-', '*', '/', '**', '//', '%']

if des in dess:
    if des == '+': 
        print(a + b)
    elif des == '-': 
        print(a - b)
    elif des == '*': 
        print(a * b)
    elif des == '/': 
        if b <= 0:
            print('иди учи курс школьной математики, на 0 делить нельзя')
        else:
            print(a/b)
    elif des == '**': print(a ** b)
    elif des == '//': 
        if b <= 0:
            print('иди учи курс школьной математики, на 0 делить нельзя')
        else:
            print(a//b)
    elif des == '%': 
        if b <= 0:
            print('иди учи курс школьной математики, на 0 делить нельзя')
        else:
            print(a%b)
else: print('ты слаб в программировании')

des2 = input('если хотите сравнить числа, введите действие из списка >, <, <=, >=, ==, !=: ')
dess2 = ['>', '<', '<=', '>=', '==', '!=']

if des2 in dess2:
    if des2 == '>':
        if a>b:
            print(a>b)
        else:
            print('error')
    elif des2 == '<':
        if a<b:
            print(a<b)
        else:
            print('error')
    elif des2 == '>=':
        if a>=b:
            print(a>=b)
        else:
            print('error')
    elif des2 == '<=':
        if a<=b:
            print(a<=b)
        else:
            print('error')
    elif des2 == '==':
        if a==b:
            print(a==b)
        else:
            print('error')
    elif des2 == '!=':
        if a!=b:
            print(a!=b)
        else:
            print('error')
else:
    print('иди учи python')

log_des = input('если хотите использовать логические операторы выберете из списка and,or,not: ')
log_dess = ['and', 'or', 'not']
if log_des in log_dess:
    if log_des == 'and':
        result = a and b
        print(f'{a} and {b} = {result}')
    elif log_des == 'or':
        result = a or b
        print(f'{a} or {b} = {result}')
    elif log_des == 'not':
        print(f'not {a} = {not a}')
        print(f'not {b} = {not b}')

spisok_chisel= input('введите список чисел через пробел для проверки принадлежности: ')
if spisok_chisel:
    spisok = list(map(int, spisok_chisel.split()))
    in_des = input('если хотите проверить принадлежность числа списк, введите один вариант из списка in, not in: ')
    in_dess = ['in', 'not in']
    if in_des in in_dess:
        if in_des == 'in':
            num = int(input('введите число для проверки: '))
            print(f'{num} in {spisok} = {num in spisok}')
        elif in_des == 'not in':
            num = int(input('введите число для проверки: '))
            print(f'{num} not in {spisok} = {num not in spisok}')
    else:
        print('прочитай условия заново')

is_des = input('проверить тождественность? (is/is not): ')
is_dess = ['is', 'is not']
if is_des in is_dess: 
    if is_des == 'is':
        print(f'a is b = {a is b}')
    elif is_des == 'is not':
        print(f'a is not b = {a is not b}')