var userAgent = navigator.userAgent || navigator.vendor || window.opera;

if (/android/i.test(userAgent)) {
    window.location = 'https://android.com';

}

// iOS detection from: http://stackoverflow.com/a/9039885/177710
if (/iPad|iPhone|iPod/.test(userAgent) && !window.MSStream) {
    window.location = 'https://apple.com';

}
console.log('Not an android or iPhone');