window.onload = function () {
    var creditModal = document.getElementById("addCreditModal");
    var debtModal = document.getElementById("addDebtModal");

    var creditBtn = document.getElementById("addCreditButton");
    var debtBtn = document.getElementById("addDebtButton");

    var creditSpan = document.getElementsByClassName("close")[0];
    var debtSpan = document.getElementsByClassName("close")[0];

    creditBtn.onclick = function () {
        creditModal.style.display = "block"
    };

    debtBtn.onclick = function () {
        debtModal.style.display = "block"
    };

    creditSpan.onclick = function () {
        creditModal.style.display = "none";
    };

    debtSpan.onclick = function () {
        debtModal.style.display = "none";
    };

    window.onclick = function (event) {
        if (event.target == creditModal || event.target == debtModal) {
            creditModal.style.display = "none";
            debtModal.style.display = "none";
        }
    };
};

