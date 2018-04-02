var getJSON = function (url, params, callback) {
    var xhr = new XMLHttpRequest();
    xhr.open('POST', url, true);
    xhr.setRequestHeader("Content-type", "application/json; charset=utf-8");

    xhr.responseType = 'json';
    xhr.onload = function () {
        var status = xhr.status;
        if (status === 200) {
            callback(null, xhr.response);
        } else {
            callback(status, xhr.response);
        }
    };
    xhr.send(params);
};

var getData = function (url, params) {
    getJSON(url, params,
        function (err, data) {
            if (err !== null) {
                console.log("Error retrieving data: " + err);
            } else {
                login(data[0]);
            }
        });
};

var authenticate = function () {
    var p = document.getElementById('login');
    p.innerText = '';
    p.classList.remove('loginSucces', 'loginFailure');
    var username = document.getElementById('username').value;
    var password = document.getElementById('password').value;
    var params = JSON.stringify({username: username, password: password});
    getData('/test', params);
};

function login(success) {
    if (success) {
        loginSuccess();
        // set session cookie
    } else {
        loginFailure();
    }
};

function loginSuccess() {
    var p = document.getElementById('login');
    p.innerText = 'Login Success';
    p.classList.add('loginSuccess');
};

var loginFailure = function () {
    var p = document.getElementById('login');
    p.innerText = 'Login Failure';
    p.classList.add('loginFailure');
};