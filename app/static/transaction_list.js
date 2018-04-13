let addLoan = function (url, params) {
    getJSON(url, params,
        function (err, data) {
            if (err !== null) {
                console.log("Error retrieving data: " + err);
            } else {
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
    const sender = document.getElementById('sender').value;
    const cost = document.getElementById('credCost').value;
    const description = document.getElementById('credDesc').value;
    const params = JSON.stringify({sender: sender, cost: cost, description: description});
    addLoan('/addCredit', params);
}


function addDebt() {
    const owner = document.getElementById('owner').value;
    const cost = document.getElementById('debtCost').value;
    const description = document.getElementById('debtDesc').value;
    const params = JSON.stringify({owner: owner, cost: cost, description: description});
    addLoan('/addDebt', params);
}

function add(success) {
    if (success) {
        window.location.replace('/transactions');
    } else {
        const p = document.createElement('P');
        document.getElementsByTagName('BODY')[0].appendChild(p);
        p.setAttribute('id', 'alert');
        p.innerText = 'There was an error adding the transaction';
    }
}

function setActive(className) {
    Array.from(document.getElementsByClassName('transActive')).forEach(function (item) {
        item.classList.remove('transActive');
    });

    Array.from(document.getElementsByClassName(className)).forEach(function (item) {

        item.classList.add('transActive');
    });
}

function setActive(className) {
    Array.from(document.getElementsByClassName('transActive')).forEach(function (item) {
        item.classList.remove('transActive');
    });

    Array.from(document.getElementsByClassName(className)).forEach(function(item) {

        item.classList.add('transActive');
    });
}

let confirm = function (url, params) {
    getJSON(url, params,
        function (err, data) {
            if (err !== null) {
                console.log("Error retrieving data: " + err);
            } else {
                window.location.replace('/transactions');
                setActive('pending');
            }
        });
};

let completeParams;
function completeButton(tid) {
    completeParams = JSON.stringify({tid: tid});
    document.getElementById('completeModal').style.display = "block";
}

let complete = function (url, params) {
    getJSON(url, params,
        function (err, data) {
            if (err !== null) {
                console.log("Error retrieving data: " + err);
            } else {
                window.location.replace('/transactions');
            }
        });
};

function completeTransaction() {
    complete('/completeTransaction', completeParams);
}

function confirmTransaction(tid) {
    const params = JSON.stringify({tid: tid});
    confirm('/confirmTransaction', params);
}

window.addEventListener('click', function (event) {
    if(event.target == document.getElementById('completeModal')) {
        document.getElementById('completeModal').style.display = "none";
    }
});