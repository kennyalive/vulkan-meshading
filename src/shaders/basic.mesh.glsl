#version 460
#extension GL_EXT_mesh_shader : require
layout(row_major) uniform;

layout(triangles) out;
layout(max_vertices = 3, max_primitives = 1) out;

layout(location=0) out vec2 frag_uv[];

layout(std140, binding=0) uniform Uniform_Block {
    mat4x4 model_view_proj;
};

void main() {
    gl_MeshVerticesEXT[0].gl_Position = model_view_proj * vec4(-1, -1, 0, 1);
    gl_MeshVerticesEXT[1].gl_Position = model_view_proj * vec4( 1, -1, 0, 1);
    gl_MeshVerticesEXT[2].gl_Position = model_view_proj * vec4( 0,  1, 0, 1);

    frag_uv[0] = vec2(0, 0);
    frag_uv[1] = vec2(0, 1);
    frag_uv[2] = vec2(1, 1);

    gl_PrimitiveTriangleIndicesEXT[0] = uvec3(0, 1, 2);

    SetMeshOutputsEXT(3, 1);
}
