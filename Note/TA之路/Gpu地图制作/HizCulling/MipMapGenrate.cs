using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MipMapGenrate : MonoBehaviour
{
   RenderTexture m_depthTexture;//带 mipmap 的深度图
    public RenderTexture depthTexture => m_depthTexture;

    int m_depthTextureSize = 0;
    public int depthTextureSize {
        get {
            if(m_depthTextureSize == 0)
                m_depthTextureSize = Mathf.NextPowerOfTwo(Mathf.Max(Screen.width, Screen.height));
            return m_depthTextureSize;
        }
        
    }

    const RenderTextureFormat m_depthTextureFormat = RenderTextureFormat.RHalf;//深度取值范围0-1，单通道即可。

    void InitDepthTexture() {
        if(m_depthTexture != null) return;
        m_depthTexture = new RenderTexture(depthTextureSize, depthTextureSize, 0, m_depthTextureFormat);
        m_depthTexture.autoGenerateMips = false;//Mipmap手动生成
        m_depthTexture.useMipMap = true;
        m_depthTexture.filterMode = FilterMode.Point;
        m_depthTexture.Create();
    }
    
    public Shader depthTextureShader;//用来生成mipmap的shader
    Material m_depthTextureMaterial;
    int m_depthTextureShaderID;

    void Start() {
        Camera.main.depthTextureMode |= DepthTextureMode.Depth;
        m_depthTextureMaterial = new Material(depthTextureShader);
        m_depthTextureShaderID = Shader.PropertyToID("_CameraDepthTexture");
    }

//生成mipmap
    void OnPostRender() {
        int w = m_depthTexture.width;
        int mipmapLevel = 0;

        RenderTexture currentRenderTexture = null;//当前mipmapLevel对应的mipmap
        RenderTexture preRenderTexture = null;//上一层的mipmap，即mipmapLevel-1对应的mipmap
    
        //如果当前的mipmap的宽高大于8，则计算下一层的mipmap
        while(w > 8) {
            currentRenderTexture = RenderTexture.GetTemporary(w, w, 0, m_depthTextureFormat);
            currentRenderTexture.filterMode = FilterMode.Point;
            if(preRenderTexture == null) {
                //Mipmap[0]即copy原始的深度图
                Graphics.Blit(Shader.GetGlobalTexture(m_depthTextureShaderID), currentRenderTexture);
            }
            else {
                //将Mipmap[i] Blit到Mipmap[i+1]上
                //在生成dest纹理时，Unity会调用我们设置的mat里的Shader，
                //并且把source设置到Shader的_MainTex属性中，这样我们就可以在Shader中针对source对dest纹理的每个像素进行自定义处理。
                //（也可以source传null，然后利用 Material.SetTexture 设置纹理）
                Graphics.Blit(preRenderTexture, currentRenderTexture, m_depthTextureMaterial);
                RenderTexture.ReleaseTemporary(preRenderTexture);
            }
            //Graphics.CopyTexture: 允许高效地将像素数据从一个纹理复制到另一个纹理。
            //它还允许从元素（例如立方体贴图面）或特定的 mip 级别以及纹理的子区域进行复制。
            //复制不会进行任何缩放，即源大小和目标大小必须相同
            Graphics.CopyTexture(currentRenderTexture, 0, 0, m_depthTexture, 0, mipmapLevel);
            preRenderTexture = currentRenderTexture;

            w /= 2;
            mipmapLevel++;
        }
        RenderTexture.ReleaseTemporary(preRenderTexture);
    }
}
