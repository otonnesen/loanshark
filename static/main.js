/*const rawData = [
    {
        month: "March",
        date: 10,
        person: 'Oliver',
        description: 'Burger from Caps',
        cost: 12,
        currency: 'CAD'
    }, {
        month: "February",
        date: 19,
        person: 'Matt',
        description: 'T-Shirt bought in States',
        cost: 30,
        currency: 'USD'
    }, {
        month: "December",
        date: 23,
        person: 'Victor',
        description: 'Icecream Sandwich',
        cost: 3,
        currency: 'CAD'
    }
]*/

function getData() {
    let path = "https://loanshark2.herokuapp.com/data";
    let xhttp = new XMLHttpRequest();
    xhttp.open("GET", path);
    xhttp.send();
    let d = xhttp.responseText;
    return d;
}

function showData() {
    const data = getData();
    let table = document.getElementById('table');
    for (let i=0; i < data.length; i++ ) {
        console.log(data[i]);
        table.insertAdjacentHTML('beforeend',`<div class="row">
        <div class="col-2">
            <h4 id="month"> ${data[i].month} </h4>
            <h2 id="day"> ${data[i].date} </h2>
        </div>
        <div class="col-6">
            <h2 id="other_user"> ${data[i].person} </h2>
            <h5 id="transaction_details"> ${data[i].description} </h5>
        </div>
        <div class="col-4">
            <h1 id="cost"> +$${data[i].cost} ${data[i].currency} </h1>
            <div class="row">
              <div class="col-3"></div>
              <div class="col-9">
              <button type="button" class="btn btn-info">Edit</button>
              </div>
            </div>
        </div>
        </div>
	<hr>`);
    }
}

showData()
