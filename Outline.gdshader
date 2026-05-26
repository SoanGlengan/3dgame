shader_type spatial;
render_mode cull_back, unshaded, world_vertex_coords, shadows_disabled, depth_draw_never;

uniform vec3 OUTLINE_COLOR : source_color = vec3(0);
uniform float THICKNESS : hint_range(0.0, 0.05, 0.001) = 0.01f;
uniform float OFFSET : hint_range(0.25, 5.0, 0.01) = 0.35f;

void vertex() {
  VERTEX += NORMAL * THICKNESS + normalize(
  VERTEX - CAMERA_POSITION_WORLD
  ) * OFFSET;

  // Avoid perspective warping by offsetting vertices
  vec4 projected_vertex = VIEW_MATRIX * vec4(VERTEX, 1.0);
  projected_vertex /= projected_vertex.w;

  float dist_to_plane = length(VERTEX - projected_vertex.xyz);
  VERTEX += NORMAL * dist_to_plane * THICKNESS;
}

void fragment() {
  ALBEDO = OUTLINE_COLOR;
}