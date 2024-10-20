#version 460
#extension GL_EXT_mesh_shader : require

layout(row_major) uniform;
layout(local_size_x = 32, local_size_y = 1, local_size_z = 1) in;
layout(triangles, max_vertices = 8, max_primitives = 12) out;
layout(location=0) out perprimitiveEXT vec3 frag_color[];
layout(std140, binding=0) uniform Uniform_Block {
    mat4x4 object_to_clip_transform;
};

void main() {
    uint ti = gl_LocalInvocationIndex;
    // Vertices
    if (ti < 8) {
        float x = (ti & 3) == 1 || (ti & 3) == 2 ? 1.0 : -1.0;
        float y = (ti & 2) != 0 ? 1.0 : -1.0;
        float z = ti > 3 ? -1.0 : 1.0;
        gl_MeshVerticesEXT[ti].gl_Position = object_to_clip_transform * vec4(x, y, z, 1);
    }
    // Triangles
    const uvec3 triangles[12] = {
        uvec3(0, 1, 2),
        uvec3(0, 2, 3),
        uvec3(1, 5, 6),
        uvec3(1, 6, 2),
        uvec3(5, 4, 7),
        uvec3(5, 7, 6),
        uvec3(4, 0, 3),
        uvec3(4, 3, 7),
        uvec3(4, 5, 1),
        uvec3(4, 1, 0),
        uvec3(3, 2, 6),
        uvec3(3, 6, 7)
    };
    if (ti < 12) {
        gl_PrimitiveTriangleIndicesEXT[ti] = triangles[ti];
        uint k = (ti >> 1) + 1;
        frag_color[ti] = vec3((k & 1) == 0 ? 0 : 1, (k & 2) == 0 ? 0 : 1, (k & 4) == 0 ? 0 : 1);
    }
    SetMeshOutputsEXT(8, 12);
}
