var modalU;
var btnU;
var spanU;
var modalL;
var btnL;
var spanL;

window.onload = function () {
    modalU = document.getElementById("addUserModal");
    modalL = document.getElementById("addLoanModal");

    btnU = document.getElementById("addUserButton");
    btnL = document.getElementById("addLoanButton");

    spanU = document.getElementsByClassName("close")[0];
    spanL = document.getElementsByClassName("close")[1];

};

btnU.onclick = function () {
    modalU.style.display = "block";
};

btnL.onclick = function () {
    modalL.style.display = "block"
};

spanU.onclick = function () {
    modalU.style.display = "none";
};

spanL.onclick = function () {
    modalL.style.display = "none";
};

window.onclick = function (event) {
    if (event.target == modalU || event.target == modalL) {
        modalU.style.display = "none";
        modalL.style.display = "none";
    }
};