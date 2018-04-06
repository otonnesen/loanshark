function setActive(className) {
    Array.from(document.getElementsByClassName('sidebarActive')).forEach(function (item) {
        console.log(item);
        item.classList.remove('sidebarActive');
    });

    Array.from(document.getElementsByClassName(className)).forEach(function(item) {

        item.classList.add('sidebarActive');
    });
}