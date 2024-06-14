/*
 *  Shared textures across shaders by prod80
 *  Required for proper effect execution
 */

// Textures
texture texNoise        < source = "pd80_bluenoise.png"; >       { Width = 512; Height = 512; Format = RGBA8; };
texture texNoiseRGB     < source = "pd80_bluenoise_rgba.png"; >  { Width = 512; Height = 512; Format = RGBA8; };
texture texGaussNoise   < source = "pd80_gaussnoise.png"; >      { Width = 512; Height = 512; Format = RGBA8; };

// Samplers
sampler samplerNoise
{ 
    Texture = texNoise;
    MipFilter = POINT;
    MinFilter = POINT;
    MagFilter = POINT;
    AddressU = WRAP;
    AddressV = WRAP;
    AddressW = WRAP;
};
sampler samplerRGBNoise
{ 
    Texture = texNoiseRGB;
    MipFilter = POINT;
    MinFilter = POINT;
    MagFilter = POINT;
    AddressU = WRAP;
    AddressV = WRAP;
    AddressW = WRAP;
};
sampler samplerGaussNoise
{ 
    Texture = texGaussNoise;
    MipFilter = POINT;
    MinFilter = POINT;
    MagFilter = POINT;
    AddressU = WRAP;
    AddressV = WRAP;
    AddressW = WRAP;
};

// Functions
uniform float2 pp < source = "pingpong"; min = 0; max = 128; step = 1; >;

float2 get_dither_uv()
{
    return float2( BUFFER_WIDTH / 512.0f, BUFFER_HEIGHT / 512.0f );
}

float4 dither( sampler2D tex, float2 coords, int var, bool enabler, float str, bool motion, float swing )
{
    float2 dither_uv = get_dither_uv();
    coords.xy *= dither_uv.xy;
    float4 noise = tex2D( tex, coords.xy );
    float mot = motion ? pp.x + var : 0.0f;
    noise = frac( noise + 0.61803398875f * mot );
    noise = ( noise * 2.0f - 1.0f ) * swing;
    return ( enabler ) ? noise * ( str / 255.0f ) : float4( 0.0f, 0.0f, 0.0f, 0.0f );
}
