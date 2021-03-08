console.log("Image slideshow started!");
window.onload = function() {
    document.getElementsByTagName("body")[0].classList.remove("preload");
};
var locations = [
	'188 OSOR',
	'189 VELI VRH',
	'191 GOLA PLJESIVICA',
	'222 KALNIK',
	'226 NEPROBIĆ',
	'248 KAPAVAC',
	'259 KAMENJAK',
	'283 STRAZICA',
	'289 KREMEN',
	'290 CRNOPAC',
	'293 DINARA',
	'300 MOSOR',
	'301 PRAPATNICA',
	'312 SV IVAN',
	'384 BRUSNIK',
	'391 NOVOSELSKO BRDO',
	'403 BREŽIĆ',
];


function setBackground(index) {
	var cadaver = document.getElementsByClassName("cadaver")[0];
	var trigPointName = document.getElementById("trig-point-name");
	var trigPointLink = document.getElementById("trig-point-link");
	var location = locations[index];
	var locationId =  location.split(" ")[0];
	var url = baseUrl + locationId + ".jpg";
	cadaver.style.backgroundImage = 'url("'+ url + '")';
	trigPointName.innerText = location;
	trigPointLink.href = "https://geopp.planinarski-portal.org/kt-gpo/" + locationId; // {% /kt-gpo/id %}
}

var baseUrl = "assets/images/";
var intervalId = 0;
function startImagesSlideShow() {
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

startImagesSlideShow();