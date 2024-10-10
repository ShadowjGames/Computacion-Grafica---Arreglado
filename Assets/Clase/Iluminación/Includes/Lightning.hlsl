//#Include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
//#include "Packages/com.unity.redner-pipelines.core/ShaderLibrary/Texture.hlsl"


void GetMainLight_float(float3 positionWS, out float3 direction, out float3 color, out float shadowAttenuation) {

#if !defined(SHADERGRAPH_PREVIEW)
    Light light;
    float4 shadowCoord = TransformWorldToShadowCoord(positionWS);
    light = GetMainLight(shadowCoord);
    direction = light.direction;
    color = light.color;
    ShadowSamplingData samplingData = GetMainLightShadowSamplingData();
    float shadowIntensity = GetMainLightShadowStrenght();
    shadowAttenuation = SampleShadowmap(shadowCoord, TEXTURE2D_ARGS(_MainLightShadowmapTexture, sampler_MainLightShadowmapTexture), samplingData, shadowIntensity, false);
#else
    direction = float3(1, 1, -1);
    color = 1;
    shadowAttenuation = 1;
#endif
}

void ShadeToonAddtionalLights_float(float3 normalWS, float3 positionWS, UnitySamplerState sState, UnityTexture2D toonGradient,
    float3 vierDirWS, half smoothness, out half3 diffuse, out half3 specular) {

#if !defined(SHADERGRAPH_PREVIEW)
    int _additionalLightCount = GetAdditionalLightsCount();
    diffuse = 0;
    specular = 0;

    [unroll(8)]
    for (int lightId = 0; lightId < _additionalLightCount; lightId++) {
        Light additionalLight = GetAdditionalLight(lightId, positionWS);
        //diffuse
        half halfLambert = dot(normalWS, additionalLight.direction) * 0.5 + 0.5;
        diffuse += SAMPLE_TEXTURE2D(toonGradient, sState, halfLambert) * additionalLight.color * additionalLight.distanceAttenuation;

        //Specular
        float h = normalize(additionalLight.direction + vierDirWS);
        half blinnPhong = max(0, dot(normalWS, h));
        blinnPhong = pow(blinnPhong, 50);
        blinnPhong = smoothstep(0.5, 0.6, blinnPhong);
        blinnPhong *= smoothness;
        specular += blinnPhong * additionalLight.color * additionalLight.distanceAttenuation;
    }
#else
    diffuse = 0;
    specular = 0;
#endif
}