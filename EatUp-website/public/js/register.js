const auth = firebase.auth();

getAreas();
var areaIsChosen = false;
var data = {};

var animatedElements = ['dropdownmenu', 'password1', 'password2', 'name', 'description'];

window.onload = function() {
    animatedElements.forEach((animated) => {
        document.getElementById(animated).addEventListener("animationend", () => {
            document.getElementById(animated).classList.remove("apply-shake");
        });
    });
}

function login() {


    var email = document.getElementById('email').value;
    var password1 = document.getElementById('password1').value;
    var password2 = document.getElementById('password2').value;

    var area = document.getElementById('dropdownmenu').innerText;

    document.getElementById('under-passwords').classList.add('hide');

    if (password1 === null) {} //fix me
    if (password2 === null) {
        document.getElementById('password1').classList.add("apply-shake");
        document.getElementById('password2').classList.add("apply-shake");
        return;
    }

    if (password1.length < 8) {
        var note = document.getElementById('under-passwords');
        note.innerText = 'Lozinka mora biti dulja od osam znakova!';
        note.classList.remove('hide');
        document.getElementById('password1').classList.add("apply-shake");

        return;
    }

    if (password1 != password2) {
        var note = document.getElementById('under-passwords');
        note.innerText = 'Lozinke moraju biti iste!';
        document.getElementById('password1').classList.add("apply-shake");
        document.getElementById('password2').classList.add("apply-shake");
        note.classList.remove('hide');
        return;
    }


    var name = document.getElementById('name').value;

    var description = document.getElementById('description').value;

    if (name === false || name === undefined || name === null || name === '') {
        document.getElementById('name').classList.add("apply-shake");
        return;
    }
    if (description === false || description === undefined || description === null || description === '') {
        document.getElementById('description').classList.add("apply-shake");
        return;
    }

    if (areaIsChosen === false || areaIsChosen === undefined || areaIsChosen === null) {
        document.getElementById('dropdownmenu').classList.add("apply-shake");
        return;
    }

    if (email != null && password1 != null && email.includes('@') && email.includes('.')) {
        data = {
            'name': name,
            'description': description,
            'active': false,
            'menu': [],
            'area': area
        };

        const promise = auth.createUserWithEmailAndPassword(email, password1);
        promise.catch(e => {
            if (e.code === 'auth/email-already-in-use') {
                var note = document.getElementById('under-email');
                note.innerText = 'Ovaj email se već koristi !';
                note.classList.remove('hide');
                document.getElementById('email').classList.add("apply-shake");
            }
        });
    }
}


auth.onAuthStateChanged(() => {
    if (auth.currentUser != null) {
        console.log('You are logged in!!!');
        console.log(auth.currentUser.uid);
        firebase.firestore().collection('restaurants').doc(auth.currentUser.uid).get().then((doc) => {
            if (doc.exists) {
                window.location.href = '/';
            } else {
                firebase.firestore().collection('restaurants').doc(auth.currentUser.uid).set(data).then(() => {
                    console.log('Document created!');
                    window.location.href = '/restoran';
                });
            }
        });


    } else {
        console.log('You are NOT logged in!');
    }
});

function newArea(area) {
    document.getElementById('dropdownmenu').innerText = area;
    areaIsChosen = true;
}

function getAreas() {
    firebase.firestore().collection('areas').doc('areas').get().then(function(doc) {
        areas = doc.data()['list'];

        areas.forEach((area) => {
            document.getElementById('dropdownmenu-list').insertAdjacentHTML('beforeend',
                `<a class="dropdown-item" onclick="newArea('${area}');" style="cursor: pointer;">${area}</a>`);
        });
    });
}