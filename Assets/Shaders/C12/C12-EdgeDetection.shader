// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/C12/EdgeDetection"
{
    Properties
    {
        _MainTex ("Main Tex", 2D) = "white" {}
        _EdgeOnly ("Edge Only", float) = 1
        _EdgeColor ("Edge Color", Color) = (1,1,1,1)
        _BackgroundColor ("Background Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Pass
        {
            ZTest Always Cull Off ZWrite Off

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            uniform half4 _MainTex_TexelSize;
            fixed _EdgeOnly;
            fixed4 _EdgeColor;
            fixed4 _BackgroundColor;

            struct v2f
            {
                float4 pos:SV_POSITION;
                half2 uv[9]:TEXCOORD0;
            };

            v2f vert(appdata_img v)
            {
                v2f o;

                o.pos = UnityObjectToClipPos(v.vertex);

                half2 uv = v.texcoord;
                
                o.uv[0] = uv + _MainTex_TexelSize.xy * half2(-1,-1);
                o.uv[1] = uv + _MainTex_TexelSize.xy * half2(0,-1);
                o.uv[2] = uv + _MainTex_TexelSize.xy * half2(1,-1);
                o.uv[3] = uv + _MainTex_TexelSize.xy * half2(-1,0);
                o.uv[4] = uv + _MainTex_TexelSize.xy * half2(0,0);
                o.uv[5] = uv + _MainTex_TexelSize.xy * half2(1,0);
                o.uv[6] = uv + _MainTex_TexelSize.xy * half2(-1,1);
                o.uv[7] = uv + _MainTex_TexelSize.xy * half2(0,1);
                o.uv[8] = uv + _MainTex_TexelSize.xy * half2(1,1);

                return o;
            }

            half Sobel(v2f i)
            {
                const half Gx[9] = {-1,0,1,
                                    -2,0,2,
                                    -1,0,1};
                const half Gy[9] = {-1,-2,-1,
                                    0 ,0 ,0,
                                    1 ,2 ,1};

                half texColor;
                half edgeX = 0;
                half edgeY = 0;
                fixed3 color;
                for(int it = 0;it < 9;it++)
                {
                    color = tex2D(_MainTex, i.uv[it]).rgb;
                    texColor = 0.2125 * color.r + 0.7154 * color.g + 0.0721 * color.b;
                    edgeX += texColor * Gx[it];
                    edgeY += texColor * Gy[it];
                }
                return 1 - abs(edgeX) - abs(edgeY);
            }

            fixed4 frag(v2f i):SV_Target
            {
                half edge = Sobel(i);

                fixed4 withEdgeColor = lerp(_EdgeColor, tex2D(_MainTex, i.uv[4]), edge);
                fixed4 onlyEdgeColor = lerp(_EdgeColor, _BackgroundColor, edge);

                return lerp(withEdgeColor, onlyEdgeColor ,_EdgeOnly);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
