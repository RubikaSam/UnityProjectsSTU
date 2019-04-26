// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "New Amplify Shader"
{
	Properties
	{
		_MaskIntensity("MaskIntensity", Float) = 1
		_Albedo("Albedo", 2D) = "bump" {}
		_AmbientOcclusion("Ambient Occlusion", 2D) = "white" {}
		_TilingRipple("TilingRipple", Range( 0 , 4)) = 1
		_Tint("Tint", Color) = (1,1,1,0)
		_TilingNormal("TilingNormal", Float) = 0
		_AlbedoNormal("AlbedoNormal", 2D) = "bump" {}
		_RippleNormal("RippleNormal", 2D) = "bump" {}
		_Wetness("Wetness", Float) = 1
		_Speed("Speed", Float) = 1
		_MaskSpeed("MaskSpeed", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _RippleNormal;
		uniform float _MaskIntensity;
		uniform float _MaskSpeed;
		uniform float _TilingRipple;
		uniform float _Speed;
		uniform sampler2D _AlbedoNormal;
		uniform float _TilingNormal;
		uniform sampler2D _Albedo;
		uniform sampler2D _AmbientOcclusion;
		uniform float4 _Tint;
		uniform float _Wetness;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float temp_output_35_0 = ( _Time.y * _MaskSpeed );
			float RippleTiling8 = _TilingRipple;
			float2 temp_cast_0 = (RippleTiling8).xx;
			float2 uv_TexCoord28 = i.uv_texcoord * temp_cast_0;
			float2 panner27 = ( temp_output_35_0 * float2( 1,1 ) + uv_TexCoord28);
			float simplePerlin2D26 = snoise( panner27 );
			float2 temp_cast_1 = (RippleTiling8).xx;
			float2 uv_TexCoord31 = i.uv_texcoord * temp_cast_1;
			float2 panner32 = ( temp_output_35_0 * float2( -1,-1 ) + uv_TexCoord31);
			float simplePerlin2D30 = snoise( panner32 );
			float RippleMask39 = ( _MaskIntensity * ( simplePerlin2D26 + simplePerlin2D30 ) );
			float2 temp_cast_2 = (RippleTiling8).xx;
			float2 uv_TexCoord2 = i.uv_texcoord * temp_cast_2;
			float2 appendResult3 = (float2(frac( uv_TexCoord2.x ) , frac( uv_TexCoord2.y )));
			float temp_output_4_0_g3 = 2.0;
			float temp_output_5_0_g3 = 2.0;
			float2 appendResult7_g3 = (float2(temp_output_4_0_g3 , temp_output_5_0_g3));
			float totalFrames39_g3 = ( temp_output_4_0_g3 * temp_output_5_0_g3 );
			float2 appendResult8_g3 = (float2(totalFrames39_g3 , temp_output_5_0_g3));
			float clampResult42_g3 = clamp( 0.0 , 0.0001 , ( totalFrames39_g3 - 1.0 ) );
			float temp_output_35_0_g3 = frac( ( ( ( _Time.y * _Speed ) + clampResult42_g3 ) / totalFrames39_g3 ) );
			float2 appendResult29_g3 = (float2(temp_output_35_0_g3 , ( 1.0 - temp_output_35_0_g3 )));
			float2 temp_output_15_0_g3 = ( ( appendResult3 / appendResult7_g3 ) + ( floor( ( appendResult8_g3 * appendResult29_g3 ) ) / appendResult7_g3 ) );
			float2 temp_cast_3 = (( RippleTiling8 / 0.6 )).xx;
			float2 uv_TexCoord13 = i.uv_texcoord * temp_cast_3;
			float2 appendResult16 = (float2(frac( uv_TexCoord13.x ) , frac( uv_TexCoord13.y )));
			float temp_output_4_0_g2 = 2.0;
			float temp_output_5_0_g2 = 2.0;
			float2 appendResult7_g2 = (float2(temp_output_4_0_g2 , temp_output_5_0_g2));
			float totalFrames39_g2 = ( temp_output_4_0_g2 * temp_output_5_0_g2 );
			float2 appendResult8_g2 = (float2(totalFrames39_g2 , temp_output_5_0_g2));
			float clampResult42_g2 = clamp( 0.0 , 0.0001 , ( totalFrames39_g2 - 1.0 ) );
			float temp_output_35_0_g2 = frac( ( ( _Time.y + clampResult42_g2 ) / totalFrames39_g2 ) );
			float2 appendResult29_g2 = (float2(temp_output_35_0_g2 , ( 1.0 - temp_output_35_0_g2 )));
			float2 temp_output_15_0_g2 = ( ( appendResult16 / appendResult7_g2 ) + ( floor( ( appendResult8_g2 * appendResult29_g2 ) ) / appendResult7_g2 ) );
			float3 RippleNormal23 = BlendNormals( UnpackScaleNormal( tex2D( _RippleNormal, temp_output_15_0_g3 ), RippleMask39 ) , UnpackScaleNormal( tex2D( _RippleNormal, temp_output_15_0_g2 ), RippleMask39 ) );
			float2 temp_cast_4 = (_TilingNormal).xx;
			float2 uv_TexCoord54 = i.uv_texcoord * temp_cast_4;
			float3 AlbedoNormal53 = UnpackNormal( tex2D( _AlbedoNormal, uv_TexCoord54 ) );
			o.Normal = BlendNormals( RippleNormal23 , AlbedoNormal53 );
			float4 tex2DNode44 = tex2D( _AmbientOcclusion, uv_TexCoord54 );
			float4 Albedo49 = ( ( float4( UnpackNormal( tex2D( _Albedo, uv_TexCoord54 ) ) , 0.0 ) * tex2DNode44 ) * ( tex2DNode44 * _Tint ) );
			o.Albedo = Albedo49.rgb;
			o.Smoothness = _Wetness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
1928;81;979;574;1868.386;11.20133;3.071421;True;True
Node;AmplifyShaderEditor.CommentaryNode;19;-1637.52,-61.29676;Float;False;580.1606;165.312;RippleTiling;2;7;8;RippleTiling;0.3679245,0.3679245,0.3679245,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1587.52,-10.98481;Float;False;Property;_TilingRipple;TilingRipple;3;0;Create;True;0;0;False;0;1;0;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;8;-1300.359,-11.29676;Float;False;RippleTiling;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;40;-1634.69,1491.343;Float;False;1859.368;615.3481;;14;32;28;31;27;29;34;33;35;26;36;30;37;38;39;RippleMask;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-1244.773,1819.54;Float;False;Property;_MaskSpeed;MaskSpeed;10;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;29;-1584.69,1776.499;Float;False;8;RippleTiling;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;33;-1259.202,1731.04;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-1140.457,1541.345;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-1047.407,1775.911;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-1141.316,1950.691;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;25;-1639.847,298.7193;Float;False;2033.119;990.0018;;20;9;20;2;13;5;10;11;4;14;15;16;3;12;17;1;22;6;18;21;41;RippleNormal;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;9;-1589.847,390.637;Float;False;8;RippleTiling;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;32;-880.99,1950.689;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-1,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;27;-880.1309,1541.343;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;26;-651.9953,1665.052;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;20;-1447.448,1105.795;Float;False;2;0;FLOAT;0;False;1;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;30;-647.5605,1831.361;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-396.5426,1624.024;Float;False;Property;_MaskIntensity;MaskIntensity;0;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1316.18,372.8723;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-399.9717,1744.039;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;13;-1309.05,1082.874;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;11;-1115.451,694.8107;Float;False;Property;_Speed;Speed;9;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-193.5321,1721.79;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;4;-1086.571,434.7592;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;5;-1089.925,355.8449;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;15;-1079.442,1144.761;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;14;-1082.796,1065.847;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;10;-1128.806,598.646;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;3;-966.8093,356.365;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-947.4531,630.0061;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;16;-959.6808,1066.367;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;39;-18.32142,1730.02;Float;False;RippleMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-2166.665,3180.059;Float;False;Property;_TilingNormal;TilingNormal;5;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;41;-332.6794,717.1774;Float;False;39;RippleMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;17;-758.1074,1065.134;Float;False;Flipbook;-1;;2;53c2488c220f6564ca6c90721ee16673;2,71,0,68,0;8;51;SAMPLER2D;0.0;False;13;FLOAT2;0,0;False;4;FLOAT;2;False;5;FLOAT;2;False;24;FLOAT;0;False;2;FLOAT;0;False;55;FLOAT;0;False;70;FLOAT;0;False;5;COLOR;53;FLOAT2;0;FLOAT;47;FLOAT;48;FLOAT;62
Node;AmplifyShaderEditor.TextureCoordinatesNode;54;-1969.127,3161.239;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;1;-765.2357,355.1317;Float;False;Flipbook;-1;;3;53c2488c220f6564ca6c90721ee16673;2,71,0,68,0;8;51;SAMPLER2D;0.0;False;13;FLOAT2;0,0;False;4;FLOAT;2;False;5;FLOAT;2;False;24;FLOAT;0;False;2;FLOAT;0;False;55;FLOAT;0;False;70;FLOAT;0;False;5;COLOR;53;FLOAT2;0;FLOAT;47;FLOAT;48;FLOAT;62
Node;AmplifyShaderEditor.TexturePropertyNode;22;-774.4226,685.3281;Float;True;Property;_RippleNormal;RippleNormal;7;0;Create;True;0;0;False;0;80eacbee8614e624c993df4cba17673c;80eacbee8614e624c993df4cba17673c;True;bump;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.CommentaryNode;50;-1643.795,2258.643;Float;False;1086.641;759.4412;Comment;7;43;44;46;45;47;48;49;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;56;-1646.214,3121.322;Float;False;619.0793;280;;2;52;53;NormalMap;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;6;-96.61488,352.3171;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;18;-89.48621,1062.319;Float;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;43;-1588.274,2308.643;Float;True;Property;_Albedo;Albedo;1;0;Create;True;0;0;False;0;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;44;-1583.518,2573.793;Float;True;Property;_AmbientOcclusion;Ambient Occlusion;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;46;-1555.146,2811.084;Float;False;Property;_Tint;Tint;4;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendNormalsNode;21;242.7612,752.8935;Float;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-1220.185,2503.73;Float;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;52;-1596.214,3171.322;Float;True;Property;_AlbedoNormal;AlbedoNormal;6;0;Create;True;0;0;False;0;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-1222.026,2792.679;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-1008.124,2643.432;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;477.6696,747.9244;Float;False;RippleNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-1271.135,3171.832;Float;False;AlbedoNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;24;532.1318,338.3681;Float;False;23;RippleNormal;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;-800.1544,2656.319;Float;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;541.746,537.575;Float;False;53;AlbedoNormal;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;59;782.4833,651.6223;Float;False;Property;_Wetness;Wetness;8;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;761.5435,327.8928;Float;False;49;Albedo;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendNormalsNode;58;761.9253,453.3164;Float;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;961.5079,387.6101;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;New Amplify Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;7;0
WireConnection;28;0;29;0
WireConnection;35;0;33;0
WireConnection;35;1;34;0
WireConnection;31;0;29;0
WireConnection;32;0;31;0
WireConnection;32;1;35;0
WireConnection;27;0;28;0
WireConnection;27;1;35;0
WireConnection;26;0;27;0
WireConnection;20;0;9;0
WireConnection;30;0;32;0
WireConnection;2;0;9;0
WireConnection;36;0;26;0
WireConnection;36;1;30;0
WireConnection;13;0;20;0
WireConnection;38;0;37;0
WireConnection;38;1;36;0
WireConnection;4;0;2;2
WireConnection;5;0;2;1
WireConnection;15;0;13;2
WireConnection;14;0;13;1
WireConnection;3;0;5;0
WireConnection;3;1;4;0
WireConnection;12;0;10;0
WireConnection;12;1;11;0
WireConnection;16;0;14;0
WireConnection;16;1;15;0
WireConnection;39;0;38;0
WireConnection;17;13;16;0
WireConnection;54;0;55;0
WireConnection;1;13;3;0
WireConnection;1;2;12;0
WireConnection;6;0;22;0
WireConnection;6;1;1;0
WireConnection;6;5;41;0
WireConnection;18;0;22;0
WireConnection;18;1;17;0
WireConnection;18;5;41;0
WireConnection;43;1;54;0
WireConnection;44;1;54;0
WireConnection;21;0;6;0
WireConnection;21;1;18;0
WireConnection;45;0;43;0
WireConnection;45;1;44;0
WireConnection;52;1;54;0
WireConnection;47;0;44;0
WireConnection;47;1;46;0
WireConnection;48;0;45;0
WireConnection;48;1;47;0
WireConnection;23;0;21;0
WireConnection;53;0;52;0
WireConnection;49;0;48;0
WireConnection;58;0;24;0
WireConnection;58;1;57;0
WireConnection;0;0;51;0
WireConnection;0;1;58;0
WireConnection;0;4;59;0
ASEEND*/
//CHKSM=93AEC294AD7569ABBA6A764056A074368E43EAE9