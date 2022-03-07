var currentTime = document.getElementById("currentTime");
var currentDay = document.getElementById("currentDay");
var currentWeather = document.getElementById("currentWeather");

function upDate() {
  var date = new Date();
  var weekday = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
  var month = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
  var hours = date.getHours();
  var minutes = date.getMinutes();
  hours = hours < 10 ? '0' + hours : hours;
  minutes = minutes < 10 ? '0' + minutes : minutes;

  var prettyTime = `${hours}:${minutes}`
  var prettyDate = `${weekday[date.getDay()]} ${date.getDate()} ${month[date.getMonth()]},`
  
  currentTime.innerHTML = prettyTime;
  currentDay.innerHTML = prettyDate;
}

upDate();
setInterval(upDate, 1000);

const weatherResponse = fetch("http://wttr.in/Halifax?format=%c%t")
  .then(r => r.text())
  .then(weather => currentWeather.innerHTML = weather);
