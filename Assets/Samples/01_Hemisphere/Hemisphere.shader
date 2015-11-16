Shader "Custom/Hemisphere" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_CurveZ ("Curve Z", float) = 0.001
		_CurveX ("Curve X", float) = 0.001
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Lambert vertex:vert

		sampler2D _MainTex;
		fixed _CurveZ;
		fixed _CurveX;

		struct Input {
			fixed2 uv_MainTex;
			fixed3 viewDir;
			fixed4 vertColor;
		};

		void vert( inout appdata_full v, out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input, o); // for dx3d environment
			
			// Modify Vert Position
			fixed4 worldPos = mul(_Object2World, v.vertex);
			worldPos.xyz -= _WorldSpaceCameraPos.xyz;
			worldPos = fixed4(0, (worldPos.z * worldPos.z) * -_CurveZ + (worldPos.x * worldPos.x) * -_CurveX , 0, 0);
			v.vertex += mul(_World2Object, worldPos);

			o.vertColor = v.color; // vert color
		}

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * IN.vertColor;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
}