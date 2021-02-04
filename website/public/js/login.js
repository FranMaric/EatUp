const auth = firebase.auth();

function login() {
    let email = document.getElementById('email').value;
    let password = document.getElementById('password').value;

    if (email != null && password != null && email.includes('@') && email.includes('.') && password.length >= 6) {
        const promise = auth.signInWithEmailAndPassword(email, password);
        promise.catch(e => console.log(e));
    }
}

auth.onAuthStateChanged(() => {
    console.log(auth.currentUser);

    if (auth.currentUser != null) {
        console.log('You are logged in!!!');
        window.location.href = '/';
    } else {
        console.log('You are NOT logged in!');
    }
});