Shader "Manana/Gaussian Blur"
{
    Properties{
        _MainTex("Blit Source", 2D) = "White" {}
        _PixelOffset("Pixel Offset", float) = 1.0
    }
    
    Subshader{
        Tags{
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "Queue"="Transparent"
        }
        
        ZWrite Off
        Blend One One
        
        Pass{
            Name "Gaussian3X3"
            
            HLSLPROGRAM
            
            #pragma vertex Vertex
            #pragma fragment Fragment

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            
            struct Input{
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            Texture2D<float4> _MainTex;
            SamplerState sampler_MainTex;
            float4 _MainTex_TexelSize;

            float _PixelOffset;

            Varyings Vertex(Input IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS);
                OUT.uv = IN.uv;
                return OUT;
            }

            float4 GaussianBlur3x3(Texture2D tex, SamplerState samplerS, float2 uv, float pixelOffset, float2 texelSize) {
                float gaussianKernel[9] =
                {   1 / 16,   1 / 8,    1 / 16,
                    1 / 8,    1 / 4,    1 / 8,
                    1 / 16,   1 / 8,    1 / 16 };

                float4 result = 0;

                [Unroll(9)]
                for (float x = -1; x < 1; ++x) {
                    for (float y = -1; y < 1; ++y) {
                        float2 offset = float2(x, y) * texelSize;
                        result += tex.Sample(samplerS, uv + offset) * gaussianKernel[x + 1 + (y+1) * 3];
                    }
                }

                return result;
            }

            float4 Fragment(Varyings IN) : SV_Target{
                return GaussianBlur3x3(_MainTex, sampler_MainTex, IN.uv, _PixelOffset, _MainTex_TexelSize);
            }
            
            ENDHLSL
        }
    }
}