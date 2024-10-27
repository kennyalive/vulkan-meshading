#version 460
#extension GL_EXT_mesh_shader : require
#extension GL_EXT_shader_8bit_storage : require

#define MESH_WORKGROUP_SIZE 64

layout(row_major) uniform;
layout(local_size_x = MESH_WORKGROUP_SIZE, local_size_y = 1, local_size_z = 1) in;

layout(triangles, max_vertices = 64, max_primitives = 64) out;

//layout(location=0) out perprimitiveEXT vec3 frag_color[];
layout(location = 0) out vec2 frag_uv[];
layout(std140, binding=0) uniform Uniform_Block {
    mat4x4 object_to_clip_transform;
};

struct Vertex {
    float x, y, z;
    float u, v;
};

layout(std430, binding=4) readonly buffer Vertices {
    Vertex vertices[];
};

layout(std430, binding=5) readonly buffer MeshletVertices {
    uint meshlet_vertices[];
};

layout(std430, binding=6) readonly buffer MeshletIndices {
    uint8_t meshlet_indices[];
};

struct Meshlet {
    uint first_vertex;
    uint vertex_count;
    uint first_index;
    uint index_count;
};

layout(std430, binding=7) readonly buffer Meshlets {
    Meshlet meshlets[];
};

void main() {
    uint meshlet_index = gl_WorkGroupID.x;
    {
        uint first_vertex = meshlets[meshlet_index].first_vertex;
        uint vertex_count = meshlets[meshlet_index].vertex_count;
        uint first_index = meshlets[meshlet_index].first_index;
        uint index_count = meshlets[meshlet_index].index_count;

        uint ti = gl_LocalInvocationIndex;

        SetMeshOutputsEXT(vertex_count, index_count / 3);

        if (ti < vertex_count) {
            uint vertex_index = meshlet_vertices[first_vertex + ti];
            Vertex v = vertices[vertex_index];
            gl_MeshVerticesEXT[ti].gl_Position = object_to_clip_transform * vec4(v.x, v.y, v.z, 1);
            frag_uv[ti] = vec2(v.u, v.v);
        }
        if (ti < index_count / 3) {
            uint index_offset = first_index + ti * 3;
            gl_PrimitiveTriangleIndicesEXT[ti] = uvec3(
                uint(meshlet_indices[index_offset + 0]),
                uint(meshlet_indices[index_offset + 1]),
                uint(meshlet_indices[index_offset + 2])
            );
        }
        
    }
}
