var createCheck = function (url, params) {
    getJSON(url, params,
        function (err, data) {
            if (err !== null) {
                console.log("Error retrieving data: " + err);
            } else {
                create(!data['exists']);
            }
        });
};

var checkString = /^([0-9]|[a-z_])+([0-9a-z_]+)$/i;

function addUser() {
    if (document.contains(document.getElementById('alert'))) {
        document.getElementById('alert').remove();
    }
    var username = document.getElementById('username').value;
    var password = document.getElementById('password').value;
    var firstname = document.getElementById('firstname').value;
    var lastname = document.getElementById('lastname').value;
    if (!username.match(checkString)) {
        var p = document.createElement('P');
        document.getElementsByTagName('BODY')[0].appendChild(p)
        p.setAttribute('id', 'alert');
        p.innerText = 'Invalid Username';
        return;
    } else if (!firstname.match(checkString) || !lastname.match(checkString)) {
        var p = document.createElement('P');
        document.getElementsByTagName('BODY')[0].appendChild(p)
        p.setAttribute('id', 'alert');
        p.innerText = 'Invalid Name';
        return;
    }

    var params = JSON.stringify({username: username, password: password, firstname: firstname, lastname: lastname});
    createCheck('/createUser', params);
}

function create(success) {
    if (success) {
        window.location.replace('/login')
    } else {
        var p = document.createElement('P');
        document.getElementsByTagName('BODY')[0].appendChild(p)
        p.setAttribute('id', 'alert');
        p.innerText = 'Username Taken';
    }
}