//Include Guard
#ifndef LIGHTING_T_INCLUDED
#define LIGHTING_T_INCLUDED

#define ADD(a,b) add(a,b)

void GetMainLightInfo_float(float3 positionWS, out float3 direction, out half3 color, out float shadowAttenuation)
{
    //Si estoy en el shader invento luz
    #if defined(SHADERGRAPH_PREVIEW)
    direction = float3(1,1,-1);
    color = 1;
    shadowAttenuation = 1;
    #else
    Light mainLight = GetMainLight();
    direction = mainLight.direction;
    color = mainLight.color;
    float4 shadowCoord = TransformWorldToShadowCoord(positionWS);
    ShadowSamplingData samplingData = GetMainLightShadowSamplingData();
    float shadowStrength = GetMainLightShadowStrength();
    shadowAttenuation = SampleShadowmap(shadowCoord, TEXTURE2D_ARGS(_MainLightShadowmapTexture, sampler_MainLightShadowmapTexture), samplingData, shadowStrength, false);
    #endif
}
void ShadeToonAdditionalLights_float(float3 normalWS, float3 positionWS, UnityTexture2D toonGrading, UnitySamplerState sState,
    float3 viewDirWS, half smoothness, out half3 diffuse, out half3 specular) {

    diffuse = (0, 0, 0);
    specular = (0, 0, 0);

#if !defined(SHADERGRAPH_PREVIEW)    
    int additionalLightCount = GetAdditionalLightsCount();

    [unroll(2)]
    for (int lightId = 0; lightId < additionalLightCount; lightId++) {

        Light additionalLight = GetAdditionalLight(lightId, positionWS);

        //Diffuse
        half halfLambert = dot(normalWS, additionalLight.direction) * 0.5 + 0.5;
        diffuse += SAMPLE_TEXTURE2D(toonGrading, sState, halfLambert) * additionalLight.color * additionalLight.distanceAttenuation;


        //Specular
        float3 h = normalize(additionalLight.direction + viewDirWS);
        half blinnPhong = max(0, dot(normalWS, h));

        blinnPhong = pow(blinnPhong, 50);
        blinnPhong = smoothstep(0.5, 0.6, blinnPhong);
        blinnPhong *= smoothness;
        specular += blinnPhong * additionalLight.color * additionalLight.distanceAttenuation;
    }
#endif
}

void Add_float(float a, float b,out float c)
{
    c = a + b;
}

#endif