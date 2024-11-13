using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class ValorantSmokeFog : VolumeComponent, IPostProcessComponent
{
    public ColorParameter FogColor = new ColorParameter(new Color(0.98f, 0.25f, 1f));
    public FloatParameter FogStart = new FloatParameter(5f);
    public FloatParameter FogSmoothness = new FloatParameter(5f);

    public bool IsActive() => FogColor.value.a > 0.05f;
    public bool IsTileCompatible() => false;
}