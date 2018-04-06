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

function logoutButton() {
    document.getElementById('logoutModal').style.display = "block";
}

function cancel() {
    document.getElementById('logoutModal').style.display = "none";
}

window.addEventListener('click', function (event) {
    if(event.target == document.getElementById('logoutModal')) {
        document.getElementById('logoutModal').style.display = "none";
    }
});
document.getElementById("debtModal")