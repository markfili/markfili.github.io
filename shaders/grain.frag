#version 460 core
#include <flutter/runtime_effect.glsl>

precision mediump float;

uniform float uOpacity;

out vec4 fragColor;

// Cheap per-pixel hash, stable across frames so the grain reads as film
// texture rather than static.
float hash(vec2 p) {
  vec3 p3 = fract(vec3(p.xyx) * 0.1031);
  p3 += dot(p3, p3.yzx + 33.33);
  return fract((p3.x + p3.y) * p3.z);
}

void main() {
  vec2 p = floor(FlutterFragCoord().xy);
  float n = hash(p);
  // Premultiplied grey noise.
  fragColor = vec4(vec3(n * uOpacity), uOpacity);
}
