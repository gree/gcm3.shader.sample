Shader "Custom/Bokeh"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255

		_ColorMask ("Color Mask", Float) = 15
		
		_OffsetX("OffsetX", float) = 0
		_OffsetY("OffsetY", float) = 0
	}

	SubShader
	{
		Tags
		{ 
			"Queue"="Transparent" 
			"IgnoreProjector"="True" 
			"RenderType"="Transparent" 
			"PreviewType"="Plane"
			"CanUseSpriteAtlas"="True"
		}
		
		Stencil
		{
			Ref [_Stencil]
			Comp [_StencilComp]
			Pass [_StencilOp] 
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
		}

		Cull Off
		Lighting Off
		ZWrite Off
		ZTest [unity_GUIZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask [_ColorMask]

		Pass
		{
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "UnityUI.cginc"
			
			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				half2 texcoord  : TEXCOORD0;
				float4 worldPosition : TEXCOORD1;
			};
			
			fixed4 _Color;
			fixed4 _TextureSampleAdd;
	
			bool _UseClipRect;
			float4 _ClipRect;

			bool _UseAlphaClip;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				OUT.worldPosition = IN.vertex;
				OUT.vertex = mul(UNITY_MATRIX_MVP, OUT.worldPosition);

				OUT.texcoord = IN.texcoord;
				
				#ifdef UNITY_HALF_TEXEL_OFFSET
				OUT.vertex.xy += (_ScreenParams.zw-1.0)*float2(-1,1);
				#endif
				
				OUT.color = IN.color * _Color;
				return OUT;
			}

			sampler2D _MainTex;
			
			fixed _OffsetX;
			fixed _OffsetY;
			
			fixed4 frag(v2f IN) : SV_Target
			{
				half offsetX = _OffsetX * 0.001;
				half offsetY = _OffsetY * 0.001;
				
				// Calculate Bokeh Level
				half2 uv0 = half2(IN.texcoord.x + offsetX, IN.texcoord.y + offsetY);
				half2 uv1 = half2(IN.texcoord.x + offsetX, IN.texcoord.y - offsetY);
				half2 uv2 = half2(IN.texcoord.x - offsetX, IN.texcoord.y - offsetY);
				half2 uv3 = half2(IN.texcoord.x - offsetX, IN.texcoord.y + offsetY);
				half4 bokeh = (tex2D(_MainTex, uv0) + tex2D(_MainTex, uv1) + tex2D(_MainTex, uv2) + tex2D(_MainTex, uv3)) * 0.25;
				
				// Masking
				fixed maskValue = lerp(0, 1, abs(sin(_Time.y * 10)));
				
				// Result
				fixed4 color = tex2D(_MainTex, IN.texcoord);
				color = (color * maskValue) + (bokeh * (1 - maskValue));
				color *= IN.color;
				
				
				if (_UseClipRect)
					color *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
				
				if (_UseAlphaClip)
					clip (color.a - 0.001);
					
				

				return color;
			}
		ENDCG
		}
	}
}
