
//#Include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

void GetMainLight_float(out float3 direction, out float3 color){
	#if !defined(SHADERGRAPH_PREVIEW)
	Light light;
	Light = GetMainLight();
	direction = Light.direction;
	color = Light.color;
	#else
	direction = float3(1, 1, -1);
	color = 1;
	#endif
}