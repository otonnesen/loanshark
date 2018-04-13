let getData = function (url, params) {
    getJSON(url, params,
        function (err, data) {
            if (err !== null) {
                console.log("Error retrieving data: " + err);
            } else {
                login(data['validate']);
            }
            //document.getElementById('submit').style.cursor = '';
        });
};

let authenticate = function () {
    //document.getElementById('submit').style.cursor = 'not-allowed';
    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;
    const params = JSON.stringify({username: username, password: password});
    getData('/login', params);
};

function login(success) {
    if (success) {
        loginSuccess();
        window.location.replace('/');
    } else {
        loginFailure();
    }
}

function loginSuccess() {
    if (document.contains(document.getElementById('login'))) {
        document.getElementById('login').remove();
    }
    const p = document.createElement('P');
    document.getElementsByTagName('BODY')[0].appendChild(p);
    p.setAttribute('id', 'login');
    p.innerText = 'Login Success';
    p.classList.add('loginSuccess');

}

function loginFailure() {
    if (document.contains(document.getElementById('login'))) {
        document.getElementById('login').remove();
    }
    const p = document.createElement('P');
    document.getElementsByTagName('BODY')[0].appendChild(p);
    p.setAttribute('id', 'login');
    p.innerText = 'Login Failure';
    p.classList.add('loginFailure');
}