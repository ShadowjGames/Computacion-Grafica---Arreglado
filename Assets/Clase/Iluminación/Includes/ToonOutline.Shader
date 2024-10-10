Shader "CustomShaders/Toon/Outline"
{
    Properties{
        _Color("Color", Color) = (0,0,0,1)
        _Thickness("Thickness", Float) = 0.0
    }

    Subshader{
        Tags{
            "RenderType" = "Opaque"
            "RenderPipeline" = "UniversalPipeline"
            "Queue" = "Geometry"
        }

        pass{
            HLSLPROGRAM
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            #pragma vertex Vertex
            #pragma fragment Fragment

            struct VertexInput{
                float4 positionOS : POSITION; //position object space
                float3 normalOS : NORMAL; //normal object space
            };

            struct FragmentInput{
                nointerpolation float4 positionCS : SV_POSITION;
            };

            float _Thickness = 0.0;

            FragmentInput Vertex(VertexInput IN){
                FragmentInput OUT;
                OUT.positionCS = TransformObjectToHClip(IN.positionOS + IN.normalOS * _Thickness);
                return OUT;
            }

            float4 Fragment(FragmentInput IN) : SV_Target{
                return float4(1,0,0,1);
            }
            ENDHLSL
        }
    }
}