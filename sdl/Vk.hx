package sdl;
class Vk {
    public static inline var CULL_NONE = 0; public static inline var CULL_FRONT = 1; public static inline var CULL_BACK = 2;
    public static inline var FRONT_FACE_CLOCKWISE = 1; public static inline var FRONT_FACE_COUNTER_CLOCKWISE = 0;
    public static inline var BLEND_FACTOR_ONE = 1; public static inline var BLEND_FACTOR_ZERO = 0;
    public static inline var PRIMITIVE_TOPOLOGY_TRIANGLE_LIST = 3; public static inline var INDEX_TYPE_UINT16 = 0; public static inline var INDEX_TYPE_UINT32 = 1;
    public static inline var FORMAT_R8G8B8A8_UNORM = 37; public static inline var FORMAT_B8G8R8A8_UNORM = 44; public static inline var FORMAT_B8G8R8A8_SRGB = 50;
    public static inline var FORMAT_R32G32B32A32_SFLOAT = 109; public static inline var FORMAT_R16G16B16A16_SFLOAT = 97; public static inline var FORMAT_R16G16_SFLOAT = 83;
    public static inline var FORMAT_R16G16B16_SFLOAT = 90; public static inline var FORMAT_R32_SFLOAT = 100; public static inline var FORMAT_R32G32_SFLOAT = 103;
    public static inline var FORMAT_R32G32B32_SFLOAT = 106; public static inline var FORMAT_R8_UNORM = 9; public static inline var FORMAT_R8G8_UNORM = 16;
    public static inline var FORMAT_R8G8B8_UNORM = 23; public static inline var FORMAT_R16_SFLOAT = 76; public static inline var FORMAT_D16_UNORM = 124;
    public static inline var FORMAT_D32_SFLOAT = 126; public static inline var FORMAT_D24_UNORM_S8_UINT = 129; public static inline var FORMAT_D32_SFLOAT_S8_UINT = 130;
    public static inline var FORMAT_B10G11R11_UFLOAT_PACK32 = 122; public static inline var FORMAT_A2B10G10R10_UNORM_PACK32 = 64;
    public static inline var FORMAT_R16G16B16A16_UINT = 98; public static inline var FORMAT_R16_UINT = 74;
    public static inline var FORMAT_R16G16_UINT = 81; public static inline var FORMAT_R16G16B16_UINT = 88;
    public static inline var IMAGE_USAGE_SAMPLED = 4; public static inline var IMAGE_USAGE_TRANSFER_DST = 2; public static inline var IMAGE_USAGE_TRANSFER_SRC = 1;
    public static inline var IMAGE_USAGE_COLOR_ATTACHMENT = 16; public static inline var IMAGE_USAGE_DEPTH_STENCIL_ATTACHMENT = 32;
    public static inline var IMAGE_ASPECT_COLOR = 1; public static inline var IMAGE_ASPECT_DEPTH = 2;
    public static inline var BUFFER_USAGE_VERTEX_BUFFER = 128; public static inline var BUFFER_USAGE_INDEX_BUFFER = 64; public static inline var BUFFER_USAGE_TRANSFER_SRC = 1;
    public static inline var FILTER_NEAREST = 0; public static inline var FILTER_LINEAR = 1;
    public static inline var SAMPLER_MIPMAP_MODE_NEAREST = 0; public static inline var SAMPLER_MIPMAP_MODE_LINEAR = 1;
    public static inline var SAMPLER_ADDRESS_MODE_REPEAT = 0; public static inline var SAMPLER_ADDRESS_MODE_CLAMP_TO_EDGE = 2;
    public static inline var IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL = 5; public static inline var IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL = 6;
    public static inline var IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL = 7; public static inline var IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL = 3;
    public static inline var PIPELINE_STAGE_TOP_OF_PIPE = 1; public static inline var PIPELINE_STAGE_TRANSFER = 4096;
    public static inline var PIPELINE_STAGE_FRAGMENT_SHADER = 128;
    public static inline var ACCESS_TRANSFER_WRITE = 4096; public static inline var ACCESS_TRANSFER_READ = 2048;
    public static inline var ACCESS_SHADER_READ = 32;
    public static inline var IMAGE_LAYOUT_UNDEFINED = 0; public static inline var IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL = 2;
    public static inline var SAMPLE_COUNT_1_BIT = 1; public static inline var SAMPLE_COUNT_4_BIT = 4;
}

