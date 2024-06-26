#version 330

uniform vec3 light_source_position;
uniform float gloss;
uniform float shadow;
uniform float glow_factor;
uniform float anti_alias_width;

in vec4 color;
in float point_radius;
in vec2 center;
in vec2 point;

out vec4 frag_color;

#include ../include/finalize_color.glsl

void main() {
    vec2 diff = point - center;
    float dist = length(diff);
    float signed_dist = dist - point_radius;
    if (signed_dist > 0.5 * anti_alias_width){
        discard;
    }
    vec3 normal = vec3(diff / point_radius, sqrt(1 - (dist * dist) / (point_radius * point_radius)));
    frag_color = finalize_color(
        color,
        vec3(point.xy, 0.0),
        normal,
        light_source_position,
        gloss,
        shadow
    );
    if(glow_factor > 0){
        frag_color.a *= pow(1 - dist / point_radius, glow_factor);
    }
    frag_color.a *= smoothstep(0.5, -0.5, signed_dist / anti_alias_width);
}
