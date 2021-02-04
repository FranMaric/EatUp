import json

data = {}


def read():
    global data

    with open('lamut.json') as json_file:
        data = json.load(json_file)


def write():
    f = open('lamut.json', 'w')
    json.dump(data, f)
    f.close()


def add_meals():
    read()

    categoryName = input('\nMenu category name: ')
    image = input('Image: ')
    meals = []

    while True:
        name = input('\nMeal name: ')
        if name in ['n', 'N']:
            break
        elif name == '':
            continue

        price = float(input('Meal price[kn]: '))
        description = input('Meal description: ')
        if description == '':
            description = None
        quantity = input('Quantity: ')
        if quantity == '':
            quantity = None
        meals.append(
            {'name': name, 'price': price, 'description': description, 'quantity': quantity})

    data['menu'].append(
        {'name': categoryName, 'image': image, 'meals': meals})

    write()


add_meals()

input('GOTOVO')
