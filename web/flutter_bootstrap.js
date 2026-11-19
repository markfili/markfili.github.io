{{flutter_js}}
{{flutter_build_config}}

// Start the engine straight away, without registering a service worker.
// Since Flutter 3.50 the generated flutter_service_worker.js caches nothing:
// it only unregisters itself, which clears the old caching worker from
// returning visitors. The build still emits it, so keep deploying it.
_flutter.loader.load();
