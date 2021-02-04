const auth = firebase.auth();

auth.onAuthStateChanged(() => {
    if (auth.currentUser != null) {
        console.log('Logged in!!!');
        document.getElementById('login').classList.add('hide');
        document.getElementById('register').classList.add('hide');
        document.getElementById('restaurant').classList.remove('hide');
        document.getElementById('logout').classList.remove('hide');

    } else {
        console.log('NOT logged in!');
        document.getElementById('login').classList.remove('hide');
        document.getElementById('register').classList.remove('hide');
        document.getElementById('restaurant').classList.add('hide');
        document.getElementById('logout').classList.add('hide');
    }
});

function logout() {
    console.log('Odlogiranje');
    auth.signOut();
}