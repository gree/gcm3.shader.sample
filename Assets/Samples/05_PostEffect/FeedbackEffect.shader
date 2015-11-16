Shader "Custom/FeedbackEffect" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Alpha ("Scale", float) = 0.5
		_MaskTex ("Albedo (RGB)", 2D) = "black" {}
	}
	
	SubShader {
	
		ZTest Always Cull Off ZWrite Off
		
		Pass {
			Blend SrcAlpha OneMinusSrcAlpha
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision+hint_fastest
			#include "UnityCG.cginc"
	
			struct appdata {
				fixed4 vertex : POSITION;
				fixed2 texcoord : TEXCOORD0;
			};
	
			struct v2f {
				fixed4 vertex : POSITION;
				fixed2 texcoord : TEXCOORD0;
				fixed2 texcoordMask;
			};
			
			sampler2D _MainTex;
			sampler2D _MaskTex;
			fixed _Alpha;
			fixed4x4 _Matrix;
			
			v2f vert (appdata v)
			{		
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.texcoord = mul(_Matrix, fixed4(v.texcoord.xy, 0, 1));
				o.texcoordMask = v.texcoord;
				return o;
			}
	
			fixed4 frag (v2f i) : Color
			{
				fixed4 mask = tex2D(_MaskTex, i.texcoordMask);
				return fixed4(tex2D(_MainTex, i.texcoord).rgb, (1 - mask.r) * _Alpha);
			}
			ENDCG
		}
	}
}
