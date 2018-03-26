function addUser(first_name, last_name) {
  let path = "/";
  let xhttp = new XMLHttpRequest;
  xhttp.open("POST", path);
  xhttp.onreadystatechange = function() {
    console.log(xhttp.status)
  }
}
