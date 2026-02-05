import json
from abc import ABC, abstractmethod

class SystemUser(ABC):
    def __init__(self, name, role):
        self._name = name
        self._role = role
    
    @abstractmethod
    def get_menu_options(self):
        pass
    
    def get_name(self):
        return self._name
    
    def get_role(self):
        return self._role

class User(SystemUser):
    def __init__(self, name, borrowed_books=None):
        super().__init__(name, "user")
        self._borrowed_books = []
        if borrowed_books is not None:
            self._borrowed_books.extend(borrowed_books)
    
    def borrow_book(self, book_title):
        self._borrowed_books.append(book_title)
    
    def return_book(self, book_title):
        if book_title in self._borrowed_books:
            self._borrowed_books.remove(book_title)
            return True
        return False
    
    def get_borrowed_books(self):
        return list(self._borrowed_books)
    
    def get_menu_options(self):
        return [
            "Просмотреть доступные книги",
            "Взять книгу", 
            "Вернуть книгу",
            "Просмотреть список взятых книг",
            "Выйти"
        ]

class Librarian(SystemUser):
    def __init__(self, name):
        super().__init__(name, "librarian")
    
    def get_menu_options(self):
        return [
            "Добавить новую книгу",
            "Удалить книгу из системы",
            "Зарегистрировать нового пользователя",
            "Просмотреть список всех пользователей",
            "Просмотреть список всех книг",
            "Выйти"
        ]

class Book:
    def __init__(self, title, author, is_available=True):
        self._title = title
        self._author = author
        self._is_available = is_available
    
    def get_title(self):
        return self._title
    
    def get_author(self):
        return self._author
    
    def get_is_available(self):
        return self._is_available
    
    def set_is_available(self, value):
        self._is_available = value
    
    def __str__(self):
        return f"'{self._title}' - {self._author} [{'Доступна' if self._is_available else 'Выдана'}]"

class Library:
    def __init__(self):
        self._books = []
        self._users = []
        self._current_user = None
        self._load_data()
    
    def add_book(self, title, author):
        book = Book(title, author)
        self._books.append(book)
        print(f"Книга '{title}' добавлена.")
    
    def remove_book(self, title):
        for book in self._books:
            if book.get_title().lower() == title.lower():
                self._books.remove(book)
                for user in self._users:
                    if title in user.get_borrowed_books():
                        user.return_book(title)
                print(f"Книга '{title}' удалена.")
                return True
        print(f"Книга '{title}' не найдена.")
        return False
    
    def register_user(self, name):
        if not any(user.get_name() == name for user in self._users):
            user = User(name)
            self._users.append(user)
            print(f"Пользователь '{name}' зарегистрирован.")
            return user
        print(f"Пользователь '{name}' уже существует.")
        return None
    
    def get_available_books(self):
        return [book for book in self._books if book.get_is_available()]
    
    def get_all_books(self):
        return list(self._books)
    
    def get_all_users(self):
        return list(self._users)
    
    def find_book(self, title):
        for book in self._books:
            if book.get_title().lower() == title.lower():
                return book
        return None
    
    def find_user(self, name):
        for user in self._users:
            if user.get_name().lower() == name.lower():
                return user
        return None
    
    def borrow_book_for_user(self, user_name, book_title):
        user = self.find_user(user_name)
        book = self.find_book(book_title)
        
        if not user:
            print(f"Пользователь '{user_name}' не найден.")
            return False
        
        if not book:
            print(f"Книга '{book_title}' не найдена.")
            return False
        
        if not book.get_is_available():
            print(f"Книга '{book_title}' уже выдана.")
            return False
        
        book.set_is_available(False)
        user.borrow_book(book_title)
        print(f"Книга '{book_title}' выдана пользователю {user_name}.")
        return True
    
    def return_book_from_user(self, user_name, book_title):
        user = self.find_user(user_name)
        book = self.find_book(book_title)
        
        if not user:
            print(f"Пользователь '{user_name}' не найден.")
            return False
        
        if not book:
            print(f"Книга '{book_title}' не найдена.")
            return False
        
        if user.return_book(book_title):
            book.set_is_available(True)
            print(f"Книга '{book_title}' возвращена.")
            return True
        print(f"У пользователя {user_name} нет книги '{book_title}'.")
        return False
    
    def login(self, name, role):
        if role == "librarian":
            self._current_user = Librarian(name)
            return True
        user = self.find_user(name)
        if user:
            self._current_user = user
            return True
        return False
    
    def logout(self):
        if self._current_user:
            print(f"{self._current_user.get_name()} вышел из системы.")
        self._current_user = None
    
    def get_current_user(self):
        return self._current_user
    
    def _load_data(self):
        try:
            with open("books.txt", "r", encoding="utf-8") as f:
                books_data = json.load(f)
                for book_data in books_data:
                    book = Book(book_data["title"], book_data["author"], book_data["is_available"])
                    self._books.append(book)
        except:
            pass  
        
        try:
            with open("users.txt", "r", encoding="utf-8") as f:
                users_data = json.load(f)
                for user_data in users_data:
                    user = User(user_data["name"], user_data["borrowed_books"])
                    self._users.append(user)
        except:
            pass  
    
    def _save_data(self):
        try:
            books_data = []
            for book in self._books:
                books_data.append({
                    "title": book.get_title(),
                    "author": book.get_author(),
                    "is_available": book.get_is_available()
                })
            with open("books.txt", "w", encoding="utf-8") as f:
                json.dump(books_data, f, ensure_ascii=False, indent=2)
            
            users_data = []
            for user in self._users:
                users_data.append({
                    "name": user.get_name(),
                    "borrowed_books": user.get_borrowed_books()
                })
            with open("users.txt", "w", encoding="utf-8") as f:
                json.dump(users_data, f, ensure_ascii=False, indent=2)
        except:
            print("Ошибка сохранения.")
            
library = Library()

while True:
    print("1. Библиотекарь")
    print("2. Пользователь")
    print("3. Выход")
    
    choice = input("Выберите роль: ").strip()
    
    if choice == "1":
        name = input("Имя библиотекаря: ").strip()
        if library.login(name, "librarian"):
            # Меню библиотекаря
            while True:
                print(f"Бибилиотекарь: {name}")
                for i, option in enumerate(library.get_current_user().get_menu_options(), 1):
                    print(f"{i}. {option}")
                
                action = input("Выберите действие: ").strip()
                
                if action == "1":
                    title = input("Название книги: ").strip()
                    author = input("Автор: ").strip()
                    if title and author:
                        library.add_book(title, author)
                
                elif action == "2":
                    title = input("Название книги для удаления: ").strip()
                    if title:
                        library.remove_book(title)
                
                elif action == "3":
                    name_user = input("Имя нового пользователя: ").strip()
                    if name_user:
                        library.register_user(name_user)
                
                elif action == "4":
                    users = library.get_all_users()
                    if users:
                        print("\nСписок пользователей:")
                        for user in users:
                            books = user.get_borrowed_books()
                            print(f"- {user.get_name()} (книг: {len(books)})")
                    else:
                        print("Нет пользователей.")
                
                elif action == "5":
                    books = library.get_all_books()
                    if books:
                        print("\nСписок книг:")
                        for book in books:
                            print(f"- {book}")
                    else:
                        print("Нет книг.")
                
                elif action == "6":
                    library.logout()
                    break
                
                else:
                    print("Неверный выбор.")
        else:
            print("Ошибка входа.")
    
    elif choice == "2":
        name = input("Имя пользователя: ").strip()
        if library.login(name, "user"):
            while True:
                print(f"ПОЛЬЗОВАТЕЛЬ: {name}")
                for i, option in enumerate(library.get_current_user().get_menu_options(), 1):
                    print(f"{i}. {option}")
                
                action = input("Выберите действие: ").strip()
                
                if action == "1":
                    books = library.get_available_books()
                    if books:
                        print("Доступные книги:")
                        for book in books:
                            print(f"- '{book.get_title()}' - {book.get_author()}")
                    else:
                        print("Нет доступных книг.")
                
                elif action == "2":
                    title = input("Название книги для взятия: ").strip()
                    if title:
                        library.borrow_book_for_user(name, title)
                
                elif action == "3":
                    title = input("Название книги для возврата: ").strip()
                    if title:
                        library.return_book_from_user(name, title)
                
                elif action == "4":
                    user = library.get_current_user()
                    books = user.get_borrowed_books()
                    if books:
                        print("\nВаши книги:")
                        for book_title in books:
                            print(f"- {book_title}")
                    else:
                        print("У вас нет книг.")
                
                elif action == "5":
                    library.logout()
                    break
                
                else:
                    print("Неверный выбор.")
        else:
            print("Пользователь не найден.")
    
    elif choice == "3":
        library._save_data()
        print("Выход из системы.")
        break
    
    else:
        print("Неверный выбор.")