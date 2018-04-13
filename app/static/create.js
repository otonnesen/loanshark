let createCheck = function (url, params) {
    getJSON(url, params,
        function (err, data) {
            if (err !== null) {
                console.log("Error retrieving data: " + err);
            } else {
                create(!data['exists']);
            }
        });
};

const checkString = /^([0-9]|[a-z_])+([0-9a-z_]+)$/i;

function addUser() {
    if (document.contains(document.getElementById('alert'))) {
        document.getElementById('alert').remove();
    }
    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;
    const confirm = document.getElementById('confirm').value;
    const firstname = document.getElementById('firstname').value;
    const lastname = document.getElementById('lastname').value;
    if (!username.match(checkString)) {
        const p = document.createElement('P');
        document.getElementsByTagName('BODY')[0].appendChild(p);
        p.setAttribute('id', 'alert');
        p.innerText = 'Invalid Username';
        return;
    } else if (password !== confirm) {
        const p = document.createElement('P');
        document.getElementsByTagName('BODY')[0].appendChild(p);
        p.setAttribute('id', 'alert');
        p.innerText = 'Passwords do not match';
        return;
    } else if (!firstname.match(checkString) || !lastname.match(checkString)) {
        const p = document.createElement('P');
        document.getElementsByTagName('BODY')[0].appendChild(p);
        p.setAttribute('id', 'alert');
        p.innerText = 'Invalid Name';
        return;
    }

    const params = JSON.stringify({username: username, password: password, firstname: firstname, lastname: lastname});
    createCheck('/create', params);
}

function create(success) {
    if (success) {
        window.location.replace('/login')
    } else {
        let p = document.createElement('P');
        document.getElementsByTagName('BODY')[0].appendChild(p);
        p.setAttribute('id', 'alert');
        p.innerText = 'Username Taken';
    }
}