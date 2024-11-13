using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.Universal;

public class ValorantSmokeFogs : ScriptableRendererFeature
{
    [SerializeField] private RenderPassEvent passEvent;
    [SerializeField] private Material smokeFogMaterial;
    private ValorantSmokeFogPass _pass;
    public override void Create()
    {
        _pass = new ValorantSmokeFogPass(smokeFogMaterial);
        _pass.renderPassEvent = passEvent;

    }

    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
    {
        renderer.EnqueuePass(_pass);
    }
}
