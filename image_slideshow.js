console.log("Image slideshow started!");

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

var baseUrl = "assets/images/";
function startImagesSlideShow() {
	var cadaver = document.getElementsByClassName("cadaver")[0];
	locations.forEach(function (location) { 
		var url = baseUrl + location + ".JPG";
		cadaver.style.backgroundImage = 'url("'+ url + '")';
		document.getElementById("trig-point-name").innerText = location;
	});
}

startImagesSlideShow();