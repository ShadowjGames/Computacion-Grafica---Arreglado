using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class ValorantSmokeFogPass : ScriptableRenderPass
{
    private RTHandle texture;
    private Material fogMaterial;

    public ValorantSmokeFogPass(Material fogMaterial)
    {
        this.fogMaterial = fogMaterial;
    }

    public override void Configure(CommandBuffer cmd, RenderTextureDescriptor cameraTextureDescriptor)
    {
        if (fogMaterial == null) return;
        RenderingUtils.ReAllocateIfNeeded(ref texture, cameraTextureDescriptor);
    }
    public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
    {
        if (fogMaterial == null) return;
        CommandBuffer cmd = CommandBufferPool.Get("Valorant Smoke Fogs");
        RTHandle screen = renderingData.cameraData.renderer.cameraColorTargetHandle;
        cmd.Blit(screen, texture);
        cmd.Blit(texture, screen, fogMaterial);
        context.ExecuteCommandBuffer(cmd);
        cmd.Release();
    }
}
