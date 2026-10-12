from sqlalchemy import create_engine, Column, Integer, String, ForeignKey, func
from sqlalchemy.orm import declarative_base, sessionmaker

engine = create_engine("sqlite:///library.db", echo=False)

print(engine)

Base = declarative_base()


class Author(Base):
    __tablename__ = "authors"

    id = Column(Integer, primary_key=True)
    name = Column(String(100), nullable=False)
    birth_year = Column(Integer, nullable=False)

    def __repr__(self):
        return f"<Author(id={self.id}, name='{self.name}', birth_year={self.birth_year})>"


class Book(Base):
    __tablename__ = "books"

    id = Column(Integer, primary_key=True)
    title = Column(String(200), nullable=False)
    year = Column(Integer, nullable=False)
    author_id = Column(Integer, ForeignKey("authors.id"), nullable=False)

    def __repr__(self):
        return f"<Book(id={self.id}, title='{self.title}', year={self.year}, author_id={self.author_id})>"


Base.metadata.create_all(engine)

Session = sessionmaker(bind=engine)
session = Session()

if session.query(Author).count() == 0:
    print("Добавление авторов")
    authors = [
        Author(name="Лев Толстой", birth_year=1828),
        Author(name="Фёдор Достоевский", birth_year=1821),
        Author(name="Антон Чехов", birth_year=1860)
    ]
    session.add_all(authors)
    session.commit()
    print(f"Добавлены авторы: {authors}")

    print("Добавление книг")
    books = [
        Book(title="Война и мир", year=1869, author_id=authors[0].id),
        Book(title="Анна Каренина", year=1877, author_id=authors[0].id),
        Book(title="Преступление и наказание", year=1866, author_id=authors[1].id),
        Book(title="Идиот", year=1869, author_id=authors[1].id),
        Book(title="Вишнёвый сад", year=1904, author_id=authors[2].id),
    ]

    session.add_all(books)
    session.commit()
    print(f"Добавлено книг: {len(books)}")
    for book in books:
        print(f"  {book}")
else:
    print("Данные уже существуют в таблицах, пропускаем добавление.")

print("\nИмена всех авторов")
authors = session.query(Author).all()
for author in authors:
    print(f"  {author.name}")

print("\nИзменение имени автора")
author_to_update = session.query(Author).filter_by(name="Антон Чехов").first()
if author_to_update:
    old_name = author_to_update.name
    author_to_update.name = "Антон Павлович Чехов"
    session.commit()
    print(f"Имя изменено: '{old_name}' -> '{author_to_update.name}'")
else:
    print("Автор не найден")

print("\nУдаление книги")
book_to_delete = session.query(Book).filter_by(title="Идиот").first()
if book_to_delete:
    session.delete(book_to_delete)
    session.commit()
    print(f"Удалена книга: {book_to_delete.title}")
else:
    print("Книга не найдена")

print("\nВсе книги (от новых к старым)")
books_sorted_by_year = session.query(Book).order_by(Book.year.desc()).all()
if books_sorted_by_year:
    for book in books_sorted_by_year:
        print(f"  {book.title} - {book.year} г")
else:
    print("Книг не найдено")

print("\nКниги, изданные после 1850 года")
books_after_1850 = session.query(Book).filter(Book.year > 1850).all()
if books_after_1850:
    for book in books_after_1850:
        print(f"  {book.title} — {book.year} г.")
else:
    print("Книг, изданных после 1850 года, не найдено")

print("\nПоиск автора по имени 'Лев Толстой'")
specific_author = session.query(Author).filter_by(name="Лев Толстой").first()
if specific_author:
    print(f"Найден: {specific_author}")
    his_books = session.query(Book).filter_by(author_id=specific_author.id).all()
    if his_books:
        print("Его книги:")
        for b in his_books:
            print(f"  - {b.title} ({b.year})")
else:
    print("Автор не найден")

print("\nКоличество книг в библиотеке")
book_count = session.query(func.count(Book.id)).scalar()
print(f"  Всего книг: {book_count}")

print("\nКоличество книг по авторам:")
result = session.query(Author.name, func.count(Book.id)).join(Book, Author.id == Book.author_id).group_by(Author.id).all()  # ИСПРАВЛЕНО: убраны лишние {}
for author_name, count in result:
    print(f"  {author_name}: {count} книг(и)")

print("\nПервые 3 книги в алфавитном порядке")
first_three_books = session.query(Book).order_by(Book.title.asc()).limit(3).all()
if first_three_books:
    for idx, book in enumerate(first_three_books, 1):
        print(f"  {idx}. {book.title} ({book.year})")
else:
    print("Книг не найдено")

session.close()
print("\nРабота завершена.")