#version 460
#extension GL_EXT_mesh_shader : enable

layout(location=0) flat in perprimitiveEXT vec3 frag_color;
layout(location = 0) out vec4 color_attachment0;

void main() {
    color_attachment0 = vec4(frag_color, 1);
}
