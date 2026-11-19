#version 460 core
#include <flutter/runtime_effect.glsl>

precision highp float;

// Still cloud banks in the upper sky, painted once. Domain-warped value noise,
// stretched horizontally so it reads as layered banks rather than puffs.
// uTime only picks which cloud arrangement is shown; nothing animates.

uniform vec2 uSize;
uniform float uTime;      // fixed: selects the cloud arrangement
uniform float uHorizon;   // fraction of height where the clouds have faded out
uniform float uOpacity;   // peak opacity of the densest cloud
uniform vec3 uTint;       // cloud colour high in the sky
uniform vec3 uGlow;       // colour the clouds pick up near the horizon

out vec4 fragColor;

float hash(vec2 p) {
  vec3 p3 = fract(vec3(p.xyx) * 0.1031);
  p3 += dot(p3, p3.yzx + 33.33);
  return fract((p3.x + p3.y) * p3.z);
}

float noise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  vec2 u = f * f * (3.0 - 2.0 * f);
  return mix(
    mix(hash(i), hash(i + vec2(1.0, 0.0)), u.x),
    mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x),
    u.y
  );
}

float fbm(vec2 p) {
  float v = 0.0;
  float a = 0.5;
  mat2 r = mat2(0.8, 0.6, -0.6, 0.8);
  for (int i = 0; i < 5; i++) {
    v += a * noise(p);
    p = r * p * 2.02;
    a *= 0.5;
  }
  return v;
}

void main() {
  vec2 frag = FlutterFragCoord().xy;
  // Canvas heights, so wide screens show more cloud, not stretched cloud.
  vec2 uv = frag / uSize.y;
  float y = frag.y / uSize.y;

  float t = uTime * 0.008;
  vec2 p = vec2(uv.x * 1.4 + t * 3.0, uv.y * 4.2);
  vec2 q = vec2(
    fbm(p + vec2(0.0, t)),
    fbm(p + vec2(5.2, 1.3) - vec2(t, 0.0))
  );
  float d = fbm(p + 1.7 * q);
  float cloud = smoothstep(0.48, 0.82, d);

  // Thin out towards the top edge and fade before the far peaks.
  float mask = smoothstep(0.0, 0.18, y) *
      (1.0 - smoothstep(uHorizon - 0.28, uHorizon, y));
  float a = cloud * mask * uOpacity;

  vec3 col = mix(uTint, uGlow, 0.7 * smoothstep(0.15, uHorizon, y));
  // Premultiplied alpha.
  fragColor = vec4(col * a, a);
}
