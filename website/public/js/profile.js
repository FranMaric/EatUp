function print(a) { //PYTHON is the best <3
    console.log(a);
}

const auth = firebase.auth();

var menu = [];
var menuHasChanged = false;

var userData = {};

var chosenArea;
var areas;

auth.onAuthStateChanged(() => {
    if (auth.currentUser != null) {
        console.log('You are logged in!!!');

        getAndSetProfileImage();

        firebase.firestore().collection('restaurants').doc(auth.currentUser.uid).get().then(function(doc) {
            if (!doc.exists) {
                console.log("Document doesn't exists!");
                window.location.href = '/';
                return;
            }
            setDataToDOM(doc.data());

            document.querySelectorAll('.loader').forEach((a) => a.remove());
        });
    } else {
        console.log('You are NOT logged in!');
        window.location.href = '/';
    }
});

function getAndSetProfileImage() {
    var path = firebase.storage().ref(auth.currentUser.uid + '/profile.jpg');

    path.getDownloadURL().then(function(url) {
        var img = document.getElementById('profile-img');
        img.src = url;
        img.classList.remove('hide');

        document.getElementById('add-img').classList.add('hide');
    });
}

function setDataToDOM(data) {
    userData = data;
    menu = data['menu'] ? data['menu'] : [];

    document.getElementById('description').innerText = data['description'];
    document.getElementById('name').innerText = data['name'];
    document.getElementById('area').innerText = 'Područje: ' + data['area'];

    for (var categoryNum = 0; categoryNum < data['menu'].length; categoryNum++) {
        const meals = data['menu'][categoryNum]['meals'];
        document.getElementById('menu').insertAdjacentHTML('beforeend', categoryTemplate(data['menu'][categoryNum], categoryNum));

        for (var mealNum = 0; mealNum < meals.length; mealNum++) {
            document.getElementById('meals-' + categoryNum).insertAdjacentHTML('beforeend', mealTemplate(meals[mealNum], mealNum, categoryNum));
        }
    }


}

function newArea(area) {
    chosenArea = area;
    document.getElementById('dropdownmenu').innerText = 'Područje: ' + area;
}

function showUserDataEntry() {
    getAreas();
    chosenArea = null;

    document.getElementById('description-entry').value = userData['description'];
    document.getElementById('name-entry').value = userData['name'];
    document.getElementById('dropdownmenu').innerText = 'Područje: ' + userData['area'];

    document.getElementById('change-user-data').classList.remove('hide');
}

function saveUserDataEntry() {
    var name = document.getElementById('name-entry').value;
    var description = document.getElementById('description-entry').value;

    if (chosenArea === null) {
        var changes = {
            'name': name,
            'description': description
        };
    } else {
        var changes = {
            'area': chosenArea,
            'name': name,
            'description': description
        };
    }


    firebase.firestore().collection('restaurants').doc(auth.currentUser.uid).update(changes).then(() => {
        document.getElementById('change-user-data').classList.add('hide');
        document.getElementById('name').innerText = name;
        document.getElementById('description').innerText = description;

        userData['name'] = name;
        userData['description'] = description;

        if (chosenArea != null) {
            userData['area'] = chosenArea;
            document.getElementById('area').innerText = 'Područje: ' + chosenArea;
        }
    });
}

function getAreas() {
    if (areas === null || areas === [] || areas === undefined)
        firebase.firestore().collection('areas').doc('areas').get().then(function(doc) {
            areas = doc.data()['list'];

            areas.forEach((area) => {
                document.getElementById('dropdownmenu-list').insertAdjacentHTML('beforeend',
                    `<a class="dropdown-item" onclick="newArea('${area}');" style="cursor: pointer;">${area}</a>`);
            });
        });
}


window.onbeforeunload = function() {
    beforeClose();
};

function beforeClose() {
    print('He is trying to leave!');
    saveMenu();
}

window.onload = function() {
    document.getElementById('fileButton').addEventListener('change', function(e) {
        var file = e.target.files[0];

        var storageRef = firebase.storage().ref().child(auth.currentUser.uid + '/profile.jpg');

        storageRef.put(file).then(() => getAndSetProfileImage());

    });
};

function newImage() {
    document.getElementById('fileButton').click();
}


function saveMenu() {
    if (menuHasChanged) {
        firebase.firestore().collection('restaurants').doc(auth.currentUser.uid).update({ 'menu': menu }).then(() => {
            menuHasChanged = false;
            document.getElementById('changed').classList.add("hide");
        });
    }

}

function menuChanged() {
    if (menuHasChanged === false) {
        menuHasChanged = true;
        document.getElementById('changed').classList.remove("hide");
    }
}

//ONINPUT action

function input(args, value) {
    args = args.split(" ");
    var attribute = args[0];
    var categoryIndex = args[1];

    if (args.length == 2) {
        menu[categoryIndex]['name'] = value;
    } else if (attribute === 'price') {
        value = parseFloat(value);
        var mealIndex = args[2];
        menu[categoryIndex]['meals'][mealIndex][attribute] = value;
    } else {
        var mealIndex = args[2];
        menu[categoryIndex]['meals'][mealIndex][attribute] = value;
    }
    menuChanged();
}

//BUTTON actions

function addCategory() {
    var category = {
        'name': '',
        'meals': [],
        'image': ''
    };
    menu.push(category);
    document.getElementById('menu').insertAdjacentHTML('beforeend', categoryTemplate(category, menu.length - 1));
    addMeal(menu.length - 1);
    menuChanged();
}

function addMeal(index) {
    var meal = {
        'name': '',
        'description': '',
        'price': 0
    };
    menu[index]['meals'].push(meal);
    document.getElementById('meals-' + index).insertAdjacentHTML('beforeend', mealTemplate(meal, null, index));
    menuChanged();
}

function deleteMeal(categoryIndex, mealIndex) {
    if (!confirm(`Jeste li sigurni da želite obrisati ${menu[categoryIndex]['meals'][mealIndex]['name']}?`)) return;

    document.getElementById(`${categoryIndex} ${mealIndex}`).remove();
    menu[categoryIndex]['meals'].splice(mealIndex, 1); //Ova jedinica je tu jer ono javascript wtf
    menuChanged();
}

function deleteCategory(categoryIndex) {
    if (!confirm(`Jeste li sigurni da želite obrisati kategoriju ${menu[categoryIndex]['name']}?`)) return;

    document.getElementById(`category-${categoryIndex}`).remove();
    menu.splice(categoryIndex, 1);
    menuChanged();
}



//TEMPLATES

function mealTemplate(meal, mealNum, categoryNum) {
    const name = meal['name'] ? meal['name'] : '';
    const description = meal['description'] ? meal['description'] : '';
    const price = meal['price'] ? meal['price'] : 0;

    if (menu[categoryNum]['meals'].length === 0) {
        mealNum = 0;
    } else if (mealNum === null) {
        mealNum = menu[categoryNum]['meals'].length - 1;
    }

    if (categoryNum === null || categoryNum === undefined) {
        console.log('DEFINE categoryNum!!!');
    }

    return `<div class="meal" id="${categoryNum} ${mealNum}">
    <div class="my-row row">
        <div style="flex: 1; margin-right:5px; margin-bottom: 5px;">
            <input oninput="input('name ${categoryNum} ${mealNum}', this.value);" class="form-control" placeholder="Ime jela" value="${name}">
        </div>
        <div style="width: 20%;">
            <input oninput="validity.valid||(value=''); input('price ${categoryNum} ${mealNum}', this.value);" class="form-control" placeholder="Cijena" size="5" type="number" min="0" style="text-align: right;" value="${price}">
        </div>
        <label style="font-weight: 500;margin: auto; margin-left: 3px;">KN</label>
    </div>
    <div class="row" style="display: flex;">
        <div style="flex: 1;">
            <input oninput="input('description ${categoryNum} ${mealNum}', this.value);" class="form-control" placeholder="Opis jela" value="${description}">
        </div>
        <div style="width: 10px;"></div>
        <button class="btn btn-secondary" style="margin: auto;" onclick="deleteMeal(${categoryNum},${mealNum});">Obriši jelo</button>
    </div>

    </div>`;
}

function categoryTemplate(category, categoryNum) {
    const name = category['name'] ? category['name'] : '';
    if (menu.length == 0) {
        categoryNum = 0;
    } else if (categoryNum === null) {
        categoryNum = menu.length - 1;
    }

    return `<div class="card card-body meal-category" id="category-${categoryNum}">
    <div class="row" style="display: flex; margin: 0px 5px;">
        <div style="flex: 1;">
            <input oninput="input('name ${categoryNum}', this.value);" class="form-control meal-category-name font-weight-bold" placeholder="Kategorija jela" value="${name}">
        </div>
        <div style="width: 10px;"></div>
        <button class="btn btn-secondary" style="margin: auto;" onclick="deleteCategory(${categoryNum})">Obriši kategoriju</button>
    </div>
    <div id="meals-${categoryNum}"></div>
    <button class="btn btn-primary btn-block" onclick="addMeal(${categoryNum});">Dodaj jelo</button>
    </div>`;
}