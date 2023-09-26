// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/C11/ScrollingBackground"
{
    Properties
    {
        _MainTex ("Base Layer", 2D) = "white" {}
        _DetailTex ("2nd Layer", 2D) = "white" {}
        _ScrollX ("Base Layer Scroll Speed", float) = 1.0
        _Scroll2X ("2nd Layer Scroll Speed", float) = 1.0
        _Multiplier ("Layer Multiplier", float) = 1
    }
    SubShader
    {
        Pass { 
			Tags { "LightMode"="ForwardBase" }
			
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			
			sampler2D _MainTex;
			sampler2D _DetailTex;
			float4 _MainTex_ST;
			float4 _DetailTex_ST;
			float _ScrollX;
			float _Scroll2X;
			float _Multiplier;
			
			struct a2v {
				float4 vertex : POSITION;
				float4 texcoord : TEXCOORD0;
			};
			
			struct v2f {
				float4 pos : SV_POSITION;
				float4 uv : TEXCOORD0;
			};
			
			v2f vert (a2v v) {
				v2f o;

				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex) + frac(float2(_ScrollX, 0.0) * _Time.y);
				o.uv.zw = TRANSFORM_TEX(v.texcoord, _DetailTex) + frac(float2(_Scroll2X, 0.0) * _Time.y);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target {
				fixed4 firstLayer = tex2D(_MainTex, i.uv.xy);
				fixed4 secondLayer = tex2D(_DetailTex, i.uv.zw);

				fixed4 c = lerp(firstLayer, secondLayer, secondLayer.a);
				c.rgb *= _Multiplier;

				return c;
			}
			
			ENDCG
		}
    }
    FallBack "VertexLit"
}
