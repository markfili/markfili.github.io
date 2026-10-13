{{flutter_js}}
{{flutter_build_config}}

// Start the engine straight away. The stock bootstrap first registers the
// service worker and waits for it to precache everything, which is what made
// the first visit sit on a blank page.
_flutter.loader.load();

// Still register the service worker so repeat visits load from cache, but only
// after the page is already on screen.
var serviceWorkerVersion = {{flutter_service_worker_version}};
if ('serviceWorker' in navigator) {
  window.addEventListener('flutter-first-frame', function () {
    navigator.serviceWorker.register('flutter_service_worker.js?v=' + serviceWorkerVersion);
  }, { once: true });
}
