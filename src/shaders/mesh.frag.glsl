#version 460
layout(row_major) uniform;

layout(location=0) in vec2 frag_uv;
layout(location = 0) out vec4 color_attachment0;

layout(binding=1) uniform texture2D image;
layout(binding=2) uniform sampler image_sampler;

layout(std430, binding=3) readonly buffer DebugMeshletIndices {
    uint debug_meshlet_indices[];
};

void main() {
    color_attachment0 = texture(sampler2D(image, image_sampler), frag_uv);

    // uint k = uint(debug_meshlet_indices[gl_PrimitiveID]);
    // debug: Highlight specific meshlet
    // color_attachment0 = (k == 0) ? vec4(1, 0, 0, 1) : vec4(0, 0, 0, 1);
    // debug: Show all meshlets
    // color_attachment0 = vec4((k & 1) == 0 ? 0 : 1, (k & 2) == 0 ? 0 : 1, (k & 4) == 0 ? 0 : 1, 1);
}
