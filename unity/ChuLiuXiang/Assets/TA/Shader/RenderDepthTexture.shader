﻿Shader "Hidden/ShadowMap" {
 Properties 
 {
	 _MainTex("主贴图", 2D) = "white" {}
 }
 SubShader{
	 Tags{ "RenderType" = "Opaque" }

	 Pass{
	 CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#include "UnityCG.cginc"


		 struct v2f {
		 float4 position : SV_POSITION;
		 fixed depth : TEXCOORD0;
		 float4 spos:TEXCOORD1;
	 };


	 v2f vert(appdata_base v)
	 {
		 v2f o;
		 o.position = mul(UNITY_MATRIX_MVP, v.vertex);
		 o.depth = COMPUTE_DEPTH_01;
		 o.spos = o.position;
		 return o;
	 }

	 float4 frag(v2f IN) : COLOR
	 {
		 float f = min(IN.depth,0.9999991);
 
		 clip(0.95f - abs(IN.spos.x));
		 clip(0.95f - abs(IN.spos.y));
 
			return (EncodeFloatRGBA(f)); 
	 }


		 ENDCG
	 }
 }


SubShader{
	 Tags{ "RenderType" = "Transparent" }

	 Pass{
	 CGPROGRAM
	 #pragma vertex vert
	 #pragma fragment frag
	 #include "UnityCG.cginc"
 
	struct v2f {
		 float4 position : SV_POSITION;
		 fixed depth : TEXCOORD0;
		 float2 uv : TEXCOORD1;
		 float4 spos:TEXCOORD2;
	 };
	 sampler2D _MainTex;
	 half4 _MainTex_ST;

	 struct appdata {
		 float4 vertex : POSITION;
		 float4 uv : TEXCOORD0;
		 
	 };

	 v2f vert(appdata v)
	 {
		 v2f o;
		 o.position = mul(UNITY_MATRIX_MVP, v.vertex);
		 o.depth = COMPUTE_DEPTH_01;
		 o.uv = TRANSFORM_TEX(v.uv, _MainTex);
		 o.spos = o.position;
		 return o;
	 }

	 float4 frag(v2f IN) : COLOR
	 {
		 fixed4 col = tex2D(_MainTex, IN.uv);
		 clip(0.95f - abs(IN.spos.x));
		 clip(0.95f - abs(IN.spos.y));

		 float f = min(IN.depth,0.9999991);
		 //return f;
		 return (EncodeFloatRGBA(f));
	 }


		 ENDCG
	 }
 }


SubShader{
		 Tags{ "RenderType" = "AlphaTest" }

		 Pass{
		 CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"

		 struct v2f {
		 float4 position : SV_POSITION;
		 fixed depth : TEXCOORD0;
		 float2 uv : TEXCOORD1;
		 float4 spos:TEXCOORD2;
	 };
	 sampler2D _MainTex;
	 half4 _MainTex_ST;

	 struct appdata {
		 float4 vertex : POSITION;
		 float4 uv : TEXCOORD0;

	 };

	 v2f vert(appdata v)
	 {
		 v2f o;
		 o.position = mul(UNITY_MATRIX_MVP, v.vertex);
		 o.depth = COMPUTE_DEPTH_01;
		 o.uv = TRANSFORM_TEX(v.uv, _MainTex);
		 o.spos = o.position;
		 return o;
	 }

	 float4 frag(v2f IN) : COLOR
	 {
		 fixed4 col = tex2D(_MainTex, IN.uv);
			clip(col.a - 0.5);
			//clip(abs(0.9-IN.spos.x));
			clip(0.95f - abs(IN.spos.x));
			clip(0.95f - abs(IN.spos.y));

	 float f = min(IN.depth,0.9999991);
	 //return f;
	 return (EncodeFloatRGBA(f));
	 }


		 ENDCG
	 }
}

 
}