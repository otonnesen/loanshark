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