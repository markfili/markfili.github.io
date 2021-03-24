window.onload = function() {
    document.getElementsByTagName("body")[0].classList.remove("preload");
};
var locations = [{"id":188,"name":"OSOR"},{"id":189,"name":"VELI VRH"},{"id":191,"name":"GOLA PLJEŠIVICA"},{"id":222,"name":"KALNIK"},{"id":226,"name":"NEPROBIĆ"},{"id":248,"name":"KAPAVAC"},{"id":259,"name":"KAMENJAK"},{"id":283,"name":"STRAŽICA"},{"id":289,"name":"KREMEN"},{"id":290,"name":"CRNOPAC"},{"id":293,"name":"DINARA"},{"id":300,"name":"MOSOR"},{"id":301,"name":"PRAPATNICA"},{"id":312,"name":"SV IVAN"},{"id":384,"name":"BRUSNIK"},{"id":391,"name":"NOVOSELSKO BRDO"},{"id":403,"name":"BREŽIĆ"},{"id":183,"name":"UČKA"},{"id":184,"name":"TUHOBIĆ"},{"id":186,"name":"SV. MIHOVIL"},{"id":187,"name":"PULA"},{"id":209,"name":"IVANČICA"}]

function setBackground(index) {
	var cadaver = document.getElementsByClassName("cadaver")[0];
	var trigPointName = document.getElementById("trig-point-name");
	var trigPointLink = document.getElementById("trig-point-link");
	var location = locations[index];
	forcePreloadNext(index);
	cadaver.style.backgroundImage = 'url("'+ imagePath(location.id) + '")';
	trigPointName.innerText = location.id + " " + location.name;
	trigPointLink.href = "/kt-gpo/" + location.id;
}

function forcePreloadNext(index) {
	var nextIndex = index + 1;
	if (nextIndex < locations.length) {
		var nextImage = imagePath(locations[nextIndex].id);
		var img = new Image();
		img.src = nextImage;
	}
}

function imagePath(id) {
	return baseUrl + id + ".jpg";
}

var baseUrl = "static/images/";
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
