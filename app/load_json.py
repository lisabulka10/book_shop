import json
from app.database import session_scope
from app.models.book import Section, Genre, Book, Author
from app.schemas.book import SectionPydantic, GenrePydantic, BookPydanticDB, AuthorPydantic
from app.schemas.address import AddressPydantic, ShopPydanticCreate
from app.models.address import Address, Shop
from pydantic import ValidationError


def load_data_section():
    try:
        with open('./app/data/sections.json', 'r', encoding='utf-8') as file:
            data = json.load(file)
            print(data)

        if not isinstance(data, list):
            raise ValueError('Файл должен содержать список объектов')

        inserted = 0
        with session_scope() as session:
            for item in data:
                try:
                    section_data = SectionPydantic(**item)
                    section = Section(**section_data.model_dump())
                    session.add(section)
                    inserted += 1
                    print('Данные добавлены')
                except ValidationError as e:
                    print(f'Ошибка валидации: {e.errors()} | Данные: {item}')
                except Exception as e:
                    print(f'Ошибка добавления в БД: {e} | Данные: {item}')

    except ValueError or FileNotFoundError as e:
        print('Ошибка открытия файла. Проверьте файл и путь к нему.', e)


def load_data(DbModel, PydanticModel, file_name):
    try:
        with open('./app/data/' + file_name, 'r', encoding='utf-8') as file:
            data = json.load(file)
            print(data)

        if not isinstance(data, list):
            raise ValueError('Файл должен содержать список объектов')

        inserted = 0
        with session_scope() as session:
            for item in data:
                try:
                    model_data = PydanticModel(**item)
                    model = DbModel(**model_data.model_dump())
                    session.add(model)
                    inserted += 1
                    print('Данные добавлены')
                except ValidationError as e:
                    print(f'Ошибка валидации: {e.errors()} | Данные: {item}')
                except Exception as e:
                    print(f'Ошибка добавления в БД: {e} | Данные: {item}')

    except ValueError or FileNotFoundError as e:
        print('Ошибка открытия файла. Проверьте файл и путь к нему.', e)

#python -m app.load_json
#load_data(Author, AuthorPydantic, 'author.json')
#load_data(Book, BookPydanticDB, 'book.json')
#load_data(Address, AddressPydantic, 'shop_addresses.json')
#load_data(Shop, ShopPydanticCreate, 'shops.json')

