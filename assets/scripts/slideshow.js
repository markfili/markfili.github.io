window.onload = function() {
    document.getElementsByTagName("body")[0].classList.remove("preload");
};

function setBackground(index) {
	var backgroundDiv = document.getElementsByClassName("background-image")[0];
	var pointName = document.getElementById("point-name");
	var location = locations[index];
	forcePreloadNext(index);
	backgroundDiv.style.backgroundImage = 'url("'+ imagePath(location.name) + '")';
	pointName.innerText = location.name;
}

function forcePreloadNext(index) {
	var nextIndex = index + 1;
	if (nextIndex < locations.length) {
		var nextImage = imagePath(locations[nextIndex].name);
		var img = new Image();
		img.src = nextImage;
	}
}

function imagePath(id) {
	return baseUrl + id + ".jpg?v1";
}

var baseUrl = "assets/images/backgrounds/";
var intervalId = 0;
function startImagesSlideShow() {
	shuffleArray(locations);
	var index = 0;
	setBackground(index);
	intervalId = setInterval(function() {
		index++;
		if (index >= locations.length) {
			index = 0;
		}
		setBackground(index);
	}, 5000);
}

function shuffleArray(array) {
    for (var i = array.length - 1; i > 0; i--) {
        var j = Math.floor(Math.random() * (i + 1));
        var temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }
}

if (!window.matchMedia("(max-width: 575px)").matches) {
	startImagesSlideShow();
}
