window.onload = function () {
    var modalU = document.getElementById("addUserModal");
    var modalL = document.getElementById("addLoanModal");

    var btnU = document.getElementById("addUserButton");
    var btnL = document.getElementById("addLoanButton");

    var spanU = document.getElementsByClassName("close")[0];
    var spanL = document.getElementsByClassName("close")[1];

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
};

