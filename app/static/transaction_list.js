var addLoan = function (url, params) {
    getJSON(url, params,
        function (err, data) {
            if (err !== null) {
                console.log("Error retrieving data: " + err);
            } else {
                console.log(data);
                add(data['exists']);
            }
        });
};

function creditButton() {
    document.getElementById("creditModal").style.display = "block";
}

function debtButton() {
    document.getElementById("debtModal").style.display = "block";
}

function creditClose() {
    document.getElementById("creditModal").style.display = "none";
}

function debtClose() {
    document.getElementById("debtModal").style.display = "none";
}

window.addEventListener('click', function (event) {
    if (event.target == creditModal || event.target == debtModal) {
        document.getElementById("creditModal").style.display = "none";
        document.getElementById("debtModal").style.display = "none";
    }
});

/*function currencyValue(num) {
    return parseFloat(num.replace(/[^\d\.]/g,''));
}

var moneyFormat = /[0-9]+(\.[0-9][0-9]?)?/;*/

function addCredit() {
    var sender = document.getElementById('sender').value;
    var cost = document.getElementById('credCost').value;
    var description = document.getElementById('credDesc').value;
    var params = JSON.stringify({sender: sender, cost: cost, description: description});
    addLoan('/addCredit', params);
}


function addDebt() {
    var owner = document.getElementById('owner').value;
    var cost = document.getElementById('debtCost').value;
    var description = document.getElementById('debtDesc').value;
    var params = JSON.stringify({owner: owner, cost: cost, description: description});
    console.log(params);
    addLoan('/addDebt', params);
}

function add(success) {
    if (success) {
        window.location.replace('/transactions');
    } else {
        var p = document.createElement('P');
        document.getElementsByTagName('BODY')[0].appendChild(p);
        p.setAttribute('id', 'alert');
        p.innerText = 'There was an error adding the transaction';
    }
}

function setActive(className) {
    Array.from(document.getElementsByClassName('transActive')).forEach(function (item) {
        console.log(item);
        item.classList.remove('transActive');
    });

    Array.from(document.getElementsByClassName(className)).forEach(function (item) {

        item.classList.add('transActive');
    });
}

function setActive(className) {
    Array.from(document.getElementsByClassName('transActive')).forEach(function (item) {
        console.log(item);
        item.classList.remove('transActive');
    });

    Array.from(document.getElementsByClassName(className)).forEach(function(item) {

        item.classList.add('transActive');
    });
}

var confirm = function (url, params) {
    getJSON(url, params,
        function (err, data) {
            if (err !== null) {
                console.log("Error retrieving data: " + err);
            } else {
                console.log(data);
                window.location.replace('/transactions')
                setActive('pending');
            }
        });
};

function confirmTransaction(tid) {
    var params = JSON.stringify({tid: tid});
    confirm('/confirmTransaction', params);
}

