window.onload = function () {
    const modalU = document.getElementById("addUserModal");
    const modalL = document.getElementById("addLoanModal");

    const btnU = document.getElementById("addUserButton");
    const btnL = document.getElementById("addLoanButton");

    const spanU = document.getElementsByClassName("close")[0];
    const spanL = document.getElementsByClassName("close")[1];

    /*btnU.onclick = function () {
        modalU.style.display = "block";
    };*/

    /*btnL.onclick = function () {
        modalL.style.display = "block"
    };*/

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

