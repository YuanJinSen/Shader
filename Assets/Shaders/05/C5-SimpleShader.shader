// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/C5/SimpleShader"
{
	SubShader{
		Pass{
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag

			//��䵽POSITION, TANGENT, NORMAL ��Щ�����е����ݾ����Ǵ����������أ�
			//��Unity�У���������ʹ�øò��ʵ�Mesh Render����ṩ�ġ�
			//ģ��{������s[��������(����λ�á����ߡ����ߡ��������ꡢ������ɫ��)]}
			//��ÿ֡����Draw Call��ʱ��Mesh Render��������������Ⱦ��ģ�����ݷ��͸�Uruty Shader��

			//Application to VertexShader(��Ӧ�ý׶δ��ݵ�������ɫ���׶�)
			struct a2v{
				//POSITION�������Unity�� ��ģ�Ϳռ�Ķ����������vertex����
				float4 vertex: POSITION;
				//NORMAL�������Unity����ģ�Ϳռ�ķ��߷������normal����
				float3 normal: NORMAL;
				//TEXCOORD0�������Unity����ģ�͵ĵ�һ�������������texcoord����
				float4 texcoord: TEXCOORD0;
			};

			struct v2f{
				//SV_POSITION�������Unity��pos��������˶����ڲ��пռ��е�λ����Ϣ
				float4 pos: SV_POSITION;
				//COLOR0����������ڴ洢��ɫ��Ϣ
				fixed3 color: COLOR0;
			};

			v2f vert(a2v v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				//v.normal�����˶���ķ��߷����������Χ��[-1.0, 1.0];
				//����Ĵ���ѷ�����Χӳ�䵽��[0.0, 1.0]
				o.color = v.normal * 0.5 + fixed3(0.5, 0.5, 0.5);
				return o;
			}

			fixed4 frag(v2f i): SV_Target{
				return fixed4(i.color,1.0);
			}

			ENDCG
		}
	}
}
