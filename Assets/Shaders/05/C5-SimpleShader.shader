// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/C5/SimpleShader"
{
	SubShader{
		Pass{
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag

			//填充到POSITION, TANGENT, NORMAL 这些语义中的数据究竟是从哪里来的呢？
			//在Unity中，它们是由使用该材质的Mesh Render组件提供的。
			//模型{三角面s[三个顶点(顶点位置、法线、切线、纹理坐标、顶点颜色等)]}
			//在每帧调用Draw Call的时候Mesh Render组件会把它负责渲染的模型数据发送给Uruty Shader。

			//Application to VertexShader(从应用阶段传递到顶点着色器阶段)
			struct a2v{
				//POSITION语义告诉Unity， 用模型空间的顶点坐标填充vertex变量
				float4 vertex: POSITION;
				//NORMAL语义告诉Unity，用模型空间的法线方向填充normal变量
				float3 normal: NORMAL;
				//TEXCOORD0语义告诉Unity，用模型的第一套纹理坐标填充texcoord变量
				float4 texcoord: TEXCOORD0;
			};

			struct v2f{
				//SV_POSITION语义告诉Unity，pos里面包含了顶点在裁切空间中的位置信息
				float4 pos: SV_POSITION;
				//COLOR0语义可以用于存储颜色信息
				fixed3 color: COLOR0;
			};

			v2f vert(a2v v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				//v.normal包含了顶点的法线方向，其分量范围在[-1.0, 1.0];
				//下面的代码把分量范围映射到了[0.0, 1.0]
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
