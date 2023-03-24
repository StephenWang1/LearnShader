// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/EdgeDetection"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        //边缘颜色
        _EdgeColor ("EdgeColor", Color) = (0,0,0,1)
        //背景色
        _BackgroundColor ("BackgroundColor", Color) = (1,1,1,1)
        //是否只显示边缘
        _EdgeOnly ("EdgeOnly", Range(0,1)) = 0.5
    }
    SubShader
    {
        ZTest Always Cull Off ZWrite Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                half2 uv[9] : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            fixed4 _Color;
            //边缘颜色
            fixed4 _EdgeColor;
            //背景色
            fixed4 _BackgroundColor;
            //是否只显示边缘
            float _EdgeOnly;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            half4 _MainTex_TexelSize;
            fixed luminance(fixed4 color)
            {
                return color.r * 0.2125 + 0.7154 * color.g + 0.0721 * color.b;
            }

            half sober(v2f i)
            {
                const half Gx[9] = {
                    -1, -2, -1,
                    0, 0, 0,
                    1, 2, 1
                };
                const half Gy[9] = {
                    -1, 0, 1,
                    -2, 0, 2,
                    -1, 0, 1
                };
                float Gxm;
                float Gym;
                for (int it = 0; it < 9; it++)
                {
                    fixed4 color = tex2D(_MainTex, i.uv[it]);
                    float lumin = luminance(color);
                    Gxm += lumin * Gx[it];
                    Gym += lumin * Gy[it];
                }
                return 1 - abs(Gxm) - abs(Gym);
            }

            v2f vert(appdata v)
            {
                v2f o;
	o.vertex = UnityObjectToClipPos(v.vertex);
				
	half2 uv = v.uv;
				
	o.uv[0] = uv + _MainTex_TexelSize.xy * half2(-1, -1);
	o.uv[1] = uv + _MainTex_TexelSize.xy * half2(0, -1);
	o.uv[2] = uv + _MainTex_TexelSize.xy * half2(1, -1);
	o.uv[3] = uv + _MainTex_TexelSize.xy * half2(-1, 0);
	o.uv[4] = uv + _MainTex_TexelSize.xy * half2(0, 0);
	o.uv[5] = uv + _MainTex_TexelSize.xy * half2(1, 0);
	o.uv[6] = uv + _MainTex_TexelSize.xy * half2(-1, 1);
	o.uv[7] = uv + _MainTex_TexelSize.xy * half2(0, 1);
	o.uv[8] = uv + _MainTex_TexelSize.xy * half2(1, 1);
						 
	return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                half edge = sober(i);
                fixed4 withEdgeColor = lerp(_EdgeColor, tex2D(_MainTex, i.uv[4]), edge);
                fixed4 onlyEdgeColor = lerp(_EdgeColor, _BackgroundColor, edge);
                return lerp(withEdgeColor, onlyEdgeColor, _EdgeOnly);
            }
            ENDCG
        }
    }
}