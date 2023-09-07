// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/C6/DiffuseVertexLevelMat"
{
    Properties
    {
        _Diffuse ("Diffuse", Color) = (1,1,1,1)
    }
    SubShader
    {
        Pass{
            Tags { "LightMode"="ForwardBase" }

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"

            fixed4 _Diffuse;

            struct a2v{
                float4 vertex: POSITION;
                float3 normal: NORMAL;
            };

            struct v2f{
                float4 pos: SV_POSITION;
                fixed3 color: COLOR;
            };

            v2f vert(a2v v){
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                //�õ�������
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                //������ŵ����������£�����Ӧ���ǣ�mul((float3x3)_Object2World, v.normal)��
                //��Ϊ��ʲô����Ҳ��֪��������Ҫ��һ��д������fixed3��v.normal�����о����
                fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
                //�õ����շ���
                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
                //�������㣬������ɫ������ķ�������ˣ��Ҳ���Ϊ����saturate
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));

                o.color = ambient + diffuse;
                return o;
            }

            fixed4 frag(v2f i):SV_Target{
                return fixed4(i.color,1);
            }

            ENDCG
        }
    }

    FallBack "Diffuse"
}