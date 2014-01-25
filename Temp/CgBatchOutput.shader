// FogOfWar shader
// Copyright (C) 2013 Sergey Taraban <http://staraban.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
 
Shader "Custom/FogOfWar" {
Properties {
    _Color ("Main Color", Color) = (1,1,1,1)
    _MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
    _FogRadius ("FogRadius", Float) = 1.0
    _FogMaxRadius("FogMaxRadius", Float) = 0.5
    _Player1_Pos ("_Player1_Pos", Vector) = (0,0,0,1)
}
 
SubShader {
    Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
    LOD 200
    Blend SrcAlpha OneMinusSrcAlpha
    Cull Off
 
    	
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }
Program "vp" {
// Vertex combos: 12
//   opengl - ALU: 9 to 65
//   d3d9 - ALU: 9 to 65
//   d3d11 - ALU: 10 to 51, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 10 to 51, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [unity_SHAr]
Vector 10 [unity_SHAg]
Vector 11 [unity_SHAb]
Vector 12 [unity_SHBr]
Vector 13 [unity_SHBg]
Vector 14 [unity_SHBb]
Vector 15 [unity_SHC]
Matrix 5 [_Object2World]
Vector 16 [unity_Scale]
Vector 17 [_MainTex_ST]
"!!ARBvp1.0
# 30 ALU
PARAM c[18] = { { 1 },
		state.matrix.mvp,
		program.local[5..17] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[16].w;
DP3 R3.w, R1, c[6];
DP3 R2.w, R1, c[7];
DP3 R0.x, R1, c[5];
MOV R0.y, R3.w;
MOV R0.z, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[11];
DP4 R2.y, R0, c[10];
DP4 R2.x, R0, c[9];
MUL R0.y, R3.w, R3.w;
MAD R0.y, R0.x, R0.x, -R0;
MOV result.texcoord[2].x, R0;
DP4 R3.z, R1, c[14];
DP4 R3.y, R1, c[13];
DP4 R3.x, R1, c[12];
MUL R1.xyz, R0.y, c[15];
ADD R2.xyz, R2, R3;
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[7];
ADD result.texcoord[3].xyz, R2, R1;
MOV result.texcoord[2].z, R2.w;
MOV result.texcoord[2].y, R3.w;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[17], c[17].zwzw;
MOV result.texcoord[1].xy, R0;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 30 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_SHAr]
Vector 9 [unity_SHAg]
Vector 10 [unity_SHAb]
Vector 11 [unity_SHBr]
Vector 12 [unity_SHBg]
Vector 13 [unity_SHBb]
Vector 14 [unity_SHC]
Matrix 4 [_Object2World]
Vector 15 [unity_Scale]
Vector 16 [_MainTex_ST]
"vs_2_0
; 30 ALU
def c17, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c15.w
dp3 r3.w, r1, c5
dp3 r2.w, r1, c6
dp3 r0.x, r1, c4
mov r0.y, r3.w
mov r0.z, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c17.x
dp4 r2.z, r0, c10
dp4 r2.y, r0, c9
dp4 r2.x, r0, c8
mul r0.y, r3.w, r3.w
mad r0.y, r0.x, r0.x, -r0
mov oT2.x, r0
dp4 r3.z, r1, c13
dp4 r3.y, r1, c12
dp4 r3.x, r1, c11
mul r1.xyz, r0.y, c14
add r2.xyz, r2, r3
dp4 r0.x, v0, c4
dp4 r0.y, v0, c6
add oT3.xyz, r2, r1
mov oT2.z, r2.w
mov oT2.y, r3.w
mad oT0.xy, v2, c16, c16.zwzw
mov oT1.xy, r0
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 144 // 144 used size, 10 vars
Vector 128 [_MainTex_ST] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 27 instructions, 4 temp regs, 0 temp arrays:
// ALU 24 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedicfbamafbeanmcnpjgihkidjihmpcnffabaaaaaalmafaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefccaaeaaaaeaaaabaa
aiabaaaafjaaaaaeegiocaaaaaaaaaaaajaaaaaafjaaaaaeegiocaaaabaaaaaa
cnaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagiaaaaacaeaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
acaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaidcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaigiacaaaacaaaaaaanaaaaaadcaaaaakdcaabaaa
aaaaaaaaigiacaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegaabaaaaaaaaaaa
dcaaaaakdcaabaaaaaaaaaaaigiacaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egaabaaaaaaaaaaadcaaaaakmccabaaaabaaaaaaagiicaaaacaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaagaebaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaaiaaaaaaogikcaaaaaaaaaaaaiaaaaaadiaaaaai
hcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaacaaaaaabeaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
lcaabaaaaaaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaa
abaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaa
aaaaaaaaegadbaaaaaaaaaaadgaaaaafhccabaaaacaaaaaaegacbaaaaaaaaaaa
dgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaabaaaaaa
egiocaaaabaaaaaacgaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaaabaaaaaa
egiocaaaabaaaaaachaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaaabaaaaaa
egiocaaaabaaaaaaciaaaaaaegaobaaaaaaaaaaadiaaaaahpcaabaaaacaaaaaa
jgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaa
abaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaa
abaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaa
abaaaaaaclaaaaaaegaobaaaacaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaa
abaaaaaaegacbaaaadaaaaaadiaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaa
bkaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaa
aaaaaaaabkaabaiaebaaaaaaaaaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaa
abaaaaaacmaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal_8;
  normal_8 = tmpvar_6;
  highp float vC_9;
  mediump vec3 x3_10;
  mediump vec3 x2_11;
  mediump vec3 x1_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal_8);
  x1_12.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal_8);
  x1_12.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal_8);
  x1_12.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal_8.xyzz * normal_8.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2_11.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2_11.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2_11.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal_8.x * normal_8.x) - (normal_8.y * normal_8.y));
  vC_9 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC_9);
  x3_10 = tmpvar_21;
  tmpvar_7 = ((x1_12 + x2_11) + x3_10);
  shlight_1 = tmpvar_7;
  tmpvar_3 = shlight_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp float tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_4;
  arg0_4 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_5;
  arg0_5 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_6;
  arg0_6 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_7;
  tmpvar_7 = (1.0 - (((tmpvar_3.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_4, arg0_4))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_5, arg0_5))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_2 = tmpvar_7;
  lowp vec4 c_8;
  c_8.xyz = ((tmpvar_3.xyz * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz)) * 2.0));
  c_8.w = tmpvar_2;
  c_1.w = c_8.w;
  c_1.xyz = (c_8.xyz + (tmpvar_3.xyz * xlv_TEXCOORD3));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal_8;
  normal_8 = tmpvar_6;
  highp float vC_9;
  mediump vec3 x3_10;
  mediump vec3 x2_11;
  mediump vec3 x1_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal_8);
  x1_12.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal_8);
  x1_12.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal_8);
  x1_12.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal_8.xyzz * normal_8.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2_11.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2_11.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2_11.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal_8.x * normal_8.x) - (normal_8.y * normal_8.y));
  vC_9 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC_9);
  x3_10 = tmpvar_21;
  tmpvar_7 = ((x1_12 + x2_11) + x3_10);
  shlight_1 = tmpvar_7;
  tmpvar_3 = shlight_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp float tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_4;
  arg0_4 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_5;
  arg0_5 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_6;
  arg0_6 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_7;
  tmpvar_7 = (1.0 - (((tmpvar_3.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_4, arg0_4))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_5, arg0_5))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_2 = tmpvar_7;
  lowp vec4 c_8;
  c_8.xyz = ((tmpvar_3.xyz * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz)) * 2.0));
  c_8.w = tmpvar_2;
  c_1.w = c_8.w;
  c_1.xyz = (c_8.xyz + (tmpvar_3.xyz * xlv_TEXCOORD3));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_SHAr]
Vector 9 [unity_SHAg]
Vector 10 [unity_SHAb]
Vector 11 [unity_SHBr]
Vector 12 [unity_SHBg]
Vector 13 [unity_SHBb]
Vector 14 [unity_SHC]
Matrix 4 [_Object2World]
Vector 15 [unity_Scale]
Vector 16 [_MainTex_ST]
"agal_vs
c17 1.0 0.0 0.0 0.0
[bc]
adaaaaaaabaaahacabaaaaoeaaaaaaaaapaaaappabaaaaaa mul r1.xyz, a1, c15.w
bcaaaaaaadaaaiacabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r3.w, r1.xyzz, c5
bcaaaaaaacaaaiacabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r2.w, r1.xyzz, c6
bcaaaaaaaaaaabacabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r0.x, r1.xyzz, c4
aaaaaaaaaaaaacacadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.y, r3.w
aaaaaaaaaaaaaeacacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.z, r2.w
adaaaaaaabaaapacaaaaaakeacaaaaaaaaaaaacjacaaaaaa mul r1, r0.xyzz, r0.yzzx
aaaaaaaaaaaaaiacbbaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c17.x
bdaaaaaaacaaaeacaaaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r2.z, r0, c10
bdaaaaaaacaaacacaaaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r2.y, r0, c9
bdaaaaaaacaaabacaaaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r2.x, r0, c8
adaaaaaaaaaaacacadaaaappacaaaaaaadaaaappacaaaaaa mul r0.y, r3.w, r3.w
adaaaaaaaeaaacacaaaaaaaaacaaaaaaaaaaaaaaacaaaaaa mul r4.y, r0.x, r0.x
acaaaaaaaaaaacacaeaaaaffacaaaaaaaaaaaaffacaaaaaa sub r0.y, r4.y, r0.y
aaaaaaaaacaaabaeaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov v2.x, r0.x
bdaaaaaaadaaaeacabaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 r3.z, r1, c13
bdaaaaaaadaaacacabaaaaoeacaaaaaaamaaaaoeabaaaaaa dp4 r3.y, r1, c12
bdaaaaaaadaaabacabaaaaoeacaaaaaaalaaaaoeabaaaaaa dp4 r3.x, r1, c11
adaaaaaaabaaahacaaaaaaffacaaaaaaaoaaaaoeabaaaaaa mul r1.xyz, r0.y, c14
abaaaaaaacaaahacacaaaakeacaaaaaaadaaaakeacaaaaaa add r2.xyz, r2.xyzz, r3.xyzz
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.y, a0, c6
abaaaaaaadaaahaeacaaaakeacaaaaaaabaaaakeacaaaaaa add v3.xyz, r2.xyzz, r1.xyzz
aaaaaaaaacaaaeaeacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v2.z, r2.w
aaaaaaaaacaaacaeadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v2.y, r3.w
adaaaaaaaeaaadacadaaaaoeaaaaaaaabaaaaaoeabaaaaaa mul r4.xy, a3, c16
abaaaaaaaaaaadaeaeaaaafeacaaaaaabaaaaaooabaaaaaa add v0.xy, r4.xyyy, c16.zwzw
aaaaaaaaabaaadaeaaaaaafeacaaaaaaaaaaaaaaaaaaaaaa mov v1.xy, r0.xyyy
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 144 // 144 used size, 10 vars
Vector 128 [_MainTex_ST] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 27 instructions, 4 temp regs, 0 temp arrays:
// ALU 24 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedjeddneklgoafmpkjjdfmjfnjioaklpcmabaaaaaafeaiaaaaaeaaaaaa
daaaaaaameacaaaaomagaaaaleahaaaaebgpgodjimacaaaaimacaaaaaaacpopp
ciacaaaageaaaaaaafaaceaaaaaagaaaaaaagaaaaaaaceaaabaagaaaaaaaaiaa
abaaabaaaaaaaaaaabaacgaaahaaacaaaaaaaaaaacaaaaaaaeaaajaaaaaaaaaa
acaaamaaaeaaanaaaaaaaaaaacaabeaaabaabbaaaaaaaaaaaaaaaaaaaaacpopp
fbaaaaafbcaaapkaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaabpaaaaacafaaaaia
aaaaapjabpaaaaacafaaaciaacaaapjabpaaaaacafaaadiaadaaapjaafaaaaad
aaaaadiaaaaaffjaaoaaockaaeaaaaaeaaaaadiaanaaockaaaaaaajaaaaaoeia
aeaaaaaeaaaaadiaapaaockaaaaakkjaaaaaoeiaaeaaaaaeaaaaamoabaaaceka
aaaappjaaaaaeeiaaeaaaaaeaaaaadoaadaaoejaabaaoekaabaaookaafaaaaad
aaaaahiaacaaoejabbaappkaafaaaaadabaaahiaaaaaffiaaoaaoekaaeaaaaae
aaaaaliaanaakekaaaaaaaiaabaakeiaaeaaaaaeaaaaahiaapaaoekaaaaakkia
aaaapeiaabaaaaacaaaaaiiabcaaaakaajaaaaadabaaabiaacaaoekaaaaaoeia
ajaaaaadabaaaciaadaaoekaaaaaoeiaajaaaaadabaaaeiaaeaaoekaaaaaoeia
afaaaaadacaaapiaaaaacjiaaaaakeiaajaaaaadadaaabiaafaaoekaacaaoeia
ajaaaaadadaaaciaagaaoekaacaaoeiaajaaaaadadaaaeiaahaaoekaacaaoeia
acaaaaadabaaahiaabaaoeiaadaaoeiaafaaaaadaaaaaiiaaaaaffiaaaaaffia
aeaaaaaeaaaaaiiaaaaaaaiaaaaaaaiaaaaappibabaaaaacabaaahoaaaaaoeia
aeaaaaaeacaaahoaaiaaoekaaaaappiaabaaoeiaafaaaaadaaaaapiaaaaaffja
akaaoekaaeaaaaaeaaaaapiaajaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapia
alaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaamaaoekaaaaappjaaaaaoeia
aeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeia
ppppaaaafdeieefccaaeaaaaeaaaabaaaiabaaaafjaaaaaeegiocaaaaaaaaaaa
ajaaaaaafjaaaaaeegiocaaaabaaaaaacnaaaaaafjaaaaaeegiocaaaacaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
hccabaaaadaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaaidcaabaaaaaaaaaaafgbfbaaaaaaaaaaaigiacaaa
acaaaaaaanaaaaaadcaaaaakdcaabaaaaaaaaaaaigiacaaaacaaaaaaamaaaaaa
agbabaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaakdcaabaaaaaaaaaaaigiacaaa
acaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaakmccabaaa
abaaaaaaagiicaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaagaebaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaaiaaaaaa
ogikcaaaaaaaaaaaaiaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaa
pgipcaaaacaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaacaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaacaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaaf
hccabaaaacaaaaaaegacbaaaaaaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaa
aaaaiadpbbaaaaaibcaabaaaabaaaaaaegiocaaaabaaaaaacgaaaaaaegaobaaa
aaaaaaaabbaaaaaiccaabaaaabaaaaaaegiocaaaabaaaaaachaaaaaaegaobaaa
aaaaaaaabbaaaaaiecaabaaaabaaaaaaegiocaaaabaaaaaaciaaaaaaegaobaaa
aaaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaa
bbaaaaaibcaabaaaadaaaaaaegiocaaaabaaaaaacjaaaaaaegaobaaaacaaaaaa
bbaaaaaiccaabaaaadaaaaaaegiocaaaabaaaaaackaaaaaaegaobaaaacaaaaaa
bbaaaaaiecaabaaaadaaaaaaegiocaaaabaaaaaaclaaaaaaegaobaaaacaaaaaa
aaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaah
ccaabaaaaaaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaakbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaa
dcaaaaakhccabaaaadaaaaaaegiccaaaabaaaaaacmaaaaaaagaabaaaaaaaaaaa
egacbaaaabaaaaaadoaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 398
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    lowp vec3 normal;
    lowp vec3 vlight;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 393
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 397
uniform highp vec4 _Player3_Pos;
#line 405
#line 419
#line 433
uniform highp vec4 _MainTex_ST;
#line 449
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 405
void vert( inout appdata_full vertexData, out Input outData ) {
    highp vec4 pos = (glstate_matrix_mvp * vertexData.vertex);
    highp vec4 posWorld = (_Object2World * vertexData.vertex);
    #line 409
    outData.uv_MainTex = vec2( vertexData.texcoord);
    outData.location = posWorld.xz;
}
#line 434
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 437
    Input customInputData;
    vert( v, customInputData);
    o.cust_location = customInputData.location;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 441
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 shlight = ShadeSH9( vec4( worldN, 1.0));
    #line 445
    o.vlight = shlight;
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out lowp vec3 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.pack0);
    xlv_TEXCOORD1 = vec2(xl_retval.cust_location);
    xlv_TEXCOORD2 = vec3(xl_retval.normal);
    xlv_TEXCOORD3 = vec3(xl_retval.vlight);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 398
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    lowp vec3 normal;
    lowp vec3 vlight;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 393
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 397
uniform highp vec4 _Player3_Pos;
#line 405
#line 419
#line 433
uniform highp vec4 _MainTex_ST;
#line 449
#line 338
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp vec4 c;
    #line 342
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.0));
    c.w = s.Alpha;
    return c;
}
#line 419
highp float powerForPos( in highp vec4 pos, in highp vec2 nearVertex ) {
    highp float atten = clamp( (_FogRadius - length((pos.xz - nearVertex.xy))), 0.0, _FogRadius);
    return (((1.0 / _FogMaxRadius) * atten) / _FogRadius);
}
#line 412
void surf( in Input IN, inout SurfaceOutput o ) {
    #line 414
    lowp vec4 baseColor = (texture( _MainTex, IN.uv_MainTex) * _Color);
    highp float alpha = (1.0 - (((baseColor.w + powerForPos( _Player1_Pos, IN.location)) + powerForPos( _Player2_Pos, IN.location)) + powerForPos( _Player3_Pos, IN.location)));
    o.Albedo = baseColor.xyz;
    o.Alpha = alpha;
}
#line 449
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    #line 453
    surfIN.location = IN.cust_location;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 457
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    #line 461
    surf( surfIN, o);
    lowp float atten = 1.0;
    lowp vec4 c = vec4( 0.0);
    c = LightingLambert( o, _WorldSpaceLightPos0.xyz, atten);
    #line 465
    c.xyz += (o.Albedo * IN.vlight);
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in lowp vec3 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec2(xlv_TEXCOORD0);
    xlt_IN.cust_location = vec2(xlv_TEXCOORD1);
    xlt_IN.normal = vec3(xlv_TEXCOORD2);
    xlt_IN.vlight = vec3(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 5 [_Object2World]
Vector 9 [unity_LightmapST]
Vector 10 [_MainTex_ST]
"!!ARBvp1.0
# 9 ALU
PARAM c[11] = { program.local[0],
		state.matrix.mvp,
		program.local[5..10] };
TEMP R0;
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[7];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[10], c[10].zwzw;
MOV result.texcoord[1].xy, R0;
MAD result.texcoord[2].xy, vertex.texcoord[1], c[9], c[9].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 9 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [unity_LightmapST]
Vector 9 [_MainTex_ST]
"vs_2_0
; 9 ALU
dcl_position0 v0
dcl_texcoord0 v2
dcl_texcoord1 v3
dp4 r0.x, v0, c4
dp4 r0.y, v0, c6
mad oT0.xy, v2, c9, c9.zwzw
mov oT1.xy, r0
mad oT2.xy, v3, c8, c8.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 160 // 160 used size, 11 vars
Vector 128 [unity_LightmapST] 4
Vector 144 [_MainTex_ST] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
// 11 instructions, 1 temp regs, 0 temp arrays:
// ALU 10 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedgembbahjedhpgaonghhmedggpbodhomfabaaaaaajiadaaaaadaaaaaa
cmaaaaaapeaaaaaahmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaa
adamaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
beacaaaaeaaaabaaifaaaaaafjaaaaaeegiocaaaaaaaaaaaakaaaaaafjaaaaae
egiocaaaabaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaa
adaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaaddccabaaa
acaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaaidcaabaaaaaaaaaaafgbfbaaaaaaaaaaaigiacaaaabaaaaaa
anaaaaaadcaaaaakdcaabaaaaaaaaaaaigiacaaaabaaaaaaamaaaaaaagbabaaa
aaaaaaaaegaabaaaaaaaaaaadcaaaaakdcaabaaaaaaaaaaaigiacaaaabaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaakmccabaaaabaaaaaa
agiicaaaabaaaaaaapaaaaaapgbpbaaaaaaaaaaaagaebaaaaaaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaajaaaaaaogikcaaa
aaaaaaaaajaaaaaadcaaaaaldccabaaaacaaaaaaegbabaaaaeaaaaaaegiacaaa
aaaaaaaaaiaaaaaaogikcaaaaaaaaaaaaiaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
void main ()
{
  lowp vec4 c_1;
  lowp float tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_4;
  arg0_4 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_5;
  arg0_5 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_6;
  arg0_6 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_7;
  tmpvar_7 = (1.0 - (((tmpvar_3.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_4, arg0_4))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_5, arg0_5))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_2 = tmpvar_7;
  c_1.xyz = (tmpvar_3.xyz * (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD2).xyz));
  c_1.w = tmpvar_2;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
void main ()
{
  lowp vec4 c_1;
  lowp float tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_4;
  arg0_4 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_5;
  arg0_5 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_6;
  arg0_6 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_7;
  tmpvar_7 = (1.0 - (((tmpvar_3.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_4, arg0_4))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_5, arg0_5))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_2 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  c_1.xyz = (tmpvar_3.xyz * ((8.0 * tmpvar_8.w) * tmpvar_8.xyz));
  c_1.w = tmpvar_2;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [unity_LightmapST]
Vector 9 [_MainTex_ST]
"agal_vs
[bc]
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.y, a0, c6
adaaaaaaaaaaamacadaaaaoeaaaaaaaaajaaaaoeabaaaaaa mul r0.zw, a3, c9
abaaaaaaaaaaadaeaaaaaapoacaaaaaaajaaaaooabaaaaaa add v0.xy, r0.zwww, c9.zwzw
aaaaaaaaabaaadaeaaaaaafeacaaaaaaaaaaaaaaaaaaaaaa mov v1.xy, r0.xyyy
adaaaaaaaaaaadacaeaaaaoeaaaaaaaaaiaaaaoeabaaaaaa mul r0.xy, a4, c8
abaaaaaaacaaadaeaaaaaafeacaaaaaaaiaaaaooabaaaaaa add v2.xy, r0.xyyy, c8.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
aaaaaaaaacaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.zw, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 160 // 160 used size, 11 vars
Vector 128 [unity_LightmapST] 4
Vector 144 [_MainTex_ST] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
// 11 instructions, 1 temp regs, 0 temp arrays:
// ALU 10 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedoanjkljkhegaedhpgdabakjigaihlodfabaaaaaapmaeaaaaaeaaaaaa
daaaaaaajaabaaaakmadaaaaheaeaaaaebgpgodjfiabaaaafiabaaaaaaacpopp
amabaaaaemaaaaaaadaaceaaaaaaeiaaaaaaeiaaaaaaceaaabaaeiaaaaaaaiaa
acaaabaaaaaaaaaaabaaaaaaaeaaadaaaaaaaaaaabaaamaaaeaaahaaaaaaaaaa
aaaaaaaaaaacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaadiaadaaapja
bpaaaaacafaaaeiaaeaaapjaafaaaaadaaaaadiaaaaaffjaaiaaockaaeaaaaae
aaaaadiaahaaockaaaaaaajaaaaaoeiaaeaaaaaeaaaaadiaajaaockaaaaakkja
aaaaoeiaaeaaaaaeaaaaamoaakaacekaaaaappjaaaaaeeiaaeaaaaaeaaaaadoa
adaaoejaacaaoekaacaaookaaeaaaaaeabaaadoaaeaaoejaabaaoekaabaaooka
afaaaaadaaaaapiaaaaaffjaaeaaoekaaeaaaaaeaaaaapiaadaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaapiaafaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapia
agaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeia
abaaaaacaaaaammaaaaaoeiappppaaaafdeieefcbeacaaaaeaaaabaaifaaaaaa
fjaaaaaeegiocaaaaaaaaaaaakaaaaaafjaaaaaeegiocaaaabaaaaaabaaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaa
aeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaa
gfaaaaadmccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagiaaaaacabaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
abaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaidcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaigiacaaaabaaaaaaanaaaaaadcaaaaakdcaabaaa
aaaaaaaaigiacaaaabaaaaaaamaaaaaaagbabaaaaaaaaaaaegaabaaaaaaaaaaa
dcaaaaakdcaabaaaaaaaaaaaigiacaaaabaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egaabaaaaaaaaaaadcaaaaakmccabaaaabaaaaaaagiicaaaabaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaagaebaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaajaaaaaaogikcaaaaaaaaaaaajaaaaaadcaaaaal
dccabaaaacaaaaaaegbabaaaaeaaaaaaegiacaaaaaaaaaaaaiaaaaaaogikcaaa
aaaaaaaaaiaaaaaadoaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaa
adamaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 398
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    highp vec2 lmap;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 393
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 397
uniform highp vec4 _Player3_Pos;
#line 405
#line 419
#line 432
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform sampler2D unity_Lightmap;
#line 405
void vert( inout appdata_full vertexData, out Input outData ) {
    highp vec4 pos = (glstate_matrix_mvp * vertexData.vertex);
    highp vec4 posWorld = (_Object2World * vertexData.vertex);
    #line 409
    outData.uv_MainTex = vec2( vertexData.texcoord);
    outData.location = posWorld.xz;
}
#line 434
v2f_surf vert_surf( in appdata_full v ) {
    #line 436
    v2f_surf o;
    Input customInputData;
    vert( v, customInputData);
    o.cust_location = customInputData.location;
    #line 440
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    #line 445
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
out highp vec2 xlv_TEXCOORD2;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.pack0);
    xlv_TEXCOORD1 = vec2(xl_retval.cust_location);
    xlv_TEXCOORD2 = vec2(xl_retval.lmap);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 398
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    highp vec2 lmap;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 393
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 397
uniform highp vec4 _Player3_Pos;
#line 405
#line 419
#line 432
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform sampler2D unity_Lightmap;
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 419
highp float powerForPos( in highp vec4 pos, in highp vec2 nearVertex ) {
    highp float atten = clamp( (_FogRadius - length((pos.xz - nearVertex.xy))), 0.0, _FogRadius);
    return (((1.0 / _FogMaxRadius) * atten) / _FogRadius);
}
#line 412
void surf( in Input IN, inout SurfaceOutput o ) {
    #line 414
    lowp vec4 baseColor = (texture( _MainTex, IN.uv_MainTex) * _Color);
    highp float alpha = (1.0 - (((baseColor.w + powerForPos( _Player1_Pos, IN.location)) + powerForPos( _Player2_Pos, IN.location)) + powerForPos( _Player3_Pos, IN.location)));
    o.Albedo = baseColor.xyz;
    o.Alpha = alpha;
}
#line 448
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 450
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.location = IN.cust_location;
    SurfaceOutput o;
    #line 454
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 458
    o.Gloss = 0.0;
    surf( surfIN, o);
    lowp float atten = 1.0;
    lowp vec4 c = vec4( 0.0);
    #line 462
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec3 lm = DecodeLightmap( lmtex);
    c.xyz += (o.Albedo * lm);
    c.w = o.Alpha;
    #line 466
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
in highp vec2 xlv_TEXCOORD2;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec2(xlv_TEXCOORD0);
    xlt_IN.cust_location = vec2(xlv_TEXCOORD1);
    xlt_IN.lmap = vec2(xlv_TEXCOORD2);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 5 [_Object2World]
Vector 9 [unity_LightmapST]
Vector 10 [_MainTex_ST]
"!!ARBvp1.0
# 9 ALU
PARAM c[11] = { program.local[0],
		state.matrix.mvp,
		program.local[5..10] };
TEMP R0;
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[7];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[10], c[10].zwzw;
MOV result.texcoord[1].xy, R0;
MAD result.texcoord[2].xy, vertex.texcoord[1], c[9], c[9].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 9 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [unity_LightmapST]
Vector 9 [_MainTex_ST]
"vs_2_0
; 9 ALU
dcl_position0 v0
dcl_texcoord0 v2
dcl_texcoord1 v3
dp4 r0.x, v0, c4
dp4 r0.y, v0, c6
mad oT0.xy, v2, c9, c9.zwzw
mov oT1.xy, r0
mad oT2.xy, v3, c8, c8.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 160 // 160 used size, 11 vars
Vector 128 [unity_LightmapST] 4
Vector 144 [_MainTex_ST] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
// 11 instructions, 1 temp regs, 0 temp arrays:
// ALU 10 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedgembbahjedhpgaonghhmedggpbodhomfabaaaaaajiadaaaaadaaaaaa
cmaaaaaapeaaaaaahmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaa
adamaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
beacaaaaeaaaabaaifaaaaaafjaaaaaeegiocaaaaaaaaaaaakaaaaaafjaaaaae
egiocaaaabaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaa
adaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaaddccabaaa
acaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaaidcaabaaaaaaaaaaafgbfbaaaaaaaaaaaigiacaaaabaaaaaa
anaaaaaadcaaaaakdcaabaaaaaaaaaaaigiacaaaabaaaaaaamaaaaaaagbabaaa
aaaaaaaaegaabaaaaaaaaaaadcaaaaakdcaabaaaaaaaaaaaigiacaaaabaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaakmccabaaaabaaaaaa
agiicaaaabaaaaaaapaaaaaapgbpbaaaaaaaaaaaagaebaaaaaaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaajaaaaaaogikcaaa
aaaaaaaaajaaaaaadcaaaaaldccabaaaacaaaaaaegbabaaaaeaaaaaaegiacaaa
aaaaaaaaaiaaaaaaogikcaaaaaaaaaaaaiaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
void main ()
{
  lowp vec4 c_1;
  lowp float tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_4;
  arg0_4 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_5;
  arg0_5 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_6;
  arg0_6 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_7;
  tmpvar_7 = (1.0 - (((tmpvar_3.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_4, arg0_4))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_5, arg0_5))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_2 = tmpvar_7;
  mediump vec3 lm_8;
  lowp vec3 tmpvar_9;
  tmpvar_9 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD2).xyz);
  lm_8 = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_3.xyz * lm_8);
  c_1.xyz = tmpvar_10;
  c_1.w = tmpvar_2;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
void main ()
{
  lowp vec4 c_1;
  lowp float tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_4;
  arg0_4 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_5;
  arg0_5 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_6;
  arg0_6 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_7;
  tmpvar_7 = (1.0 - (((tmpvar_3.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_4, arg0_4))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_5, arg0_5))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_2 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  mediump vec3 lm_9;
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((8.0 * tmpvar_8.w) * tmpvar_8.xyz);
  lm_9 = tmpvar_10;
  mediump vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_3.xyz * lm_9);
  c_1.xyz = tmpvar_11;
  c_1.w = tmpvar_2;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [unity_LightmapST]
Vector 9 [_MainTex_ST]
"agal_vs
[bc]
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.y, a0, c6
adaaaaaaaaaaamacadaaaaoeaaaaaaaaajaaaaoeabaaaaaa mul r0.zw, a3, c9
abaaaaaaaaaaadaeaaaaaapoacaaaaaaajaaaaooabaaaaaa add v0.xy, r0.zwww, c9.zwzw
aaaaaaaaabaaadaeaaaaaafeacaaaaaaaaaaaaaaaaaaaaaa mov v1.xy, r0.xyyy
adaaaaaaaaaaadacaeaaaaoeaaaaaaaaaiaaaaoeabaaaaaa mul r0.xy, a4, c8
abaaaaaaacaaadaeaaaaaafeacaaaaaaaiaaaaooabaaaaaa add v2.xy, r0.xyyy, c8.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
aaaaaaaaacaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.zw, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 160 // 160 used size, 11 vars
Vector 128 [unity_LightmapST] 4
Vector 144 [_MainTex_ST] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
// 11 instructions, 1 temp regs, 0 temp arrays:
// ALU 10 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedoanjkljkhegaedhpgdabakjigaihlodfabaaaaaapmaeaaaaaeaaaaaa
daaaaaaajaabaaaakmadaaaaheaeaaaaebgpgodjfiabaaaafiabaaaaaaacpopp
amabaaaaemaaaaaaadaaceaaaaaaeiaaaaaaeiaaaaaaceaaabaaeiaaaaaaaiaa
acaaabaaaaaaaaaaabaaaaaaaeaaadaaaaaaaaaaabaaamaaaeaaahaaaaaaaaaa
aaaaaaaaaaacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaadiaadaaapja
bpaaaaacafaaaeiaaeaaapjaafaaaaadaaaaadiaaaaaffjaaiaaockaaeaaaaae
aaaaadiaahaaockaaaaaaajaaaaaoeiaaeaaaaaeaaaaadiaajaaockaaaaakkja
aaaaoeiaaeaaaaaeaaaaamoaakaacekaaaaappjaaaaaeeiaaeaaaaaeaaaaadoa
adaaoejaacaaoekaacaaookaaeaaaaaeabaaadoaaeaaoejaabaaoekaabaaooka
afaaaaadaaaaapiaaaaaffjaaeaaoekaaeaaaaaeaaaaapiaadaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaapiaafaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapia
agaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeia
abaaaaacaaaaammaaaaaoeiappppaaaafdeieefcbeacaaaaeaaaabaaifaaaaaa
fjaaaaaeegiocaaaaaaaaaaaakaaaaaafjaaaaaeegiocaaaabaaaaaabaaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaa
aeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaa
gfaaaaadmccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagiaaaaacabaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
abaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaidcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaigiacaaaabaaaaaaanaaaaaadcaaaaakdcaabaaa
aaaaaaaaigiacaaaabaaaaaaamaaaaaaagbabaaaaaaaaaaaegaabaaaaaaaaaaa
dcaaaaakdcaabaaaaaaaaaaaigiacaaaabaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egaabaaaaaaaaaaadcaaaaakmccabaaaabaaaaaaagiicaaaabaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaagaebaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaajaaaaaaogikcaaaaaaaaaaaajaaaaaadcaaaaal
dccabaaaacaaaaaaegbabaaaaeaaaaaaegiacaaaaaaaaaaaaiaaaaaaogikcaaa
aaaaaaaaaiaaaaaadoaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaa
adamaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 398
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    highp vec2 lmap;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 393
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 397
uniform highp vec4 _Player3_Pos;
#line 405
#line 419
#line 432
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
#line 449
#line 405
void vert( inout appdata_full vertexData, out Input outData ) {
    highp vec4 pos = (glstate_matrix_mvp * vertexData.vertex);
    highp vec4 posWorld = (_Object2World * vertexData.vertex);
    #line 409
    outData.uv_MainTex = vec2( vertexData.texcoord);
    outData.location = posWorld.xz;
}
#line 434
v2f_surf vert_surf( in appdata_full v ) {
    #line 436
    v2f_surf o;
    Input customInputData;
    vert( v, customInputData);
    o.cust_location = customInputData.location;
    #line 440
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    #line 445
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
out highp vec2 xlv_TEXCOORD2;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.pack0);
    xlv_TEXCOORD1 = vec2(xl_retval.cust_location);
    xlv_TEXCOORD2 = vec2(xl_retval.lmap);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 398
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    highp vec2 lmap;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 393
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 397
uniform highp vec4 _Player3_Pos;
#line 405
#line 419
#line 432
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
#line 449
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 325
mediump vec3 DirLightmapDiffuse( in mediump mat3 dirBasis, in lowp vec4 color, in lowp vec4 scale, in mediump vec3 normal, in bool surfFuncWritesNormal, out mediump vec3 scalePerBasisVector ) {
    mediump vec3 lm = DecodeLightmap( color);
    scalePerBasisVector = DecodeLightmap( scale);
    #line 329
    if (surfFuncWritesNormal){
        mediump vec3 normalInRnmBasis = xll_saturate_vf3((dirBasis * normal));
        lm *= dot( normalInRnmBasis, scalePerBasisVector);
    }
    #line 334
    return lm;
}
#line 353
mediump vec4 LightingLambert_DirLightmap( in SurfaceOutput s, in lowp vec4 color, in lowp vec4 scale, in bool surfFuncWritesNormal ) {
    #line 355
    highp mat3 unity_DirBasis = xll_transpose_mf3x3(mat3( vec3( 0.816497, 0.0, 0.57735), vec3( -0.408248, 0.707107, 0.57735), vec3( -0.408248, -0.707107, 0.57735)));
    mediump vec3 scalePerBasisVector;
    mediump vec3 lm = DirLightmapDiffuse( unity_DirBasis, color, scale, s.Normal, surfFuncWritesNormal, scalePerBasisVector);
    return vec4( lm, 0.0);
}
#line 419
highp float powerForPos( in highp vec4 pos, in highp vec2 nearVertex ) {
    highp float atten = clamp( (_FogRadius - length((pos.xz - nearVertex.xy))), 0.0, _FogRadius);
    return (((1.0 / _FogMaxRadius) * atten) / _FogRadius);
}
#line 412
void surf( in Input IN, inout SurfaceOutput o ) {
    #line 414
    lowp vec4 baseColor = (texture( _MainTex, IN.uv_MainTex) * _Color);
    highp float alpha = (1.0 - (((baseColor.w + powerForPos( _Player1_Pos, IN.location)) + powerForPos( _Player2_Pos, IN.location)) + powerForPos( _Player3_Pos, IN.location)));
    o.Albedo = baseColor.xyz;
    o.Alpha = alpha;
}
#line 449
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    #line 453
    surfIN.location = IN.cust_location;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 457
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    surf( surfIN, o);
    #line 461
    lowp float atten = 1.0;
    lowp vec4 c = vec4( 0.0);
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec4 lmIndTex = texture( unity_LightmapInd, IN.lmap.xy);
    #line 465
    mediump vec3 lm = LightingLambert_DirLightmap( o, lmtex, lmIndTex, false).xyz;
    c.xyz += (o.Albedo * lm);
    c.w = o.Alpha;
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
in highp vec2 xlv_TEXCOORD2;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec2(xlv_TEXCOORD0);
    xlt_IN.cust_location = vec2(xlv_TEXCOORD1);
    xlt_IN.lmap = vec2(xlv_TEXCOORD2);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_ProjectionParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Matrix 5 [_Object2World]
Vector 17 [unity_Scale]
Vector 18 [_MainTex_ST]
"!!ARBvp1.0
# 35 ALU
PARAM c[19] = { { 1, 0.5 },
		state.matrix.mvp,
		program.local[5..18] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R0.xyz, vertex.normal, c[17].w;
DP3 R3.w, R0, c[6];
DP3 R2.w, R0, c[7];
DP3 R1.w, R0, c[5];
MOV R1.x, R3.w;
MOV R1.y, R2.w;
MOV R1.z, c[0].x;
MUL R0, R1.wxyy, R1.xyyw;
DP4 R2.z, R1.wxyz, c[12];
DP4 R2.y, R1.wxyz, c[11];
DP4 R2.x, R1.wxyz, c[10];
DP4 R1.z, R0, c[15];
DP4 R1.y, R0, c[14];
DP4 R1.x, R0, c[13];
MUL R3.x, R3.w, R3.w;
MAD R0.x, R1.w, R1.w, -R3;
ADD R3.xyz, R2, R1;
MUL R2.xyz, R0.x, c[16];
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].y;
MOV result.position, R0;
MUL R1.y, R1, c[9].x;
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[7];
ADD result.texcoord[3].xyz, R3, R2;
ADD result.texcoord[4].xy, R1, R1.z;
MOV result.texcoord[4].zw, R0;
MOV result.texcoord[2].z, R2.w;
MOV result.texcoord[2].y, R3.w;
MOV result.texcoord[2].x, R1.w;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
MOV result.texcoord[1].xy, R0;
END
# 35 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Matrix 4 [_Object2World]
Vector 17 [unity_Scale]
Vector 18 [_MainTex_ST]
"vs_2_0
; 35 ALU
def c19, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1, c17.w
dp3 r3.w, r0, c5
dp3 r2.w, r0, c6
dp3 r1.w, r0, c4
mov r1.x, r3.w
mov r1.y, r2.w
mov r1.z, c19.x
mul r0, r1.wxyy, r1.xyyw
dp4 r2.z, r1.wxyz, c12
dp4 r2.y, r1.wxyz, c11
dp4 r2.x, r1.wxyz, c10
dp4 r1.z, r0, c15
dp4 r1.y, r0, c14
dp4 r1.x, r0, c13
mul r3.x, r3.w, r3.w
mad r0.x, r1.w, r1.w, -r3
add r3.xyz, r2, r1
mul r2.xyz, r0.x, c16
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c19.y
mov oPos, r0
mul r1.y, r1, c8.x
dp4 r0.x, v0, c4
dp4 r0.y, v0, c6
add oT3.xyz, r3, r2
mad oT4.xy, r1.z, c9.zwzw, r1
mov oT4.zw, r0
mov oT2.z, r2.w
mov oT2.y, r3.w
mov oT2.x, r1.w
mad oT0.xy, v2, c18, c18.zwzw
mov oT1.xy, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 208 // 208 used size, 11 vars
Vector 192 [_MainTex_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 32 instructions, 5 temp regs, 0 temp arrays:
// ALU 27 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedggnaeopljidnnhmeodankngmmaiendapabaaaaaahmagaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcmiaeaaaaeaaaabaadcabaaaafjaaaaae
egiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
mccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaa
gfaaaaadpccabaaaaeaaaaaagiaaaaacafaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaidcaabaaaabaaaaaafgbfbaaaaaaaaaaaigiacaaaadaaaaaaanaaaaaa
dcaaaaakdcaabaaaabaaaaaaigiacaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaa
egaabaaaabaaaaaadcaaaaakdcaabaaaabaaaaaaigiacaaaadaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegaabaaaabaaaaaadcaaaaakmccabaaaabaaaaaaagiicaaa
adaaaaaaapaaaaaapgbpbaaaaaaaaaaaagaebaaaabaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaamaaaaaaogikcaaaaaaaaaaa
amaaaaaadiaaaaaihcaabaaaabaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaa
beaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaaklcaabaaaabaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaa
abaaaaaaegaibaaaacaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaa
aoaaaaaakgakbaaaabaaaaaaegadbaaaabaaaaaadgaaaaafhccabaaaacaaaaaa
egacbaaaabaaaaaadgaaaaaficaabaaaabaaaaaaabeaaaaaaaaaiadpbbaaaaai
bcaabaaaacaaaaaaegiocaaaacaaaaaacgaaaaaaegaobaaaabaaaaaabbaaaaai
ccaabaaaacaaaaaaegiocaaaacaaaaaachaaaaaaegaobaaaabaaaaaabbaaaaai
ecaabaaaacaaaaaaegiocaaaacaaaaaaciaaaaaaegaobaaaabaaaaaadiaaaaah
pcaabaaaadaaaaaajgacbaaaabaaaaaaegakbaaaabaaaaaabbaaaaaibcaabaaa
aeaaaaaaegiocaaaacaaaaaacjaaaaaaegaobaaaadaaaaaabbaaaaaiccaabaaa
aeaaaaaaegiocaaaacaaaaaackaaaaaaegaobaaaadaaaaaabbaaaaaiecaabaaa
aeaaaaaaegiocaaaacaaaaaaclaaaaaaegaobaaaadaaaaaaaaaaaaahhcaabaaa
acaaaaaaegacbaaaacaaaaaaegacbaaaaeaaaaaadiaaaaahccaabaaaabaaaaaa
bkaabaaaabaaaaaabkaabaaaabaaaaaadcaaaaakbcaabaaaabaaaaaaakaabaaa
abaaaaaaakaabaaaabaaaaaabkaabaiaebaaaaaaabaaaaaadcaaaaakhccabaaa
adaaaaaaegiccaaaacaaaaaacmaaaaaaagaabaaaabaaaaaaegacbaaaacaaaaaa
diaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaa
aaaaaadpaaaaaadpdgaaaaafmccabaaaaeaaaaaakgaobaaaaaaaaaaaaaaaaaah
dccabaaaaeaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal_8;
  normal_8 = tmpvar_6;
  highp float vC_9;
  mediump vec3 x3_10;
  mediump vec3 x2_11;
  mediump vec3 x1_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal_8);
  x1_12.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal_8);
  x1_12.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal_8);
  x1_12.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal_8.xyzz * normal_8.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2_11.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2_11.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2_11.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal_8.x * normal_8.x) - (normal_8.y * normal_8.y));
  vC_9 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC_9);
  x3_10 = tmpvar_21;
  tmpvar_7 = ((x1_12 + x2_11) + x3_10);
  shlight_1 = tmpvar_7;
  tmpvar_3 = shlight_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _LightShadowData;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp float tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_4;
  arg0_4 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_5;
  arg0_5 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_6;
  arg0_6 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_7;
  tmpvar_7 = (1.0 - (((tmpvar_3.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_4, arg0_4))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_5, arg0_5))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_2 = tmpvar_7;
  lowp float tmpvar_8;
  mediump float lightShadowDataX_9;
  highp float dist_10;
  lowp float tmpvar_11;
  tmpvar_11 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x;
  dist_10 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = _LightShadowData.x;
  lightShadowDataX_9 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = max (float((dist_10 > (xlv_TEXCOORD4.z / xlv_TEXCOORD4.w))), lightShadowDataX_9);
  tmpvar_8 = tmpvar_13;
  lowp vec4 c_14;
  c_14.xyz = ((tmpvar_3.xyz * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz)) * tmpvar_8) * 2.0));
  c_14.w = tmpvar_2;
  c_1.w = c_14.w;
  c_1.xyz = (c_14.xyz + (tmpvar_3.xyz * xlv_TEXCOORD3));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = tmpvar_6;
  mediump vec3 tmpvar_8;
  mediump vec4 normal_9;
  normal_9 = tmpvar_7;
  highp float vC_10;
  mediump vec3 x3_11;
  mediump vec3 x2_12;
  mediump vec3 x1_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal_9);
  x1_13.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal_9);
  x1_13.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal_9);
  x1_13.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal_9.xyzz * normal_9.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2_12.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2_12.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2_12.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal_9.x * normal_9.x) - (normal_9.y * normal_9.y));
  vC_10 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC_10);
  x3_11 = tmpvar_22;
  tmpvar_8 = ((x1_13 + x2_12) + x3_11);
  shlight_1 = tmpvar_8;
  tmpvar_3 = shlight_1;
  highp vec4 o_23;
  highp vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_25;
  tmpvar_25.x = tmpvar_24.x;
  tmpvar_25.y = (tmpvar_24.y * _ProjectionParams.x);
  o_23.xy = (tmpvar_25 + tmpvar_24.w);
  o_23.zw = tmpvar_4.zw;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = o_23;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp float tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_4;
  arg0_4 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_5;
  arg0_5 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_6;
  arg0_6 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_7;
  tmpvar_7 = (1.0 - (((tmpvar_3.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_4, arg0_4))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_5, arg0_5))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_2 = tmpvar_7;
  lowp vec4 c_8;
  c_8.xyz = ((tmpvar_3.xyz * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz)) * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x) * 2.0));
  c_8.w = tmpvar_2;
  c_1.w = c_8.w;
  c_1.xyz = (c_8.xyz + (tmpvar_3.xyz * xlv_TEXCOORD3));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [unity_SHAr]
Vector 10 [unity_SHAg]
Vector 11 [unity_SHAb]
Vector 12 [unity_SHBr]
Vector 13 [unity_SHBg]
Vector 14 [unity_SHBb]
Vector 15 [unity_SHC]
Matrix 4 [_Object2World]
Vector 16 [unity_Scale]
Vector 17 [unity_NPOTScale]
Vector 18 [_MainTex_ST]
"agal_vs
c19 1.0 0.5 0.0 0.0
[bc]
adaaaaaaaaaaahacabaaaaoeaaaaaaaabaaaaappabaaaaaa mul r0.xyz, a1, c16.w
bcaaaaaaadaaaiacaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r3.w, r0.xyzz, c5
bcaaaaaaacaaaiacaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r2.w, r0.xyzz, c6
bcaaaaaaabaaaiacaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r1.w, r0.xyzz, c4
aaaaaaaaabaaabacadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r3.w
aaaaaaaaabaaacacacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r1.y, r2.w
aaaaaaaaabaaaeacbdaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.z, c19.x
adaaaaaaaaaaapacabaaaafdacaaaaaaabaaaaneacaaaaaa mul r0, r1.wxyy, r1.xyyw
bdaaaaaaacaaaeacabaaaajdacaaaaaaalaaaaoeabaaaaaa dp4 r2.z, r1.wxyz, c11
bdaaaaaaacaaacacabaaaajdacaaaaaaakaaaaoeabaaaaaa dp4 r2.y, r1.wxyz, c10
bdaaaaaaacaaabacabaaaajdacaaaaaaajaaaaoeabaaaaaa dp4 r2.x, r1.wxyz, c9
bdaaaaaaabaaaeacaaaaaaoeacaaaaaaaoaaaaoeabaaaaaa dp4 r1.z, r0, c14
bdaaaaaaabaaacacaaaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 r1.y, r0, c13
bdaaaaaaabaaabacaaaaaaoeacaaaaaaamaaaaoeabaaaaaa dp4 r1.x, r0, c12
adaaaaaaadaaabacadaaaappacaaaaaaadaaaappacaaaaaa mul r3.x, r3.w, r3.w
adaaaaaaaeaaabacabaaaappacaaaaaaabaaaappacaaaaaa mul r4.x, r1.w, r1.w
acaaaaaaaaaaabacaeaaaaaaacaaaaaaadaaaaaaacaaaaaa sub r0.x, r4.x, r3.x
abaaaaaaacaaahacacaaaakeacaaaaaaabaaaakeacaaaaaa add r2.xyz, r2.xyzz, r1.xyzz
adaaaaaaabaaahacaaaaaaaaacaaaaaaapaaaaoeabaaaaaa mul r1.xyz, r0.x, c15
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 r0.w, a0, c3
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 r0.z, a0, c2
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 r0.x, a0, c0
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 r0.y, a0, c1
adaaaaaaadaaahacaaaaaapeacaaaaaabdaaaaffabaaaaaa mul r3.xyz, r0.xyww, c19.y
abaaaaaaadaaahaeacaaaakeacaaaaaaabaaaakeacaaaaaa add v3.xyz, r2.xyzz, r1.xyzz
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
adaaaaaaabaaacacadaaaaffacaaaaaaaiaaaaaaabaaaaaa mul r1.y, r3.y, c8.x
aaaaaaaaabaaabacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r3.x
abaaaaaaabaaadacabaaaafeacaaaaaaadaaaakkacaaaaaa add r1.xy, r1.xyyy, r3.z
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.y, a0, c6
adaaaaaaaeaaadaeabaaaafeacaaaaaabbaaaaoeabaaaaaa mul v4.xy, r1.xyyy, c17
aaaaaaaaaeaaamaeaaaaaaopacaaaaaaaaaaaaaaaaaaaaaa mov v4.zw, r0.wwzw
aaaaaaaaacaaaeaeacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v2.z, r2.w
aaaaaaaaacaaacaeadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v2.y, r3.w
aaaaaaaaacaaabaeabaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v2.x, r1.w
adaaaaaaaeaaadacadaaaaoeaaaaaaaabcaaaaoeabaaaaaa mul r4.xy, a3, c18
abaaaaaaaaaaadaeaeaaaafeacaaaaaabcaaaaooabaaaaaa add v0.xy, r4.xyyy, c18.zwzw
aaaaaaaaabaaadaeaaaaaafeacaaaaaaaaaaaaaaaaaaaaaa mov v1.xy, r0.xyyy
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 208 // 208 used size, 11 vars
Vector 192 [_MainTex_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 32 instructions, 5 temp regs, 0 temp arrays:
// ALU 27 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedbakopkciofmiagjcnodjekngncadplkdabaaaaaagmajaaaaaeaaaaaa
daaaaaaabmadaaaaomahaaaaleaiaaaaebgpgodjoeacaaaaoeacaaaaaaacpopp
heacaaaahaaaaaaaagaaceaaaaaagmaaaaaagmaaaaaaceaaabaagmaaaaaaamaa
abaaabaaaaaaaaaaabaaafaaabaaacaaaaaaaaaaacaacgaaahaaadaaaaaaaaaa
adaaaaaaaeaaakaaaaaaaaaaadaaamaaaeaaaoaaaaaaaaaaadaabeaaabaabcaa
aaaaaaaaaaaaaaaaaaacpoppfbaaaaafbdaaapkaaaaaiadpaaaaaadpaaaaaaaa
aaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaaciaacaaapjabpaaaaac
afaaadiaadaaapjaafaaaaadaaaaadiaaaaaffjaapaaockaaeaaaaaeaaaaadia
aoaaockaaaaaaajaaaaaoeiaaeaaaaaeaaaaadiabaaaockaaaaakkjaaaaaoeia
aeaaaaaeaaaaamoabbaacekaaaaappjaaaaaeeiaaeaaaaaeaaaaadoaadaaoeja
abaaoekaabaaookaafaaaaadaaaaahiaacaaoejabcaappkaafaaaaadabaaahia
aaaaffiaapaaoekaaeaaaaaeaaaaaliaaoaakekaaaaaaaiaabaakeiaaeaaaaae
aaaaahiabaaaoekaaaaakkiaaaaapeiaabaaaaacaaaaaiiabdaaaakaajaaaaad
abaaabiaadaaoekaaaaaoeiaajaaaaadabaaaciaaeaaoekaaaaaoeiaajaaaaad
abaaaeiaafaaoekaaaaaoeiaafaaaaadacaaapiaaaaacjiaaaaakeiaajaaaaad
adaaabiaagaaoekaacaaoeiaajaaaaadadaaaciaahaaoekaacaaoeiaajaaaaad
adaaaeiaaiaaoekaacaaoeiaacaaaaadabaaahiaabaaoeiaadaaoeiaafaaaaad
aaaaaiiaaaaaffiaaaaaffiaaeaaaaaeaaaaaiiaaaaaaaiaaaaaaaiaaaaappib
abaaaaacabaaahoaaaaaoeiaaeaaaaaeacaaahoaajaaoekaaaaappiaabaaoeia
afaaaaadaaaaapiaaaaaffjaalaaoekaaeaaaaaeaaaaapiaakaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaapiaamaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapia
anaaoekaaaaappjaaaaaoeiaafaaaaadabaaabiaaaaaffiaacaaaakaafaaaaad
abaaaiiaabaaaaiabdaaffkaafaaaaadabaaafiaaaaapeiabdaaffkaacaaaaad
adaaadoaabaakkiaabaaomiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeia
abaaaaacaaaaammaaaaaoeiaabaaaaacadaaamoaaaaaoeiappppaaaafdeieefc
miaeaaaaeaaaabaadcabaaaafjaaaaaeegiocaaaaaaaaaaaanaaaaaafjaaaaae
egiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaae
egiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagiaaaaac
afaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaf
pccabaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaidcaabaaaabaaaaaafgbfbaaa
aaaaaaaaigiacaaaadaaaaaaanaaaaaadcaaaaakdcaabaaaabaaaaaaigiacaaa
adaaaaaaamaaaaaaagbabaaaaaaaaaaaegaabaaaabaaaaaadcaaaaakdcaabaaa
abaaaaaaigiacaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaabaaaabaaaaaa
dcaaaaakmccabaaaabaaaaaaagiicaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaa
agaebaaaabaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaaamaaaaaaogikcaaaaaaaaaaaamaaaaaadiaaaaaihcaabaaaabaaaaaa
egbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaaacaaaaaa
fgafbaaaabaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaabaaaaaa
egiicaaaadaaaaaaamaaaaaaagaabaaaabaaaaaaegaibaaaacaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaabaaaaaaegadbaaa
abaaaaaadgaaaaafhccabaaaacaaaaaaegacbaaaabaaaaaadgaaaaaficaabaaa
abaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaacaaaaaaegiocaaaacaaaaaa
cgaaaaaaegaobaaaabaaaaaabbaaaaaiccaabaaaacaaaaaaegiocaaaacaaaaaa
chaaaaaaegaobaaaabaaaaaabbaaaaaiecaabaaaacaaaaaaegiocaaaacaaaaaa
ciaaaaaaegaobaaaabaaaaaadiaaaaahpcaabaaaadaaaaaajgacbaaaabaaaaaa
egakbaaaabaaaaaabbaaaaaibcaabaaaaeaaaaaaegiocaaaacaaaaaacjaaaaaa
egaobaaaadaaaaaabbaaaaaiccaabaaaaeaaaaaaegiocaaaacaaaaaackaaaaaa
egaobaaaadaaaaaabbaaaaaiecaabaaaaeaaaaaaegiocaaaacaaaaaaclaaaaaa
egaobaaaadaaaaaaaaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaa
aeaaaaaadiaaaaahccaabaaaabaaaaaabkaabaaaabaaaaaabkaabaaaabaaaaaa
dcaaaaakbcaabaaaabaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaabkaabaia
ebaaaaaaabaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaaacaaaaaacmaaaaaa
agaabaaaabaaaaaaegacbaaaacaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaa
aaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaa
aeaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaaeaaaaaakgakbaaaabaaaaaa
mgaabaaaabaaaaaadoaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 432
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec4 _ShadowCoord;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 401
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 405
uniform highp vec4 _Player3_Pos;
#line 413
#line 427
#line 442
uniform highp vec4 _MainTex_ST;
#line 459
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 413
void vert( inout appdata_full vertexData, out Input outData ) {
    highp vec4 pos = (glstate_matrix_mvp * vertexData.vertex);
    highp vec4 posWorld = (_Object2World * vertexData.vertex);
    #line 417
    outData.uv_MainTex = vec2( vertexData.texcoord);
    outData.location = posWorld.xz;
}
#line 443
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 446
    Input customInputData;
    vert( v, customInputData);
    o.cust_location = customInputData.location;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 450
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 shlight = ShadeSH9( vec4( worldN, 1.0));
    #line 454
    o.vlight = shlight;
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out lowp vec3 xlv_TEXCOORD3;
out highp vec4 xlv_TEXCOORD4;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.pack0);
    xlv_TEXCOORD1 = vec2(xl_retval.cust_location);
    xlv_TEXCOORD2 = vec3(xl_retval.normal);
    xlv_TEXCOORD3 = vec3(xl_retval.vlight);
    xlv_TEXCOORD4 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 432
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec4 _ShadowCoord;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 401
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 405
uniform highp vec4 _Player3_Pos;
#line 413
#line 427
#line 442
uniform highp vec4 _MainTex_ST;
#line 459
#line 338
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp vec4 c;
    #line 342
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.0));
    c.w = s.Alpha;
    return c;
}
#line 427
highp float powerForPos( in highp vec4 pos, in highp vec2 nearVertex ) {
    highp float atten = clamp( (_FogRadius - length((pos.xz - nearVertex.xy))), 0.0, _FogRadius);
    return (((1.0 / _FogMaxRadius) * atten) / _FogRadius);
}
#line 420
void surf( in Input IN, inout SurfaceOutput o ) {
    #line 422
    lowp vec4 baseColor = (texture( _MainTex, IN.uv_MainTex) * _Color);
    highp float alpha = (1.0 - (((baseColor.w + powerForPos( _Player1_Pos, IN.location)) + powerForPos( _Player2_Pos, IN.location)) + powerForPos( _Player3_Pos, IN.location)));
    o.Albedo = baseColor.xyz;
    o.Alpha = alpha;
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    highp float dist = textureProj( _ShadowMapTexture, shadowCoord).x;
    mediump float lightShadowDataX = _LightShadowData.x;
    #line 397
    return max( float((dist > (shadowCoord.z / shadowCoord.w))), lightShadowDataX);
}
#line 459
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    #line 463
    surfIN.location = IN.cust_location;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 467
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    #line 471
    surf( surfIN, o);
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    c = LightingLambert( o, _WorldSpaceLightPos0.xyz, atten);
    #line 475
    c.xyz += (o.Albedo * IN.vlight);
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in lowp vec3 xlv_TEXCOORD3;
in highp vec4 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec2(xlv_TEXCOORD0);
    xlt_IN.cust_location = vec2(xlv_TEXCOORD1);
    xlt_IN.normal = vec3(xlv_TEXCOORD2);
    xlt_IN.vlight = vec3(xlv_TEXCOORD3);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD4);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 9 [_ProjectionParams]
Matrix 5 [_Object2World]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
"!!ARBvp1.0
# 14 ALU
PARAM c[12] = { { 0.5 },
		state.matrix.mvp,
		program.local[5..11] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MOV result.position, R0;
MUL R1.y, R1, c[9].x;
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[7];
ADD result.texcoord[3].xy, R1, R1.z;
MOV result.texcoord[3].zw, R0;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[11], c[11].zwzw;
MOV result.texcoord[1].xy, R0;
MAD result.texcoord[2].xy, vertex.texcoord[1], c[10], c[10].zwzw;
END
# 14 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Matrix 4 [_Object2World]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
"vs_2_0
; 14 ALU
def c12, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v2
dcl_texcoord1 v3
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c12.x
mov oPos, r0
mul r1.y, r1, c8.x
dp4 r0.x, v0, c4
dp4 r0.y, v0, c6
mad oT3.xy, r1.z, c9.zwzw, r1
mov oT3.zw, r0
mad oT0.xy, v2, c11, c11.zwzw
mov oT1.xy, r0
mad oT2.xy, v3, c10, c10.zwzw
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 224 // 224 used size, 12 vars
Vector 192 [unity_LightmapST] 4
Vector 208 [_MainTex_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 16 instructions, 2 temp regs, 0 temp arrays:
// ALU 13 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedjlohdbihpalcogemffcffppbglkaajkeabaaaaaafiaeaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaa
adamaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefclmacaaaaeaaaabaa
kpaaaaaafjaaaaaeegiocaaaaaaaaaaaaoaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
gfaaaaaddccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagiaaaaacacaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaa
aaaaaaaaegaobaaaaaaaaaaadiaaaaaidcaabaaaabaaaaaafgbfbaaaaaaaaaaa
igiacaaaacaaaaaaanaaaaaadcaaaaakdcaabaaaabaaaaaaigiacaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegaabaaaabaaaaaadcaaaaakdcaabaaaabaaaaaa
igiacaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaabaaaabaaaaaadcaaaaak
mccabaaaabaaaaaaagiicaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaagaebaaa
abaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
anaaaaaaogikcaaaaaaaaaaaanaaaaaadcaaaaaldccabaaaacaaaaaaegbabaaa
aeaaaaaaegiacaaaaaaaaaaaamaaaaaaogikcaaaaaaaaaaaamaaaaaadiaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaak
ncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaadpdgaaaaafmccabaaaadaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaa
adaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _LightShadowData;
void main ()
{
  lowp vec4 c_1;
  lowp float tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_4;
  arg0_4 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_5;
  arg0_5 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_6;
  arg0_6 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_7;
  tmpvar_7 = (1.0 - (((tmpvar_3.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_4, arg0_4))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_5, arg0_5))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_2 = tmpvar_7;
  lowp float tmpvar_8;
  mediump float lightShadowDataX_9;
  highp float dist_10;
  lowp float tmpvar_11;
  tmpvar_11 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD3).x;
  dist_10 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = _LightShadowData.x;
  lightShadowDataX_9 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = max (float((dist_10 > (xlv_TEXCOORD3.z / xlv_TEXCOORD3.w))), lightShadowDataX_9);
  tmpvar_8 = tmpvar_13;
  c_1.xyz = (tmpvar_3.xyz * min ((2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD2).xyz), vec3((tmpvar_8 * 2.0))));
  c_1.w = tmpvar_2;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = o_2;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
void main ()
{
  lowp vec4 c_1;
  lowp float tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_4;
  arg0_4 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_5;
  arg0_5 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_6;
  arg0_6 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_7;
  tmpvar_7 = (1.0 - (((tmpvar_3.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_4, arg0_4))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_5, arg0_5))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_2 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD3);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((8.0 * tmpvar_9.w) * tmpvar_9.xyz);
  c_1.xyz = (tmpvar_3.xyz * max (min (tmpvar_10, ((tmpvar_8.x * 2.0) * tmpvar_9.xyz)), (tmpvar_10 * tmpvar_8.x)));
  c_1.w = tmpvar_2;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Matrix 4 [_Object2World]
Vector 9 [unity_NPOTScale]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
"agal_vs
c12 0.5 0.0 0.0 0.0
[bc]
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 r0.w, a0, c3
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 r0.z, a0, c2
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 r0.x, a0, c0
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 r0.y, a0, c1
adaaaaaaabaaahacaaaaaapeacaaaaaaamaaaaaaabaaaaaa mul r1.xyz, r0.xyww, c12.x
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
adaaaaaaabaaacacabaaaaffacaaaaaaaiaaaaaaabaaaaaa mul r1.y, r1.y, c8.x
abaaaaaaabaaadacabaaaafeacaaaaaaabaaaakkacaaaaaa add r1.xy, r1.xyyy, r1.z
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.y, a0, c6
adaaaaaaadaaadaeabaaaafeacaaaaaaajaaaaoeabaaaaaa mul v3.xy, r1.xyyy, c9
aaaaaaaaadaaamaeaaaaaaopacaaaaaaaaaaaaaaaaaaaaaa mov v3.zw, r0.wwzw
adaaaaaaabaaadacadaaaaoeaaaaaaaaalaaaaoeabaaaaaa mul r1.xy, a3, c11
abaaaaaaaaaaadaeabaaaafeacaaaaaaalaaaaooabaaaaaa add v0.xy, r1.xyyy, c11.zwzw
aaaaaaaaabaaadaeaaaaaafeacaaaaaaaaaaaaaaaaaaaaaa mov v1.xy, r0.xyyy
adaaaaaaaaaaadacaeaaaaoeaaaaaaaaakaaaaoeabaaaaaa mul r0.xy, a4, c10
abaaaaaaacaaadaeaaaaaafeacaaaaaaakaaaaooabaaaaaa add v2.xy, r0.xyyy, c10.zwzw
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
aaaaaaaaacaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.zw, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 224 // 224 used size, 12 vars
Vector 192 [unity_LightmapST] 4
Vector 208 [_MainTex_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 16 instructions, 2 temp regs, 0 temp arrays:
// ALU 13 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedkfgihafbadpmpfccfdghjicjcbmlmceaabaaaaaacmagaaaaaeaaaaaa
daaaaaaaaaacaaaameaeaaaaimafaaaaebgpgodjmiabaaaamiabaaaaaaacpopp
haabaaaafiaaaaaaaeaaceaaaaaafeaaaaaafeaaaaaaceaaabaafeaaaaaaamaa
acaaabaaaaaaaaaaabaaafaaabaaadaaaaaaaaaaacaaaaaaaeaaaeaaaaaaaaaa
acaaamaaaeaaaiaaaaaaaaaaaaaaaaaaaaacpoppfbaaaaafamaaapkaaaaaaadp
aaaaaaaaaaaaaaaaaaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaadia
adaaapjabpaaaaacafaaaeiaaeaaapjaafaaaaadaaaaadiaaaaaffjaajaaocka
aeaaaaaeaaaaadiaaiaaockaaaaaaajaaaaaoeiaaeaaaaaeaaaaadiaakaaocka
aaaakkjaaaaaoeiaaeaaaaaeaaaaamoaalaacekaaaaappjaaaaaeeiaaeaaaaae
aaaaadoaadaaoejaacaaoekaacaaookaaeaaaaaeabaaadoaaeaaoejaabaaoeka
abaaookaafaaaaadaaaaapiaaaaaffjaafaaoekaaeaaaaaeaaaaapiaaeaaoeka
aaaaaajaaaaaoeiaaeaaaaaeaaaaapiaagaaoekaaaaakkjaaaaaoeiaaeaaaaae
aaaaapiaahaaoekaaaaappjaaaaaoeiaafaaaaadabaaabiaaaaaffiaadaaaaka
afaaaaadabaaaiiaabaaaaiaamaaaakaafaaaaadabaaafiaaaaapeiaamaaaaka
acaaaaadacaaadoaabaakkiaabaaomiaaeaaaaaeaaaaadmaaaaappiaaaaaoeka
aaaaoeiaabaaaaacaaaaammaaaaaoeiaabaaaaacacaaamoaaaaaoeiappppaaaa
fdeieefclmacaaaaeaaaabaakpaaaaaafjaaaaaeegiocaaaaaaaaaaaaoaaaaaa
fjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaabaaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaa
aeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaa
gfaaaaadmccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagfaaaaadpccabaaa
adaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaidcaabaaa
abaaaaaafgbfbaaaaaaaaaaaigiacaaaacaaaaaaanaaaaaadcaaaaakdcaabaaa
abaaaaaaigiacaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegaabaaaabaaaaaa
dcaaaaakdcaabaaaabaaaaaaigiacaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egaabaaaabaaaaaadcaaaaakmccabaaaabaaaaaaagiicaaaacaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaagaebaaaabaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaaanaaaaaadcaaaaal
dccabaaaacaaaaaaegbabaaaaeaaaaaaegiacaaaaaaaaaaaamaaaaaaogikcaaa
aaaaaaaaamaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaa
abaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaa
aaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaadaaaaaakgaobaaa
aaaaaaaaaaaaaaahdccabaaaadaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaa
doaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
apaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaaaaaalaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaaabaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffied
epepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadamaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amadaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadamaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 432
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    highp vec2 lmap;
    highp vec4 _ShadowCoord;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 401
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 405
uniform highp vec4 _Player3_Pos;
#line 413
#line 427
#line 441
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
#line 457
uniform sampler2D unity_Lightmap;
#line 413
void vert( inout appdata_full vertexData, out Input outData ) {
    highp vec4 pos = (glstate_matrix_mvp * vertexData.vertex);
    highp vec4 posWorld = (_Object2World * vertexData.vertex);
    #line 417
    outData.uv_MainTex = vec2( vertexData.texcoord);
    outData.location = posWorld.xz;
}
#line 443
v2f_surf vert_surf( in appdata_full v ) {
    #line 445
    v2f_surf o;
    Input customInputData;
    vert( v, customInputData);
    o.cust_location = customInputData.location;
    #line 449
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    #line 453
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
out highp vec2 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.pack0);
    xlv_TEXCOORD1 = vec2(xl_retval.cust_location);
    xlv_TEXCOORD2 = vec2(xl_retval.lmap);
    xlv_TEXCOORD3 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 432
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    highp vec2 lmap;
    highp vec4 _ShadowCoord;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 401
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 405
uniform highp vec4 _Player3_Pos;
#line 413
#line 427
#line 441
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
#line 457
uniform sampler2D unity_Lightmap;
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 427
highp float powerForPos( in highp vec4 pos, in highp vec2 nearVertex ) {
    highp float atten = clamp( (_FogRadius - length((pos.xz - nearVertex.xy))), 0.0, _FogRadius);
    return (((1.0 / _FogMaxRadius) * atten) / _FogRadius);
}
#line 420
void surf( in Input IN, inout SurfaceOutput o ) {
    #line 422
    lowp vec4 baseColor = (texture( _MainTex, IN.uv_MainTex) * _Color);
    highp float alpha = (1.0 - (((baseColor.w + powerForPos( _Player1_Pos, IN.location)) + powerForPos( _Player2_Pos, IN.location)) + powerForPos( _Player3_Pos, IN.location)));
    o.Albedo = baseColor.xyz;
    o.Alpha = alpha;
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    highp float dist = textureProj( _ShadowMapTexture, shadowCoord).x;
    mediump float lightShadowDataX = _LightShadowData.x;
    #line 397
    return max( float((dist > (shadowCoord.z / shadowCoord.w))), lightShadowDataX);
}
#line 458
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    #line 461
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.location = IN.cust_location;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    #line 465
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    #line 469
    surf( surfIN, o);
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    #line 473
    lowp vec3 lm = DecodeLightmap( lmtex);
    c.xyz += (o.Albedo * min( lm, vec3( (atten * 2.0))));
    c.w = o.Alpha;
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
in highp vec2 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec2(xlv_TEXCOORD0);
    xlt_IN.cust_location = vec2(xlv_TEXCOORD1);
    xlt_IN.lmap = vec2(xlv_TEXCOORD2);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 9 [_ProjectionParams]
Matrix 5 [_Object2World]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
"!!ARBvp1.0
# 14 ALU
PARAM c[12] = { { 0.5 },
		state.matrix.mvp,
		program.local[5..11] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MOV result.position, R0;
MUL R1.y, R1, c[9].x;
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[7];
ADD result.texcoord[3].xy, R1, R1.z;
MOV result.texcoord[3].zw, R0;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[11], c[11].zwzw;
MOV result.texcoord[1].xy, R0;
MAD result.texcoord[2].xy, vertex.texcoord[1], c[10], c[10].zwzw;
END
# 14 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Matrix 4 [_Object2World]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
"vs_2_0
; 14 ALU
def c12, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v2
dcl_texcoord1 v3
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c12.x
mov oPos, r0
mul r1.y, r1, c8.x
dp4 r0.x, v0, c4
dp4 r0.y, v0, c6
mad oT3.xy, r1.z, c9.zwzw, r1
mov oT3.zw, r0
mad oT0.xy, v2, c11, c11.zwzw
mov oT1.xy, r0
mad oT2.xy, v3, c10, c10.zwzw
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 224 // 224 used size, 12 vars
Vector 192 [unity_LightmapST] 4
Vector 208 [_MainTex_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 16 instructions, 2 temp regs, 0 temp arrays:
// ALU 13 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedjlohdbihpalcogemffcffppbglkaajkeabaaaaaafiaeaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaa
adamaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefclmacaaaaeaaaabaa
kpaaaaaafjaaaaaeegiocaaaaaaaaaaaaoaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
gfaaaaaddccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagiaaaaacacaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaa
aaaaaaaaegaobaaaaaaaaaaadiaaaaaidcaabaaaabaaaaaafgbfbaaaaaaaaaaa
igiacaaaacaaaaaaanaaaaaadcaaaaakdcaabaaaabaaaaaaigiacaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegaabaaaabaaaaaadcaaaaakdcaabaaaabaaaaaa
igiacaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaabaaaabaaaaaadcaaaaak
mccabaaaabaaaaaaagiicaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaagaebaaa
abaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
anaaaaaaogikcaaaaaaaaaaaanaaaaaadcaaaaaldccabaaaacaaaaaaegbabaaa
aeaaaaaaegiacaaaaaaaaaaaamaaaaaaogikcaaaaaaaaaaaamaaaaaadiaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaak
ncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaadpdgaaaaafmccabaaaadaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaa
adaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _LightShadowData;
void main ()
{
  lowp vec4 c_1;
  lowp float tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_4;
  arg0_4 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_5;
  arg0_5 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_6;
  arg0_6 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_7;
  tmpvar_7 = (1.0 - (((tmpvar_3.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_4, arg0_4))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_5, arg0_5))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_2 = tmpvar_7;
  lowp float tmpvar_8;
  mediump float lightShadowDataX_9;
  highp float dist_10;
  lowp float tmpvar_11;
  tmpvar_11 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD3).x;
  dist_10 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = _LightShadowData.x;
  lightShadowDataX_9 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = max (float((dist_10 > (xlv_TEXCOORD3.z / xlv_TEXCOORD3.w))), lightShadowDataX_9);
  tmpvar_8 = tmpvar_13;
  mediump vec3 lm_14;
  lowp vec3 tmpvar_15;
  tmpvar_15 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD2).xyz);
  lm_14 = tmpvar_15;
  lowp vec3 tmpvar_16;
  tmpvar_16 = vec3((tmpvar_8 * 2.0));
  mediump vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_3.xyz * min (lm_14, tmpvar_16));
  c_1.xyz = tmpvar_17;
  c_1.w = tmpvar_2;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = o_2;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
void main ()
{
  lowp vec4 c_1;
  lowp float tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_4;
  arg0_4 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_5;
  arg0_5 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_6;
  arg0_6 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_7;
  tmpvar_7 = (1.0 - (((tmpvar_3.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_4, arg0_4))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_5, arg0_5))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_2 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD3);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  mediump vec3 lm_10;
  lowp vec3 tmpvar_11;
  tmpvar_11 = ((8.0 * tmpvar_9.w) * tmpvar_9.xyz);
  lm_10 = tmpvar_11;
  lowp vec3 arg1_12;
  arg1_12 = ((tmpvar_8.x * 2.0) * tmpvar_9.xyz);
  mediump vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_3.xyz * max (min (lm_10, arg1_12), (lm_10 * tmpvar_8.x)));
  c_1.xyz = tmpvar_13;
  c_1.w = tmpvar_2;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Matrix 4 [_Object2World]
Vector 9 [unity_NPOTScale]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
"agal_vs
c12 0.5 0.0 0.0 0.0
[bc]
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 r0.w, a0, c3
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 r0.z, a0, c2
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 r0.x, a0, c0
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 r0.y, a0, c1
adaaaaaaabaaahacaaaaaapeacaaaaaaamaaaaaaabaaaaaa mul r1.xyz, r0.xyww, c12.x
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
adaaaaaaabaaacacabaaaaffacaaaaaaaiaaaaaaabaaaaaa mul r1.y, r1.y, c8.x
abaaaaaaabaaadacabaaaafeacaaaaaaabaaaakkacaaaaaa add r1.xy, r1.xyyy, r1.z
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.y, a0, c6
adaaaaaaadaaadaeabaaaafeacaaaaaaajaaaaoeabaaaaaa mul v3.xy, r1.xyyy, c9
aaaaaaaaadaaamaeaaaaaaopacaaaaaaaaaaaaaaaaaaaaaa mov v3.zw, r0.wwzw
adaaaaaaabaaadacadaaaaoeaaaaaaaaalaaaaoeabaaaaaa mul r1.xy, a3, c11
abaaaaaaaaaaadaeabaaaafeacaaaaaaalaaaaooabaaaaaa add v0.xy, r1.xyyy, c11.zwzw
aaaaaaaaabaaadaeaaaaaafeacaaaaaaaaaaaaaaaaaaaaaa mov v1.xy, r0.xyyy
adaaaaaaaaaaadacaeaaaaoeaaaaaaaaakaaaaoeabaaaaaa mul r0.xy, a4, c10
abaaaaaaacaaadaeaaaaaafeacaaaaaaakaaaaooabaaaaaa add v2.xy, r0.xyyy, c10.zwzw
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
aaaaaaaaacaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.zw, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 224 // 224 used size, 12 vars
Vector 192 [unity_LightmapST] 4
Vector 208 [_MainTex_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 16 instructions, 2 temp regs, 0 temp arrays:
// ALU 13 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedkfgihafbadpmpfccfdghjicjcbmlmceaabaaaaaacmagaaaaaeaaaaaa
daaaaaaaaaacaaaameaeaaaaimafaaaaebgpgodjmiabaaaamiabaaaaaaacpopp
haabaaaafiaaaaaaaeaaceaaaaaafeaaaaaafeaaaaaaceaaabaafeaaaaaaamaa
acaaabaaaaaaaaaaabaaafaaabaaadaaaaaaaaaaacaaaaaaaeaaaeaaaaaaaaaa
acaaamaaaeaaaiaaaaaaaaaaaaaaaaaaaaacpoppfbaaaaafamaaapkaaaaaaadp
aaaaaaaaaaaaaaaaaaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaadia
adaaapjabpaaaaacafaaaeiaaeaaapjaafaaaaadaaaaadiaaaaaffjaajaaocka
aeaaaaaeaaaaadiaaiaaockaaaaaaajaaaaaoeiaaeaaaaaeaaaaadiaakaaocka
aaaakkjaaaaaoeiaaeaaaaaeaaaaamoaalaacekaaaaappjaaaaaeeiaaeaaaaae
aaaaadoaadaaoejaacaaoekaacaaookaaeaaaaaeabaaadoaaeaaoejaabaaoeka
abaaookaafaaaaadaaaaapiaaaaaffjaafaaoekaaeaaaaaeaaaaapiaaeaaoeka
aaaaaajaaaaaoeiaaeaaaaaeaaaaapiaagaaoekaaaaakkjaaaaaoeiaaeaaaaae
aaaaapiaahaaoekaaaaappjaaaaaoeiaafaaaaadabaaabiaaaaaffiaadaaaaka
afaaaaadabaaaiiaabaaaaiaamaaaakaafaaaaadabaaafiaaaaapeiaamaaaaka
acaaaaadacaaadoaabaakkiaabaaomiaaeaaaaaeaaaaadmaaaaappiaaaaaoeka
aaaaoeiaabaaaaacaaaaammaaaaaoeiaabaaaaacacaaamoaaaaaoeiappppaaaa
fdeieefclmacaaaaeaaaabaakpaaaaaafjaaaaaeegiocaaaaaaaaaaaaoaaaaaa
fjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaabaaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaa
aeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaa
gfaaaaadmccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagfaaaaadpccabaaa
adaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaidcaabaaa
abaaaaaafgbfbaaaaaaaaaaaigiacaaaacaaaaaaanaaaaaadcaaaaakdcaabaaa
abaaaaaaigiacaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegaabaaaabaaaaaa
dcaaaaakdcaabaaaabaaaaaaigiacaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egaabaaaabaaaaaadcaaaaakmccabaaaabaaaaaaagiicaaaacaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaagaebaaaabaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaaanaaaaaadcaaaaal
dccabaaaacaaaaaaegbabaaaaeaaaaaaegiacaaaaaaaaaaaamaaaaaaogikcaaa
aaaaaaaaamaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaa
abaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaa
aaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaadaaaaaakgaobaaa
aaaaaaaaaaaaaaahdccabaaaadaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaa
doaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
apaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaaaaaalaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaaabaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffied
epepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadamaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amadaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadamaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 432
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    highp vec2 lmap;
    highp vec4 _ShadowCoord;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 401
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 405
uniform highp vec4 _Player3_Pos;
#line 413
#line 427
#line 441
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
#line 457
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
#line 413
void vert( inout appdata_full vertexData, out Input outData ) {
    highp vec4 pos = (glstate_matrix_mvp * vertexData.vertex);
    highp vec4 posWorld = (_Object2World * vertexData.vertex);
    #line 417
    outData.uv_MainTex = vec2( vertexData.texcoord);
    outData.location = posWorld.xz;
}
#line 443
v2f_surf vert_surf( in appdata_full v ) {
    #line 445
    v2f_surf o;
    Input customInputData;
    vert( v, customInputData);
    o.cust_location = customInputData.location;
    #line 449
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    #line 453
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
out highp vec2 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.pack0);
    xlv_TEXCOORD1 = vec2(xl_retval.cust_location);
    xlv_TEXCOORD2 = vec2(xl_retval.lmap);
    xlv_TEXCOORD3 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 432
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    highp vec2 lmap;
    highp vec4 _ShadowCoord;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 401
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 405
uniform highp vec4 _Player3_Pos;
#line 413
#line 427
#line 441
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
#line 457
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 325
mediump vec3 DirLightmapDiffuse( in mediump mat3 dirBasis, in lowp vec4 color, in lowp vec4 scale, in mediump vec3 normal, in bool surfFuncWritesNormal, out mediump vec3 scalePerBasisVector ) {
    mediump vec3 lm = DecodeLightmap( color);
    scalePerBasisVector = DecodeLightmap( scale);
    #line 329
    if (surfFuncWritesNormal){
        mediump vec3 normalInRnmBasis = xll_saturate_vf3((dirBasis * normal));
        lm *= dot( normalInRnmBasis, scalePerBasisVector);
    }
    #line 334
    return lm;
}
#line 353
mediump vec4 LightingLambert_DirLightmap( in SurfaceOutput s, in lowp vec4 color, in lowp vec4 scale, in bool surfFuncWritesNormal ) {
    #line 355
    highp mat3 unity_DirBasis = xll_transpose_mf3x3(mat3( vec3( 0.816497, 0.0, 0.57735), vec3( -0.408248, 0.707107, 0.57735), vec3( -0.408248, -0.707107, 0.57735)));
    mediump vec3 scalePerBasisVector;
    mediump vec3 lm = DirLightmapDiffuse( unity_DirBasis, color, scale, s.Normal, surfFuncWritesNormal, scalePerBasisVector);
    return vec4( lm, 0.0);
}
#line 427
highp float powerForPos( in highp vec4 pos, in highp vec2 nearVertex ) {
    highp float atten = clamp( (_FogRadius - length((pos.xz - nearVertex.xy))), 0.0, _FogRadius);
    return (((1.0 / _FogMaxRadius) * atten) / _FogRadius);
}
#line 420
void surf( in Input IN, inout SurfaceOutput o ) {
    #line 422
    lowp vec4 baseColor = (texture( _MainTex, IN.uv_MainTex) * _Color);
    highp float alpha = (1.0 - (((baseColor.w + powerForPos( _Player1_Pos, IN.location)) + powerForPos( _Player2_Pos, IN.location)) + powerForPos( _Player3_Pos, IN.location)));
    o.Albedo = baseColor.xyz;
    o.Alpha = alpha;
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    highp float dist = textureProj( _ShadowMapTexture, shadowCoord).x;
    mediump float lightShadowDataX = _LightShadowData.x;
    #line 397
    return max( float((dist > (shadowCoord.z / shadowCoord.w))), lightShadowDataX);
}
#line 459
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 461
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.location = IN.cust_location;
    SurfaceOutput o;
    #line 465
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 469
    o.Gloss = 0.0;
    surf( surfIN, o);
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    #line 473
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec4 lmIndTex = texture( unity_LightmapInd, IN.lmap.xy);
    mediump vec3 lm = LightingLambert_DirLightmap( o, lmtex, lmIndTex, false).xyz;
    c.xyz += (o.Albedo * min( lm, vec3( (atten * 2.0))));
    #line 477
    c.w = o.Alpha;
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
in highp vec2 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec2(xlv_TEXCOORD0);
    xlt_IN.cust_location = vec2(xlv_TEXCOORD1);
    xlt_IN.lmap = vec2(xlv_TEXCOORD2);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [unity_4LightPosX0]
Vector 10 [unity_4LightPosY0]
Vector 11 [unity_4LightPosZ0]
Vector 12 [unity_4LightAtten0]
Vector 13 [unity_LightColor0]
Vector 14 [unity_LightColor1]
Vector 15 [unity_LightColor2]
Vector 16 [unity_LightColor3]
Vector 17 [unity_SHAr]
Vector 18 [unity_SHAg]
Vector 19 [unity_SHAb]
Vector 20 [unity_SHBr]
Vector 21 [unity_SHBg]
Vector 22 [unity_SHBb]
Vector 23 [unity_SHC]
Matrix 5 [_Object2World]
Vector 24 [unity_Scale]
Vector 25 [_MainTex_ST]
"!!ARBvp1.0
# 59 ALU
PARAM c[26] = { { 1, 0 },
		state.matrix.mvp,
		program.local[5..25] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R3.xyz, vertex.normal, c[24].w;
DP3 R3.w, R3, c[5];
DP3 R4.w, R3, c[6];
DP4 R0.x, vertex.position, c[6];
ADD R2, -R0.x, c[10];
MUL R0, R4.w, R2;
DP4 R4.z, vertex.position, c[5];
ADD R1, -R4.z, c[9];
MUL R2, R2, R2;
DP4 R4.xy, vertex.position, c[7];
MAD R0, R3.w, R1, R0;
MAD R2, R1, R1, R2;
ADD R1, -R4.x, c[11];
DP3 R4.x, R3, c[7];
MAD R2, R1, R1, R2;
MAD R0, R4.x, R1, R0;
MUL R1, R2, c[12];
ADD R1, R1, c[0].x;
MOV R3.x, R4.w;
MOV R3.y, R4.x;
MOV R3.z, c[0].x;
RSQ R2.x, R2.x;
RSQ R2.y, R2.y;
RSQ R2.z, R2.z;
RSQ R2.w, R2.w;
MUL R0, R0, R2;
DP4 R2.z, R3.wxyz, c[19];
DP4 R2.y, R3.wxyz, c[18];
DP4 R2.x, R3.wxyz, c[17];
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[14];
MAD R1.xyz, R0.x, c[13], R1;
MAD R0.xyz, R0.z, c[15], R1;
MAD R1.xyz, R0.w, c[16], R0;
MUL R0, R3.wxyy, R3.xyyw;
MUL R1.w, R4, R4;
MOV result.texcoord[2].y, R4.w;
MOV R4.w, R4.y;
DP4 R3.z, R0, c[22];
DP4 R3.y, R0, c[21];
DP4 R3.x, R0, c[20];
MAD R1.w, R3, R3, -R1;
MUL R0.xyz, R1.w, c[23];
ADD R2.xyz, R2, R3;
ADD R0.xyz, R2, R0;
ADD result.texcoord[3].xyz, R0, R1;
MOV result.texcoord[2].z, R4.x;
MOV result.texcoord[2].x, R3.w;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[25], c[25].zwzw;
MOV result.texcoord[1].xy, R4.zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 59 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_4LightPosX0]
Vector 9 [unity_4LightPosY0]
Vector 10 [unity_4LightPosZ0]
Vector 11 [unity_4LightAtten0]
Vector 12 [unity_LightColor0]
Vector 13 [unity_LightColor1]
Vector 14 [unity_LightColor2]
Vector 15 [unity_LightColor3]
Vector 16 [unity_SHAr]
Vector 17 [unity_SHAg]
Vector 18 [unity_SHAb]
Vector 19 [unity_SHBr]
Vector 20 [unity_SHBg]
Vector 21 [unity_SHBb]
Vector 22 [unity_SHC]
Matrix 4 [_Object2World]
Vector 23 [unity_Scale]
Vector 24 [_MainTex_ST]
"vs_2_0
; 59 ALU
def c25, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c23.w
dp3 r3.w, r3, c4
dp3 r4.w, r3, c5
dp4 r0.x, v0, c5
add r2, -r0.x, c9
mul r0, r4.w, r2
dp4 r4.z, v0, c4
add r1, -r4.z, c8
mul r2, r2, r2
dp4 r4.xy, v0, c6
mad r0, r3.w, r1, r0
mad r2, r1, r1, r2
add r1, -r4.x, c10
dp3 r4.x, r3, c6
mad r2, r1, r1, r2
mad r0, r4.x, r1, r0
mul r1, r2, c11
add r1, r1, c25.x
mov r3.x, r4.w
mov r3.y, r4.x
mov r3.z, c25.x
rsq r2.x, r2.x
rsq r2.y, r2.y
rsq r2.z, r2.z
rsq r2.w, r2.w
mul r0, r0, r2
dp4 r2.z, r3.wxyz, c18
dp4 r2.y, r3.wxyz, c17
dp4 r2.x, r3.wxyz, c16
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c25.y
mul r0, r0, r1
mul r1.xyz, r0.y, c13
mad r1.xyz, r0.x, c12, r1
mad r0.xyz, r0.z, c14, r1
mad r1.xyz, r0.w, c15, r0
mul r0, r3.wxyy, r3.xyyw
mul r1.w, r4, r4
mov oT2.y, r4.w
mov r4.w, r4.y
dp4 r3.z, r0, c21
dp4 r3.y, r0, c20
dp4 r3.x, r0, c19
mad r1.w, r3, r3, -r1
mul r0.xyz, r1.w, c22
add r2.xyz, r2, r3
add r0.xyz, r2, r0
add oT3.xyz, r0, r1
mov oT2.z, r4.x
mov oT2.x, r3.w
mad oT0.xy, v2, c24, c24.zwzw
mov oT1.xy, r4.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 144 // 144 used size, 10 vars
Vector 128 [_MainTex_ST] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 32 [unity_4LightPosX0] 4
Vector 48 [unity_4LightPosY0] 4
Vector 64 [unity_4LightPosZ0] 4
Vector 80 [unity_4LightAtten0] 4
Vector 96 [unity_LightColor0] 4
Vector 112 [unity_LightColor1] 4
Vector 128 [unity_LightColor2] 4
Vector 144 [unity_LightColor3] 4
Vector 160 [unity_LightColor4] 4
Vector 176 [unity_LightColor5] 4
Vector 192 [unity_LightColor6] 4
Vector 208 [unity_LightColor7] 4
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 51 instructions, 6 temp regs, 0 temp arrays:
// ALU 48 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedipmeliemoaeoommhegckffndcnimobfjabaaaaaaamajaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefchaahaaaaeaaaabaa
nmabaaaafjaaaaaeegiocaaaaaaaaaaaajaaaaaafjaaaaaeegiocaaaabaaaaaa
cnaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagiaaaaacagaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
acaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaidcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaigiacaaaacaaaaaaanaaaaaadcaaaaakdcaabaaa
aaaaaaaaigiacaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegaabaaaaaaaaaaa
dcaaaaakdcaabaaaaaaaaaaaigiacaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egaabaaaaaaaaaaadcaaaaakmccabaaaabaaaaaaagiicaaaacaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaagaebaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaaiaaaaaaogikcaaaaaaaaaaaaiaaaaaadiaaaaai
hcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaacaaaaaabeaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
lcaabaaaaaaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaa
abaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaa
aaaaaaaaegadbaaaaaaaaaaadgaaaaafhccabaaaacaaaaaaegacbaaaaaaaaaaa
dgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaabaaaaaa
egiocaaaabaaaaaacgaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaaabaaaaaa
egiocaaaabaaaaaachaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaaabaaaaaa
egiocaaaabaaaaaaciaaaaaaegaobaaaaaaaaaaadiaaaaahpcaabaaaacaaaaaa
jgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaa
abaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaa
abaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaa
abaaaaaaclaaaaaaegaobaaaacaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaa
abaaaaaaegacbaaaadaaaaaadiaaaaahicaabaaaaaaaaaaabkaabaaaaaaaaaaa
bkaabaaaaaaaaaaadcaaaaakicaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaa
aaaaaaaadkaabaiaebaaaaaaaaaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
abaaaaaacmaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaa
acaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaa
acaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaacaaaaaa
dcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egacbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaegacbaaaacaaaaaaaaaaaaajpcaabaaaadaaaaaafgafbaia
ebaaaaaaacaaaaaaegiocaaaabaaaaaaadaaaaaadiaaaaahpcaabaaaaeaaaaaa
fgafbaaaaaaaaaaaegaobaaaadaaaaaadiaaaaahpcaabaaaadaaaaaaegaobaaa
adaaaaaaegaobaaaadaaaaaaaaaaaaajpcaabaaaafaaaaaaagaabaiaebaaaaaa
acaaaaaaegiocaaaabaaaaaaacaaaaaaaaaaaaajpcaabaaaacaaaaaakgakbaia
ebaaaaaaacaaaaaaegiocaaaabaaaaaaaeaaaaaadcaaaaajpcaabaaaaeaaaaaa
egaobaaaafaaaaaaagaabaaaaaaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaa
aaaaaaaaegaobaaaacaaaaaakgakbaaaaaaaaaaaegaobaaaaeaaaaaadcaaaaaj
pcaabaaaadaaaaaaegaobaaaafaaaaaaegaobaaaafaaaaaaegaobaaaadaaaaaa
dcaaaaajpcaabaaaacaaaaaaegaobaaaacaaaaaaegaobaaaacaaaaaaegaobaaa
adaaaaaaeeaaaaafpcaabaaaadaaaaaaegaobaaaacaaaaaadcaaaaanpcaabaaa
acaaaaaaegaobaaaacaaaaaaegiocaaaabaaaaaaafaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpaoaaaaakpcaabaaaacaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpegaobaaaacaaaaaadiaaaaahpcaabaaaaaaaaaaa
egaobaaaaaaaaaaaegaobaaaadaaaaaadeaaaaakpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadiaaaaahpcaabaaa
aaaaaaaaegaobaaaacaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaaacaaaaaa
fgafbaaaaaaaaaaaegiccaaaabaaaaaaahaaaaaadcaaaaakhcaabaaaacaaaaaa
egiccaaaabaaaaaaagaaaaaaagaabaaaaaaaaaaaegacbaaaacaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaabaaaaaaaiaaaaaakgakbaaaaaaaaaaaegacbaaa
acaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaajaaaaaapgapbaaa
aaaaaaaaegacbaaaaaaaaaaaaaaaaaahhccabaaaadaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal_8;
  normal_8 = tmpvar_6;
  highp float vC_9;
  mediump vec3 x3_10;
  mediump vec3 x2_11;
  mediump vec3 x1_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal_8);
  x1_12.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal_8);
  x1_12.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal_8);
  x1_12.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal_8.xyzz * normal_8.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2_11.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2_11.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2_11.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal_8.x * normal_8.x) - (normal_8.y * normal_8.y));
  vC_9 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC_9);
  x3_10 = tmpvar_21;
  tmpvar_7 = ((x1_12 + x2_11) + x3_10);
  shlight_1 = tmpvar_7;
  tmpvar_3 = shlight_1;
  highp vec3 tmpvar_22;
  tmpvar_22 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_4LightPosX0 - tmpvar_22.x);
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosY0 - tmpvar_22.y);
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_4LightPosZ0 - tmpvar_22.z);
  highp vec4 tmpvar_26;
  tmpvar_26 = (((tmpvar_23 * tmpvar_23) + (tmpvar_24 * tmpvar_24)) + (tmpvar_25 * tmpvar_25));
  highp vec4 tmpvar_27;
  tmpvar_27 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_23 * tmpvar_5.x) + (tmpvar_24 * tmpvar_5.y)) + (tmpvar_25 * tmpvar_5.z)) * inversesqrt(tmpvar_26))) * (1.0/((1.0 + (tmpvar_26 * unity_4LightAtten0)))));
  highp vec3 tmpvar_28;
  tmpvar_28 = (tmpvar_3 + ((((unity_LightColor[0].xyz * tmpvar_27.x) + (unity_LightColor[1].xyz * tmpvar_27.y)) + (unity_LightColor[2].xyz * tmpvar_27.z)) + (unity_LightColor[3].xyz * tmpvar_27.w)));
  tmpvar_3 = tmpvar_28;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp float tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_4;
  arg0_4 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_5;
  arg0_5 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_6;
  arg0_6 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_7;
  tmpvar_7 = (1.0 - (((tmpvar_3.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_4, arg0_4))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_5, arg0_5))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_2 = tmpvar_7;
  lowp vec4 c_8;
  c_8.xyz = ((tmpvar_3.xyz * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz)) * 2.0));
  c_8.w = tmpvar_2;
  c_1.w = c_8.w;
  c_1.xyz = (c_8.xyz + (tmpvar_3.xyz * xlv_TEXCOORD3));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal_8;
  normal_8 = tmpvar_6;
  highp float vC_9;
  mediump vec3 x3_10;
  mediump vec3 x2_11;
  mediump vec3 x1_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal_8);
  x1_12.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal_8);
  x1_12.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal_8);
  x1_12.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal_8.xyzz * normal_8.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2_11.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2_11.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2_11.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal_8.x * normal_8.x) - (normal_8.y * normal_8.y));
  vC_9 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC_9);
  x3_10 = tmpvar_21;
  tmpvar_7 = ((x1_12 + x2_11) + x3_10);
  shlight_1 = tmpvar_7;
  tmpvar_3 = shlight_1;
  highp vec3 tmpvar_22;
  tmpvar_22 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_4LightPosX0 - tmpvar_22.x);
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosY0 - tmpvar_22.y);
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_4LightPosZ0 - tmpvar_22.z);
  highp vec4 tmpvar_26;
  tmpvar_26 = (((tmpvar_23 * tmpvar_23) + (tmpvar_24 * tmpvar_24)) + (tmpvar_25 * tmpvar_25));
  highp vec4 tmpvar_27;
  tmpvar_27 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_23 * tmpvar_5.x) + (tmpvar_24 * tmpvar_5.y)) + (tmpvar_25 * tmpvar_5.z)) * inversesqrt(tmpvar_26))) * (1.0/((1.0 + (tmpvar_26 * unity_4LightAtten0)))));
  highp vec3 tmpvar_28;
  tmpvar_28 = (tmpvar_3 + ((((unity_LightColor[0].xyz * tmpvar_27.x) + (unity_LightColor[1].xyz * tmpvar_27.y)) + (unity_LightColor[2].xyz * tmpvar_27.z)) + (unity_LightColor[3].xyz * tmpvar_27.w)));
  tmpvar_3 = tmpvar_28;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp float tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_4;
  arg0_4 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_5;
  arg0_5 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_6;
  arg0_6 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_7;
  tmpvar_7 = (1.0 - (((tmpvar_3.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_4, arg0_4))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_5, arg0_5))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_2 = tmpvar_7;
  lowp vec4 c_8;
  c_8.xyz = ((tmpvar_3.xyz * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz)) * 2.0));
  c_8.w = tmpvar_2;
  c_1.w = c_8.w;
  c_1.xyz = (c_8.xyz + (tmpvar_3.xyz * xlv_TEXCOORD3));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_4LightPosX0]
Vector 9 [unity_4LightPosY0]
Vector 10 [unity_4LightPosZ0]
Vector 11 [unity_4LightAtten0]
Vector 12 [unity_LightColor0]
Vector 13 [unity_LightColor1]
Vector 14 [unity_LightColor2]
Vector 15 [unity_LightColor3]
Vector 16 [unity_SHAr]
Vector 17 [unity_SHAg]
Vector 18 [unity_SHAb]
Vector 19 [unity_SHBr]
Vector 20 [unity_SHBg]
Vector 21 [unity_SHBb]
Vector 22 [unity_SHC]
Matrix 4 [_Object2World]
Vector 23 [unity_Scale]
Vector 24 [_MainTex_ST]
"agal_vs
c25 1.0 0.0 0.0 0.0
[bc]
adaaaaaaadaaahacabaaaaoeaaaaaaaabhaaaappabaaaaaa mul r3.xyz, a1, c23.w
bcaaaaaaadaaaiacadaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r3.w, r3.xyzz, c4
bcaaaaaaaeaaaiacadaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r4.w, r3.xyzz, c5
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.x, a0, c5
bfaaaaaaacaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r2.x, r0.x
abaaaaaaacaaapacacaaaaaaacaaaaaaajaaaaoeabaaaaaa add r2, r2.x, c9
adaaaaaaaaaaapacaeaaaappacaaaaaaacaaaaoeacaaaaaa mul r0, r4.w, r2
bdaaaaaaaeaaaeacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r4.z, a0, c4
bfaaaaaaabaaaeacaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa neg r1.z, r4.z
abaaaaaaabaaapacabaaaakkacaaaaaaaiaaaaoeabaaaaaa add r1, r1.z, c8
adaaaaaaacaaapacacaaaaoeacaaaaaaacaaaaoeacaaaaaa mul r2, r2, r2
bdaaaaaaaeaaadacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r4.xy, a0, c6
adaaaaaaafaaapacadaaaappacaaaaaaabaaaaoeacaaaaaa mul r5, r3.w, r1
abaaaaaaaaaaapacafaaaaoeacaaaaaaaaaaaaoeacaaaaaa add r0, r5, r0
adaaaaaaafaaapacabaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r5, r1, r1
abaaaaaaacaaapacafaaaaoeacaaaaaaacaaaaoeacaaaaaa add r2, r5, r2
bfaaaaaaabaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r1.x, r4.x
abaaaaaaabaaapacabaaaaaaacaaaaaaakaaaaoeabaaaaaa add r1, r1.x, c10
bcaaaaaaaeaaabacadaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r4.x, r3.xyzz, c6
adaaaaaaafaaapacabaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r5, r1, r1
abaaaaaaacaaapacafaaaaoeacaaaaaaacaaaaoeacaaaaaa add r2, r5, r2
adaaaaaaafaaapacaeaaaaaaacaaaaaaabaaaaoeacaaaaaa mul r5, r4.x, r1
abaaaaaaaaaaapacafaaaaoeacaaaaaaaaaaaaoeacaaaaaa add r0, r5, r0
adaaaaaaabaaapacacaaaaoeacaaaaaaalaaaaoeabaaaaaa mul r1, r2, c11
abaaaaaaabaaapacabaaaaoeacaaaaaabjaaaaaaabaaaaaa add r1, r1, c25.x
aaaaaaaaadaaabacaeaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r3.x, r4.w
aaaaaaaaadaaacacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r3.y, r4.x
aaaaaaaaadaaaeacbjaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r3.z, c25.x
akaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r2.x, r2.x
akaaaaaaacaaacacacaaaaffacaaaaaaaaaaaaaaaaaaaaaa rsq r2.y, r2.y
akaaaaaaacaaaeacacaaaakkacaaaaaaaaaaaaaaaaaaaaaa rsq r2.z, r2.z
akaaaaaaacaaaiacacaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r2.w, r2.w
adaaaaaaaaaaapacaaaaaaoeacaaaaaaacaaaaoeacaaaaaa mul r0, r0, r2
bdaaaaaaacaaaeacadaaaajdacaaaaaabcaaaaoeabaaaaaa dp4 r2.z, r3.wxyz, c18
bdaaaaaaacaaacacadaaaajdacaaaaaabbaaaaoeabaaaaaa dp4 r2.y, r3.wxyz, c17
bdaaaaaaacaaabacadaaaajdacaaaaaabaaaaaoeabaaaaaa dp4 r2.x, r3.wxyz, c16
afaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r1.x, r1.x
afaaaaaaabaaacacabaaaaffacaaaaaaaaaaaaaaaaaaaaaa rcp r1.y, r1.y
afaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r1.w, r1.w
afaaaaaaabaaaeacabaaaakkacaaaaaaaaaaaaaaaaaaaaaa rcp r1.z, r1.z
ahaaaaaaaaaaapacaaaaaaoeacaaaaaabjaaaaffabaaaaaa max r0, r0, c25.y
adaaaaaaaaaaapacaaaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r0, r0, r1
adaaaaaaabaaahacaaaaaaffacaaaaaaanaaaaoeabaaaaaa mul r1.xyz, r0.y, c13
adaaaaaaafaaahacaaaaaaaaacaaaaaaamaaaaoeabaaaaaa mul r5.xyz, r0.x, c12
abaaaaaaabaaahacafaaaakeacaaaaaaabaaaakeacaaaaaa add r1.xyz, r5.xyzz, r1.xyzz
adaaaaaaaaaaahacaaaaaakkacaaaaaaaoaaaaoeabaaaaaa mul r0.xyz, r0.z, c14
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa add r0.xyz, r0.xyzz, r1.xyzz
adaaaaaaabaaahacaaaaaappacaaaaaaapaaaaoeabaaaaaa mul r1.xyz, r0.w, c15
abaaaaaaabaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r1.xyz, r1.xyzz, r0.xyzz
adaaaaaaaaaaapacadaaaafdacaaaaaaadaaaaneacaaaaaa mul r0, r3.wxyy, r3.xyyw
adaaaaaaabaaaiacaeaaaappacaaaaaaaeaaaappacaaaaaa mul r1.w, r4.w, r4.w
aaaaaaaaacaaacaeaeaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v2.y, r4.w
aaaaaaaaaeaaaiacaeaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r4.w, r4.y
bdaaaaaaadaaaeacaaaaaaoeacaaaaaabfaaaaoeabaaaaaa dp4 r3.z, r0, c21
bdaaaaaaadaaacacaaaaaaoeacaaaaaabeaaaaoeabaaaaaa dp4 r3.y, r0, c20
bdaaaaaaadaaabacaaaaaaoeacaaaaaabdaaaaoeabaaaaaa dp4 r3.x, r0, c19
adaaaaaaafaaaiacadaaaappacaaaaaaadaaaappacaaaaaa mul r5.w, r3.w, r3.w
acaaaaaaabaaaiacafaaaappacaaaaaaabaaaappacaaaaaa sub r1.w, r5.w, r1.w
adaaaaaaaaaaahacabaaaappacaaaaaabgaaaaoeabaaaaaa mul r0.xyz, r1.w, c22
abaaaaaaacaaahacacaaaakeacaaaaaaadaaaakeacaaaaaa add r2.xyz, r2.xyzz, r3.xyzz
abaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r2.xyzz, r0.xyzz
abaaaaaaadaaahaeaaaaaakeacaaaaaaabaaaakeacaaaaaa add v3.xyz, r0.xyzz, r1.xyzz
aaaaaaaaacaaaeaeaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov v2.z, r4.x
aaaaaaaaacaaabaeadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v2.x, r3.w
adaaaaaaafaaadacadaaaaoeaaaaaaaabiaaaaoeabaaaaaa mul r5.xy, a3, c24
abaaaaaaaaaaadaeafaaaafeacaaaaaabiaaaaooabaaaaaa add v0.xy, r5.xyyy, c24.zwzw
aaaaaaaaabaaadaeaeaaaapoacaaaaaaaaaaaaaaaaaaaaaa mov v1.xy, r4.zwww
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 144 // 144 used size, 10 vars
Vector 128 [_MainTex_ST] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 32 [unity_4LightPosX0] 4
Vector 48 [unity_4LightPosY0] 4
Vector 64 [unity_4LightPosZ0] 4
Vector 80 [unity_4LightAtten0] 4
Vector 96 [unity_LightColor0] 4
Vector 112 [unity_LightColor1] 4
Vector 128 [unity_LightColor2] 4
Vector 144 [unity_LightColor3] 4
Vector 160 [unity_LightColor4] 4
Vector 176 [unity_LightColor5] 4
Vector 192 [unity_LightColor6] 4
Vector 208 [unity_LightColor7] 4
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 51 instructions, 6 temp regs, 0 temp arrays:
// ALU 48 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedcoghdjemngblinpdbddgbnkgddackddbabaaaaaakianaaaaaeaaaaaa
daaaaaaamiaeaaaaeaamaaaaaianaaaaebgpgodjjaaeaaaajaaeaaaaaaacpopp
caaeaaaahaaaaaaaagaaceaaaaaagmaaaaaagmaaaaaaceaaabaagmaaaaaaaiaa
abaaabaaaaaaaaaaabaaacaaaiaaacaaaaaaaaaaabaacgaaahaaakaaaaaaaaaa
acaaaaaaaeaabbaaaaaaaaaaacaaamaaaeaabfaaaaaaaaaaacaabeaaabaabjaa
aaaaaaaaaaaaaaaaaaacpoppfbaaaaafbkaaapkaaaaaiadpaaaaaaaaaaaaaaaa
aaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaaciaacaaapjabpaaaaac
afaaadiaadaaapjaafaaaaadaaaaadiaaaaaffjabgaaockaaeaaaaaeaaaaadia
bfaaockaaaaaaajaaaaaoeiaaeaaaaaeaaaaadiabhaaockaaaaakkjaaaaaoeia
aeaaaaaeaaaaamoabiaacekaaaaappjaaaaaeeiaaeaaaaaeaaaaadoaadaaoeja
abaaoekaabaaookaafaaaaadaaaaahiaaaaaffjabgaaoekaaeaaaaaeaaaaahia
bfaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaahiabhaaoekaaaaakkjaaaaaoeia
aeaaaaaeaaaaahiabiaaoekaaaaappjaaaaaoeiaacaaaaadabaaapiaaaaaffib
adaaoekaafaaaaadacaaapiaabaaoeiaabaaoeiaacaaaaadadaaapiaaaaaaaib
acaaoekaacaaaaadaaaaapiaaaaakkibaeaaoekaaeaaaaaeacaaapiaadaaoeia
adaaoeiaacaaoeiaaeaaaaaeacaaapiaaaaaoeiaaaaaoeiaacaaoeiaahaaaaac
aeaaabiaacaaaaiaahaaaaacaeaaaciaacaaffiaahaaaaacaeaaaeiaacaakkia
ahaaaaacaeaaaiiaacaappiaabaaaaacafaaabiabkaaaakaaeaaaaaeacaaapia
acaaoeiaafaaoekaafaaaaiaafaaaaadafaaahiaacaaoejabjaappkaafaaaaad
agaaahiaafaaffiabgaaoekaaeaaaaaeafaaaliabfaakekaafaaaaiaagaakeia
aeaaaaaeafaaahiabhaaoekaafaakkiaafaapeiaafaaaaadabaaapiaabaaoeia
afaaffiaaeaaaaaeabaaapiaadaaoeiaafaaaaiaabaaoeiaaeaaaaaeaaaaapia
aaaaoeiaafaakkiaabaaoeiaafaaaaadaaaaapiaaeaaoeiaaaaaoeiaalaaaaad
aaaaapiaaaaaoeiabkaaffkaagaaaaacabaaabiaacaaaaiaagaaaaacabaaacia
acaaffiaagaaaaacabaaaeiaacaakkiaagaaaaacabaaaiiaacaappiaafaaaaad
aaaaapiaaaaaoeiaabaaoeiaafaaaaadabaaahiaaaaaffiaahaaoekaaeaaaaae
abaaahiaagaaoekaaaaaaaiaabaaoeiaaeaaaaaeaaaaahiaaiaaoekaaaaakkia
abaaoeiaaeaaaaaeaaaaahiaajaaoekaaaaappiaaaaaoeiaabaaaaacafaaaiia
bkaaaakaajaaaaadabaaabiaakaaoekaafaaoeiaajaaaaadabaaaciaalaaoeka
afaaoeiaajaaaaadabaaaeiaamaaoekaafaaoeiaafaaaaadacaaapiaafaacjia
afaakeiaajaaaaadadaaabiaanaaoekaacaaoeiaajaaaaadadaaaciaaoaaoeka
acaaoeiaajaaaaadadaaaeiaapaaoekaacaaoeiaacaaaaadabaaahiaabaaoeia
adaaoeiaafaaaaadaaaaaiiaafaaffiaafaaffiaaeaaaaaeaaaaaiiaafaaaaia
afaaaaiaaaaappibabaaaaacabaaahoaafaaoeiaaeaaaaaeabaaahiabaaaoeka
aaaappiaabaaoeiaacaaaaadacaaahoaaaaaoeiaabaaoeiaafaaaaadaaaaapia
aaaaffjabcaaoekaaeaaaaaeaaaaapiabbaaoekaaaaaaajaaaaaoeiaaeaaaaae
aaaaapiabdaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiabeaaoekaaaaappja
aaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaamma
aaaaoeiappppaaaafdeieefchaahaaaaeaaaabaanmabaaaafjaaaaaeegiocaaa
aaaaaaaaajaaaaaafjaaaaaeegiocaaaabaaaaaacnaaaaaafjaaaaaeegiocaaa
acaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaa
fpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
dccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagiaaaaacagaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadiaaaaaidcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
igiacaaaacaaaaaaanaaaaaadcaaaaakdcaabaaaaaaaaaaaigiacaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaakdcaabaaaaaaaaaaa
igiacaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaak
mccabaaaabaaaaaaagiicaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaagaebaaa
aaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
aiaaaaaaogikcaaaaaaaaaaaaiaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaa
acaaaaaapgipcaaaacaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaa
aaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaa
acaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaa
dgaaaaafhccabaaaacaaaaaaegacbaaaaaaaaaaadgaaaaaficaabaaaaaaaaaaa
abeaaaaaaaaaiadpbbaaaaaibcaabaaaabaaaaaaegiocaaaabaaaaaacgaaaaaa
egaobaaaaaaaaaaabbaaaaaiccaabaaaabaaaaaaegiocaaaabaaaaaachaaaaaa
egaobaaaaaaaaaaabbaaaaaiecaabaaaabaaaaaaegiocaaaabaaaaaaciaaaaaa
egaobaaaaaaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaa
aaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaaabaaaaaacjaaaaaaegaobaaa
acaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaabaaaaaackaaaaaaegaobaaa
acaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaabaaaaaaclaaaaaaegaobaaa
acaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaa
diaaaaahicaabaaaaaaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaak
icaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaadkaabaiaebaaaaaa
aaaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaabaaaaaacmaaaaaapgapbaaa
aaaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaacaaaaaafgbfbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaa
egiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaacaaaaaadcaaaaak
hcaabaaaacaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
acaaaaaaaaaaaaajpcaabaaaadaaaaaafgafbaiaebaaaaaaacaaaaaaegiocaaa
abaaaaaaadaaaaaadiaaaaahpcaabaaaaeaaaaaafgafbaaaaaaaaaaaegaobaaa
adaaaaaadiaaaaahpcaabaaaadaaaaaaegaobaaaadaaaaaaegaobaaaadaaaaaa
aaaaaaajpcaabaaaafaaaaaaagaabaiaebaaaaaaacaaaaaaegiocaaaabaaaaaa
acaaaaaaaaaaaaajpcaabaaaacaaaaaakgakbaiaebaaaaaaacaaaaaaegiocaaa
abaaaaaaaeaaaaaadcaaaaajpcaabaaaaeaaaaaaegaobaaaafaaaaaaagaabaaa
aaaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaaacaaaaaa
kgakbaaaaaaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaaadaaaaaaegaobaaa
afaaaaaaegaobaaaafaaaaaaegaobaaaadaaaaaadcaaaaajpcaabaaaacaaaaaa
egaobaaaacaaaaaaegaobaaaacaaaaaaegaobaaaadaaaaaaeeaaaaafpcaabaaa
adaaaaaaegaobaaaacaaaaaadcaaaaanpcaabaaaacaaaaaaegaobaaaacaaaaaa
egiocaaaabaaaaaaafaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadp
aoaaaaakpcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadp
egaobaaaacaaaaaadiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaa
adaaaaaadeaaaaakpcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaadiaaaaahpcaabaaaaaaaaaaaegaobaaaacaaaaaa
egaobaaaaaaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaaaaaaaaaegiccaaa
abaaaaaaahaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaabaaaaaaagaaaaaa
agaabaaaaaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
abaaaaaaaiaaaaaakgakbaaaaaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaabaaaaaaajaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
aaaaaaahhccabaaaadaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab
ejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaa
kjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaa
faepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfcee
aaedepemepfcaaklepfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaadamaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaa
imaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaaimaaaaaaadaaaaaa
aaaaaaaaadaaaaaaadaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 398
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    lowp vec3 normal;
    lowp vec3 vlight;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 393
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 397
uniform highp vec4 _Player3_Pos;
#line 405
#line 419
#line 433
uniform highp vec4 _MainTex_ST;
#line 96
highp vec3 Shade4PointLights( in highp vec4 lightPosX, in highp vec4 lightPosY, in highp vec4 lightPosZ, in highp vec3 lightColor0, in highp vec3 lightColor1, in highp vec3 lightColor2, in highp vec3 lightColor3, in highp vec4 lightAttenSq, in highp vec3 pos, in highp vec3 normal ) {
    highp vec4 toLightX = (lightPosX - pos.x);
    highp vec4 toLightY = (lightPosY - pos.y);
    #line 100
    highp vec4 toLightZ = (lightPosZ - pos.z);
    highp vec4 lengthSq = vec4( 0.0);
    lengthSq += (toLightX * toLightX);
    lengthSq += (toLightY * toLightY);
    #line 104
    lengthSq += (toLightZ * toLightZ);
    highp vec4 ndotl = vec4( 0.0);
    ndotl += (toLightX * normal.x);
    ndotl += (toLightY * normal.y);
    #line 108
    ndotl += (toLightZ * normal.z);
    highp vec4 corr = inversesqrt(lengthSq);
    ndotl = max( vec4( 0.0, 0.0, 0.0, 0.0), (ndotl * corr));
    highp vec4 atten = (1.0 / (1.0 + (lengthSq * lightAttenSq)));
    #line 112
    highp vec4 diff = (ndotl * atten);
    highp vec3 col = vec3( 0.0);
    col += (lightColor0 * diff.x);
    col += (lightColor1 * diff.y);
    #line 116
    col += (lightColor2 * diff.z);
    col += (lightColor3 * diff.w);
    return col;
}
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 405
void vert( inout appdata_full vertexData, out Input outData ) {
    highp vec4 pos = (glstate_matrix_mvp * vertexData.vertex);
    highp vec4 posWorld = (_Object2World * vertexData.vertex);
    #line 409
    outData.uv_MainTex = vec2( vertexData.texcoord);
    outData.location = posWorld.xz;
}
#line 434
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 437
    Input customInputData;
    vert( v, customInputData);
    o.cust_location = customInputData.location;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 441
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 shlight = ShadeSH9( vec4( worldN, 1.0));
    #line 445
    o.vlight = shlight;
    highp vec3 worldPos = (_Object2World * v.vertex).xyz;
    o.vlight += Shade4PointLights( unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0, unity_LightColor[0].xyz, unity_LightColor[1].xyz, unity_LightColor[2].xyz, unity_LightColor[3].xyz, unity_4LightAtten0, worldPos, worldN);
    #line 449
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out lowp vec3 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.pack0);
    xlv_TEXCOORD1 = vec2(xl_retval.cust_location);
    xlv_TEXCOORD2 = vec3(xl_retval.normal);
    xlv_TEXCOORD3 = vec3(xl_retval.vlight);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 398
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    lowp vec3 normal;
    lowp vec3 vlight;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 393
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 397
uniform highp vec4 _Player3_Pos;
#line 405
#line 419
#line 433
uniform highp vec4 _MainTex_ST;
#line 338
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp vec4 c;
    #line 342
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.0));
    c.w = s.Alpha;
    return c;
}
#line 419
highp float powerForPos( in highp vec4 pos, in highp vec2 nearVertex ) {
    highp float atten = clamp( (_FogRadius - length((pos.xz - nearVertex.xy))), 0.0, _FogRadius);
    return (((1.0 / _FogMaxRadius) * atten) / _FogRadius);
}
#line 412
void surf( in Input IN, inout SurfaceOutput o ) {
    #line 414
    lowp vec4 baseColor = (texture( _MainTex, IN.uv_MainTex) * _Color);
    highp float alpha = (1.0 - (((baseColor.w + powerForPos( _Player1_Pos, IN.location)) + powerForPos( _Player2_Pos, IN.location)) + powerForPos( _Player3_Pos, IN.location)));
    o.Albedo = baseColor.xyz;
    o.Alpha = alpha;
}
#line 451
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 453
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.location = IN.cust_location;
    SurfaceOutput o;
    #line 457
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 461
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    surf( surfIN, o);
    lowp float atten = 1.0;
    #line 465
    lowp vec4 c = vec4( 0.0);
    c = LightingLambert( o, _WorldSpaceLightPos0.xyz, atten);
    c.xyz += (o.Albedo * IN.vlight);
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in lowp vec3 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec2(xlv_TEXCOORD0);
    xlt_IN.cust_location = vec2(xlv_TEXCOORD1);
    xlt_IN.normal = vec3(xlv_TEXCOORD2);
    xlt_IN.vlight = vec3(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_ProjectionParams]
Vector 10 [unity_4LightPosX0]
Vector 11 [unity_4LightPosY0]
Vector 12 [unity_4LightPosZ0]
Vector 13 [unity_4LightAtten0]
Vector 14 [unity_LightColor0]
Vector 15 [unity_LightColor1]
Vector 16 [unity_LightColor2]
Vector 17 [unity_LightColor3]
Vector 18 [unity_SHAr]
Vector 19 [unity_SHAg]
Vector 20 [unity_SHAb]
Vector 21 [unity_SHBr]
Vector 22 [unity_SHBg]
Vector 23 [unity_SHBb]
Vector 24 [unity_SHC]
Matrix 5 [_Object2World]
Vector 25 [unity_Scale]
Vector 26 [_MainTex_ST]
"!!ARBvp1.0
# 65 ALU
PARAM c[27] = { { 1, 0, 0.5 },
		state.matrix.mvp,
		program.local[5..26] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R3.xyz, vertex.normal, c[25].w;
DP3 R3.w, R3, c[5];
DP3 R4.w, R3, c[6];
DP4 R0.x, vertex.position, c[6];
ADD R2, -R0.x, c[11];
MUL R0, R4.w, R2;
DP4 R4.z, vertex.position, c[5];
ADD R1, -R4.z, c[10];
MUL R2, R2, R2;
DP4 R4.xy, vertex.position, c[7];
MAD R0, R3.w, R1, R0;
MAD R2, R1, R1, R2;
ADD R1, -R4.x, c[12];
DP3 R4.x, R3, c[7];
MAD R2, R1, R1, R2;
MAD R0, R4.x, R1, R0;
MUL R1, R2, c[13];
ADD R1, R1, c[0].x;
MOV R3.x, R4.w;
MOV R3.y, R4.x;
MOV R3.z, c[0].x;
RSQ R2.x, R2.x;
RSQ R2.y, R2.y;
RSQ R2.z, R2.z;
RSQ R2.w, R2.w;
MUL R0, R0, R2;
DP4 R2.z, R3.wxyz, c[20];
DP4 R2.y, R3.wxyz, c[19];
DP4 R2.x, R3.wxyz, c[18];
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[15];
MAD R1.xyz, R0.x, c[14], R1;
MAD R0.xyz, R0.z, c[16], R1;
MAD R1.xyz, R0.w, c[17], R0;
MUL R0, R3.wxyy, R3.xyyw;
MUL R1.w, R4, R4;
MOV result.texcoord[2].y, R4.w;
MOV R4.w, R4.y;
DP4 R3.z, R0, c[23];
DP4 R3.y, R0, c[22];
DP4 R3.x, R0, c[21];
MAD R1.w, R3, R3, -R1;
MUL R0.xyz, R1.w, c[24];
ADD R2.xyz, R2, R3;
ADD R3.xyz, R2, R0;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R2.xyz, R0.xyww, c[0].z;
ADD result.texcoord[3].xyz, R3, R1;
MOV R1.x, R2;
MUL R1.y, R2, c[9].x;
ADD result.texcoord[4].xy, R1, R2.z;
MOV result.position, R0;
MOV result.texcoord[4].zw, R0;
MOV result.texcoord[2].z, R4.x;
MOV result.texcoord[2].x, R3.w;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[26], c[26].zwzw;
MOV result.texcoord[1].xy, R4.zwzw;
END
# 65 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_4LightPosX0]
Vector 11 [unity_4LightPosY0]
Vector 12 [unity_4LightPosZ0]
Vector 13 [unity_4LightAtten0]
Vector 14 [unity_LightColor0]
Vector 15 [unity_LightColor1]
Vector 16 [unity_LightColor2]
Vector 17 [unity_LightColor3]
Vector 18 [unity_SHAr]
Vector 19 [unity_SHAg]
Vector 20 [unity_SHAb]
Vector 21 [unity_SHBr]
Vector 22 [unity_SHBg]
Vector 23 [unity_SHBb]
Vector 24 [unity_SHC]
Matrix 4 [_Object2World]
Vector 25 [unity_Scale]
Vector 26 [_MainTex_ST]
"vs_2_0
; 65 ALU
def c27, 1.00000000, 0.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c25.w
dp3 r3.w, r3, c4
dp3 r4.w, r3, c5
dp4 r0.x, v0, c5
add r2, -r0.x, c11
mul r0, r4.w, r2
dp4 r4.z, v0, c4
add r1, -r4.z, c10
mul r2, r2, r2
dp4 r4.xy, v0, c6
mad r0, r3.w, r1, r0
mad r2, r1, r1, r2
add r1, -r4.x, c12
dp3 r4.x, r3, c6
mad r2, r1, r1, r2
mad r0, r4.x, r1, r0
mul r1, r2, c13
add r1, r1, c27.x
mov r3.x, r4.w
mov r3.y, r4.x
mov r3.z, c27.x
rsq r2.x, r2.x
rsq r2.y, r2.y
rsq r2.z, r2.z
rsq r2.w, r2.w
mul r0, r0, r2
dp4 r2.z, r3.wxyz, c20
dp4 r2.y, r3.wxyz, c19
dp4 r2.x, r3.wxyz, c18
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c27.y
mul r0, r0, r1
mul r1.xyz, r0.y, c15
mad r1.xyz, r0.x, c14, r1
mad r0.xyz, r0.z, c16, r1
mad r1.xyz, r0.w, c17, r0
mul r0, r3.wxyy, r3.xyyw
mul r1.w, r4, r4
mov oT2.y, r4.w
mov r4.w, r4.y
dp4 r3.z, r0, c23
dp4 r3.y, r0, c22
dp4 r3.x, r0, c21
mad r1.w, r3, r3, -r1
mul r0.xyz, r1.w, c24
add r2.xyz, r2, r3
add r3.xyz, r2, r0
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c27.z
add oT3.xyz, r3, r1
mov r1.x, r2
mul r1.y, r2, c8.x
mad oT4.xy, r2.z, c9.zwzw, r1
mov oPos, r0
mov oT4.zw, r0
mov oT2.z, r4.x
mov oT2.x, r3.w
mad oT0.xy, v2, c26, c26.zwzw
mov oT1.xy, r4.zwzw
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 208 // 208 used size, 11 vars
Vector 192 [_MainTex_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 32 [unity_4LightPosX0] 4
Vector 48 [unity_4LightPosY0] 4
Vector 64 [unity_4LightPosZ0] 4
Vector 80 [unity_4LightAtten0] 4
Vector 96 [unity_LightColor0] 4
Vector 112 [unity_LightColor1] 4
Vector 128 [unity_LightColor2] 4
Vector 144 [unity_LightColor3] 4
Vector 160 [unity_LightColor4] 4
Vector 176 [unity_LightColor5] 4
Vector 192 [unity_LightColor6] 4
Vector 208 [unity_LightColor7] 4
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 56 instructions, 7 temp regs, 0 temp arrays:
// ALU 51 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedbjhdbbobeebdhegohkkncnjhcjdgafanabaaaaaammajaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcbiaiaaaaeaaaabaaagacaaaafjaaaaae
egiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
mccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaa
gfaaaaadpccabaaaaeaaaaaagiaaaaacahaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaidcaabaaaabaaaaaafgbfbaaaaaaaaaaaigiacaaaadaaaaaaanaaaaaa
dcaaaaakdcaabaaaabaaaaaaigiacaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaa
egaabaaaabaaaaaadcaaaaakdcaabaaaabaaaaaaigiacaaaadaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegaabaaaabaaaaaadcaaaaakmccabaaaabaaaaaaagiicaaa
adaaaaaaapaaaaaapgbpbaaaaaaaaaaaagaebaaaabaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaamaaaaaaogikcaaaaaaaaaaa
amaaaaaadiaaaaaihcaabaaaabaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaa
beaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaaklcaabaaaabaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaa
abaaaaaaegaibaaaacaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaa
aoaaaaaakgakbaaaabaaaaaaegadbaaaabaaaaaadgaaaaafhccabaaaacaaaaaa
egacbaaaabaaaaaadgaaaaaficaabaaaabaaaaaaabeaaaaaaaaaiadpbbaaaaai
bcaabaaaacaaaaaaegiocaaaacaaaaaacgaaaaaaegaobaaaabaaaaaabbaaaaai
ccaabaaaacaaaaaaegiocaaaacaaaaaachaaaaaaegaobaaaabaaaaaabbaaaaai
ecaabaaaacaaaaaaegiocaaaacaaaaaaciaaaaaaegaobaaaabaaaaaadiaaaaah
pcaabaaaadaaaaaajgacbaaaabaaaaaaegakbaaaabaaaaaabbaaaaaibcaabaaa
aeaaaaaaegiocaaaacaaaaaacjaaaaaaegaobaaaadaaaaaabbaaaaaiccaabaaa
aeaaaaaaegiocaaaacaaaaaackaaaaaaegaobaaaadaaaaaabbaaaaaiecaabaaa
aeaaaaaaegiocaaaacaaaaaaclaaaaaaegaobaaaadaaaaaaaaaaaaahhcaabaaa
acaaaaaaegacbaaaacaaaaaaegacbaaaaeaaaaaadiaaaaahicaabaaaabaaaaaa
bkaabaaaabaaaaaabkaabaaaabaaaaaadcaaaaakicaabaaaabaaaaaaakaabaaa
abaaaaaaakaabaaaabaaaaaadkaabaiaebaaaaaaabaaaaaadcaaaaakhcaabaaa
acaaaaaaegiccaaaacaaaaaacmaaaaaapgapbaaaabaaaaaaegacbaaaacaaaaaa
diaaaaaihcaabaaaadaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaa
dcaaaaakhcaabaaaadaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaa
egacbaaaadaaaaaadcaaaaakhcaabaaaadaaaaaaegiccaaaadaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegacbaaaadaaaaaadcaaaaakhcaabaaaadaaaaaaegiccaaa
adaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaadaaaaaaaaaaaaajpcaabaaa
aeaaaaaafgafbaiaebaaaaaaadaaaaaaegiocaaaacaaaaaaadaaaaaadiaaaaah
pcaabaaaafaaaaaafgafbaaaabaaaaaaegaobaaaaeaaaaaadiaaaaahpcaabaaa
aeaaaaaaegaobaaaaeaaaaaaegaobaaaaeaaaaaaaaaaaaajpcaabaaaagaaaaaa
agaabaiaebaaaaaaadaaaaaaegiocaaaacaaaaaaacaaaaaaaaaaaaajpcaabaaa
adaaaaaakgakbaiaebaaaaaaadaaaaaaegiocaaaacaaaaaaaeaaaaaadcaaaaaj
pcaabaaaafaaaaaaegaobaaaagaaaaaaagaabaaaabaaaaaaegaobaaaafaaaaaa
dcaaaaajpcaabaaaabaaaaaaegaobaaaadaaaaaakgakbaaaabaaaaaaegaobaaa
afaaaaaadcaaaaajpcaabaaaaeaaaaaaegaobaaaagaaaaaaegaobaaaagaaaaaa
egaobaaaaeaaaaaadcaaaaajpcaabaaaadaaaaaaegaobaaaadaaaaaaegaobaaa
adaaaaaaegaobaaaaeaaaaaaeeaaaaafpcaabaaaaeaaaaaaegaobaaaadaaaaaa
dcaaaaanpcaabaaaadaaaaaaegaobaaaadaaaaaaegiocaaaacaaaaaaafaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpaoaaaaakpcaabaaaadaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpegaobaaaadaaaaaadiaaaaah
pcaabaaaabaaaaaaegaobaaaabaaaaaaegaobaaaaeaaaaaadeaaaaakpcaabaaa
abaaaaaaegaobaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
diaaaaahpcaabaaaabaaaaaaegaobaaaadaaaaaaegaobaaaabaaaaaadiaaaaai
hcaabaaaadaaaaaafgafbaaaabaaaaaaegiccaaaacaaaaaaahaaaaaadcaaaaak
hcaabaaaadaaaaaaegiccaaaacaaaaaaagaaaaaaagaabaaaabaaaaaaegacbaaa
adaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaaiaaaaaakgakbaaa
abaaaaaaegacbaaaadaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaa
ajaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaaaaaaaaahhccabaaaadaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaa
aaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaa
aeaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaaeaaaaaakgakbaaaabaaaaaa
mgaabaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal_8;
  normal_8 = tmpvar_6;
  highp float vC_9;
  mediump vec3 x3_10;
  mediump vec3 x2_11;
  mediump vec3 x1_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal_8);
  x1_12.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal_8);
  x1_12.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal_8);
  x1_12.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal_8.xyzz * normal_8.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2_11.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2_11.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2_11.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal_8.x * normal_8.x) - (normal_8.y * normal_8.y));
  vC_9 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC_9);
  x3_10 = tmpvar_21;
  tmpvar_7 = ((x1_12 + x2_11) + x3_10);
  shlight_1 = tmpvar_7;
  tmpvar_3 = shlight_1;
  highp vec3 tmpvar_22;
  tmpvar_22 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_4LightPosX0 - tmpvar_22.x);
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosY0 - tmpvar_22.y);
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_4LightPosZ0 - tmpvar_22.z);
  highp vec4 tmpvar_26;
  tmpvar_26 = (((tmpvar_23 * tmpvar_23) + (tmpvar_24 * tmpvar_24)) + (tmpvar_25 * tmpvar_25));
  highp vec4 tmpvar_27;
  tmpvar_27 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_23 * tmpvar_5.x) + (tmpvar_24 * tmpvar_5.y)) + (tmpvar_25 * tmpvar_5.z)) * inversesqrt(tmpvar_26))) * (1.0/((1.0 + (tmpvar_26 * unity_4LightAtten0)))));
  highp vec3 tmpvar_28;
  tmpvar_28 = (tmpvar_3 + ((((unity_LightColor[0].xyz * tmpvar_27.x) + (unity_LightColor[1].xyz * tmpvar_27.y)) + (unity_LightColor[2].xyz * tmpvar_27.z)) + (unity_LightColor[3].xyz * tmpvar_27.w)));
  tmpvar_3 = tmpvar_28;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _LightShadowData;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp float tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_4;
  arg0_4 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_5;
  arg0_5 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_6;
  arg0_6 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_7;
  tmpvar_7 = (1.0 - (((tmpvar_3.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_4, arg0_4))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_5, arg0_5))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_2 = tmpvar_7;
  lowp float tmpvar_8;
  mediump float lightShadowDataX_9;
  highp float dist_10;
  lowp float tmpvar_11;
  tmpvar_11 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x;
  dist_10 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = _LightShadowData.x;
  lightShadowDataX_9 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = max (float((dist_10 > (xlv_TEXCOORD4.z / xlv_TEXCOORD4.w))), lightShadowDataX_9);
  tmpvar_8 = tmpvar_13;
  lowp vec4 c_14;
  c_14.xyz = ((tmpvar_3.xyz * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz)) * tmpvar_8) * 2.0));
  c_14.w = tmpvar_2;
  c_1.w = c_14.w;
  c_1.xyz = (c_14.xyz + (tmpvar_3.xyz * xlv_TEXCOORD3));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = tmpvar_6;
  mediump vec3 tmpvar_8;
  mediump vec4 normal_9;
  normal_9 = tmpvar_7;
  highp float vC_10;
  mediump vec3 x3_11;
  mediump vec3 x2_12;
  mediump vec3 x1_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal_9);
  x1_13.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal_9);
  x1_13.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal_9);
  x1_13.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal_9.xyzz * normal_9.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2_12.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2_12.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2_12.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal_9.x * normal_9.x) - (normal_9.y * normal_9.y));
  vC_10 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC_10);
  x3_11 = tmpvar_22;
  tmpvar_8 = ((x1_13 + x2_12) + x3_11);
  shlight_1 = tmpvar_8;
  tmpvar_3 = shlight_1;
  highp vec3 tmpvar_23;
  tmpvar_23 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosX0 - tmpvar_23.x);
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_4LightPosY0 - tmpvar_23.y);
  highp vec4 tmpvar_26;
  tmpvar_26 = (unity_4LightPosZ0 - tmpvar_23.z);
  highp vec4 tmpvar_27;
  tmpvar_27 = (((tmpvar_24 * tmpvar_24) + (tmpvar_25 * tmpvar_25)) + (tmpvar_26 * tmpvar_26));
  highp vec4 tmpvar_28;
  tmpvar_28 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_24 * tmpvar_6.x) + (tmpvar_25 * tmpvar_6.y)) + (tmpvar_26 * tmpvar_6.z)) * inversesqrt(tmpvar_27))) * (1.0/((1.0 + (tmpvar_27 * unity_4LightAtten0)))));
  highp vec3 tmpvar_29;
  tmpvar_29 = (tmpvar_3 + ((((unity_LightColor[0].xyz * tmpvar_28.x) + (unity_LightColor[1].xyz * tmpvar_28.y)) + (unity_LightColor[2].xyz * tmpvar_28.z)) + (unity_LightColor[3].xyz * tmpvar_28.w)));
  tmpvar_3 = tmpvar_29;
  highp vec4 o_30;
  highp vec4 tmpvar_31;
  tmpvar_31 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_32;
  tmpvar_32.x = tmpvar_31.x;
  tmpvar_32.y = (tmpvar_31.y * _ProjectionParams.x);
  o_30.xy = (tmpvar_32 + tmpvar_31.w);
  o_30.zw = tmpvar_4.zw;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = o_30;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp float tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_4;
  arg0_4 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_5;
  arg0_5 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_6;
  arg0_6 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_7;
  tmpvar_7 = (1.0 - (((tmpvar_3.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_4, arg0_4))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_5, arg0_5))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_2 = tmpvar_7;
  lowp vec4 c_8;
  c_8.xyz = ((tmpvar_3.xyz * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz)) * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x) * 2.0));
  c_8.w = tmpvar_2;
  c_1.w = c_8.w;
  c_1.xyz = (c_8.xyz + (tmpvar_3.xyz * xlv_TEXCOORD3));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [unity_4LightPosX0]
Vector 10 [unity_4LightPosY0]
Vector 11 [unity_4LightPosZ0]
Vector 12 [unity_4LightAtten0]
Vector 13 [unity_LightColor0]
Vector 14 [unity_LightColor1]
Vector 15 [unity_LightColor2]
Vector 16 [unity_LightColor3]
Vector 17 [unity_SHAr]
Vector 18 [unity_SHAg]
Vector 19 [unity_SHAb]
Vector 20 [unity_SHBr]
Vector 21 [unity_SHBg]
Vector 22 [unity_SHBb]
Vector 23 [unity_SHC]
Matrix 4 [_Object2World]
Vector 24 [unity_Scale]
Vector 25 [unity_NPOTScale]
Vector 26 [_MainTex_ST]
"agal_vs
c27 1.0 0.0 0.5 0.0
[bc]
adaaaaaaadaaahacabaaaaoeaaaaaaaabiaaaappabaaaaaa mul r3.xyz, a1, c24.w
bcaaaaaaadaaaiacadaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r3.w, r3.xyzz, c4
bcaaaaaaaeaaaiacadaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r4.w, r3.xyzz, c5
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.x, a0, c5
bfaaaaaaacaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r2.x, r0.x
abaaaaaaacaaapacacaaaaaaacaaaaaaakaaaaoeabaaaaaa add r2, r2.x, c10
adaaaaaaaaaaapacaeaaaappacaaaaaaacaaaaoeacaaaaaa mul r0, r4.w, r2
bdaaaaaaaeaaaeacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r4.z, a0, c4
bfaaaaaaabaaaeacaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa neg r1.z, r4.z
abaaaaaaabaaapacabaaaakkacaaaaaaajaaaaoeabaaaaaa add r1, r1.z, c9
adaaaaaaacaaapacacaaaaoeacaaaaaaacaaaaoeacaaaaaa mul r2, r2, r2
bdaaaaaaaeaaadacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r4.xy, a0, c6
adaaaaaaafaaapacadaaaappacaaaaaaabaaaaoeacaaaaaa mul r5, r3.w, r1
abaaaaaaaaaaapacafaaaaoeacaaaaaaaaaaaaoeacaaaaaa add r0, r5, r0
adaaaaaaafaaapacabaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r5, r1, r1
abaaaaaaacaaapacafaaaaoeacaaaaaaacaaaaoeacaaaaaa add r2, r5, r2
bfaaaaaaabaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r1.x, r4.x
abaaaaaaabaaapacabaaaaaaacaaaaaaalaaaaoeabaaaaaa add r1, r1.x, c11
bcaaaaaaaeaaabacadaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r4.x, r3.xyzz, c6
adaaaaaaafaaapacabaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r5, r1, r1
abaaaaaaacaaapacafaaaaoeacaaaaaaacaaaaoeacaaaaaa add r2, r5, r2
adaaaaaaafaaapacaeaaaaaaacaaaaaaabaaaaoeacaaaaaa mul r5, r4.x, r1
abaaaaaaaaaaapacafaaaaoeacaaaaaaaaaaaaoeacaaaaaa add r0, r5, r0
adaaaaaaabaaapacacaaaaoeacaaaaaaamaaaaoeabaaaaaa mul r1, r2, c12
abaaaaaaabaaapacabaaaaoeacaaaaaablaaaaaaabaaaaaa add r1, r1, c27.x
aaaaaaaaadaaabacaeaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r3.x, r4.w
aaaaaaaaadaaacacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r3.y, r4.x
aaaaaaaaadaaaeacblaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r3.z, c27.x
akaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r2.x, r2.x
akaaaaaaacaaacacacaaaaffacaaaaaaaaaaaaaaaaaaaaaa rsq r2.y, r2.y
akaaaaaaacaaaeacacaaaakkacaaaaaaaaaaaaaaaaaaaaaa rsq r2.z, r2.z
akaaaaaaacaaaiacacaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r2.w, r2.w
adaaaaaaaaaaapacaaaaaaoeacaaaaaaacaaaaoeacaaaaaa mul r0, r0, r2
bdaaaaaaacaaaeacadaaaajdacaaaaaabdaaaaoeabaaaaaa dp4 r2.z, r3.wxyz, c19
bdaaaaaaacaaacacadaaaajdacaaaaaabcaaaaoeabaaaaaa dp4 r2.y, r3.wxyz, c18
bdaaaaaaacaaabacadaaaajdacaaaaaabbaaaaoeabaaaaaa dp4 r2.x, r3.wxyz, c17
afaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r1.x, r1.x
afaaaaaaabaaacacabaaaaffacaaaaaaaaaaaaaaaaaaaaaa rcp r1.y, r1.y
afaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r1.w, r1.w
afaaaaaaabaaaeacabaaaakkacaaaaaaaaaaaaaaaaaaaaaa rcp r1.z, r1.z
ahaaaaaaaaaaapacaaaaaaoeacaaaaaablaaaaffabaaaaaa max r0, r0, c27.y
adaaaaaaaaaaapacaaaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r0, r0, r1
adaaaaaaabaaahacaaaaaaffacaaaaaaaoaaaaoeabaaaaaa mul r1.xyz, r0.y, c14
adaaaaaaafaaahacaaaaaaaaacaaaaaaanaaaaoeabaaaaaa mul r5.xyz, r0.x, c13
abaaaaaaabaaahacafaaaakeacaaaaaaabaaaakeacaaaaaa add r1.xyz, r5.xyzz, r1.xyzz
adaaaaaaaaaaahacaaaaaakkacaaaaaaapaaaaoeabaaaaaa mul r0.xyz, r0.z, c15
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa add r0.xyz, r0.xyzz, r1.xyzz
adaaaaaaabaaahacaaaaaappacaaaaaabaaaaaoeabaaaaaa mul r1.xyz, r0.w, c16
abaaaaaaabaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r1.xyz, r1.xyzz, r0.xyzz
adaaaaaaaaaaapacadaaaafdacaaaaaaadaaaaneacaaaaaa mul r0, r3.wxyy, r3.xyyw
adaaaaaaabaaaiacaeaaaappacaaaaaaaeaaaappacaaaaaa mul r1.w, r4.w, r4.w
aaaaaaaaacaaacaeaeaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v2.y, r4.w
aaaaaaaaaeaaaiacaeaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r4.w, r4.y
bdaaaaaaadaaaeacaaaaaaoeacaaaaaabgaaaaoeabaaaaaa dp4 r3.z, r0, c22
bdaaaaaaadaaacacaaaaaaoeacaaaaaabfaaaaoeabaaaaaa dp4 r3.y, r0, c21
bdaaaaaaadaaabacaaaaaaoeacaaaaaabeaaaaoeabaaaaaa dp4 r3.x, r0, c20
adaaaaaaafaaaiacadaaaappacaaaaaaadaaaappacaaaaaa mul r5.w, r3.w, r3.w
acaaaaaaabaaaiacafaaaappacaaaaaaabaaaappacaaaaaa sub r1.w, r5.w, r1.w
adaaaaaaaaaaahacabaaaappacaaaaaabhaaaaoeabaaaaaa mul r0.xyz, r1.w, c23
abaaaaaaacaaahacacaaaakeacaaaaaaadaaaakeacaaaaaa add r2.xyz, r2.xyzz, r3.xyzz
abaaaaaaacaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r2.xyz, r2.xyzz, r0.xyzz
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 r0.w, a0, c3
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 r0.z, a0, c2
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 r0.x, a0, c0
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 r0.y, a0, c1
adaaaaaaadaaahacaaaaaapeacaaaaaablaaaakkabaaaaaa mul r3.xyz, r0.xyww, c27.z
abaaaaaaadaaahaeacaaaakeacaaaaaaabaaaakeacaaaaaa add v3.xyz, r2.xyzz, r1.xyzz
adaaaaaaabaaacacadaaaaffacaaaaaaaiaaaaaaabaaaaaa mul r1.y, r3.y, c8.x
aaaaaaaaabaaabacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r3.x
abaaaaaaabaaadacabaaaafeacaaaaaaadaaaakkacaaaaaa add r1.xy, r1.xyyy, r3.z
adaaaaaaaeaaadaeabaaaafeacaaaaaabjaaaaoeabaaaaaa mul v4.xy, r1.xyyy, c25
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
aaaaaaaaaeaaamaeaaaaaaopacaaaaaaaaaaaaaaaaaaaaaa mov v4.zw, r0.wwzw
aaaaaaaaacaaaeaeaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov v2.z, r4.x
aaaaaaaaacaaabaeadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v2.x, r3.w
adaaaaaaafaaadacadaaaaoeaaaaaaaabkaaaaoeabaaaaaa mul r5.xy, a3, c26
abaaaaaaaaaaadaeafaaaafeacaaaaaabkaaaaooabaaaaaa add v0.xy, r5.xyyy, c26.zwzw
aaaaaaaaabaaadaeaeaaaapoacaaaaaaaaaaaaaaaaaaaaaa mov v1.xy, r4.zwww
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 208 // 208 used size, 11 vars
Vector 192 [_MainTex_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 32 [unity_4LightPosX0] 4
Vector 48 [unity_4LightPosY0] 4
Vector 64 [unity_4LightPosZ0] 4
Vector 80 [unity_4LightAtten0] 4
Vector 96 [unity_LightColor0] 4
Vector 112 [unity_LightColor1] 4
Vector 128 [unity_LightColor2] 4
Vector 144 [unity_LightColor3] 4
Vector 160 [unity_LightColor4] 4
Vector 176 [unity_LightColor5] 4
Vector 192 [unity_LightColor6] 4
Vector 208 [unity_LightColor7] 4
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 56 instructions, 7 temp regs, 0 temp arrays:
// ALU 51 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedgfgpobcddeehcladljpiakghclncjkekabaaaaaamaaoaaaaaeaaaaaa
daaaaaaacaafaaaaeaanaaaaaiaoaaaaebgpgodjoiaeaaaaoiaeaaaaaaacpopp
gmaeaaaahmaaaaaaahaaceaaaaaahiaaaaaahiaaaaaaceaaabaahiaaaaaaamaa
abaaabaaaaaaaaaaabaaafaaabaaacaaaaaaaaaaacaaacaaaiaaadaaaaaaaaaa
acaacgaaahaaalaaaaaaaaaaadaaaaaaaeaabcaaaaaaaaaaadaaamaaaeaabgaa
aaaaaaaaadaabeaaabaabkaaaaaaaaaaaaaaaaaaaaacpoppfbaaaaafblaaapka
aaaaiadpaaaaaaaaaaaaaadpaaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaac
afaaaciaacaaapjabpaaaaacafaaadiaadaaapjaafaaaaadaaaaadiaaaaaffja
bhaaockaaeaaaaaeaaaaadiabgaaockaaaaaaajaaaaaoeiaaeaaaaaeaaaaadia
biaaockaaaaakkjaaaaaoeiaaeaaaaaeaaaaamoabjaacekaaaaappjaaaaaeeia
aeaaaaaeaaaaadoaadaaoejaabaaoekaabaaookaafaaaaadaaaaahiaaaaaffja
bhaaoekaaeaaaaaeaaaaahiabgaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaahia
biaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaahiabjaaoekaaaaappjaaaaaoeia
acaaaaadabaaapiaaaaaffibaeaaoekaafaaaaadacaaapiaabaaoeiaabaaoeia
acaaaaadadaaapiaaaaaaaibadaaoekaacaaaaadaaaaapiaaaaakkibafaaoeka
aeaaaaaeacaaapiaadaaoeiaadaaoeiaacaaoeiaaeaaaaaeacaaapiaaaaaoeia
aaaaoeiaacaaoeiaahaaaaacaeaaabiaacaaaaiaahaaaaacaeaaaciaacaaffia
ahaaaaacaeaaaeiaacaakkiaahaaaaacaeaaaiiaacaappiaabaaaaacafaaabia
blaaaakaaeaaaaaeacaaapiaacaaoeiaagaaoekaafaaaaiaafaaaaadafaaahia
acaaoejabkaappkaafaaaaadagaaahiaafaaffiabhaaoekaaeaaaaaeafaaalia
bgaakekaafaaaaiaagaakeiaaeaaaaaeafaaahiabiaaoekaafaakkiaafaapeia
afaaaaadabaaapiaabaaoeiaafaaffiaaeaaaaaeabaaapiaadaaoeiaafaaaaia
abaaoeiaaeaaaaaeaaaaapiaaaaaoeiaafaakkiaabaaoeiaafaaaaadaaaaapia
aeaaoeiaaaaaoeiaalaaaaadaaaaapiaaaaaoeiablaaffkaagaaaaacabaaabia
acaaaaiaagaaaaacabaaaciaacaaffiaagaaaaacabaaaeiaacaakkiaagaaaaac
abaaaiiaacaappiaafaaaaadaaaaapiaaaaaoeiaabaaoeiaafaaaaadabaaahia
aaaaffiaaiaaoekaaeaaaaaeabaaahiaahaaoekaaaaaaaiaabaaoeiaaeaaaaae
aaaaahiaajaaoekaaaaakkiaabaaoeiaaeaaaaaeaaaaahiaakaaoekaaaaappia
aaaaoeiaabaaaaacafaaaiiablaaaakaajaaaaadabaaabiaalaaoekaafaaoeia
ajaaaaadabaaaciaamaaoekaafaaoeiaajaaaaadabaaaeiaanaaoekaafaaoeia
afaaaaadacaaapiaafaacjiaafaakeiaajaaaaadadaaabiaaoaaoekaacaaoeia
ajaaaaadadaaaciaapaaoekaacaaoeiaajaaaaadadaaaeiabaaaoekaacaaoeia
acaaaaadabaaahiaabaaoeiaadaaoeiaafaaaaadaaaaaiiaafaaffiaafaaffia
aeaaaaaeaaaaaiiaafaaaaiaafaaaaiaaaaappibabaaaaacabaaahoaafaaoeia
aeaaaaaeabaaahiabbaaoekaaaaappiaabaaoeiaacaaaaadacaaahoaaaaaoeia
abaaoeiaafaaaaadaaaaapiaaaaaffjabdaaoekaaeaaaaaeaaaaapiabcaaoeka
aaaaaajaaaaaoeiaaeaaaaaeaaaaapiabeaaoekaaaaakkjaaaaaoeiaaeaaaaae
aaaaapiabfaaoekaaaaappjaaaaaoeiaafaaaaadabaaabiaaaaaffiaacaaaaka
afaaaaadabaaaiiaabaaaaiablaakkkaafaaaaadabaaafiaaaaapeiablaakkka
acaaaaadadaaadoaabaakkiaabaaomiaaeaaaaaeaaaaadmaaaaappiaaaaaoeka
aaaaoeiaabaaaaacaaaaammaaaaaoeiaabaaaaacadaaamoaaaaaoeiappppaaaa
fdeieefcbiaiaaaaeaaaabaaagacaaaafjaaaaaeegiocaaaaaaaaaaaanaaaaaa
fjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaa
fjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaad
hcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaa
giaaaaacahaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
adaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaidcaabaaaabaaaaaa
fgbfbaaaaaaaaaaaigiacaaaadaaaaaaanaaaaaadcaaaaakdcaabaaaabaaaaaa
igiacaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegaabaaaabaaaaaadcaaaaak
dcaabaaaabaaaaaaigiacaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaabaaa
abaaaaaadcaaaaakmccabaaaabaaaaaaagiicaaaadaaaaaaapaaaaaapgbpbaaa
aaaaaaaaagaebaaaabaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaamaaaaaaogikcaaaaaaaaaaaamaaaaaadiaaaaaihcaabaaa
abaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaa
acaaaaaafgafbaaaabaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaa
abaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaabaaaaaaegaibaaaacaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaabaaaaaa
egadbaaaabaaaaaadgaaaaafhccabaaaacaaaaaaegacbaaaabaaaaaadgaaaaaf
icaabaaaabaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaacaaaaaaegiocaaa
acaaaaaacgaaaaaaegaobaaaabaaaaaabbaaaaaiccaabaaaacaaaaaaegiocaaa
acaaaaaachaaaaaaegaobaaaabaaaaaabbaaaaaiecaabaaaacaaaaaaegiocaaa
acaaaaaaciaaaaaaegaobaaaabaaaaaadiaaaaahpcaabaaaadaaaaaajgacbaaa
abaaaaaaegakbaaaabaaaaaabbaaaaaibcaabaaaaeaaaaaaegiocaaaacaaaaaa
cjaaaaaaegaobaaaadaaaaaabbaaaaaiccaabaaaaeaaaaaaegiocaaaacaaaaaa
ckaaaaaaegaobaaaadaaaaaabbaaaaaiecaabaaaaeaaaaaaegiocaaaacaaaaaa
claaaaaaegaobaaaadaaaaaaaaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaa
egacbaaaaeaaaaaadiaaaaahicaabaaaabaaaaaabkaabaaaabaaaaaabkaabaaa
abaaaaaadcaaaaakicaabaaaabaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaa
dkaabaiaebaaaaaaabaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaa
cmaaaaaapgapbaaaabaaaaaaegacbaaaacaaaaaadiaaaaaihcaabaaaadaaaaaa
fgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaadaaaaaa
egiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaadaaaaaadcaaaaak
hcaabaaaadaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaa
adaaaaaadcaaaaakhcaabaaaadaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaa
aaaaaaaaegacbaaaadaaaaaaaaaaaaajpcaabaaaaeaaaaaafgafbaiaebaaaaaa
adaaaaaaegiocaaaacaaaaaaadaaaaaadiaaaaahpcaabaaaafaaaaaafgafbaaa
abaaaaaaegaobaaaaeaaaaaadiaaaaahpcaabaaaaeaaaaaaegaobaaaaeaaaaaa
egaobaaaaeaaaaaaaaaaaaajpcaabaaaagaaaaaaagaabaiaebaaaaaaadaaaaaa
egiocaaaacaaaaaaacaaaaaaaaaaaaajpcaabaaaadaaaaaakgakbaiaebaaaaaa
adaaaaaaegiocaaaacaaaaaaaeaaaaaadcaaaaajpcaabaaaafaaaaaaegaobaaa
agaaaaaaagaabaaaabaaaaaaegaobaaaafaaaaaadcaaaaajpcaabaaaabaaaaaa
egaobaaaadaaaaaakgakbaaaabaaaaaaegaobaaaafaaaaaadcaaaaajpcaabaaa
aeaaaaaaegaobaaaagaaaaaaegaobaaaagaaaaaaegaobaaaaeaaaaaadcaaaaaj
pcaabaaaadaaaaaaegaobaaaadaaaaaaegaobaaaadaaaaaaegaobaaaaeaaaaaa
eeaaaaafpcaabaaaaeaaaaaaegaobaaaadaaaaaadcaaaaanpcaabaaaadaaaaaa
egaobaaaadaaaaaaegiocaaaacaaaaaaafaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaiadpaoaaaaakpcaabaaaadaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaiadpegaobaaaadaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaa
abaaaaaaegaobaaaaeaaaaaadeaaaaakpcaabaaaabaaaaaaegaobaaaabaaaaaa
aceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadiaaaaahpcaabaaaabaaaaaa
egaobaaaadaaaaaaegaobaaaabaaaaaadiaaaaaihcaabaaaadaaaaaafgafbaaa
abaaaaaaegiccaaaacaaaaaaahaaaaaadcaaaaakhcaabaaaadaaaaaaegiccaaa
acaaaaaaagaaaaaaagaabaaaabaaaaaaegacbaaaadaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaacaaaaaaaiaaaaaakgakbaaaabaaaaaaegacbaaaadaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaajaaaaaapgapbaaaabaaaaaa
egacbaaaabaaaaaaaaaaaaahhccabaaaadaaaaaaegacbaaaabaaaaaaegacbaaa
acaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaa
afaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadp
aaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaaeaaaaaakgaobaaaaaaaaaaa
aaaaaaahdccabaaaaeaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab
ejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaa
kjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaa
faepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfcee
aaedepemepfcaaklepfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaadamaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaa
keaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaakeaaaaaaadaaaaaa
aaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 432
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec4 _ShadowCoord;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 401
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 405
uniform highp vec4 _Player3_Pos;
#line 413
#line 427
#line 442
uniform highp vec4 _MainTex_ST;
#line 96
highp vec3 Shade4PointLights( in highp vec4 lightPosX, in highp vec4 lightPosY, in highp vec4 lightPosZ, in highp vec3 lightColor0, in highp vec3 lightColor1, in highp vec3 lightColor2, in highp vec3 lightColor3, in highp vec4 lightAttenSq, in highp vec3 pos, in highp vec3 normal ) {
    highp vec4 toLightX = (lightPosX - pos.x);
    highp vec4 toLightY = (lightPosY - pos.y);
    #line 100
    highp vec4 toLightZ = (lightPosZ - pos.z);
    highp vec4 lengthSq = vec4( 0.0);
    lengthSq += (toLightX * toLightX);
    lengthSq += (toLightY * toLightY);
    #line 104
    lengthSq += (toLightZ * toLightZ);
    highp vec4 ndotl = vec4( 0.0);
    ndotl += (toLightX * normal.x);
    ndotl += (toLightY * normal.y);
    #line 108
    ndotl += (toLightZ * normal.z);
    highp vec4 corr = inversesqrt(lengthSq);
    ndotl = max( vec4( 0.0, 0.0, 0.0, 0.0), (ndotl * corr));
    highp vec4 atten = (1.0 / (1.0 + (lengthSq * lightAttenSq)));
    #line 112
    highp vec4 diff = (ndotl * atten);
    highp vec3 col = vec3( 0.0);
    col += (lightColor0 * diff.x);
    col += (lightColor1 * diff.y);
    #line 116
    col += (lightColor2 * diff.z);
    col += (lightColor3 * diff.w);
    return col;
}
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 413
void vert( inout appdata_full vertexData, out Input outData ) {
    highp vec4 pos = (glstate_matrix_mvp * vertexData.vertex);
    highp vec4 posWorld = (_Object2World * vertexData.vertex);
    #line 417
    outData.uv_MainTex = vec2( vertexData.texcoord);
    outData.location = posWorld.xz;
}
#line 443
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 446
    Input customInputData;
    vert( v, customInputData);
    o.cust_location = customInputData.location;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 450
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 shlight = ShadeSH9( vec4( worldN, 1.0));
    #line 454
    o.vlight = shlight;
    highp vec3 worldPos = (_Object2World * v.vertex).xyz;
    o.vlight += Shade4PointLights( unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0, unity_LightColor[0].xyz, unity_LightColor[1].xyz, unity_LightColor[2].xyz, unity_LightColor[3].xyz, unity_4LightAtten0, worldPos, worldN);
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    #line 459
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out lowp vec3 xlv_TEXCOORD3;
out highp vec4 xlv_TEXCOORD4;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.pack0);
    xlv_TEXCOORD1 = vec2(xl_retval.cust_location);
    xlv_TEXCOORD2 = vec3(xl_retval.normal);
    xlv_TEXCOORD3 = vec3(xl_retval.vlight);
    xlv_TEXCOORD4 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 432
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec4 _ShadowCoord;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 401
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 405
uniform highp vec4 _Player3_Pos;
#line 413
#line 427
#line 442
uniform highp vec4 _MainTex_ST;
#line 338
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp vec4 c;
    #line 342
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.0));
    c.w = s.Alpha;
    return c;
}
#line 427
highp float powerForPos( in highp vec4 pos, in highp vec2 nearVertex ) {
    highp float atten = clamp( (_FogRadius - length((pos.xz - nearVertex.xy))), 0.0, _FogRadius);
    return (((1.0 / _FogMaxRadius) * atten) / _FogRadius);
}
#line 420
void surf( in Input IN, inout SurfaceOutput o ) {
    #line 422
    lowp vec4 baseColor = (texture( _MainTex, IN.uv_MainTex) * _Color);
    highp float alpha = (1.0 - (((baseColor.w + powerForPos( _Player1_Pos, IN.location)) + powerForPos( _Player2_Pos, IN.location)) + powerForPos( _Player3_Pos, IN.location)));
    o.Albedo = baseColor.xyz;
    o.Alpha = alpha;
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    highp float dist = textureProj( _ShadowMapTexture, shadowCoord).x;
    mediump float lightShadowDataX = _LightShadowData.x;
    #line 397
    return max( float((dist > (shadowCoord.z / shadowCoord.w))), lightShadowDataX);
}
#line 461
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 463
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.location = IN.cust_location;
    SurfaceOutput o;
    #line 467
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 471
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    surf( surfIN, o);
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    #line 475
    lowp vec4 c = vec4( 0.0);
    c = LightingLambert( o, _WorldSpaceLightPos0.xyz, atten);
    c.xyz += (o.Albedo * IN.vlight);
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in lowp vec3 xlv_TEXCOORD3;
in highp vec4 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec2(xlv_TEXCOORD0);
    xlt_IN.cust_location = vec2(xlv_TEXCOORD1);
    xlt_IN.normal = vec3(xlv_TEXCOORD2);
    xlt_IN.vlight = vec3(xlv_TEXCOORD3);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD4);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal_8;
  normal_8 = tmpvar_6;
  highp float vC_9;
  mediump vec3 x3_10;
  mediump vec3 x2_11;
  mediump vec3 x1_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal_8);
  x1_12.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal_8);
  x1_12.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal_8);
  x1_12.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal_8.xyzz * normal_8.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2_11.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2_11.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2_11.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal_8.x * normal_8.x) - (normal_8.y * normal_8.y));
  vC_9 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC_9);
  x3_10 = tmpvar_21;
  tmpvar_7 = ((x1_12 + x2_11) + x3_10);
  shlight_1 = tmpvar_7;
  tmpvar_3 = shlight_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _LightShadowData;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp float tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_4;
  arg0_4 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_5;
  arg0_5 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_6;
  arg0_6 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_7;
  tmpvar_7 = (1.0 - (((tmpvar_3.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_4, arg0_4))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_5, arg0_5))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_2 = tmpvar_7;
  lowp float shadow_8;
  lowp float tmpvar_9;
  tmpvar_9 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD4.xyz);
  highp float tmpvar_10;
  tmpvar_10 = (_LightShadowData.x + (tmpvar_9 * (1.0 - _LightShadowData.x)));
  shadow_8 = tmpvar_10;
  lowp vec4 c_11;
  c_11.xyz = ((tmpvar_3.xyz * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz)) * shadow_8) * 2.0));
  c_11.w = tmpvar_2;
  c_1.w = c_11.w;
  c_1.xyz = (c_11.xyz + (tmpvar_3.xyz * xlv_TEXCOORD3));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 432
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec4 _ShadowCoord;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 401
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 405
uniform highp vec4 _Player3_Pos;
#line 413
#line 427
#line 442
uniform highp vec4 _MainTex_ST;
#line 459
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 413
void vert( inout appdata_full vertexData, out Input outData ) {
    highp vec4 pos = (glstate_matrix_mvp * vertexData.vertex);
    highp vec4 posWorld = (_Object2World * vertexData.vertex);
    #line 417
    outData.uv_MainTex = vec2( vertexData.texcoord);
    outData.location = posWorld.xz;
}
#line 443
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 446
    Input customInputData;
    vert( v, customInputData);
    o.cust_location = customInputData.location;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 450
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 shlight = ShadeSH9( vec4( worldN, 1.0));
    #line 454
    o.vlight = shlight;
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out lowp vec3 xlv_TEXCOORD3;
out highp vec4 xlv_TEXCOORD4;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.pack0);
    xlv_TEXCOORD1 = vec2(xl_retval.cust_location);
    xlv_TEXCOORD2 = vec3(xl_retval.normal);
    xlv_TEXCOORD3 = vec3(xl_retval.vlight);
    xlv_TEXCOORD4 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_shadow2D(mediump sampler2DShadow s, vec3 coord) { return texture (s, coord); }
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 432
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec4 _ShadowCoord;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 401
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 405
uniform highp vec4 _Player3_Pos;
#line 413
#line 427
#line 442
uniform highp vec4 _MainTex_ST;
#line 459
#line 338
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp vec4 c;
    #line 342
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.0));
    c.w = s.Alpha;
    return c;
}
#line 427
highp float powerForPos( in highp vec4 pos, in highp vec2 nearVertex ) {
    highp float atten = clamp( (_FogRadius - length((pos.xz - nearVertex.xy))), 0.0, _FogRadius);
    return (((1.0 / _FogMaxRadius) * atten) / _FogRadius);
}
#line 420
void surf( in Input IN, inout SurfaceOutput o ) {
    #line 422
    lowp vec4 baseColor = (texture( _MainTex, IN.uv_MainTex) * _Color);
    highp float alpha = (1.0 - (((baseColor.w + powerForPos( _Player1_Pos, IN.location)) + powerForPos( _Player2_Pos, IN.location)) + powerForPos( _Player3_Pos, IN.location)));
    o.Albedo = baseColor.xyz;
    o.Alpha = alpha;
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    lowp float shadow = xll_shadow2D( _ShadowMapTexture, shadowCoord.xyz.xyz);
    shadow = (_LightShadowData.x + (shadow * (1.0 - _LightShadowData.x)));
    #line 397
    return shadow;
}
#line 459
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    #line 463
    surfIN.location = IN.cust_location;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 467
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    #line 471
    surf( surfIN, o);
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    c = LightingLambert( o, _WorldSpaceLightPos0.xyz, atten);
    #line 475
    c.xyz += (o.Albedo * IN.vlight);
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in lowp vec3 xlv_TEXCOORD3;
in highp vec4 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec2(xlv_TEXCOORD0);
    xlt_IN.cust_location = vec2(xlv_TEXCOORD1);
    xlt_IN.normal = vec3(xlv_TEXCOORD2);
    xlt_IN.vlight = vec3(xlv_TEXCOORD3);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD4);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform highp vec4 _LightShadowData;
void main ()
{
  lowp vec4 c_1;
  lowp float tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_4;
  arg0_4 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_5;
  arg0_5 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_6;
  arg0_6 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_7;
  tmpvar_7 = (1.0 - (((tmpvar_3.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_4, arg0_4))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_5, arg0_5))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_2 = tmpvar_7;
  lowp float shadow_8;
  lowp float tmpvar_9;
  tmpvar_9 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD3.xyz);
  highp float tmpvar_10;
  tmpvar_10 = (_LightShadowData.x + (tmpvar_9 * (1.0 - _LightShadowData.x)));
  shadow_8 = tmpvar_10;
  c_1.xyz = (tmpvar_3.xyz * min ((2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD2).xyz), vec3((shadow_8 * 2.0))));
  c_1.w = tmpvar_2;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 432
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    highp vec2 lmap;
    highp vec4 _ShadowCoord;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 401
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 405
uniform highp vec4 _Player3_Pos;
#line 413
#line 427
#line 441
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
#line 457
uniform sampler2D unity_Lightmap;
#line 413
void vert( inout appdata_full vertexData, out Input outData ) {
    highp vec4 pos = (glstate_matrix_mvp * vertexData.vertex);
    highp vec4 posWorld = (_Object2World * vertexData.vertex);
    #line 417
    outData.uv_MainTex = vec2( vertexData.texcoord);
    outData.location = posWorld.xz;
}
#line 443
v2f_surf vert_surf( in appdata_full v ) {
    #line 445
    v2f_surf o;
    Input customInputData;
    vert( v, customInputData);
    o.cust_location = customInputData.location;
    #line 449
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    #line 453
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
out highp vec2 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.pack0);
    xlv_TEXCOORD1 = vec2(xl_retval.cust_location);
    xlv_TEXCOORD2 = vec2(xl_retval.lmap);
    xlv_TEXCOORD3 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_shadow2D(mediump sampler2DShadow s, vec3 coord) { return texture (s, coord); }
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 432
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    highp vec2 lmap;
    highp vec4 _ShadowCoord;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 401
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 405
uniform highp vec4 _Player3_Pos;
#line 413
#line 427
#line 441
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
#line 457
uniform sampler2D unity_Lightmap;
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 427
highp float powerForPos( in highp vec4 pos, in highp vec2 nearVertex ) {
    highp float atten = clamp( (_FogRadius - length((pos.xz - nearVertex.xy))), 0.0, _FogRadius);
    return (((1.0 / _FogMaxRadius) * atten) / _FogRadius);
}
#line 420
void surf( in Input IN, inout SurfaceOutput o ) {
    #line 422
    lowp vec4 baseColor = (texture( _MainTex, IN.uv_MainTex) * _Color);
    highp float alpha = (1.0 - (((baseColor.w + powerForPos( _Player1_Pos, IN.location)) + powerForPos( _Player2_Pos, IN.location)) + powerForPos( _Player3_Pos, IN.location)));
    o.Albedo = baseColor.xyz;
    o.Alpha = alpha;
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    lowp float shadow = xll_shadow2D( _ShadowMapTexture, shadowCoord.xyz.xyz);
    shadow = (_LightShadowData.x + (shadow * (1.0 - _LightShadowData.x)));
    #line 397
    return shadow;
}
#line 458
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    #line 461
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.location = IN.cust_location;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    #line 465
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    #line 469
    surf( surfIN, o);
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    #line 473
    lowp vec3 lm = DecodeLightmap( lmtex);
    c.xyz += (o.Albedo * min( lm, vec3( (atten * 2.0))));
    c.w = o.Alpha;
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
in highp vec2 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec2(xlv_TEXCOORD0);
    xlt_IN.cust_location = vec2(xlv_TEXCOORD1);
    xlt_IN.lmap = vec2(xlv_TEXCOORD2);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform highp vec4 _LightShadowData;
void main ()
{
  lowp vec4 c_1;
  lowp float tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_4;
  arg0_4 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_5;
  arg0_5 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_6;
  arg0_6 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_7;
  tmpvar_7 = (1.0 - (((tmpvar_3.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_4, arg0_4))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_5, arg0_5))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_2 = tmpvar_7;
  lowp float shadow_8;
  lowp float tmpvar_9;
  tmpvar_9 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD3.xyz);
  highp float tmpvar_10;
  tmpvar_10 = (_LightShadowData.x + (tmpvar_9 * (1.0 - _LightShadowData.x)));
  shadow_8 = tmpvar_10;
  mediump vec3 lm_11;
  lowp vec3 tmpvar_12;
  tmpvar_12 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD2).xyz);
  lm_11 = tmpvar_12;
  lowp vec3 tmpvar_13;
  tmpvar_13 = vec3((shadow_8 * 2.0));
  mediump vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_3.xyz * min (lm_11, tmpvar_13));
  c_1.xyz = tmpvar_14;
  c_1.w = tmpvar_2;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 432
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    highp vec2 lmap;
    highp vec4 _ShadowCoord;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 401
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 405
uniform highp vec4 _Player3_Pos;
#line 413
#line 427
#line 441
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
#line 457
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
#line 413
void vert( inout appdata_full vertexData, out Input outData ) {
    highp vec4 pos = (glstate_matrix_mvp * vertexData.vertex);
    highp vec4 posWorld = (_Object2World * vertexData.vertex);
    #line 417
    outData.uv_MainTex = vec2( vertexData.texcoord);
    outData.location = posWorld.xz;
}
#line 443
v2f_surf vert_surf( in appdata_full v ) {
    #line 445
    v2f_surf o;
    Input customInputData;
    vert( v, customInputData);
    o.cust_location = customInputData.location;
    #line 449
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    #line 453
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
out highp vec2 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.pack0);
    xlv_TEXCOORD1 = vec2(xl_retval.cust_location);
    xlv_TEXCOORD2 = vec2(xl_retval.lmap);
    xlv_TEXCOORD3 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_shadow2D(mediump sampler2DShadow s, vec3 coord) { return texture (s, coord); }
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 432
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    highp vec2 lmap;
    highp vec4 _ShadowCoord;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 401
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 405
uniform highp vec4 _Player3_Pos;
#line 413
#line 427
#line 441
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
#line 457
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 325
mediump vec3 DirLightmapDiffuse( in mediump mat3 dirBasis, in lowp vec4 color, in lowp vec4 scale, in mediump vec3 normal, in bool surfFuncWritesNormal, out mediump vec3 scalePerBasisVector ) {
    mediump vec3 lm = DecodeLightmap( color);
    scalePerBasisVector = DecodeLightmap( scale);
    #line 329
    if (surfFuncWritesNormal){
        mediump vec3 normalInRnmBasis = xll_saturate_vf3((dirBasis * normal));
        lm *= dot( normalInRnmBasis, scalePerBasisVector);
    }
    #line 334
    return lm;
}
#line 353
mediump vec4 LightingLambert_DirLightmap( in SurfaceOutput s, in lowp vec4 color, in lowp vec4 scale, in bool surfFuncWritesNormal ) {
    #line 355
    highp mat3 unity_DirBasis = xll_transpose_mf3x3(mat3( vec3( 0.816497, 0.0, 0.57735), vec3( -0.408248, 0.707107, 0.57735), vec3( -0.408248, -0.707107, 0.57735)));
    mediump vec3 scalePerBasisVector;
    mediump vec3 lm = DirLightmapDiffuse( unity_DirBasis, color, scale, s.Normal, surfFuncWritesNormal, scalePerBasisVector);
    return vec4( lm, 0.0);
}
#line 427
highp float powerForPos( in highp vec4 pos, in highp vec2 nearVertex ) {
    highp float atten = clamp( (_FogRadius - length((pos.xz - nearVertex.xy))), 0.0, _FogRadius);
    return (((1.0 / _FogMaxRadius) * atten) / _FogRadius);
}
#line 420
void surf( in Input IN, inout SurfaceOutput o ) {
    #line 422
    lowp vec4 baseColor = (texture( _MainTex, IN.uv_MainTex) * _Color);
    highp float alpha = (1.0 - (((baseColor.w + powerForPos( _Player1_Pos, IN.location)) + powerForPos( _Player2_Pos, IN.location)) + powerForPos( _Player3_Pos, IN.location)));
    o.Albedo = baseColor.xyz;
    o.Alpha = alpha;
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    lowp float shadow = xll_shadow2D( _ShadowMapTexture, shadowCoord.xyz.xyz);
    shadow = (_LightShadowData.x + (shadow * (1.0 - _LightShadowData.x)));
    #line 397
    return shadow;
}
#line 459
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 461
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.location = IN.cust_location;
    SurfaceOutput o;
    #line 465
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 469
    o.Gloss = 0.0;
    surf( surfIN, o);
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    #line 473
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec4 lmIndTex = texture( unity_LightmapInd, IN.lmap.xy);
    mediump vec3 lm = LightingLambert_DirLightmap( o, lmtex, lmIndTex, false).xyz;
    c.xyz += (o.Albedo * min( lm, vec3( (atten * 2.0))));
    #line 477
    c.w = o.Alpha;
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
in highp vec2 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec2(xlv_TEXCOORD0);
    xlt_IN.cust_location = vec2(xlv_TEXCOORD1);
    xlt_IN.lmap = vec2(xlv_TEXCOORD2);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal_8;
  normal_8 = tmpvar_6;
  highp float vC_9;
  mediump vec3 x3_10;
  mediump vec3 x2_11;
  mediump vec3 x1_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal_8);
  x1_12.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal_8);
  x1_12.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal_8);
  x1_12.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal_8.xyzz * normal_8.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2_11.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2_11.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2_11.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal_8.x * normal_8.x) - (normal_8.y * normal_8.y));
  vC_9 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC_9);
  x3_10 = tmpvar_21;
  tmpvar_7 = ((x1_12 + x2_11) + x3_10);
  shlight_1 = tmpvar_7;
  tmpvar_3 = shlight_1;
  highp vec3 tmpvar_22;
  tmpvar_22 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_4LightPosX0 - tmpvar_22.x);
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosY0 - tmpvar_22.y);
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_4LightPosZ0 - tmpvar_22.z);
  highp vec4 tmpvar_26;
  tmpvar_26 = (((tmpvar_23 * tmpvar_23) + (tmpvar_24 * tmpvar_24)) + (tmpvar_25 * tmpvar_25));
  highp vec4 tmpvar_27;
  tmpvar_27 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_23 * tmpvar_5.x) + (tmpvar_24 * tmpvar_5.y)) + (tmpvar_25 * tmpvar_5.z)) * inversesqrt(tmpvar_26))) * (1.0/((1.0 + (tmpvar_26 * unity_4LightAtten0)))));
  highp vec3 tmpvar_28;
  tmpvar_28 = (tmpvar_3 + ((((unity_LightColor[0].xyz * tmpvar_27.x) + (unity_LightColor[1].xyz * tmpvar_27.y)) + (unity_LightColor[2].xyz * tmpvar_27.z)) + (unity_LightColor[3].xyz * tmpvar_27.w)));
  tmpvar_3 = tmpvar_28;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _LightShadowData;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp float tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_4;
  arg0_4 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_5;
  arg0_5 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_6;
  arg0_6 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_7;
  tmpvar_7 = (1.0 - (((tmpvar_3.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_4, arg0_4))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_5, arg0_5))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_2 = tmpvar_7;
  lowp float shadow_8;
  lowp float tmpvar_9;
  tmpvar_9 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD4.xyz);
  highp float tmpvar_10;
  tmpvar_10 = (_LightShadowData.x + (tmpvar_9 * (1.0 - _LightShadowData.x)));
  shadow_8 = tmpvar_10;
  lowp vec4 c_11;
  c_11.xyz = ((tmpvar_3.xyz * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz)) * shadow_8) * 2.0));
  c_11.w = tmpvar_2;
  c_1.w = c_11.w;
  c_1.xyz = (c_11.xyz + (tmpvar_3.xyz * xlv_TEXCOORD3));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "VERTEXLIGHT_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 432
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec4 _ShadowCoord;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 401
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 405
uniform highp vec4 _Player3_Pos;
#line 413
#line 427
#line 442
uniform highp vec4 _MainTex_ST;
#line 96
highp vec3 Shade4PointLights( in highp vec4 lightPosX, in highp vec4 lightPosY, in highp vec4 lightPosZ, in highp vec3 lightColor0, in highp vec3 lightColor1, in highp vec3 lightColor2, in highp vec3 lightColor3, in highp vec4 lightAttenSq, in highp vec3 pos, in highp vec3 normal ) {
    highp vec4 toLightX = (lightPosX - pos.x);
    highp vec4 toLightY = (lightPosY - pos.y);
    #line 100
    highp vec4 toLightZ = (lightPosZ - pos.z);
    highp vec4 lengthSq = vec4( 0.0);
    lengthSq += (toLightX * toLightX);
    lengthSq += (toLightY * toLightY);
    #line 104
    lengthSq += (toLightZ * toLightZ);
    highp vec4 ndotl = vec4( 0.0);
    ndotl += (toLightX * normal.x);
    ndotl += (toLightY * normal.y);
    #line 108
    ndotl += (toLightZ * normal.z);
    highp vec4 corr = inversesqrt(lengthSq);
    ndotl = max( vec4( 0.0, 0.0, 0.0, 0.0), (ndotl * corr));
    highp vec4 atten = (1.0 / (1.0 + (lengthSq * lightAttenSq)));
    #line 112
    highp vec4 diff = (ndotl * atten);
    highp vec3 col = vec3( 0.0);
    col += (lightColor0 * diff.x);
    col += (lightColor1 * diff.y);
    #line 116
    col += (lightColor2 * diff.z);
    col += (lightColor3 * diff.w);
    return col;
}
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 413
void vert( inout appdata_full vertexData, out Input outData ) {
    highp vec4 pos = (glstate_matrix_mvp * vertexData.vertex);
    highp vec4 posWorld = (_Object2World * vertexData.vertex);
    #line 417
    outData.uv_MainTex = vec2( vertexData.texcoord);
    outData.location = posWorld.xz;
}
#line 443
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 446
    Input customInputData;
    vert( v, customInputData);
    o.cust_location = customInputData.location;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 450
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 shlight = ShadeSH9( vec4( worldN, 1.0));
    #line 454
    o.vlight = shlight;
    highp vec3 worldPos = (_Object2World * v.vertex).xyz;
    o.vlight += Shade4PointLights( unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0, unity_LightColor[0].xyz, unity_LightColor[1].xyz, unity_LightColor[2].xyz, unity_LightColor[3].xyz, unity_4LightAtten0, worldPos, worldN);
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    #line 459
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out lowp vec3 xlv_TEXCOORD3;
out highp vec4 xlv_TEXCOORD4;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.pack0);
    xlv_TEXCOORD1 = vec2(xl_retval.cust_location);
    xlv_TEXCOORD2 = vec3(xl_retval.normal);
    xlv_TEXCOORD3 = vec3(xl_retval.vlight);
    xlv_TEXCOORD4 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_shadow2D(mediump sampler2DShadow s, vec3 coord) { return texture (s, coord); }
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 432
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec4 _ShadowCoord;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 401
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 405
uniform highp vec4 _Player3_Pos;
#line 413
#line 427
#line 442
uniform highp vec4 _MainTex_ST;
#line 338
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp vec4 c;
    #line 342
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.0));
    c.w = s.Alpha;
    return c;
}
#line 427
highp float powerForPos( in highp vec4 pos, in highp vec2 nearVertex ) {
    highp float atten = clamp( (_FogRadius - length((pos.xz - nearVertex.xy))), 0.0, _FogRadius);
    return (((1.0 / _FogMaxRadius) * atten) / _FogRadius);
}
#line 420
void surf( in Input IN, inout SurfaceOutput o ) {
    #line 422
    lowp vec4 baseColor = (texture( _MainTex, IN.uv_MainTex) * _Color);
    highp float alpha = (1.0 - (((baseColor.w + powerForPos( _Player1_Pos, IN.location)) + powerForPos( _Player2_Pos, IN.location)) + powerForPos( _Player3_Pos, IN.location)));
    o.Albedo = baseColor.xyz;
    o.Alpha = alpha;
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    lowp float shadow = xll_shadow2D( _ShadowMapTexture, shadowCoord.xyz.xyz);
    shadow = (_LightShadowData.x + (shadow * (1.0 - _LightShadowData.x)));
    #line 397
    return shadow;
}
#line 461
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 463
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.location = IN.cust_location;
    SurfaceOutput o;
    #line 467
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 471
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    surf( surfIN, o);
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    #line 475
    lowp vec4 c = vec4( 0.0);
    c = LightingLambert( o, _WorldSpaceLightPos0.xyz, atten);
    c.xyz += (o.Albedo * IN.vlight);
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in lowp vec3 xlv_TEXCOORD3;
in highp vec4 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec2(xlv_TEXCOORD0);
    xlt_IN.cust_location = vec2(xlv_TEXCOORD1);
    xlt_IN.normal = vec3(xlv_TEXCOORD2);
    xlt_IN.vlight = vec3(xlv_TEXCOORD3);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD4);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 6
//   opengl - ALU: 39 to 45, TEX: 1 to 3
//   d3d9 - ALU: 44 to 49, TEX: 1 to 3
//   d3d11 - ALU: 32 to 38, TEX: 1 to 3, FLOW: 1 to 1
//   d3d11_9x - ALU: 32 to 38, TEX: 1 to 3, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Color]
Float 3 [_FogRadius]
Float 4 [_FogMaxRadius]
Vector 5 [_Player1_Pos]
Vector 6 [_Player2_Pos]
Vector 7 [_Player3_Pos]
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
# 41 ALU, 1 TEX
PARAM c[9] = { program.local[0..7],
		{ 1, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[0], 2D;
ADD R1.xy, -fragment.texcoord[1], c[5].xzzw;
MUL R1.xy, R1, R1;
ADD R1.x, R1, R1.y;
RSQ R1.x, R1.x;
RCP R1.x, R1.x;
ADD R1.x, -R1, c[3];
MIN R1.x, R1, c[3];
ADD R1.zw, -fragment.texcoord[1].xyxy, c[6].xyxz;
MUL R1.zw, R1, R1;
ADD R1.z, R1, R1.w;
DP3 R1.w, fragment.texcoord[2], c[0];
MUL R0, R0, c[2];
RCP R2.x, c[4].x;
MAX R1.x, R1, c[8].y;
RCP R2.y, c[3].x;
MUL R1.x, R2, R1;
MAD R0.w, R1.x, R2.y, R0;
ADD R1.xy, -fragment.texcoord[1], c[7].xzzw;
MUL R1.xy, R1, R1;
ADD R1.y, R1.x, R1;
RSQ R1.x, R1.z;
RSQ R1.y, R1.y;
RCP R1.x, R1.x;
RCP R1.y, R1.y;
ADD R1.x, -R1, c[3];
ADD R1.y, -R1, c[3].x;
MIN R1.x, R1, c[3];
MIN R1.y, R1, c[3].x;
MAX R1.x, R1, c[8].y;
MUL R1.x, R1, R2;
MAD R1.x, R1, R2.y, R0.w;
MAX R1.y, R1, c[8];
MUL R0.w, R1.y, R2.x;
MAD R0.w, R0, R2.y, R1.x;
MUL R1.xyz, R0, fragment.texcoord[3];
MUL R0.xyz, R0, c[1];
MAX R1.w, R1, c[8].y;
MUL R0.xyz, R1.w, R0;
MAD result.color.xyz, R0, c[8].z, R1;
ADD result.color.w, -R0, c[8].x;
END
# 41 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Color]
Float 3 [_FogRadius]
Float 4 [_FogMaxRadius]
Vector 5 [_Player1_Pos]
Vector 6 [_Player2_Pos]
Vector 7 [_Player3_Pos]
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 47 ALU, 1 TEX
dcl_2d s0
def c8, 0.00000000, 1.00000000, 2.00000000, 0
dcl t0.xy
dcl t1.xy
dcl t2.xyz
dcl t3.xyz
texld r0, t0, s0
mul r0, r0, c2
rcp r2.x, c4.x
rcp r3.x, c3.x
mov r1.y, c5.z
mov r1.x, c5
add r1.xy, -t1, r1
mul r1.xy, r1, r1
add r1.x, r1, r1.y
rsq r1.x, r1.x
rcp r1.x, r1.x
add r1.x, -r1, c3
min r1.x, r1, c3
max r1.x, r1, c8
mul r1.x, r2, r1
mad r1.x, r1, r3, r0.w
mov r4.y, c6.z
mov r4.x, c6
add r4.xy, -t1, r4
mul r4.xy, r4, r4
add r4.x, r4, r4.y
rsq r4.x, r4.x
rcp r4.x, r4.x
add r4.x, -r4, c3
min r4.x, r4, c3
max r4.x, r4, c8
mul r4.x, r4, r2
mov r5.y, c7.z
mov r5.x, c7
add r5.xy, -t1, r5
mul r5.xy, r5, r5
add r5.x, r5, r5.y
rsq r5.x, r5.x
rcp r5.x, r5.x
add r5.x, -r5, c3
min r5.x, r5, c3
max r5.x, r5, c8
mul r2.x, r5, r2
mad r1.x, r4, r3, r1
mad r1.x, r2, r3, r1
add r0.w, -r1.x, c8.y
mul_pp r1.xyz, r0, t3
dp3_pp r2.x, t2, c0
mul_pp r0.xyz, r0, c1
max_pp r2.x, r2, c8
mul_pp r0.xyz, r2.x, r0
mad_pp r0.xyz, r0, c8.z, r1
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
ConstBuffer "$Globals" 144 // 128 used size, 10 vars
Vector 16 [_LightColor0] 4
Vector 48 [_Color] 4
Float 64 [_FogRadius]
Float 68 [_FogMaxRadius]
Vector 80 [_Player1_Pos] 4
Vector 96 [_Player2_Pos] 4
Vector 112 [_Player3_Pos] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
SetTexture 0 [_MainTex] 2D 0
// 37 instructions, 2 temp regs, 0 temp arrays:
// ALU 35 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedlfafleildghklmiehinehmflckllmbjcabaaaaaaomafaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcoeaeaaaaeaaaaaaadjabaaaafjaaaaaeegiocaaaaaaaaaaaaiaaaaaa
fjaaaaaeegiocaaaabaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaa
abaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacacaaaaaaaaaaaaajdcaabaaaaaaaaaaaogbkbaia
ebaaaaaaabaaaaaaigiacaaaaaaaaaaaagaaaaaaapaaaaahbcaabaaaaaaaaaaa
egaabaaaaaaaaaaaegaabaaaaaaaaaaaelaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaaaaaaaajbcaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaaakiacaaa
aaaaaaaaaeaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaaaaddaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaa
aeaaaaaaaoaaaaalccaabaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpbkiacaaaaaaaaaaaaeaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaabkaabaaaaaaaaaaaaaaaaaajmcaabaaaaaaaaaaakgbobaiaebaaaaaa
abaaaaaaagiicaaaaaaaaaaaafaaaaaaapaaaaahecaabaaaaaaaaaaaogakbaaa
aaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaaaaaaaaaackaabaaaaaaaaaaa
aaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaa
aeaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaaaa
ddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaa
diaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaabkaabaaaaaaaaaaaaoaaaaai
fcaabaaaaaaaaaaaagacbaaaaaaaaaaaagiacaaaaaaaaaaaaeaaaaaaefaaaaaj
pcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
dcaaaaakecaabaaaaaaaaaaadkaabaaaabaaaaaadkiacaaaaaaaaaaaadaaaaaa
ckaabaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaa
aaaaaaaaadaaaaaaaaaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaackaabaaa
aaaaaaaaaaaaaaajmcaabaaaaaaaaaaakgbobaiaebaaaaaaabaaaaaaagiicaaa
aaaaaaaaahaaaaaaapaaaaahecaabaaaaaaaaaaaogakbaaaaaaaaaaaogakbaaa
aaaaaaaaelaaaaafecaabaaaaaaaaaaackaabaaaaaaaaaaaaaaaaaajecaabaaa
aaaaaaaackaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaadeaaaaah
ecaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaaaaddaaaaaiecaabaaa
aaaaaaaackaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaadiaaaaahccaabaaa
aaaaaaaackaabaaaaaaaaaaabkaabaaaaaaaaaaaaoaaaaaiccaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaaaaaaaaahbcaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaaiiccabaaaaaaaaaaaakaabaia
ebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaaihcaabaaaaaaaaaaaegacbaaa
abaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaa
abaaaaaaegbcbaaaadaaaaaabaaaaaaiicaabaaaaaaaaaaaegbcbaaaacaaaaaa
egiccaaaabaaaaaaaaaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaaaaaaaaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaadkaabaaa
aaaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaa
egacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Color]
Float 3 [_FogRadius]
Float 4 [_FogMaxRadius]
Vector 5 [_Player1_Pos]
Vector 6 [_Player2_Pos]
Vector 7 [_Player3_Pos]
SetTexture 0 [_MainTex] 2D
"agal_ps
c8 0.0 1.0 2.0 0.0
[bc]
ciaaaaaaaaaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r0, v0, s0 <2d wrap linear point>
adaaaaaaaaaaapacaaaaaaoeacaaaaaaacaaaaoeabaaaaaa mul r0, r0, c2
aaaaaaaaabaaapacaeaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1, c4
afaaaaaaacaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r2.x, r1.x
aaaaaaaaadaaapacadaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r3, c3
afaaaaaaadaaabacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r3.x, r3.x
aaaaaaaaabaaacacafaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r1.y, c5.z
aaaaaaaaabaaabacafaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.x, c5
bfaaaaaaacaaagacabaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa neg r2.yz, v1
abaaaaaaabaaadacacaaaakjacaaaaaaabaaaafeacaaaaaa add r1.xy, r2.yzzz, r1.xyyy
adaaaaaaabaaadacabaaaafeacaaaaaaabaaaafeacaaaaaa mul r1.xy, r1.xyyy, r1.xyyy
abaaaaaaabaaabacabaaaaaaacaaaaaaabaaaaffacaaaaaa add r1.x, r1.x, r1.y
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
afaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r1.x, r1.x
bfaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r1.x, r1.x
abaaaaaaabaaabacabaaaaaaacaaaaaaadaaaaoeabaaaaaa add r1.x, r1.x, c3
agaaaaaaabaaabacabaaaaaaacaaaaaaadaaaaoeabaaaaaa min r1.x, r1.x, c3
ahaaaaaaabaaabacabaaaaaaacaaaaaaaiaaaaoeabaaaaaa max r1.x, r1.x, c8
adaaaaaaabaaabacacaaaaaaacaaaaaaabaaaaaaacaaaaaa mul r1.x, r2.x, r1.x
adaaaaaaabaaabacabaaaaaaacaaaaaaadaaaaaaacaaaaaa mul r1.x, r1.x, r3.x
abaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaappacaaaaaa add r1.x, r1.x, r0.w
aaaaaaaaaeaaacacagaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r4.y, c6.z
aaaaaaaaaeaaabacagaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r4.x, c6
bfaaaaaaadaaagacabaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa neg r3.yz, v1
abaaaaaaaeaaadacadaaaakjacaaaaaaaeaaaafeacaaaaaa add r4.xy, r3.yzzz, r4.xyyy
adaaaaaaaeaaadacaeaaaafeacaaaaaaaeaaaafeacaaaaaa mul r4.xy, r4.xyyy, r4.xyyy
abaaaaaaaeaaabacaeaaaaaaacaaaaaaaeaaaaffacaaaaaa add r4.x, r4.x, r4.y
akaaaaaaaeaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r4.x, r4.x
afaaaaaaaeaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r4.x, r4.x
bfaaaaaaaeaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r4.x, r4.x
abaaaaaaaeaaabacaeaaaaaaacaaaaaaadaaaaoeabaaaaaa add r4.x, r4.x, c3
agaaaaaaaeaaabacaeaaaaaaacaaaaaaadaaaaoeabaaaaaa min r4.x, r4.x, c3
ahaaaaaaaeaaabacaeaaaaaaacaaaaaaaiaaaaoeabaaaaaa max r4.x, r4.x, c8
adaaaaaaaeaaabacaeaaaaaaacaaaaaaacaaaaaaacaaaaaa mul r4.x, r4.x, r2.x
aaaaaaaaafaaacacahaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r5.y, c7.z
aaaaaaaaafaaabacahaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r5.x, c7
bfaaaaaaaeaaamacabaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa neg r4.zw, v1
abaaaaaaafaaadacaeaaaapoacaaaaaaafaaaafeacaaaaaa add r5.xy, r4.zwww, r5.xyyy
adaaaaaaafaaadacafaaaafeacaaaaaaafaaaafeacaaaaaa mul r5.xy, r5.xyyy, r5.xyyy
abaaaaaaafaaabacafaaaaaaacaaaaaaafaaaaffacaaaaaa add r5.x, r5.x, r5.y
akaaaaaaafaaabacafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r5.x, r5.x
afaaaaaaafaaabacafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r5.x, r5.x
bfaaaaaaafaaabacafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r5.x, r5.x
abaaaaaaafaaabacafaaaaaaacaaaaaaadaaaaoeabaaaaaa add r5.x, r5.x, c3
agaaaaaaafaaabacafaaaaaaacaaaaaaadaaaaoeabaaaaaa min r5.x, r5.x, c3
ahaaaaaaafaaabacafaaaaaaacaaaaaaaiaaaaoeabaaaaaa max r5.x, r5.x, c8
adaaaaaaacaaabacafaaaaaaacaaaaaaacaaaaaaacaaaaaa mul r2.x, r5.x, r2.x
adaaaaaaabaaaiacaeaaaaaaacaaaaaaadaaaaaaacaaaaaa mul r1.w, r4.x, r3.x
abaaaaaaabaaabacabaaaappacaaaaaaabaaaaaaacaaaaaa add r1.x, r1.w, r1.x
adaaaaaaadaaabacacaaaaaaacaaaaaaadaaaaaaacaaaaaa mul r3.x, r2.x, r3.x
abaaaaaaabaaabacadaaaaaaacaaaaaaabaaaaaaacaaaaaa add r1.x, r3.x, r1.x
bfaaaaaaadaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r3.x, r1.x
abaaaaaaaaaaaiacadaaaaaaacaaaaaaaiaaaaffabaaaaaa add r0.w, r3.x, c8.y
adaaaaaaabaaahacaaaaaakeacaaaaaaadaaaaoeaeaaaaaa mul r1.xyz, r0.xyzz, v3
bcaaaaaaacaaabacacaaaaoeaeaaaaaaaaaaaaoeabaaaaaa dp3 r2.x, v2, c0
adaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaaoeabaaaaaa mul r0.xyz, r0.xyzz, c1
ahaaaaaaacaaabacacaaaaaaacaaaaaaaiaaaaoeabaaaaaa max r2.x, r2.x, c8
adaaaaaaaaaaahacacaaaaaaacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r2.x, r0.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaaiaaaakkabaaaaaa mul r0.xyz, r0.xyzz, c8.z
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa add r0.xyz, r0.xyzz, r1.xyzz
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
ConstBuffer "$Globals" 144 // 128 used size, 10 vars
Vector 16 [_LightColor0] 4
Vector 48 [_Color] 4
Float 64 [_FogRadius]
Float 68 [_FogMaxRadius]
Vector 80 [_Player1_Pos] 4
Vector 96 [_Player2_Pos] 4
Vector 112 [_Player3_Pos] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
SetTexture 0 [_MainTex] 2D 0
// 37 instructions, 2 temp regs, 0 temp arrays:
// ALU 35 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefieceddkfnljepmjdbgebjlfdgbbgflannaddlabaaaaaacmajaaaaaeaaaaaa
daaaaaaagmadaaaafiaiaaaapiaiaaaaebgpgodjdeadaaaadeadaaaaaaacpppp
oiacaaaaemaaaaaaadaaciaaaaaaemaaaaaaemaaabaaceaaaaaaemaaaaaaaaaa
aaaaabaaabaaaaaaaaaaaaaaaaaaadaaafaaabaaaaaaaaaaabaaaaaaabaaagaa
aaaaaaaaaaacppppfbaaaaafahaaapkaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaa
bpaaaaacaaaaaaiaaaaaaplabpaaaaacaaaaaaiaabaachlabpaaaaacaaaaaaia
acaachlabpaaaaacaaaaaajaaaaiapkaecaaaaadaaaaapiaaaaaoelaaaaioeka
acaaaaadabaaabiaaaaapplbaeaaaakaacaaaaadabaaaciaaaaakklbaeaakkka
fkaaaaaeabaaabiaabaaoeiaabaaoeiaahaaaakaahaaaaacabaaabiaabaaaaia
agaaaaacabaaabiaabaaaaiaacaaaaadabaaabiaabaaaaibacaaaakaalaaaaad
acaaaiiaabaaaaiaahaaaakaakaaaaadabaaabiaacaaaakaacaappiaagaaaaac
abaaaciaacaaffkaafaaaaadabaaabiaabaaaaiaabaaffiaacaaaaadacaaabia
aaaapplbadaaaakaacaaaaadacaaaciaaaaakklbadaakkkafkaaaaaeabaaaeia
acaaoeiaacaaoeiaahaaaakaahaaaaacabaaaeiaabaakkiaagaaaaacabaaaeia
abaakkiaacaaaaadabaaaeiaabaakkibacaaaakaalaaaaadacaaabiaabaakkia
ahaaaakaakaaaaadabaaaeiaacaaaakaacaaaaiaafaaaaadabaaaeiaabaakkia
abaaffiaafaaaaadaaaacpiaaaaaoeiaabaaoekaagaaaaacabaaaiiaacaaaaka
aeaaaaaeaaaaaiiaabaakkiaabaappiaaaaappiaaeaaaaaeaaaaaiiaabaaaaia
abaappiaaaaappiaacaaaaadacaaabiaaaaapplbafaaaakaacaaaaadacaaacia
aaaakklbafaakkkafkaaaaaeabaaabiaacaaoeiaacaaoeiaahaaaakaahaaaaac
abaaabiaabaaaaiaagaaaaacabaaabiaabaaaaiaacaaaaadabaaabiaabaaaaib
acaaaakaalaaaaadacaaabiaabaaaaiaahaaaakaakaaaaadabaaabiaacaaaaka
acaaaaiaafaaaaadabaaabiaabaaaaiaabaaffiaaeaaaaaeaaaaaiiaabaaaaia
abaappiaaaaappiaacaaaaadabaaciiaaaaappibahaaffkaafaaaaadacaachia
aaaaoeiaaaaaoekaafaaaaadaaaachiaaaaaoeiaacaaoelaaiaaaaadaaaaciia
abaaoelaagaaoekaalaaaaadacaaciiaaaaappiaahaaaakaacaaaaadaaaaciia
acaappiaacaappiaaeaaaaaeabaachiaacaaoeiaaaaappiaaaaaoeiaabaaaaac
aaaicpiaabaaoeiappppaaaafdeieefcoeaeaaaaeaaaaaaadjabaaaafjaaaaae
egiocaaaaaaaaaaaaiaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafkaaaaad
aagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaaddcbabaaa
abaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaad
hcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaaaaaaaaaj
dcaabaaaaaaaaaaaogbkbaiaebaaaaaaabaaaaaaigiacaaaaaaaaaaaagaaaaaa
apaaaaahbcaabaaaaaaaaaaaegaabaaaaaaaaaaaegaabaaaaaaaaaaaelaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaajbcaabaaaaaaaaaaaakaabaia
ebaaaaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaadeaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaaaaddaaaaaibcaabaaaaaaaaaaaakaabaaa
aaaaaaaaakiacaaaaaaaaaaaaeaaaaaaaoaaaaalccaabaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpbkiacaaaaaaaaaaaaeaaaaaadiaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaaaaaaaaajmcaabaaa
aaaaaaaakgbobaiaebaaaaaaabaaaaaaagiicaaaaaaaaaaaafaaaaaaapaaaaah
ecaabaaaaaaaaaaaogakbaaaaaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaa
aaaaaaaackaabaaaaaaaaaaaaaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaa
aaaaaaaaakiacaaaaaaaaaaaaeaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaa
aaaaaaaaabeaaaaaaaaaaaaaddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaa
akiacaaaaaaaaaaaaeaaaaaadiaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaa
bkaabaaaaaaaaaaaaoaaaaaifcaabaaaaaaaaaaaagacbaaaaaaaaaaaagiacaaa
aaaaaaaaaeaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaa
aaaaaaaaaagabaaaaaaaaaaadcaaaaakecaabaaaaaaaaaaadkaabaaaabaaaaaa
dkiacaaaaaaaaaaaadaaaaaackaabaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaa
egacbaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaaaaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaackaabaaaaaaaaaaaaaaaaaajmcaabaaaaaaaaaaakgbobaia
ebaaaaaaabaaaaaaagiicaaaaaaaaaaaahaaaaaaapaaaaahecaabaaaaaaaaaaa
ogakbaaaaaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaaaaaaaaaackaabaaa
aaaaaaaaaaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaaakiacaaa
aaaaaaaaaeaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaa
aaaaaaaaddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaaaaaaaaaa
aeaaaaaadiaaaaahccaabaaaaaaaaaaackaabaaaaaaaaaaabkaabaaaaaaaaaaa
aoaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaa
aaaaaaahbcaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaai
iccabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaai
hcaabaaaaaaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaah
hcaabaaaabaaaaaaegacbaaaabaaaaaaegbcbaaaadaaaaaabaaaaaaiicaabaaa
aaaaaaaaegbcbaaaacaaaaaaegiccaaaabaaaaaaaaaaaaaadeaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaaaaaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaabejfdeheojiaaaaaa
afaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
imaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaa
aaaaaaaaadaaaaaaabaaaaaaamamaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaa
acaaaaaaahahaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaa
abaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaa
fdfgfpfegbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_Color]
Float 1 [_FogRadius]
Float 2 [_FogMaxRadius]
Vector 3 [_Player1_Pos]
Vector 4 [_Player2_Pos]
Vector 5 [_Player3_Pos]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [unity_Lightmap] 2D
"!!ARBfp1.0
# 39 ALU, 2 TEX
PARAM c[7] = { program.local[0..5],
		{ 1, 0, 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R1, fragment.texcoord[2], texture[1], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
ADD R2.xy, -fragment.texcoord[1], c[3].xzzw;
MUL R2.xy, R2, R2;
ADD R2.x, R2, R2.y;
RSQ R2.x, R2.x;
RCP R2.x, R2.x;
MUL R1.xyz, R1.w, R1;
MUL R0, R0, c[0];
MUL R0.xyz, R0, R1;
ADD R2.x, -R2, c[1];
MIN R1.w, R2.x, c[1].x;
MAX R1.x, R1.w, c[6].y;
RCP R2.x, c[2].x;
ADD R1.zw, -fragment.texcoord[1].xyxy, c[4].xyxz;
MUL R1.zw, R1, R1;
RCP R2.y, c[1].x;
MUL R1.x, R2, R1;
MAD R0.w, R1.x, R2.y, R0;
ADD R1.xy, -fragment.texcoord[1], c[5].xzzw;
MUL R1.xy, R1, R1;
ADD R1.y, R1.x, R1;
ADD R1.z, R1, R1.w;
RSQ R1.x, R1.z;
RSQ R1.y, R1.y;
RCP R1.x, R1.x;
RCP R1.y, R1.y;
ADD R1.x, -R1, c[1];
ADD R1.y, -R1, c[1].x;
MIN R1.x, R1, c[1];
MIN R1.y, R1, c[1].x;
MAX R1.x, R1, c[6].y;
MUL R1.x, R1, R2;
MAD R1.x, R1, R2.y, R0.w;
MAX R1.y, R1, c[6];
MUL R0.w, R1.y, R2.x;
MAD R0.w, R0, R2.y, R1.x;
MUL result.color.xyz, R0, c[6].z;
ADD result.color.w, -R0, c[6].x;
END
# 39 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_Color]
Float 1 [_FogRadius]
Float 2 [_FogMaxRadius]
Vector 3 [_Player1_Pos]
Vector 4 [_Player2_Pos]
Vector 5 [_Player3_Pos]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [unity_Lightmap] 2D
"ps_2_0
; 44 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c6, 0.00000000, 1.00000000, 8.00000000, 0
dcl t0.xy
dcl t1.xy
dcl t2.xy
texld r0, t2, s1
texld r1, t0, s0
mul r1, r1, c0
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r1, r0
rcp r3.x, c2.x
mov r2.y, c3.z
mov r2.x, c3
add r2.xy, -t1, r2
mul r2.xy, r2, r2
add r2.x, r2, r2.y
rsq r2.x, r2.x
rcp r2.x, r2.x
add r2.x, -r2, c1
min r2.x, r2, c1
max r1.x, r2, c6
rcp r2.x, c1.x
mul r1.x, r3, r1
mad r1.x, r1, r2, r1.w
mov r4.y, c4.z
mov r4.x, c4
add r4.xy, -t1, r4
mul r4.xy, r4, r4
add r4.x, r4, r4.y
rsq r4.x, r4.x
rcp r4.x, r4.x
add r4.x, -r4, c1
min r4.x, r4, c1
max r4.x, r4, c6
mul r4.x, r4, r3
mov r5.y, c5.z
mov r5.x, c5
add r5.xy, -t1, r5
mul r5.xy, r5, r5
add r5.x, r5, r5.y
rsq r5.x, r5.x
rcp r5.x, r5.x
add r5.x, -r5, c1
min r5.x, r5, c1
max r5.x, r5, c6
mad r1.x, r4, r2, r1
mul r3.x, r5, r3
mad r1.x, r3, r2, r1
mul_pp r0.xyz, r0, c6.z
add r0.w, -r1.x, c6.y
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
ConstBuffer "$Globals" 160 // 128 used size, 11 vars
Vector 48 [_Color] 4
Float 64 [_FogRadius]
Float 68 [_FogMaxRadius]
Vector 80 [_Player1_Pos] 4
Vector 96 [_Player2_Pos] 4
Vector 112 [_Player3_Pos] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [unity_Lightmap] 2D 1
// 35 instructions, 2 temp regs, 0 temp arrays:
// ALU 32 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedhbbibefdocblnajodmfncliememenhhoabaaaaaajeafaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefckeaeaaaaeaaaaaaacjabaaaafjaaaaaeegiocaaa
aaaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
gcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaaddcbabaaa
acaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaaaaaaaaajdcaabaaa
aaaaaaaaogbkbaiaebaaaaaaabaaaaaaigiacaaaaaaaaaaaagaaaaaaapaaaaah
bcaabaaaaaaaaaaaegaabaaaaaaaaaaaegaabaaaaaaaaaaaelaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaaaaaaaajbcaabaaaaaaaaaaaakaabaiaebaaaaaa
aaaaaaaaakiacaaaaaaaaaaaaeaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaabeaaaaaaaaaaaaaddaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaa
akiacaaaaaaaaaaaaeaaaaaaaoaaaaalccaabaaaaaaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpbkiacaaaaaaaaaaaaeaaaaaadiaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaaaaaaaaajmcaabaaaaaaaaaaa
kgbobaiaebaaaaaaabaaaaaaagiicaaaaaaaaaaaafaaaaaaapaaaaahecaabaaa
aaaaaaaaogakbaaaaaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaaaaaaaaaa
ckaabaaaaaaaaaaaaaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaa
akiacaaaaaaaaaaaaeaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaa
abeaaaaaaaaaaaaaddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaa
aaaaaaaaaeaaaaaadiaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaabkaabaaa
aaaaaaaaaoaaaaaifcaabaaaaaaaaaaaagacbaaaaaaaaaaaagiacaaaaaaaaaaa
aeaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaadcaaaaakecaabaaaaaaaaaaadkaabaaaabaaaaaadkiacaaa
aaaaaaaaadaaaaaackaabaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaa
abaaaaaaegiccaaaaaaaaaaaadaaaaaaaaaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaackaabaaaaaaaaaaaaaaaaaajmcaabaaaaaaaaaaakgbobaiaebaaaaaa
abaaaaaaagiicaaaaaaaaaaaahaaaaaaapaaaaahecaabaaaaaaaaaaaogakbaaa
aaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaaaaaaaaaackaabaaaaaaaaaaa
aaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaa
aeaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaaaa
ddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaa
diaaaaahccaabaaaaaaaaaaackaabaaaaaaaaaaabkaabaaaaaaaaaaaaoaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaaaaaaaaah
bcaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaaiiccabaaa
aaaaaaaaakaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpefaaaaajpcaabaaa
aaaaaaaaegbabaaaacaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaadiaaaaahhccabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_Color]
Float 1 [_FogRadius]
Float 2 [_FogMaxRadius]
Vector 3 [_Player1_Pos]
Vector 4 [_Player2_Pos]
Vector 5 [_Player3_Pos]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [unity_Lightmap] 2D
"agal_ps
c6 0.0 1.0 8.0 0.0
[bc]
ciaaaaaaaaaaapacacaaaaoeaeaaaaaaabaaaaaaafaababb tex r0, v2, s1 <2d wrap linear point>
ciaaaaaaabaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r1, v0, s0 <2d wrap linear point>
adaaaaaaabaaapacabaaaaoeacaaaaaaaaaaaaoeabaaaaaa mul r1, r1, c0
adaaaaaaaaaaahacaaaaaappacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r0.w, r0.xyzz
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r1.xyzz, r0.xyzz
aaaaaaaaacaaapacacaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r2, c2
afaaaaaaadaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r3.x, r2.x
aaaaaaaaacaaacacadaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r2.y, c3.z
aaaaaaaaacaaabacadaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r2.x, c3
bfaaaaaaacaaamacabaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa neg r2.zw, v1
abaaaaaaacaaadacacaaaapoacaaaaaaacaaaafeacaaaaaa add r2.xy, r2.zwww, r2.xyyy
adaaaaaaacaaadacacaaaafeacaaaaaaacaaaafeacaaaaaa mul r2.xy, r2.xyyy, r2.xyyy
abaaaaaaacaaabacacaaaaaaacaaaaaaacaaaaffacaaaaaa add r2.x, r2.x, r2.y
akaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r2.x, r2.x
afaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r2.x, r2.x
bfaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r2.x, r2.x
abaaaaaaacaaabacacaaaaaaacaaaaaaabaaaaoeabaaaaaa add r2.x, r2.x, c1
agaaaaaaacaaabacacaaaaaaacaaaaaaabaaaaoeabaaaaaa min r2.x, r2.x, c1
ahaaaaaaabaaabacacaaaaaaacaaaaaaagaaaaoeabaaaaaa max r1.x, r2.x, c6
aaaaaaaaaeaaapacabaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r4, c1
afaaaaaaacaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r2.x, r4.x
adaaaaaaabaaabacadaaaaaaacaaaaaaabaaaaaaacaaaaaa mul r1.x, r3.x, r1.x
adaaaaaaadaaacacabaaaaaaacaaaaaaacaaaaaaacaaaaaa mul r3.y, r1.x, r2.x
abaaaaaaabaaabacadaaaaffacaaaaaaabaaaappacaaaaaa add r1.x, r3.y, r1.w
aaaaaaaaaeaaacacaeaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r4.y, c4.z
aaaaaaaaaeaaabacaeaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r4.x, c4
bfaaaaaaaeaaamacabaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa neg r4.zw, v1
abaaaaaaaeaaadacaeaaaapoacaaaaaaaeaaaafeacaaaaaa add r4.xy, r4.zwww, r4.xyyy
adaaaaaaaeaaadacaeaaaafeacaaaaaaaeaaaafeacaaaaaa mul r4.xy, r4.xyyy, r4.xyyy
abaaaaaaaeaaabacaeaaaaaaacaaaaaaaeaaaaffacaaaaaa add r4.x, r4.x, r4.y
akaaaaaaaeaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r4.x, r4.x
afaaaaaaaeaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r4.x, r4.x
bfaaaaaaaeaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r4.x, r4.x
abaaaaaaaeaaabacaeaaaaaaacaaaaaaabaaaaoeabaaaaaa add r4.x, r4.x, c1
agaaaaaaaeaaabacaeaaaaaaacaaaaaaabaaaaoeabaaaaaa min r4.x, r4.x, c1
ahaaaaaaaeaaabacaeaaaaaaacaaaaaaagaaaaoeabaaaaaa max r4.x, r4.x, c6
adaaaaaaaeaaabacaeaaaaaaacaaaaaaadaaaaaaacaaaaaa mul r4.x, r4.x, r3.x
aaaaaaaaafaaacacafaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r5.y, c5.z
aaaaaaaaafaaabacafaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r5.x, c5
bfaaaaaaafaaamacabaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa neg r5.zw, v1
abaaaaaaafaaadacafaaaapoacaaaaaaafaaaafeacaaaaaa add r5.xy, r5.zwww, r5.xyyy
adaaaaaaafaaadacafaaaafeacaaaaaaafaaaafeacaaaaaa mul r5.xy, r5.xyyy, r5.xyyy
abaaaaaaafaaabacafaaaaaaacaaaaaaafaaaaffacaaaaaa add r5.x, r5.x, r5.y
akaaaaaaafaaabacafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r5.x, r5.x
afaaaaaaafaaabacafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r5.x, r5.x
bfaaaaaaafaaabacafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r5.x, r5.x
abaaaaaaafaaabacafaaaaaaacaaaaaaabaaaaoeabaaaaaa add r5.x, r5.x, c1
agaaaaaaafaaabacafaaaaaaacaaaaaaabaaaaoeabaaaaaa min r5.x, r5.x, c1
ahaaaaaaafaaabacafaaaaaaacaaaaaaagaaaaoeabaaaaaa max r5.x, r5.x, c6
adaaaaaaaeaaabacaeaaaaaaacaaaaaaacaaaaaaacaaaaaa mul r4.x, r4.x, r2.x
abaaaaaaabaaabacaeaaaaaaacaaaaaaabaaaaaaacaaaaaa add r1.x, r4.x, r1.x
adaaaaaaadaaabacafaaaaaaacaaaaaaadaaaaaaacaaaaaa mul r3.x, r5.x, r3.x
adaaaaaaacaaabacadaaaaaaacaaaaaaacaaaaaaacaaaaaa mul r2.x, r3.x, r2.x
abaaaaaaabaaabacacaaaaaaacaaaaaaabaaaaaaacaaaaaa add r1.x, r2.x, r1.x
adaaaaaaaaaaahacaaaaaakeacaaaaaaagaaaakkabaaaaaa mul r0.xyz, r0.xyzz, c6.z
bfaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r1.x, r1.x
abaaaaaaaaaaaiacabaaaaaaacaaaaaaagaaaaffabaaaaaa add r0.w, r1.x, c6.y
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
ConstBuffer "$Globals" 160 // 128 used size, 11 vars
Vector 48 [_Color] 4
Float 64 [_FogRadius]
Float 68 [_FogMaxRadius]
Vector 80 [_Player1_Pos] 4
Vector 96 [_Player2_Pos] 4
Vector 112 [_Player3_Pos] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [unity_Lightmap] 2D 1
// 35 instructions, 2 temp regs, 0 temp arrays:
// ALU 32 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedkchfleapgeajaljjiabijcpndgmcgnmhabaaaaaajmaiaaaaaeaaaaaa
daaaaaaadeadaaaaoaahaaaagiaiaaaaebgpgodjpmacaaaapmacaaaaaaacpppp
meacaaaadiaaaaaaabaacmaaaaaadiaaaaaadiaaacaaceaaaaaadiaaaaaaaaaa
abababaaaaaaadaaafaaaaaaaaaaaaaaaaacppppfbaaaaafafaaapkaaaaaaaaa
aaaaiadpaaaaaaebaaaaaaaabpaaaaacaaaaaaiaaaaaaplabpaaaaacaaaaaaia
abaaadlabpaaaaacaaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapkaecaaaaad
aaaaapiaaaaaoelaaaaioekaecaaaaadabaacpiaabaaoelaabaioekaacaaaaad
acaaabiaaaaapplbadaaaakaacaaaaadacaaaciaaaaakklbadaakkkafkaaaaae
acaaabiaacaaoeiaacaaoeiaafaaaakaahaaaaacacaaabiaacaaaaiaagaaaaac
acaaabiaacaaaaiaacaaaaadacaaabiaacaaaaibabaaaakaalaaaaadadaaaiia
acaaaaiaafaaaakaakaaaaadacaaabiaabaaaakaadaappiaagaaaaacacaaacia
abaaffkaafaaaaadacaaabiaacaaaaiaacaaffiaacaaaaadadaaabiaaaaapplb
acaaaakaacaaaaadadaaaciaaaaakklbacaakkkafkaaaaaeacaaaeiaadaaoeia
adaaoeiaafaaaakaahaaaaacacaaaeiaacaakkiaagaaaaacacaaaeiaacaakkia
acaaaaadacaaaeiaacaakkibabaaaakaalaaaaadadaaabiaacaakkiaafaaaaka
akaaaaadacaaaeiaabaaaakaadaaaaiaafaaaaadacaaaeiaacaakkiaacaaffia
afaaaaadaaaacpiaaaaaoeiaaaaaoekaagaaaaacacaaaiiaabaaaakaaeaaaaae
aaaaaiiaacaakkiaacaappiaaaaappiaaeaaaaaeaaaaaiiaacaaaaiaacaappia
aaaappiaacaaaaadadaaabiaaaaapplbaeaaaakaacaaaaadadaaaciaaaaakklb
aeaakkkafkaaaaaeacaaabiaadaaoeiaadaaoeiaafaaaakaahaaaaacacaaabia
acaaaaiaagaaaaacacaaabiaacaaaaiaacaaaaadacaaabiaacaaaaibabaaaaka
alaaaaadadaaabiaacaaaaiaafaaaakaakaaaaadacaaabiaabaaaakaadaaaaia
afaaaaadacaaabiaacaaaaiaacaaffiaaeaaaaaeaaaaaiiaacaaaaiaacaappia
aaaappiaacaaaaadacaaciiaaaaappibafaaffkaafaaaaadaaaaciiaabaappia
afaakkkaafaaaaadabaachiaabaaoeiaaaaappiaafaaaaadacaachiaaaaaoeia
abaaoeiaabaaaaacaaaicpiaacaaoeiappppaaaafdeieefckeaeaaaaeaaaaaaa
cjabaaaafjaaaaaeegiocaaaaaaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaa
fkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaa
abaaaaaagcbaaaaddcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
acaaaaaaaaaaaaajdcaabaaaaaaaaaaaogbkbaiaebaaaaaaabaaaaaaigiacaaa
aaaaaaaaagaaaaaaapaaaaahbcaabaaaaaaaaaaaegaabaaaaaaaaaaaegaabaaa
aaaaaaaaelaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaajbcaabaaa
aaaaaaaaakaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaadeaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaaddaaaaaibcaabaaa
aaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaaaoaaaaalccaabaaa
aaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpbkiacaaaaaaaaaaa
aeaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaa
aaaaaaajmcaabaaaaaaaaaaakgbobaiaebaaaaaaabaaaaaaagiicaaaaaaaaaaa
afaaaaaaapaaaaahecaabaaaaaaaaaaaogakbaaaaaaaaaaaogakbaaaaaaaaaaa
elaaaaafecaabaaaaaaaaaaackaabaaaaaaaaaaaaaaaaaajecaabaaaaaaaaaaa
ckaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaadeaaaaahecaabaaa
aaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaaaaddaaaaaiecaabaaaaaaaaaaa
ckaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaadiaaaaahecaabaaaaaaaaaaa
ckaabaaaaaaaaaaabkaabaaaaaaaaaaaaoaaaaaifcaabaaaaaaaaaaaagacbaaa
aaaaaaaaagiacaaaaaaaaaaaaeaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadcaaaaakecaabaaaaaaaaaaa
dkaabaaaabaaaaaadkiacaaaaaaaaaaaadaaaaaackaabaaaaaaaaaaadiaaaaai
hcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaaaaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaackaabaaaaaaaaaaaaaaaaaajmcaabaaa
aaaaaaaakgbobaiaebaaaaaaabaaaaaaagiicaaaaaaaaaaaahaaaaaaapaaaaah
ecaabaaaaaaaaaaaogakbaaaaaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaa
aaaaaaaackaabaaaaaaaaaaaaaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaa
aaaaaaaaakiacaaaaaaaaaaaaeaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaa
aaaaaaaaabeaaaaaaaaaaaaaddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaa
akiacaaaaaaaaaaaaeaaaaaadiaaaaahccaabaaaaaaaaaaackaabaaaaaaaaaaa
bkaabaaaaaaaaaaaaoaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaa
aaaaaaaaaeaaaaaaaaaaaaahbcaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaa
aaaaaaaaaaaaaaaiiccabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaaabeaaaaa
aaaaiadpefaaaaajpcaabaaaaaaaaaaaegbabaaaacaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaaebdiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaa
diaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab
ejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaa
heaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamamaaaaheaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaadadaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Vector 0 [_Color]
Float 1 [_FogRadius]
Float 2 [_FogMaxRadius]
Vector 3 [_Player1_Pos]
Vector 4 [_Player2_Pos]
Vector 5 [_Player3_Pos]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [unity_Lightmap] 2D
"!!ARBfp1.0
# 39 ALU, 2 TEX
PARAM c[7] = { program.local[0..5],
		{ 1, 0, 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R1, fragment.texcoord[2], texture[1], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
ADD R2.xy, -fragment.texcoord[1], c[3].xzzw;
MUL R2.xy, R2, R2;
ADD R2.x, R2, R2.y;
RSQ R2.x, R2.x;
RCP R2.x, R2.x;
MUL R1.xyz, R1.w, R1;
MUL R0, R0, c[0];
MUL R0.xyz, R0, R1;
ADD R2.x, -R2, c[1];
MIN R1.w, R2.x, c[1].x;
MAX R1.x, R1.w, c[6].y;
RCP R2.x, c[2].x;
ADD R1.zw, -fragment.texcoord[1].xyxy, c[4].xyxz;
MUL R1.zw, R1, R1;
RCP R2.y, c[1].x;
MUL R1.x, R2, R1;
MAD R0.w, R1.x, R2.y, R0;
ADD R1.xy, -fragment.texcoord[1], c[5].xzzw;
MUL R1.xy, R1, R1;
ADD R1.y, R1.x, R1;
ADD R1.z, R1, R1.w;
RSQ R1.x, R1.z;
RSQ R1.y, R1.y;
RCP R1.x, R1.x;
RCP R1.y, R1.y;
ADD R1.x, -R1, c[1];
ADD R1.y, -R1, c[1].x;
MIN R1.x, R1, c[1];
MIN R1.y, R1, c[1].x;
MAX R1.x, R1, c[6].y;
MUL R1.x, R1, R2;
MAD R1.x, R1, R2.y, R0.w;
MAX R1.y, R1, c[6];
MUL R0.w, R1.y, R2.x;
MAD R0.w, R0, R2.y, R1.x;
MUL result.color.xyz, R0, c[6].z;
ADD result.color.w, -R0, c[6].x;
END
# 39 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Vector 0 [_Color]
Float 1 [_FogRadius]
Float 2 [_FogMaxRadius]
Vector 3 [_Player1_Pos]
Vector 4 [_Player2_Pos]
Vector 5 [_Player3_Pos]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [unity_Lightmap] 2D
"ps_2_0
; 44 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c6, 0.00000000, 1.00000000, 8.00000000, 0
dcl t0.xy
dcl t1.xy
dcl t2.xy
texld r0, t2, s1
texld r1, t0, s0
mul r1, r1, c0
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r1, r0
rcp r3.x, c2.x
mov r2.y, c3.z
mov r2.x, c3
add r2.xy, -t1, r2
mul r2.xy, r2, r2
add r2.x, r2, r2.y
rsq r2.x, r2.x
rcp r2.x, r2.x
add r2.x, -r2, c1
min r2.x, r2, c1
max r1.x, r2, c6
rcp r2.x, c1.x
mul r1.x, r3, r1
mad r1.x, r1, r2, r1.w
mov r4.y, c4.z
mov r4.x, c4
add r4.xy, -t1, r4
mul r4.xy, r4, r4
add r4.x, r4, r4.y
rsq r4.x, r4.x
rcp r4.x, r4.x
add r4.x, -r4, c1
min r4.x, r4, c1
max r4.x, r4, c6
mul r4.x, r4, r3
mov r5.y, c5.z
mov r5.x, c5
add r5.xy, -t1, r5
mul r5.xy, r5, r5
add r5.x, r5, r5.y
rsq r5.x, r5.x
rcp r5.x, r5.x
add r5.x, -r5, c1
min r5.x, r5, c1
max r5.x, r5, c6
mad r1.x, r4, r2, r1
mul r3.x, r5, r3
mad r1.x, r3, r2, r1
mul_pp r0.xyz, r0, c6.z
add r0.w, -r1.x, c6.y
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
ConstBuffer "$Globals" 160 // 128 used size, 11 vars
Vector 48 [_Color] 4
Float 64 [_FogRadius]
Float 68 [_FogMaxRadius]
Vector 80 [_Player1_Pos] 4
Vector 96 [_Player2_Pos] 4
Vector 112 [_Player3_Pos] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [unity_Lightmap] 2D 1
// 35 instructions, 2 temp regs, 0 temp arrays:
// ALU 32 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedhbbibefdocblnajodmfncliememenhhoabaaaaaajeafaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefckeaeaaaaeaaaaaaacjabaaaafjaaaaaeegiocaaa
aaaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
gcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaaddcbabaaa
acaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaaaaaaaaajdcaabaaa
aaaaaaaaogbkbaiaebaaaaaaabaaaaaaigiacaaaaaaaaaaaagaaaaaaapaaaaah
bcaabaaaaaaaaaaaegaabaaaaaaaaaaaegaabaaaaaaaaaaaelaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaaaaaaaajbcaabaaaaaaaaaaaakaabaiaebaaaaaa
aaaaaaaaakiacaaaaaaaaaaaaeaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaabeaaaaaaaaaaaaaddaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaa
akiacaaaaaaaaaaaaeaaaaaaaoaaaaalccaabaaaaaaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpbkiacaaaaaaaaaaaaeaaaaaadiaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaaaaaaaaajmcaabaaaaaaaaaaa
kgbobaiaebaaaaaaabaaaaaaagiicaaaaaaaaaaaafaaaaaaapaaaaahecaabaaa
aaaaaaaaogakbaaaaaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaaaaaaaaaa
ckaabaaaaaaaaaaaaaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaa
akiacaaaaaaaaaaaaeaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaa
abeaaaaaaaaaaaaaddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaa
aaaaaaaaaeaaaaaadiaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaabkaabaaa
aaaaaaaaaoaaaaaifcaabaaaaaaaaaaaagacbaaaaaaaaaaaagiacaaaaaaaaaaa
aeaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaadcaaaaakecaabaaaaaaaaaaadkaabaaaabaaaaaadkiacaaa
aaaaaaaaadaaaaaackaabaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaa
abaaaaaaegiccaaaaaaaaaaaadaaaaaaaaaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaackaabaaaaaaaaaaaaaaaaaajmcaabaaaaaaaaaaakgbobaiaebaaaaaa
abaaaaaaagiicaaaaaaaaaaaahaaaaaaapaaaaahecaabaaaaaaaaaaaogakbaaa
aaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaaaaaaaaaackaabaaaaaaaaaaa
aaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaa
aeaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaaaa
ddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaa
diaaaaahccaabaaaaaaaaaaackaabaaaaaaaaaaabkaabaaaaaaaaaaaaoaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaaaaaaaaah
bcaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaaiiccabaaa
aaaaaaaaakaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpefaaaaajpcaabaaa
aaaaaaaaegbabaaaacaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaadiaaaaahhccabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Vector 0 [_Color]
Float 1 [_FogRadius]
Float 2 [_FogMaxRadius]
Vector 3 [_Player1_Pos]
Vector 4 [_Player2_Pos]
Vector 5 [_Player3_Pos]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [unity_Lightmap] 2D
"agal_ps
c6 0.0 1.0 8.0 0.0
[bc]
ciaaaaaaaaaaapacacaaaaoeaeaaaaaaabaaaaaaafaababb tex r0, v2, s1 <2d wrap linear point>
ciaaaaaaabaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r1, v0, s0 <2d wrap linear point>
adaaaaaaabaaapacabaaaaoeacaaaaaaaaaaaaoeabaaaaaa mul r1, r1, c0
adaaaaaaaaaaahacaaaaaappacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r0.w, r0.xyzz
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r1.xyzz, r0.xyzz
aaaaaaaaacaaapacacaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r2, c2
afaaaaaaadaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r3.x, r2.x
aaaaaaaaacaaacacadaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r2.y, c3.z
aaaaaaaaacaaabacadaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r2.x, c3
bfaaaaaaacaaamacabaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa neg r2.zw, v1
abaaaaaaacaaadacacaaaapoacaaaaaaacaaaafeacaaaaaa add r2.xy, r2.zwww, r2.xyyy
adaaaaaaacaaadacacaaaafeacaaaaaaacaaaafeacaaaaaa mul r2.xy, r2.xyyy, r2.xyyy
abaaaaaaacaaabacacaaaaaaacaaaaaaacaaaaffacaaaaaa add r2.x, r2.x, r2.y
akaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r2.x, r2.x
afaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r2.x, r2.x
bfaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r2.x, r2.x
abaaaaaaacaaabacacaaaaaaacaaaaaaabaaaaoeabaaaaaa add r2.x, r2.x, c1
agaaaaaaacaaabacacaaaaaaacaaaaaaabaaaaoeabaaaaaa min r2.x, r2.x, c1
ahaaaaaaabaaabacacaaaaaaacaaaaaaagaaaaoeabaaaaaa max r1.x, r2.x, c6
aaaaaaaaaeaaapacabaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r4, c1
afaaaaaaacaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r2.x, r4.x
adaaaaaaabaaabacadaaaaaaacaaaaaaabaaaaaaacaaaaaa mul r1.x, r3.x, r1.x
adaaaaaaadaaacacabaaaaaaacaaaaaaacaaaaaaacaaaaaa mul r3.y, r1.x, r2.x
abaaaaaaabaaabacadaaaaffacaaaaaaabaaaappacaaaaaa add r1.x, r3.y, r1.w
aaaaaaaaaeaaacacaeaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r4.y, c4.z
aaaaaaaaaeaaabacaeaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r4.x, c4
bfaaaaaaaeaaamacabaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa neg r4.zw, v1
abaaaaaaaeaaadacaeaaaapoacaaaaaaaeaaaafeacaaaaaa add r4.xy, r4.zwww, r4.xyyy
adaaaaaaaeaaadacaeaaaafeacaaaaaaaeaaaafeacaaaaaa mul r4.xy, r4.xyyy, r4.xyyy
abaaaaaaaeaaabacaeaaaaaaacaaaaaaaeaaaaffacaaaaaa add r4.x, r4.x, r4.y
akaaaaaaaeaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r4.x, r4.x
afaaaaaaaeaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r4.x, r4.x
bfaaaaaaaeaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r4.x, r4.x
abaaaaaaaeaaabacaeaaaaaaacaaaaaaabaaaaoeabaaaaaa add r4.x, r4.x, c1
agaaaaaaaeaaabacaeaaaaaaacaaaaaaabaaaaoeabaaaaaa min r4.x, r4.x, c1
ahaaaaaaaeaaabacaeaaaaaaacaaaaaaagaaaaoeabaaaaaa max r4.x, r4.x, c6
adaaaaaaaeaaabacaeaaaaaaacaaaaaaadaaaaaaacaaaaaa mul r4.x, r4.x, r3.x
aaaaaaaaafaaacacafaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r5.y, c5.z
aaaaaaaaafaaabacafaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r5.x, c5
bfaaaaaaafaaamacabaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa neg r5.zw, v1
abaaaaaaafaaadacafaaaapoacaaaaaaafaaaafeacaaaaaa add r5.xy, r5.zwww, r5.xyyy
adaaaaaaafaaadacafaaaafeacaaaaaaafaaaafeacaaaaaa mul r5.xy, r5.xyyy, r5.xyyy
abaaaaaaafaaabacafaaaaaaacaaaaaaafaaaaffacaaaaaa add r5.x, r5.x, r5.y
akaaaaaaafaaabacafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r5.x, r5.x
afaaaaaaafaaabacafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r5.x, r5.x
bfaaaaaaafaaabacafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r5.x, r5.x
abaaaaaaafaaabacafaaaaaaacaaaaaaabaaaaoeabaaaaaa add r5.x, r5.x, c1
agaaaaaaafaaabacafaaaaaaacaaaaaaabaaaaoeabaaaaaa min r5.x, r5.x, c1
ahaaaaaaafaaabacafaaaaaaacaaaaaaagaaaaoeabaaaaaa max r5.x, r5.x, c6
adaaaaaaaeaaabacaeaaaaaaacaaaaaaacaaaaaaacaaaaaa mul r4.x, r4.x, r2.x
abaaaaaaabaaabacaeaaaaaaacaaaaaaabaaaaaaacaaaaaa add r1.x, r4.x, r1.x
adaaaaaaadaaabacafaaaaaaacaaaaaaadaaaaaaacaaaaaa mul r3.x, r5.x, r3.x
adaaaaaaacaaabacadaaaaaaacaaaaaaacaaaaaaacaaaaaa mul r2.x, r3.x, r2.x
abaaaaaaabaaabacacaaaaaaacaaaaaaabaaaaaaacaaaaaa add r1.x, r2.x, r1.x
adaaaaaaaaaaahacaaaaaakeacaaaaaaagaaaakkabaaaaaa mul r0.xyz, r0.xyzz, c6.z
bfaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r1.x, r1.x
abaaaaaaaaaaaiacabaaaaaaacaaaaaaagaaaaffabaaaaaa add r0.w, r1.x, c6.y
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
ConstBuffer "$Globals" 160 // 128 used size, 11 vars
Vector 48 [_Color] 4
Float 64 [_FogRadius]
Float 68 [_FogMaxRadius]
Vector 80 [_Player1_Pos] 4
Vector 96 [_Player2_Pos] 4
Vector 112 [_Player3_Pos] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [unity_Lightmap] 2D 1
// 35 instructions, 2 temp regs, 0 temp arrays:
// ALU 32 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedkchfleapgeajaljjiabijcpndgmcgnmhabaaaaaajmaiaaaaaeaaaaaa
daaaaaaadeadaaaaoaahaaaagiaiaaaaebgpgodjpmacaaaapmacaaaaaaacpppp
meacaaaadiaaaaaaabaacmaaaaaadiaaaaaadiaaacaaceaaaaaadiaaaaaaaaaa
abababaaaaaaadaaafaaaaaaaaaaaaaaaaacppppfbaaaaafafaaapkaaaaaaaaa
aaaaiadpaaaaaaebaaaaaaaabpaaaaacaaaaaaiaaaaaaplabpaaaaacaaaaaaia
abaaadlabpaaaaacaaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapkaecaaaaad
aaaaapiaaaaaoelaaaaioekaecaaaaadabaacpiaabaaoelaabaioekaacaaaaad
acaaabiaaaaapplbadaaaakaacaaaaadacaaaciaaaaakklbadaakkkafkaaaaae
acaaabiaacaaoeiaacaaoeiaafaaaakaahaaaaacacaaabiaacaaaaiaagaaaaac
acaaabiaacaaaaiaacaaaaadacaaabiaacaaaaibabaaaakaalaaaaadadaaaiia
acaaaaiaafaaaakaakaaaaadacaaabiaabaaaakaadaappiaagaaaaacacaaacia
abaaffkaafaaaaadacaaabiaacaaaaiaacaaffiaacaaaaadadaaabiaaaaapplb
acaaaakaacaaaaadadaaaciaaaaakklbacaakkkafkaaaaaeacaaaeiaadaaoeia
adaaoeiaafaaaakaahaaaaacacaaaeiaacaakkiaagaaaaacacaaaeiaacaakkia
acaaaaadacaaaeiaacaakkibabaaaakaalaaaaadadaaabiaacaakkiaafaaaaka
akaaaaadacaaaeiaabaaaakaadaaaaiaafaaaaadacaaaeiaacaakkiaacaaffia
afaaaaadaaaacpiaaaaaoeiaaaaaoekaagaaaaacacaaaiiaabaaaakaaeaaaaae
aaaaaiiaacaakkiaacaappiaaaaappiaaeaaaaaeaaaaaiiaacaaaaiaacaappia
aaaappiaacaaaaadadaaabiaaaaapplbaeaaaakaacaaaaadadaaaciaaaaakklb
aeaakkkafkaaaaaeacaaabiaadaaoeiaadaaoeiaafaaaakaahaaaaacacaaabia
acaaaaiaagaaaaacacaaabiaacaaaaiaacaaaaadacaaabiaacaaaaibabaaaaka
alaaaaadadaaabiaacaaaaiaafaaaakaakaaaaadacaaabiaabaaaakaadaaaaia
afaaaaadacaaabiaacaaaaiaacaaffiaaeaaaaaeaaaaaiiaacaaaaiaacaappia
aaaappiaacaaaaadacaaciiaaaaappibafaaffkaafaaaaadaaaaciiaabaappia
afaakkkaafaaaaadabaachiaabaaoeiaaaaappiaafaaaaadacaachiaaaaaoeia
abaaoeiaabaaaaacaaaicpiaacaaoeiappppaaaafdeieefckeaeaaaaeaaaaaaa
cjabaaaafjaaaaaeegiocaaaaaaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaa
fkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaa
abaaaaaagcbaaaaddcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
acaaaaaaaaaaaaajdcaabaaaaaaaaaaaogbkbaiaebaaaaaaabaaaaaaigiacaaa
aaaaaaaaagaaaaaaapaaaaahbcaabaaaaaaaaaaaegaabaaaaaaaaaaaegaabaaa
aaaaaaaaelaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaajbcaabaaa
aaaaaaaaakaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaadeaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaaddaaaaaibcaabaaa
aaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaaaoaaaaalccaabaaa
aaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpbkiacaaaaaaaaaaa
aeaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaa
aaaaaaajmcaabaaaaaaaaaaakgbobaiaebaaaaaaabaaaaaaagiicaaaaaaaaaaa
afaaaaaaapaaaaahecaabaaaaaaaaaaaogakbaaaaaaaaaaaogakbaaaaaaaaaaa
elaaaaafecaabaaaaaaaaaaackaabaaaaaaaaaaaaaaaaaajecaabaaaaaaaaaaa
ckaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaadeaaaaahecaabaaa
aaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaaaaddaaaaaiecaabaaaaaaaaaaa
ckaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaadiaaaaahecaabaaaaaaaaaaa
ckaabaaaaaaaaaaabkaabaaaaaaaaaaaaoaaaaaifcaabaaaaaaaaaaaagacbaaa
aaaaaaaaagiacaaaaaaaaaaaaeaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadcaaaaakecaabaaaaaaaaaaa
dkaabaaaabaaaaaadkiacaaaaaaaaaaaadaaaaaackaabaaaaaaaaaaadiaaaaai
hcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaaaaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaackaabaaaaaaaaaaaaaaaaaajmcaabaaa
aaaaaaaakgbobaiaebaaaaaaabaaaaaaagiicaaaaaaaaaaaahaaaaaaapaaaaah
ecaabaaaaaaaaaaaogakbaaaaaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaa
aaaaaaaackaabaaaaaaaaaaaaaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaa
aaaaaaaaakiacaaaaaaaaaaaaeaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaa
aaaaaaaaabeaaaaaaaaaaaaaddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaa
akiacaaaaaaaaaaaaeaaaaaadiaaaaahccaabaaaaaaaaaaackaabaaaaaaaaaaa
bkaabaaaaaaaaaaaaoaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaa
aaaaaaaaaeaaaaaaaaaaaaahbcaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaa
aaaaaaaaaaaaaaaiiccabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaaabeaaaaa
aaaaiadpefaaaaajpcaabaaaaaaaaaaaegbabaaaacaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaaebdiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaa
diaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab
ejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaa
heaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamamaaaaheaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaadadaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Color]
Float 3 [_FogRadius]
Float 4 [_FogMaxRadius]
Vector 5 [_Player1_Pos]
Vector 6 [_Player2_Pos]
Vector 7 [_Player3_Pos]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
"!!ARBfp1.0
# 43 ALU, 2 TEX
PARAM c[9] = { program.local[0..7],
		{ 1, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TXP R1.x, fragment.texcoord[4], texture[1], 2D;
MUL R0, R0, c[2];
ADD R1.zw, -fragment.texcoord[1].xyxy, c[5].xyxz;
MUL R1.zw, R1, R1;
ADD R1.y, R1.z, R1.w;
RSQ R1.y, R1.y;
RCP R1.y, R1.y;
ADD R1.w, -R1.y, c[3].x;
DP3 R1.z, fragment.texcoord[2], c[0];
MAX R1.y, R1.z, c[8];
MUL R2.xyz, R0, c[1];
MUL R1.x, R1.y, R1;
MUL R1.xyz, R1.x, R2;
MUL R2.xyz, R0, fragment.texcoord[3];
MIN R1.w, R1, c[3].x;
MAX R0.x, R1.w, c[8].y;
RCP R1.w, c[4].x;
RCP R2.w, c[3].x;
MUL R0.x, R1.w, R0;
MAD R3.x, R0, R2.w, R0.w;
ADD R0.xy, -fragment.texcoord[1], c[6].xzzw;
MUL R0.xy, R0, R0;
ADD R0.x, R0, R0.y;
ADD R0.zw, -fragment.texcoord[1].xyxy, c[7].xyxz;
MUL R0.zw, R0, R0;
ADD R0.y, R0.z, R0.w;
RSQ R0.x, R0.x;
RSQ R0.y, R0.y;
RCP R0.x, R0.x;
RCP R0.y, R0.y;
ADD R0.x, -R0, c[3];
ADD R0.y, -R0, c[3].x;
MIN R0.x, R0, c[3];
MIN R0.y, R0, c[3].x;
MAX R0.x, R0, c[8].y;
MUL R0.x, R0, R1.w;
MAD R0.z, R0.x, R2.w, R3.x;
MAX R0.y, R0, c[8];
MUL R0.x, R0.y, R1.w;
MAD R0.x, R0, R2.w, R0.z;
MAD result.color.xyz, R1, c[8].z, R2;
ADD result.color.w, -R0.x, c[8].x;
END
# 43 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Color]
Float 3 [_FogRadius]
Float 4 [_FogMaxRadius]
Vector 5 [_Player1_Pos]
Vector 6 [_Player2_Pos]
Vector 7 [_Player3_Pos]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
"ps_2_0
; 48 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c8, 0.00000000, 1.00000000, 2.00000000, 0
dcl t0.xy
dcl t1.xy
dcl t2.xyz
dcl t3.xyz
dcl t4
texldp r1, t4, s1
texld r0, t0, s0
dp3_pp r3.x, t2, c0
mul r0, r0, c2
rcp r4.x, c4.x
max_pp r3.x, r3, c8
mul_pp r1.x, r3, r1
mul_pp r3.xyz, r0, c1
mul_pp r1.xyz, r1.x, r3
mul_pp r0.xyz, r0, t3
rcp r3.x, c3.x
mov r2.y, c5.z
mov r2.x, c5
add r2.xy, -t1, r2
mul r2.xy, r2, r2
add r2.x, r2, r2.y
rsq r2.x, r2.x
rcp r2.x, r2.x
add r2.x, -r2, c3
min r2.x, r2, c3
max r2.x, r2, c8
mul r2.x, r4, r2
mad r2.x, r2, r3, r0.w
mov r5.y, c6.z
mov r5.x, c6
add r5.xy, -t1, r5
mul r5.xy, r5, r5
add r5.x, r5, r5.y
rsq r5.x, r5.x
rcp r5.x, r5.x
add r5.x, -r5, c3
min r5.x, r5, c3
max r5.x, r5, c8
mul r5.x, r5, r4
mov r6.y, c7.z
mov r6.x, c7
add r6.xy, -t1, r6
mul r6.xy, r6, r6
add r6.x, r6, r6.y
rsq r6.x, r6.x
rcp r6.x, r6.x
add r6.x, -r6, c3
min r6.x, r6, c3
max r6.x, r6, c8
mad r2.x, r5, r3, r2
mul r4.x, r6, r4
mad r2.x, r4, r3, r2
add r0.w, -r2.x, c8.y
mad_pp r0.xyz, r1, c8.z, r0
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
ConstBuffer "$Globals" 208 // 192 used size, 11 vars
Vector 16 [_LightColor0] 4
Vector 112 [_Color] 4
Float 128 [_FogRadius]
Float 132 [_FogMaxRadius]
Vector 144 [_Player1_Pos] 4
Vector 160 [_Player2_Pos] 4
Vector 176 [_Player3_Pos] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_ShadowMapTexture] 2D 0
// 39 instructions, 2 temp regs, 0 temp arrays:
// ALU 36 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedbokcnanbenbaldgffmbeoflomcgcbhjjabaaaaaagmagaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcemafaaaa
eaaaaaaafdabaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafjaaaaaeegiocaaa
abaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
gcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadlcbabaaaaeaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacacaaaaaaaaaaaaajdcaabaaaaaaaaaaaogbkbaia
ebaaaaaaabaaaaaaigiacaaaaaaaaaaaakaaaaaaapaaaaahbcaabaaaaaaaaaaa
egaabaaaaaaaaaaaegaabaaaaaaaaaaaelaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaaaaaaaajbcaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaaakiacaaa
aaaaaaaaaiaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaaaaddaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaa
aiaaaaaaaoaaaaalccaabaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpbkiacaaaaaaaaaaaaiaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaabkaabaaaaaaaaaaaaaaaaaajmcaabaaaaaaaaaaakgbobaiaebaaaaaa
abaaaaaaagiicaaaaaaaaaaaajaaaaaaapaaaaahecaabaaaaaaaaaaaogakbaaa
aaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaaaaaaaaaackaabaaaaaaaaaaa
aaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaa
aiaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaaaa
ddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaa
diaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaabkaabaaaaaaaaaaaaoaaaaai
fcaabaaaaaaaaaaaagacbaaaaaaaaaaaagiacaaaaaaaaaaaaiaaaaaaefaaaaaj
pcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaa
dcaaaaakecaabaaaaaaaaaaadkaabaaaabaaaaaadkiacaaaaaaaaaaaahaaaaaa
ckaabaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaa
aaaaaaaaahaaaaaaaaaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaackaabaaa
aaaaaaaaaaaaaaajmcaabaaaaaaaaaaakgbobaiaebaaaaaaabaaaaaaagiicaaa
aaaaaaaaalaaaaaaapaaaaahecaabaaaaaaaaaaaogakbaaaaaaaaaaaogakbaaa
aaaaaaaaelaaaaafecaabaaaaaaaaaaackaabaaaaaaaaaaaaaaaaaajecaabaaa
aaaaaaaackaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaadeaaaaah
ecaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaaaaddaaaaaiecaabaaa
aaaaaaaackaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaadiaaaaahccaabaaa
aaaaaaaackaabaaaaaaaaaaabkaabaaaaaaaaaaaaoaaaaaiccaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaaaaaaaaahbcaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaaiiccabaaaaaaaaaaaakaabaia
ebaaaaaaaaaaaaaaabeaaaaaaaaaiadpaoaaaaahdcaabaaaaaaaaaaaegbabaaa
aeaaaaaapgbpbaaaaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaa
eghobaaaabaaaaaaaagabaaaaaaaaaaabaaaaaaiccaabaaaaaaaaaaaegbcbaaa
acaaaaaaegiccaaaabaaaaaaaaaaaaaadeaaaaahccaabaaaaaaaaaaabkaabaaa
aaaaaaaaabeaaaaaaaaaaaaaapaaaaahbcaabaaaaaaaaaaafgafbaaaaaaaaaaa
agaabaaaaaaaaaaadiaaaaaiocaabaaaaaaaaaaaagajbaaaabaaaaaaagijcaaa
aaaaaaaaabaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegbcbaaa
adaaaaaadcaaaaajhccabaaaaaaaaaaajgahbaaaaaaaaaaaagaabaaaaaaaaaaa
egacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Color]
Float 3 [_FogRadius]
Float 4 [_FogMaxRadius]
Vector 5 [_Player1_Pos]
Vector 6 [_Player2_Pos]
Vector 7 [_Player3_Pos]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
"agal_ps
c8 0.0 1.0 2.0 0.0
[bc]
aeaaaaaaaaaaapacaeaaaaoeaeaaaaaaaeaaaappaeaaaaaa div r0, v4, v4.w
ciaaaaaaabaaapacaaaaaafeacaaaaaaabaaaaaaafaababb tex r1, r0.xyyy, s1 <2d wrap linear point>
ciaaaaaaaaaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r0, v0, s0 <2d wrap linear point>
bcaaaaaaadaaabacacaaaaoeaeaaaaaaaaaaaaoeabaaaaaa dp3 r3.x, v2, c0
adaaaaaaaaaaapacaaaaaaoeacaaaaaaacaaaaoeabaaaaaa mul r0, r0, c2
aaaaaaaaacaaapacaeaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r2, c4
afaaaaaaaeaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r4.x, r2.x
ahaaaaaaadaaabacadaaaaaaacaaaaaaaiaaaaoeabaaaaaa max r3.x, r3.x, c8
adaaaaaaabaaabacadaaaaaaacaaaaaaabaaaaaaacaaaaaa mul r1.x, r3.x, r1.x
adaaaaaaadaaahacaaaaaakeacaaaaaaabaaaaoeabaaaaaa mul r3.xyz, r0.xyzz, c1
adaaaaaaabaaahacabaaaaaaacaaaaaaadaaaakeacaaaaaa mul r1.xyz, r1.x, r3.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaadaaaaoeaeaaaaaa mul r0.xyz, r0.xyzz, v3
aaaaaaaaadaaaiacadaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r3.w, c3
afaaaaaaadaaabacadaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r3.x, r3.w
aaaaaaaaacaaacacafaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r2.y, c5.z
aaaaaaaaacaaabacafaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r2.x, c5
bfaaaaaaacaaamacabaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa neg r2.zw, v1
abaaaaaaacaaadacacaaaapoacaaaaaaacaaaafeacaaaaaa add r2.xy, r2.zwww, r2.xyyy
adaaaaaaacaaadacacaaaafeacaaaaaaacaaaafeacaaaaaa mul r2.xy, r2.xyyy, r2.xyyy
abaaaaaaacaaabacacaaaaaaacaaaaaaacaaaaffacaaaaaa add r2.x, r2.x, r2.y
akaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r2.x, r2.x
afaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r2.x, r2.x
bfaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r2.x, r2.x
abaaaaaaacaaabacacaaaaaaacaaaaaaadaaaaoeabaaaaaa add r2.x, r2.x, c3
agaaaaaaacaaabacacaaaaaaacaaaaaaadaaaaoeabaaaaaa min r2.x, r2.x, c3
ahaaaaaaacaaabacacaaaaaaacaaaaaaaiaaaaoeabaaaaaa max r2.x, r2.x, c8
adaaaaaaacaaabacaeaaaaaaacaaaaaaacaaaaaaacaaaaaa mul r2.x, r4.x, r2.x
adaaaaaaacaaabacacaaaaaaacaaaaaaadaaaaaaacaaaaaa mul r2.x, r2.x, r3.x
abaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaappacaaaaaa add r2.x, r2.x, r0.w
aaaaaaaaafaaacacagaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r5.y, c6.z
aaaaaaaaafaaabacagaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r5.x, c6
bfaaaaaaaeaaagacabaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa neg r4.yz, v1
abaaaaaaafaaadacaeaaaakjacaaaaaaafaaaafeacaaaaaa add r5.xy, r4.yzzz, r5.xyyy
adaaaaaaafaaadacafaaaafeacaaaaaaafaaaafeacaaaaaa mul r5.xy, r5.xyyy, r5.xyyy
abaaaaaaafaaabacafaaaaaaacaaaaaaafaaaaffacaaaaaa add r5.x, r5.x, r5.y
akaaaaaaafaaabacafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r5.x, r5.x
afaaaaaaafaaabacafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r5.x, r5.x
bfaaaaaaafaaabacafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r5.x, r5.x
abaaaaaaafaaabacafaaaaaaacaaaaaaadaaaaoeabaaaaaa add r5.x, r5.x, c3
agaaaaaaafaaabacafaaaaaaacaaaaaaadaaaaoeabaaaaaa min r5.x, r5.x, c3
ahaaaaaaafaaabacafaaaaaaacaaaaaaaiaaaaoeabaaaaaa max r5.x, r5.x, c8
adaaaaaaafaaabacafaaaaaaacaaaaaaaeaaaaaaacaaaaaa mul r5.x, r5.x, r4.x
aaaaaaaaagaaacacahaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r6.y, c7.z
aaaaaaaaagaaabacahaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r6.x, c7
bfaaaaaaafaaamacabaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa neg r5.zw, v1
abaaaaaaagaaadacafaaaapoacaaaaaaagaaaafeacaaaaaa add r6.xy, r5.zwww, r6.xyyy
adaaaaaaagaaadacagaaaafeacaaaaaaagaaaafeacaaaaaa mul r6.xy, r6.xyyy, r6.xyyy
abaaaaaaagaaabacagaaaaaaacaaaaaaagaaaaffacaaaaaa add r6.x, r6.x, r6.y
akaaaaaaagaaabacagaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r6.x, r6.x
afaaaaaaagaaabacagaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r6.x, r6.x
bfaaaaaaagaaabacagaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r6.x, r6.x
abaaaaaaagaaabacagaaaaaaacaaaaaaadaaaaoeabaaaaaa add r6.x, r6.x, c3
agaaaaaaagaaabacagaaaaaaacaaaaaaadaaaaoeabaaaaaa min r6.x, r6.x, c3
ahaaaaaaagaaabacagaaaaaaacaaaaaaaiaaaaoeabaaaaaa max r6.x, r6.x, c8
adaaaaaaabaaaiacafaaaaaaacaaaaaaadaaaaaaacaaaaaa mul r1.w, r5.x, r3.x
abaaaaaaacaaabacabaaaappacaaaaaaacaaaaaaacaaaaaa add r2.x, r1.w, r2.x
adaaaaaaaeaaabacagaaaaaaacaaaaaaaeaaaaaaacaaaaaa mul r4.x, r6.x, r4.x
adaaaaaaadaaabacaeaaaaaaacaaaaaaadaaaaaaacaaaaaa mul r3.x, r4.x, r3.x
abaaaaaaacaaabacadaaaaaaacaaaaaaacaaaaaaacaaaaaa add r2.x, r3.x, r2.x
bfaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r2.x, r2.x
abaaaaaaaaaaaiacacaaaaaaacaaaaaaaiaaaaffabaaaaaa add r0.w, r2.x, c8.y
adaaaaaaabaaahacabaaaakeacaaaaaaaiaaaakkabaaaaaa mul r1.xyz, r1.xyzz, c8.z
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
ConstBuffer "$Globals" 208 // 192 used size, 11 vars
Vector 16 [_LightColor0] 4
Vector 112 [_Color] 4
Float 128 [_FogRadius]
Float 132 [_FogMaxRadius]
Vector 144 [_Player1_Pos] 4
Vector 160 [_Player2_Pos] 4
Vector 176 [_Player3_Pos] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_ShadowMapTexture] 2D 0
// 39 instructions, 2 temp regs, 0 temp arrays:
// ALU 36 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedgebicaappeedomffnonfiieaeleanjkjabaaaaaaaiakaaaaaeaaaaaa
daaaaaaamiadaaaabmajaaaaneajaaaaebgpgodjjaadaaaajaadaaaaaaacpppp
eaadaaaafaaaaaaaadaacmaaaaaafaaaaaaafaaaacaaceaaaaaafaaaabaaaaaa
aaababaaaaaaabaaabaaaaaaaaaaaaaaaaaaahaaafaaabaaaaaaaaaaabaaaaaa
abaaagaaaaaaaaaaaaacppppfbaaaaafahaaapkaaaaaaaaaaaaaiadpaaaaaaaa
aaaaaaaabpaaaaacaaaaaaiaaaaaaplabpaaaaacaaaaaaiaabaachlabpaaaaac
aaaaaaiaacaachlabpaaaaacaaaaaaiaadaaaplabpaaaaacaaaaaajaaaaiapka
bpaaaaacaaaaaajaabaiapkaagaaaaacaaaaaiiaadaapplaafaaaaadaaaaadia
aaaappiaadaaoelaecaaaaadabaaapiaaaaaoelaabaioekaecaaaaadaaaacpia
aaaaoeiaaaaioekaacaaaaadacaaabiaaaaapplbaeaaaakaacaaaaadacaaacia
aaaakklbaeaakkkafkaaaaaeaaaaaciaacaaoeiaacaaoeiaahaaaakaahaaaaac
aaaaaciaaaaaffiaagaaaaacaaaaaciaaaaaffiaacaaaaadaaaaaciaaaaaffib
acaaaakaalaaaaadacaaabiaaaaaffiaahaaaakaakaaaaadaaaaaciaacaaaaka
acaaaaiaagaaaaacaaaaaeiaacaaffkaafaaaaadaaaaaciaaaaaffiaaaaakkia
acaaaaadacaaabiaaaaapplbadaaaakaacaaaaadacaaaciaaaaakklbadaakkka
fkaaaaaeaaaaaiiaacaaoeiaacaaoeiaahaaaakaahaaaaacaaaaaiiaaaaappia
agaaaaacaaaaaiiaaaaappiaacaaaaadaaaaaiiaaaaappibacaaaakaalaaaaad
acaaabiaaaaappiaahaaaakaakaaaaadaaaaaiiaacaaaakaacaaaaiaafaaaaad
aaaaaiiaaaaappiaaaaakkiaafaaaaadabaacpiaabaaoeiaabaaoekaagaaaaac
acaaabiaacaaaakaaeaaaaaeaaaaaiiaaaaappiaacaaaaiaabaappiaaeaaaaae
abaaaiiaaaaaffiaacaaaaiaaaaappiaacaaaaadadaaabiaaaaapplbafaaaaka
acaaaaadadaaaciaaaaakklbafaakkkafkaaaaaeaaaaaciaadaaoeiaadaaoeia
ahaaaakaahaaaaacaaaaaciaaaaaffiaagaaaaacaaaaaciaaaaaffiaacaaaaad
aaaaaciaaaaaffibacaaaakaalaaaaadacaaaciaaaaaffiaahaaaakaakaaaaad
aaaaaciaacaaaakaacaaffiaafaaaaadaaaaaciaaaaaffiaaaaakkiaaeaaaaae
abaaaiiaaaaaffiaacaaaaiaabaappiaacaaaaadacaaciiaabaappibahaaffka
aiaaaaadabaaciiaabaaoelaagaaoekaafaaaaadaaaacbiaaaaaaaiaabaappia
fiaaaaaeabaaciiaabaappiaaaaaaaiaahaaaakaacaaaaadabaaciiaabaappia
abaappiaafaaaaadaaaachiaabaaoeiaaaaaoekaafaaaaadabaachiaabaaoeia
acaaoelaaeaaaaaeacaachiaaaaaoeiaabaappiaabaaoeiaabaaaaacaaaicpia
acaaoeiappppaaaafdeieefcemafaaaaeaaaaaaafdabaaaafjaaaaaeegiocaaa
aaaaaaaaamaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
mcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaa
gcbaaaadlcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaa
aaaaaaajdcaabaaaaaaaaaaaogbkbaiaebaaaaaaabaaaaaaigiacaaaaaaaaaaa
akaaaaaaapaaaaahbcaabaaaaaaaaaaaegaabaaaaaaaaaaaegaabaaaaaaaaaaa
elaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaajbcaabaaaaaaaaaaa
akaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaadeaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaaddaaaaaibcaabaaaaaaaaaaa
akaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaaaoaaaaalccaabaaaaaaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpbkiacaaaaaaaaaaaaiaaaaaa
diaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaaaaaaaaaj
mcaabaaaaaaaaaaakgbobaiaebaaaaaaabaaaaaaagiicaaaaaaaaaaaajaaaaaa
apaaaaahecaabaaaaaaaaaaaogakbaaaaaaaaaaaogakbaaaaaaaaaaaelaaaaaf
ecaabaaaaaaaaaaackaabaaaaaaaaaaaaaaaaaajecaabaaaaaaaaaaackaabaia
ebaaaaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaadeaaaaahecaabaaaaaaaaaaa
ckaabaaaaaaaaaaaabeaaaaaaaaaaaaaddaaaaaiecaabaaaaaaaaaaackaabaaa
aaaaaaaaakiacaaaaaaaaaaaaiaaaaaadiaaaaahecaabaaaaaaaaaaackaabaaa
aaaaaaaabkaabaaaaaaaaaaaaoaaaaaifcaabaaaaaaaaaaaagacbaaaaaaaaaaa
agiacaaaaaaaaaaaaiaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaabaaaaaadcaaaaakecaabaaaaaaaaaaadkaabaaa
abaaaaaadkiacaaaaaaaaaaaahaaaaaackaabaaaaaaaaaaadiaaaaaihcaabaaa
abaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaaaaaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaackaabaaaaaaaaaaaaaaaaaajmcaabaaaaaaaaaaa
kgbobaiaebaaaaaaabaaaaaaagiicaaaaaaaaaaaalaaaaaaapaaaaahecaabaaa
aaaaaaaaogakbaaaaaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaaaaaaaaaa
ckaabaaaaaaaaaaaaaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaa
akiacaaaaaaaaaaaaiaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaa
abeaaaaaaaaaaaaaddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaa
aaaaaaaaaiaaaaaadiaaaaahccaabaaaaaaaaaaackaabaaaaaaaaaaabkaabaaa
aaaaaaaaaoaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaaaaaaaaa
aiaaaaaaaaaaaaahbcaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaa
aaaaaaaiiccabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadp
aoaaaaahdcaabaaaaaaaaaaaegbabaaaaeaaaaaapgbpbaaaaeaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaa
baaaaaaiccaabaaaaaaaaaaaegbcbaaaacaaaaaaegiccaaaabaaaaaaaaaaaaaa
deaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaaabeaaaaaaaaaaaaaapaaaaah
bcaabaaaaaaaaaaafgafbaaaaaaaaaaaagaabaaaaaaaaaaadiaaaaaiocaabaaa
aaaaaaaaagajbaaaabaaaaaaagijcaaaaaaaaaaaabaaaaaadiaaaaahhcaabaaa
abaaaaaaegacbaaaabaaaaaaegbcbaaaadaaaaaadcaaaaajhccabaaaaaaaaaaa
jgahbaaaaaaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadoaaaaabejfdeheo
laaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaa
apaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaakeaaaaaa
abaaaaaaaaaaaaaaadaaaaaaabaaaaaaamamaaaakeaaaaaaacaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahahaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahahaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapalaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_Color]
Float 1 [_FogRadius]
Float 2 [_FogMaxRadius]
Vector 3 [_Player1_Pos]
Vector 4 [_Player2_Pos]
Vector 5 [_Player3_Pos]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
SetTexture 2 [unity_Lightmap] 2D
"!!ARBfp1.0
# 45 ALU, 3 TEX
PARAM c[7] = { program.local[0..5],
		{ 1, 0, 8, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R2, fragment.texcoord[2], texture[2], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TXP R3.x, fragment.texcoord[3], texture[1], 2D;
MUL R1.xyz, R2.w, R2;
MUL R2.xyz, R2, R3.x;
ADD R3.zw, -fragment.texcoord[1].xyxy, c[3].xyxz;
MUL R3.zw, R3, R3;
ADD R1.w, R3.z, R3;
RSQ R1.w, R1.w;
RCP R1.w, R1.w;
ADD R1.w, -R1, c[1].x;
MUL R0, R0, c[0];
MUL R1.xyz, R1, c[6].z;
MUL R2.xyz, R2, c[6].w;
MIN R2.xyz, R1, R2;
MUL R1.xyz, R1, R3.x;
MAX R1.xyz, R2, R1;
MIN R1.w, R1, c[1].x;
MAX R2.x, R1.w, c[6].y;
RCP R1.w, c[2].x;
ADD R2.zw, -fragment.texcoord[1].xyxy, c[5].xyxz;
MUL R2.x, R1.w, R2;
RCP R3.x, c[1].x;
MAD R0.w, R2.x, R3.x, R0;
ADD R2.xy, -fragment.texcoord[1], c[4].xzzw;
MUL R2.xy, R2, R2;
ADD R2.y, R2.x, R2;
MUL R2.zw, R2, R2;
ADD R2.x, R2.z, R2.w;
RSQ R2.y, R2.y;
RSQ R2.x, R2.x;
RCP R2.y, R2.y;
RCP R2.x, R2.x;
ADD R2.y, -R2, c[1].x;
ADD R2.x, -R2, c[1];
MIN R2.y, R2, c[1].x;
MIN R2.x, R2, c[1];
MAX R2.y, R2, c[6];
MUL R2.y, R2, R1.w;
MAX R2.x, R2, c[6].y;
MAD R0.w, R2.y, R3.x, R0;
MUL R1.w, R2.x, R1;
MAD R0.w, R1, R3.x, R0;
MUL result.color.xyz, R0, R1;
ADD result.color.w, -R0, c[6].x;
END
# 45 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_Color]
Float 1 [_FogRadius]
Float 2 [_FogMaxRadius]
Vector 3 [_Player1_Pos]
Vector 4 [_Player2_Pos]
Vector 5 [_Player3_Pos]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
SetTexture 2 [unity_Lightmap] 2D
"ps_2_0
; 49 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c6, 0.00000000, 1.00000000, 8.00000000, 2.00000000
dcl t0.xy
dcl t1.xy
dcl t2.xy
dcl t3
texldp r1, t3, s1
texld r0, t0, s0
texld r2, t2, s2
mul r0, r0, c0
mul_pp r3.xyz, r2, r1.x
mul_pp r2.xyz, r2.w, r2
mul_pp r2.xyz, r2, c6.z
mul_pp r3.xyz, r3, c6.w
min_pp r3.xyz, r2, r3
mul_pp r1.xyz, r2, r1.x
max_pp r1.xyz, r3, r1
rcp r3.x, c2.x
mov r4.y, c3.z
mov r4.x, c3
add r4.xy, -t1, r4
mul r4.xy, r4, r4
add r4.x, r4, r4.y
rsq r4.x, r4.x
rcp r2.x, r4.x
add r2.x, -r2, c1
min r2.x, r2, c1
max r2.x, r2, c6
rcp r4.x, c1.x
mul r2.x, r3, r2
mad r2.x, r2, r4, r0.w
mov r5.y, c4.z
mov r5.x, c4
add r5.xy, -t1, r5
mul r5.xy, r5, r5
add r5.x, r5, r5.y
rsq r5.x, r5.x
rcp r5.x, r5.x
add r5.x, -r5, c1
min r5.x, r5, c1
max r5.x, r5, c6
mul r5.x, r5, r3
mov r6.y, c5.z
mov r6.x, c5
add r6.xy, -t1, r6
mul r6.xy, r6, r6
add r6.x, r6, r6.y
rsq r6.x, r6.x
rcp r6.x, r6.x
add r6.x, -r6, c1
min r6.x, r6, c1
max r6.x, r6, c6
mad r2.x, r5, r4, r2
mul r3.x, r6, r3
mad r2.x, r3, r4, r2
mul_pp r0.xyz, r0, r1
add r0.w, -r2.x, c6.y
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
ConstBuffer "$Globals" 224 // 192 used size, 12 vars
Vector 112 [_Color] 4
Float 128 [_FogRadius]
Float 132 [_FogMaxRadius]
Vector 144 [_Player1_Pos] 4
Vector 160 [_Player2_Pos] 4
Vector 176 [_Player3_Pos] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_ShadowMapTexture] 2D 0
SetTexture 2 [unity_Lightmap] 2D 2
// 42 instructions, 3 temp regs, 0 temp arrays:
// ALU 38 float, 0 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedgkmnpmlkggehngppnnmhnifgejhjppkhabaaaaaakaagaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcjiafaaaaeaaaaaaaggabaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadmcbabaaaabaaaaaagcbaaaaddcbabaaaacaaaaaagcbaaaadlcbabaaa
adaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaajdcaabaaa
aaaaaaaaogbkbaiaebaaaaaaabaaaaaaigiacaaaaaaaaaaaakaaaaaaapaaaaah
bcaabaaaaaaaaaaaegaabaaaaaaaaaaaegaabaaaaaaaaaaaelaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaaaaaaaajbcaabaaaaaaaaaaaakaabaiaebaaaaaa
aaaaaaaaakiacaaaaaaaaaaaaiaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaabeaaaaaaaaaaaaaddaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaa
akiacaaaaaaaaaaaaiaaaaaaaoaaaaalccaabaaaaaaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpbkiacaaaaaaaaaaaaiaaaaaadiaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaaaaaaaaajmcaabaaaaaaaaaaa
kgbobaiaebaaaaaaabaaaaaaagiicaaaaaaaaaaaajaaaaaaapaaaaahecaabaaa
aaaaaaaaogakbaaaaaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaaaaaaaaaa
ckaabaaaaaaaaaaaaaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaa
akiacaaaaaaaaaaaaiaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaa
abeaaaaaaaaaaaaaddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaa
aaaaaaaaaiaaaaaadiaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaabkaabaaa
aaaaaaaaaoaaaaaifcaabaaaaaaaaaaaagacbaaaaaaaaaaaagiacaaaaaaaaaaa
aiaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaabaaaaaadcaaaaakecaabaaaaaaaaaaadkaabaaaabaaaaaadkiacaaa
aaaaaaaaahaaaaaackaabaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaa
abaaaaaaegiccaaaaaaaaaaaahaaaaaaaaaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaackaabaaaaaaaaaaaaaaaaaajmcaabaaaaaaaaaaakgbobaiaebaaaaaa
abaaaaaaagiicaaaaaaaaaaaalaaaaaaapaaaaahecaabaaaaaaaaaaaogakbaaa
aaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaaaaaaaaaackaabaaaaaaaaaaa
aaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaa
aiaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaaaa
ddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaa
diaaaaahccaabaaaaaaaaaaackaabaaaaaaaaaaabkaabaaaaaaaaaaaaoaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaaaaaaaaah
bcaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaaiiccabaaa
aaaaaaaaakaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpaoaaaaahdcaabaaa
aaaaaaaaegbabaaaadaaaaaapgbpbaaaadaaaaaaefaaaaajpcaabaaaaaaaaaaa
egaabaaaaaaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaaaaaaaaahccaabaaa
aaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaaacaaaaaa
egbabaaaacaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaahocaabaaa
aaaaaaaafgafbaaaaaaaaaaaagajbaaaacaaaaaadiaaaaahicaabaaaabaaaaaa
dkaabaaaacaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaapgapbaaaabaaaaaaddaaaaahocaabaaaaaaaaaaafgaobaaaaaaaaaaa
agajbaaaacaaaaaadiaaaaahhcaabaaaacaaaaaaagaabaaaaaaaaaaaegacbaaa
acaaaaaadeaaaaahhcaabaaaaaaaaaaajgahbaaaaaaaaaaaegacbaaaacaaaaaa
diaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_Color]
Float 1 [_FogRadius]
Float 2 [_FogMaxRadius]
Vector 3 [_Player1_Pos]
Vector 4 [_Player2_Pos]
Vector 5 [_Player3_Pos]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
SetTexture 2 [unity_Lightmap] 2D
"agal_ps
c6 0.0 1.0 8.0 2.0
[bc]
aeaaaaaaaaaaapacadaaaaoeaeaaaaaaadaaaappaeaaaaaa div r0, v3, v3.w
ciaaaaaaabaaapacaaaaaafeacaaaaaaabaaaaaaafaababb tex r1, r0.xyyy, s1 <2d wrap linear point>
ciaaaaaaaaaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r0, v0, s0 <2d wrap linear point>
ciaaaaaaacaaapacacaaaaoeaeaaaaaaacaaaaaaafaababb tex r2, v2, s2 <2d wrap linear point>
adaaaaaaaaaaapacaaaaaaoeacaaaaaaaaaaaaoeabaaaaaa mul r0, r0, c0
adaaaaaaadaaahacacaaaakeacaaaaaaabaaaaaaacaaaaaa mul r3.xyz, r2.xyzz, r1.x
adaaaaaaacaaahacacaaaappacaaaaaaacaaaakeacaaaaaa mul r2.xyz, r2.w, r2.xyzz
adaaaaaaacaaahacacaaaakeacaaaaaaagaaaakkabaaaaaa mul r2.xyz, r2.xyzz, c6.z
adaaaaaaadaaahacadaaaakeacaaaaaaagaaaappabaaaaaa mul r3.xyz, r3.xyzz, c6.w
agaaaaaaadaaahacacaaaakeacaaaaaaadaaaakeacaaaaaa min r3.xyz, r2.xyzz, r3.xyzz
adaaaaaaabaaahacacaaaakeacaaaaaaabaaaaaaacaaaaaa mul r1.xyz, r2.xyzz, r1.x
ahaaaaaaabaaahacadaaaakeacaaaaaaabaaaakeacaaaaaa max r1.xyz, r3.xyzz, r1.xyzz
aaaaaaaaadaaaiacacaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r3.w, c2
afaaaaaaadaaabacadaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r3.x, r3.w
aaaaaaaaaeaaacacadaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r4.y, c3.z
aaaaaaaaaeaaabacadaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r4.x, c3
bfaaaaaaaeaaamacabaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa neg r4.zw, v1
abaaaaaaaeaaadacaeaaaapoacaaaaaaaeaaaafeacaaaaaa add r4.xy, r4.zwww, r4.xyyy
adaaaaaaaeaaadacaeaaaafeacaaaaaaaeaaaafeacaaaaaa mul r4.xy, r4.xyyy, r4.xyyy
abaaaaaaaeaaabacaeaaaaaaacaaaaaaaeaaaaffacaaaaaa add r4.x, r4.x, r4.y
akaaaaaaaeaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r4.x, r4.x
afaaaaaaacaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r2.x, r4.x
bfaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r2.x, r2.x
abaaaaaaacaaabacacaaaaaaacaaaaaaabaaaaoeabaaaaaa add r2.x, r2.x, c1
agaaaaaaacaaabacacaaaaaaacaaaaaaabaaaaoeabaaaaaa min r2.x, r2.x, c1
ahaaaaaaacaaabacacaaaaaaacaaaaaaagaaaaoeabaaaaaa max r2.x, r2.x, c6
aaaaaaaaafaaapacabaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r5, c1
afaaaaaaaeaaabacafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r4.x, r5.x
adaaaaaaacaaabacadaaaaaaacaaaaaaacaaaaaaacaaaaaa mul r2.x, r3.x, r2.x
adaaaaaaacaaabacacaaaaaaacaaaaaaaeaaaaaaacaaaaaa mul r2.x, r2.x, r4.x
abaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaappacaaaaaa add r2.x, r2.x, r0.w
aaaaaaaaafaaacacaeaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r5.y, c4.z
aaaaaaaaafaaabacaeaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r5.x, c4
bfaaaaaaafaaamacabaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa neg r5.zw, v1
abaaaaaaafaaadacafaaaapoacaaaaaaafaaaafeacaaaaaa add r5.xy, r5.zwww, r5.xyyy
adaaaaaaafaaadacafaaaafeacaaaaaaafaaaafeacaaaaaa mul r5.xy, r5.xyyy, r5.xyyy
abaaaaaaafaaabacafaaaaaaacaaaaaaafaaaaffacaaaaaa add r5.x, r5.x, r5.y
akaaaaaaafaaabacafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r5.x, r5.x
afaaaaaaafaaabacafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r5.x, r5.x
bfaaaaaaafaaabacafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r5.x, r5.x
abaaaaaaafaaabacafaaaaaaacaaaaaaabaaaaoeabaaaaaa add r5.x, r5.x, c1
agaaaaaaafaaabacafaaaaaaacaaaaaaabaaaaoeabaaaaaa min r5.x, r5.x, c1
ahaaaaaaafaaabacafaaaaaaacaaaaaaagaaaaoeabaaaaaa max r5.x, r5.x, c6
adaaaaaaafaaabacafaaaaaaacaaaaaaadaaaaaaacaaaaaa mul r5.x, r5.x, r3.x
aaaaaaaaagaaacacafaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r6.y, c5.z
aaaaaaaaagaaabacafaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r6.x, c5
bfaaaaaaagaaamacabaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa neg r6.zw, v1
abaaaaaaagaaadacagaaaapoacaaaaaaagaaaafeacaaaaaa add r6.xy, r6.zwww, r6.xyyy
adaaaaaaagaaadacagaaaafeacaaaaaaagaaaafeacaaaaaa mul r6.xy, r6.xyyy, r6.xyyy
abaaaaaaagaaabacagaaaaaaacaaaaaaagaaaaffacaaaaaa add r6.x, r6.x, r6.y
akaaaaaaagaaabacagaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r6.x, r6.x
afaaaaaaagaaabacagaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r6.x, r6.x
bfaaaaaaagaaabacagaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r6.x, r6.x
abaaaaaaagaaabacagaaaaaaacaaaaaaabaaaaoeabaaaaaa add r6.x, r6.x, c1
agaaaaaaagaaabacagaaaaaaacaaaaaaabaaaaoeabaaaaaa min r6.x, r6.x, c1
ahaaaaaaagaaabacagaaaaaaacaaaaaaagaaaaoeabaaaaaa max r6.x, r6.x, c6
adaaaaaaabaaaiacafaaaaaaacaaaaaaaeaaaaaaacaaaaaa mul r1.w, r5.x, r4.x
abaaaaaaacaaabacabaaaappacaaaaaaacaaaaaaacaaaaaa add r2.x, r1.w, r2.x
adaaaaaaadaaabacagaaaaaaacaaaaaaadaaaaaaacaaaaaa mul r3.x, r6.x, r3.x
adaaaaaaadaaabacadaaaaaaacaaaaaaaeaaaaaaacaaaaaa mul r3.x, r3.x, r4.x
abaaaaaaacaaabacadaaaaaaacaaaaaaacaaaaaaacaaaaaa add r2.x, r3.x, r2.x
adaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa mul r0.xyz, r0.xyzz, r1.xyzz
bfaaaaaaabaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r1.x, r2.x
abaaaaaaaaaaaiacabaaaaaaacaaaaaaagaaaaffabaaaaaa add r0.w, r1.x, c6.y
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
ConstBuffer "$Globals" 224 // 192 used size, 12 vars
Vector 112 [_Color] 4
Float 128 [_FogRadius]
Float 132 [_FogMaxRadius]
Vector 144 [_Player1_Pos] 4
Vector 160 [_Player2_Pos] 4
Vector 176 [_Player3_Pos] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_ShadowMapTexture] 2D 0
SetTexture 2 [unity_Lightmap] 2D 2
// 42 instructions, 3 temp regs, 0 temp arrays:
// ALU 38 float, 0 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefieceddlokfoofjlaikkahbghnplcdjajhjgljabaaaaaaeaakaaaaaeaaaaaa
daaaaaaammadaaaagmajaaaaamakaaaaebgpgodjjeadaaaajeadaaaaaaacpppp
fiadaaaadmaaaaaaabaadaaaaaaadmaaaaaadmaaadaaceaaaaaadmaaabaaaaaa
aaababaaacacacaaaaaaahaaafaaaaaaaaaaaaaaaaacppppfbaaaaafafaaapka
aaaaaaaaaaaaiadpaaaaaaebaaaaaaaabpaaaaacaaaaaaiaaaaaaplabpaaaaac
aaaaaaiaabaaadlabpaaaaacaaaaaaiaacaaaplabpaaaaacaaaaaajaaaaiapka
bpaaaaacaaaaaajaabaiapkabpaaaaacaaaaaajaacaiapkaagaaaaacaaaaaiia
acaapplaafaaaaadaaaaadiaaaaappiaacaaoelaecaaaaadabaaapiaaaaaoela
abaioekaecaaaaadaaaacpiaaaaaoeiaaaaioekaecaaaaadacaacpiaabaaoela
acaioekaacaaaaadadaaabiaaaaapplbadaaaakaacaaaaadadaaaciaaaaakklb
adaakkkafkaaaaaeaaaaaciaadaaoeiaadaaoeiaafaaaakaahaaaaacaaaaacia
aaaaffiaagaaaaacaaaaaciaaaaaffiaacaaaaadaaaaaciaaaaaffibabaaaaka
alaaaaadadaaabiaaaaaffiaafaaaakaakaaaaadaaaaaciaabaaaakaadaaaaia
agaaaaacaaaaaeiaabaaffkaafaaaaadaaaaaciaaaaaffiaaaaakkiaacaaaaad
adaaabiaaaaapplbacaaaakaacaaaaadadaaaciaaaaakklbacaakkkafkaaaaae
aaaaaiiaadaaoeiaadaaoeiaafaaaakaahaaaaacaaaaaiiaaaaappiaagaaaaac
aaaaaiiaaaaappiaacaaaaadaaaaaiiaaaaappibabaaaakaalaaaaadadaaabia
aaaappiaafaaaakaakaaaaadaaaaaiiaabaaaakaadaaaaiaafaaaaadaaaaaiia
aaaappiaaaaakkiaafaaaaadabaacpiaabaaoeiaaaaaoekaagaaaaacadaaabia
abaaaakaaeaaaaaeaaaaaiiaaaaappiaadaaaaiaabaappiaaeaaaaaeabaaaiia
aaaaffiaadaaaaiaaaaappiaacaaaaadaeaaabiaaaaapplbaeaaaakaacaaaaad
aeaaaciaaaaakklbaeaakkkafkaaaaaeaaaaaciaaeaaoeiaaeaaoeiaafaaaaka
ahaaaaacaaaaaciaaaaaffiaagaaaaacaaaaaciaaaaaffiaacaaaaadaaaaacia
aaaaffibabaaaakaalaaaaadadaaaciaaaaaffiaafaaaakaakaaaaadaaaaacia
abaaaakaadaaffiaafaaaaadaaaaaciaaaaaffiaaaaakkiaaeaaaaaeabaaaiia
aaaaffiaadaaaaiaabaappiaacaaaaadadaaciiaabaappibafaaffkaacaaaaad
abaaciiaaaaaaaiaaaaaaaiaafaaaaadaaaacoiaacaabliaabaappiaafaaaaad
abaaciiaacaappiaafaakkkaafaaaaadacaachiaacaaoeiaabaappiaakaaaaad
aeaachiaaaaabliaacaaoeiaafaaaaadaaaachiaaaaaaaiaacaaoeiaalaaaaad
acaachiaaeaaoeiaaaaaoeiaafaaaaadadaachiaabaaoeiaacaaoeiaabaaaaac
aaaicpiaadaaoeiappppaaaafdeieefcjiafaaaaeaaaaaaaggabaaaafjaaaaae
egiocaaaaaaaaaaaamaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaa
abaaaaaafkaaaaadaagabaaaacaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
gcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaaddcbabaaa
acaaaaaagcbaaaadlcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
adaaaaaaaaaaaaajdcaabaaaaaaaaaaaogbkbaiaebaaaaaaabaaaaaaigiacaaa
aaaaaaaaakaaaaaaapaaaaahbcaabaaaaaaaaaaaegaabaaaaaaaaaaaegaabaaa
aaaaaaaaelaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaajbcaabaaa
aaaaaaaaakaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaadeaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaaddaaaaaibcaabaaa
aaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaaaoaaaaalccaabaaa
aaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpbkiacaaaaaaaaaaa
aiaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaa
aaaaaaajmcaabaaaaaaaaaaakgbobaiaebaaaaaaabaaaaaaagiicaaaaaaaaaaa
ajaaaaaaapaaaaahecaabaaaaaaaaaaaogakbaaaaaaaaaaaogakbaaaaaaaaaaa
elaaaaafecaabaaaaaaaaaaackaabaaaaaaaaaaaaaaaaaajecaabaaaaaaaaaaa
ckaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaadeaaaaahecaabaaa
aaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaaaaddaaaaaiecaabaaaaaaaaaaa
ckaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaadiaaaaahecaabaaaaaaaaaaa
ckaabaaaaaaaaaaabkaabaaaaaaaaaaaaoaaaaaifcaabaaaaaaaaaaaagacbaaa
aaaaaaaaagiacaaaaaaaaaaaaiaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadcaaaaakecaabaaaaaaaaaaa
dkaabaaaabaaaaaadkiacaaaaaaaaaaaahaaaaaackaabaaaaaaaaaaadiaaaaai
hcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaaaaaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaackaabaaaaaaaaaaaaaaaaaajmcaabaaa
aaaaaaaakgbobaiaebaaaaaaabaaaaaaagiicaaaaaaaaaaaalaaaaaaapaaaaah
ecaabaaaaaaaaaaaogakbaaaaaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaa
aaaaaaaackaabaaaaaaaaaaaaaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaa
aaaaaaaaakiacaaaaaaaaaaaaiaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaa
aaaaaaaaabeaaaaaaaaaaaaaddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaa
akiacaaaaaaaaaaaaiaaaaaadiaaaaahccaabaaaaaaaaaaackaabaaaaaaaaaaa
bkaabaaaaaaaaaaaaoaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaa
aaaaaaaaaiaaaaaaaaaaaaahbcaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaa
aaaaaaaaaaaaaaaiiccabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaaabeaaaaa
aaaaiadpaoaaaaahdcaabaaaaaaaaaaaegbabaaaadaaaaaapgbpbaaaadaaaaaa
efaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaabaaaaaaaagabaaa
aaaaaaaaaaaaaaahccaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaa
efaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaaacaaaaaaaagabaaa
acaaaaaadiaaaaahocaabaaaaaaaaaaafgafbaaaaaaaaaaaagajbaaaacaaaaaa
diaaaaahicaabaaaabaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdiaaaaah
hcaabaaaacaaaaaaegacbaaaacaaaaaapgapbaaaabaaaaaaddaaaaahocaabaaa
aaaaaaaafgaobaaaaaaaaaaaagajbaaaacaaaaaadiaaaaahhcaabaaaacaaaaaa
agaabaaaaaaaaaaaegacbaaaacaaaaaadeaaaaahhcaabaaaaaaaaaaajgahbaaa
aaaaaaaaegacbaaaacaaaaaadiaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadoaaaaabejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Vector 0 [_Color]
Float 1 [_FogRadius]
Float 2 [_FogMaxRadius]
Vector 3 [_Player1_Pos]
Vector 4 [_Player2_Pos]
Vector 5 [_Player3_Pos]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
SetTexture 2 [unity_Lightmap] 2D
"!!ARBfp1.0
# 45 ALU, 3 TEX
PARAM c[7] = { program.local[0..5],
		{ 1, 0, 8, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R2, fragment.texcoord[2], texture[2], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TXP R3.x, fragment.texcoord[3], texture[1], 2D;
MUL R1.xyz, R2.w, R2;
MUL R2.xyz, R2, R3.x;
ADD R3.zw, -fragment.texcoord[1].xyxy, c[3].xyxz;
MUL R3.zw, R3, R3;
ADD R1.w, R3.z, R3;
RSQ R1.w, R1.w;
RCP R1.w, R1.w;
ADD R1.w, -R1, c[1].x;
MUL R0, R0, c[0];
MUL R1.xyz, R1, c[6].z;
MUL R2.xyz, R2, c[6].w;
MIN R2.xyz, R1, R2;
MUL R1.xyz, R1, R3.x;
MAX R1.xyz, R2, R1;
MIN R1.w, R1, c[1].x;
MAX R2.x, R1.w, c[6].y;
RCP R1.w, c[2].x;
ADD R2.zw, -fragment.texcoord[1].xyxy, c[5].xyxz;
MUL R2.x, R1.w, R2;
RCP R3.x, c[1].x;
MAD R0.w, R2.x, R3.x, R0;
ADD R2.xy, -fragment.texcoord[1], c[4].xzzw;
MUL R2.xy, R2, R2;
ADD R2.y, R2.x, R2;
MUL R2.zw, R2, R2;
ADD R2.x, R2.z, R2.w;
RSQ R2.y, R2.y;
RSQ R2.x, R2.x;
RCP R2.y, R2.y;
RCP R2.x, R2.x;
ADD R2.y, -R2, c[1].x;
ADD R2.x, -R2, c[1];
MIN R2.y, R2, c[1].x;
MIN R2.x, R2, c[1];
MAX R2.y, R2, c[6];
MUL R2.y, R2, R1.w;
MAX R2.x, R2, c[6].y;
MAD R0.w, R2.y, R3.x, R0;
MUL R1.w, R2.x, R1;
MAD R0.w, R1, R3.x, R0;
MUL result.color.xyz, R0, R1;
ADD result.color.w, -R0, c[6].x;
END
# 45 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Vector 0 [_Color]
Float 1 [_FogRadius]
Float 2 [_FogMaxRadius]
Vector 3 [_Player1_Pos]
Vector 4 [_Player2_Pos]
Vector 5 [_Player3_Pos]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
SetTexture 2 [unity_Lightmap] 2D
"ps_2_0
; 49 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c6, 0.00000000, 1.00000000, 8.00000000, 2.00000000
dcl t0.xy
dcl t1.xy
dcl t2.xy
dcl t3
texldp r1, t3, s1
texld r0, t0, s0
texld r2, t2, s2
mul r0, r0, c0
mul_pp r3.xyz, r2, r1.x
mul_pp r2.xyz, r2.w, r2
mul_pp r2.xyz, r2, c6.z
mul_pp r3.xyz, r3, c6.w
min_pp r3.xyz, r2, r3
mul_pp r1.xyz, r2, r1.x
max_pp r1.xyz, r3, r1
rcp r3.x, c2.x
mov r4.y, c3.z
mov r4.x, c3
add r4.xy, -t1, r4
mul r4.xy, r4, r4
add r4.x, r4, r4.y
rsq r4.x, r4.x
rcp r2.x, r4.x
add r2.x, -r2, c1
min r2.x, r2, c1
max r2.x, r2, c6
rcp r4.x, c1.x
mul r2.x, r3, r2
mad r2.x, r2, r4, r0.w
mov r5.y, c4.z
mov r5.x, c4
add r5.xy, -t1, r5
mul r5.xy, r5, r5
add r5.x, r5, r5.y
rsq r5.x, r5.x
rcp r5.x, r5.x
add r5.x, -r5, c1
min r5.x, r5, c1
max r5.x, r5, c6
mul r5.x, r5, r3
mov r6.y, c5.z
mov r6.x, c5
add r6.xy, -t1, r6
mul r6.xy, r6, r6
add r6.x, r6, r6.y
rsq r6.x, r6.x
rcp r6.x, r6.x
add r6.x, -r6, c1
min r6.x, r6, c1
max r6.x, r6, c6
mad r2.x, r5, r4, r2
mul r3.x, r6, r3
mad r2.x, r3, r4, r2
mul_pp r0.xyz, r0, r1
add r0.w, -r2.x, c6.y
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
ConstBuffer "$Globals" 224 // 192 used size, 12 vars
Vector 112 [_Color] 4
Float 128 [_FogRadius]
Float 132 [_FogMaxRadius]
Vector 144 [_Player1_Pos] 4
Vector 160 [_Player2_Pos] 4
Vector 176 [_Player3_Pos] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_ShadowMapTexture] 2D 0
SetTexture 2 [unity_Lightmap] 2D 2
// 42 instructions, 3 temp regs, 0 temp arrays:
// ALU 38 float, 0 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedgkmnpmlkggehngppnnmhnifgejhjppkhabaaaaaakaagaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcjiafaaaaeaaaaaaaggabaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadmcbabaaaabaaaaaagcbaaaaddcbabaaaacaaaaaagcbaaaadlcbabaaa
adaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaajdcaabaaa
aaaaaaaaogbkbaiaebaaaaaaabaaaaaaigiacaaaaaaaaaaaakaaaaaaapaaaaah
bcaabaaaaaaaaaaaegaabaaaaaaaaaaaegaabaaaaaaaaaaaelaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaaaaaaaajbcaabaaaaaaaaaaaakaabaiaebaaaaaa
aaaaaaaaakiacaaaaaaaaaaaaiaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaabeaaaaaaaaaaaaaddaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaa
akiacaaaaaaaaaaaaiaaaaaaaoaaaaalccaabaaaaaaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpbkiacaaaaaaaaaaaaiaaaaaadiaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaaaaaaaaajmcaabaaaaaaaaaaa
kgbobaiaebaaaaaaabaaaaaaagiicaaaaaaaaaaaajaaaaaaapaaaaahecaabaaa
aaaaaaaaogakbaaaaaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaaaaaaaaaa
ckaabaaaaaaaaaaaaaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaa
akiacaaaaaaaaaaaaiaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaa
abeaaaaaaaaaaaaaddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaa
aaaaaaaaaiaaaaaadiaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaabkaabaaa
aaaaaaaaaoaaaaaifcaabaaaaaaaaaaaagacbaaaaaaaaaaaagiacaaaaaaaaaaa
aiaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaabaaaaaadcaaaaakecaabaaaaaaaaaaadkaabaaaabaaaaaadkiacaaa
aaaaaaaaahaaaaaackaabaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaa
abaaaaaaegiccaaaaaaaaaaaahaaaaaaaaaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaackaabaaaaaaaaaaaaaaaaaajmcaabaaaaaaaaaaakgbobaiaebaaaaaa
abaaaaaaagiicaaaaaaaaaaaalaaaaaaapaaaaahecaabaaaaaaaaaaaogakbaaa
aaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaaaaaaaaaackaabaaaaaaaaaaa
aaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaa
aiaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaaaa
ddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaa
diaaaaahccaabaaaaaaaaaaackaabaaaaaaaaaaabkaabaaaaaaaaaaaaoaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaaaaaaaaah
bcaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaaiiccabaaa
aaaaaaaaakaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpaoaaaaahdcaabaaa
aaaaaaaaegbabaaaadaaaaaapgbpbaaaadaaaaaaefaaaaajpcaabaaaaaaaaaaa
egaabaaaaaaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaaaaaaaaahccaabaaa
aaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaaacaaaaaa
egbabaaaacaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaahocaabaaa
aaaaaaaafgafbaaaaaaaaaaaagajbaaaacaaaaaadiaaaaahicaabaaaabaaaaaa
dkaabaaaacaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaapgapbaaaabaaaaaaddaaaaahocaabaaaaaaaaaaafgaobaaaaaaaaaaa
agajbaaaacaaaaaadiaaaaahhcaabaaaacaaaaaaagaabaaaaaaaaaaaegacbaaa
acaaaaaadeaaaaahhcaabaaaaaaaaaaajgahbaaaaaaaaaaaegacbaaaacaaaaaa
diaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Vector 0 [_Color]
Float 1 [_FogRadius]
Float 2 [_FogMaxRadius]
Vector 3 [_Player1_Pos]
Vector 4 [_Player2_Pos]
Vector 5 [_Player3_Pos]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
SetTexture 2 [unity_Lightmap] 2D
"agal_ps
c6 0.0 1.0 8.0 2.0
[bc]
aeaaaaaaaaaaapacadaaaaoeaeaaaaaaadaaaappaeaaaaaa div r0, v3, v3.w
ciaaaaaaabaaapacaaaaaafeacaaaaaaabaaaaaaafaababb tex r1, r0.xyyy, s1 <2d wrap linear point>
ciaaaaaaaaaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r0, v0, s0 <2d wrap linear point>
ciaaaaaaacaaapacacaaaaoeaeaaaaaaacaaaaaaafaababb tex r2, v2, s2 <2d wrap linear point>
adaaaaaaaaaaapacaaaaaaoeacaaaaaaaaaaaaoeabaaaaaa mul r0, r0, c0
adaaaaaaadaaahacacaaaakeacaaaaaaabaaaaaaacaaaaaa mul r3.xyz, r2.xyzz, r1.x
adaaaaaaacaaahacacaaaappacaaaaaaacaaaakeacaaaaaa mul r2.xyz, r2.w, r2.xyzz
adaaaaaaacaaahacacaaaakeacaaaaaaagaaaakkabaaaaaa mul r2.xyz, r2.xyzz, c6.z
adaaaaaaadaaahacadaaaakeacaaaaaaagaaaappabaaaaaa mul r3.xyz, r3.xyzz, c6.w
agaaaaaaadaaahacacaaaakeacaaaaaaadaaaakeacaaaaaa min r3.xyz, r2.xyzz, r3.xyzz
adaaaaaaabaaahacacaaaakeacaaaaaaabaaaaaaacaaaaaa mul r1.xyz, r2.xyzz, r1.x
ahaaaaaaabaaahacadaaaakeacaaaaaaabaaaakeacaaaaaa max r1.xyz, r3.xyzz, r1.xyzz
aaaaaaaaadaaaiacacaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r3.w, c2
afaaaaaaadaaabacadaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r3.x, r3.w
aaaaaaaaaeaaacacadaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r4.y, c3.z
aaaaaaaaaeaaabacadaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r4.x, c3
bfaaaaaaaeaaamacabaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa neg r4.zw, v1
abaaaaaaaeaaadacaeaaaapoacaaaaaaaeaaaafeacaaaaaa add r4.xy, r4.zwww, r4.xyyy
adaaaaaaaeaaadacaeaaaafeacaaaaaaaeaaaafeacaaaaaa mul r4.xy, r4.xyyy, r4.xyyy
abaaaaaaaeaaabacaeaaaaaaacaaaaaaaeaaaaffacaaaaaa add r4.x, r4.x, r4.y
akaaaaaaaeaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r4.x, r4.x
afaaaaaaacaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r2.x, r4.x
bfaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r2.x, r2.x
abaaaaaaacaaabacacaaaaaaacaaaaaaabaaaaoeabaaaaaa add r2.x, r2.x, c1
agaaaaaaacaaabacacaaaaaaacaaaaaaabaaaaoeabaaaaaa min r2.x, r2.x, c1
ahaaaaaaacaaabacacaaaaaaacaaaaaaagaaaaoeabaaaaaa max r2.x, r2.x, c6
aaaaaaaaafaaapacabaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r5, c1
afaaaaaaaeaaabacafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r4.x, r5.x
adaaaaaaacaaabacadaaaaaaacaaaaaaacaaaaaaacaaaaaa mul r2.x, r3.x, r2.x
adaaaaaaacaaabacacaaaaaaacaaaaaaaeaaaaaaacaaaaaa mul r2.x, r2.x, r4.x
abaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaappacaaaaaa add r2.x, r2.x, r0.w
aaaaaaaaafaaacacaeaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r5.y, c4.z
aaaaaaaaafaaabacaeaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r5.x, c4
bfaaaaaaafaaamacabaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa neg r5.zw, v1
abaaaaaaafaaadacafaaaapoacaaaaaaafaaaafeacaaaaaa add r5.xy, r5.zwww, r5.xyyy
adaaaaaaafaaadacafaaaafeacaaaaaaafaaaafeacaaaaaa mul r5.xy, r5.xyyy, r5.xyyy
abaaaaaaafaaabacafaaaaaaacaaaaaaafaaaaffacaaaaaa add r5.x, r5.x, r5.y
akaaaaaaafaaabacafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r5.x, r5.x
afaaaaaaafaaabacafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r5.x, r5.x
bfaaaaaaafaaabacafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r5.x, r5.x
abaaaaaaafaaabacafaaaaaaacaaaaaaabaaaaoeabaaaaaa add r5.x, r5.x, c1
agaaaaaaafaaabacafaaaaaaacaaaaaaabaaaaoeabaaaaaa min r5.x, r5.x, c1
ahaaaaaaafaaabacafaaaaaaacaaaaaaagaaaaoeabaaaaaa max r5.x, r5.x, c6
adaaaaaaafaaabacafaaaaaaacaaaaaaadaaaaaaacaaaaaa mul r5.x, r5.x, r3.x
aaaaaaaaagaaacacafaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r6.y, c5.z
aaaaaaaaagaaabacafaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r6.x, c5
bfaaaaaaagaaamacabaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa neg r6.zw, v1
abaaaaaaagaaadacagaaaapoacaaaaaaagaaaafeacaaaaaa add r6.xy, r6.zwww, r6.xyyy
adaaaaaaagaaadacagaaaafeacaaaaaaagaaaafeacaaaaaa mul r6.xy, r6.xyyy, r6.xyyy
abaaaaaaagaaabacagaaaaaaacaaaaaaagaaaaffacaaaaaa add r6.x, r6.x, r6.y
akaaaaaaagaaabacagaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r6.x, r6.x
afaaaaaaagaaabacagaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r6.x, r6.x
bfaaaaaaagaaabacagaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r6.x, r6.x
abaaaaaaagaaabacagaaaaaaacaaaaaaabaaaaoeabaaaaaa add r6.x, r6.x, c1
agaaaaaaagaaabacagaaaaaaacaaaaaaabaaaaoeabaaaaaa min r6.x, r6.x, c1
ahaaaaaaagaaabacagaaaaaaacaaaaaaagaaaaoeabaaaaaa max r6.x, r6.x, c6
adaaaaaaabaaaiacafaaaaaaacaaaaaaaeaaaaaaacaaaaaa mul r1.w, r5.x, r4.x
abaaaaaaacaaabacabaaaappacaaaaaaacaaaaaaacaaaaaa add r2.x, r1.w, r2.x
adaaaaaaadaaabacagaaaaaaacaaaaaaadaaaaaaacaaaaaa mul r3.x, r6.x, r3.x
adaaaaaaadaaabacadaaaaaaacaaaaaaaeaaaaaaacaaaaaa mul r3.x, r3.x, r4.x
abaaaaaaacaaabacadaaaaaaacaaaaaaacaaaaaaacaaaaaa add r2.x, r3.x, r2.x
adaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa mul r0.xyz, r0.xyzz, r1.xyzz
bfaaaaaaabaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r1.x, r2.x
abaaaaaaaaaaaiacabaaaaaaacaaaaaaagaaaaffabaaaaaa add r0.w, r1.x, c6.y
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
ConstBuffer "$Globals" 224 // 192 used size, 12 vars
Vector 112 [_Color] 4
Float 128 [_FogRadius]
Float 132 [_FogMaxRadius]
Vector 144 [_Player1_Pos] 4
Vector 160 [_Player2_Pos] 4
Vector 176 [_Player3_Pos] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_ShadowMapTexture] 2D 0
SetTexture 2 [unity_Lightmap] 2D 2
// 42 instructions, 3 temp regs, 0 temp arrays:
// ALU 38 float, 0 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefieceddlokfoofjlaikkahbghnplcdjajhjgljabaaaaaaeaakaaaaaeaaaaaa
daaaaaaammadaaaagmajaaaaamakaaaaebgpgodjjeadaaaajeadaaaaaaacpppp
fiadaaaadmaaaaaaabaadaaaaaaadmaaaaaadmaaadaaceaaaaaadmaaabaaaaaa
aaababaaacacacaaaaaaahaaafaaaaaaaaaaaaaaaaacppppfbaaaaafafaaapka
aaaaaaaaaaaaiadpaaaaaaebaaaaaaaabpaaaaacaaaaaaiaaaaaaplabpaaaaac
aaaaaaiaabaaadlabpaaaaacaaaaaaiaacaaaplabpaaaaacaaaaaajaaaaiapka
bpaaaaacaaaaaajaabaiapkabpaaaaacaaaaaajaacaiapkaagaaaaacaaaaaiia
acaapplaafaaaaadaaaaadiaaaaappiaacaaoelaecaaaaadabaaapiaaaaaoela
abaioekaecaaaaadaaaacpiaaaaaoeiaaaaioekaecaaaaadacaacpiaabaaoela
acaioekaacaaaaadadaaabiaaaaapplbadaaaakaacaaaaadadaaaciaaaaakklb
adaakkkafkaaaaaeaaaaaciaadaaoeiaadaaoeiaafaaaakaahaaaaacaaaaacia
aaaaffiaagaaaaacaaaaaciaaaaaffiaacaaaaadaaaaaciaaaaaffibabaaaaka
alaaaaadadaaabiaaaaaffiaafaaaakaakaaaaadaaaaaciaabaaaakaadaaaaia
agaaaaacaaaaaeiaabaaffkaafaaaaadaaaaaciaaaaaffiaaaaakkiaacaaaaad
adaaabiaaaaapplbacaaaakaacaaaaadadaaaciaaaaakklbacaakkkafkaaaaae
aaaaaiiaadaaoeiaadaaoeiaafaaaakaahaaaaacaaaaaiiaaaaappiaagaaaaac
aaaaaiiaaaaappiaacaaaaadaaaaaiiaaaaappibabaaaakaalaaaaadadaaabia
aaaappiaafaaaakaakaaaaadaaaaaiiaabaaaakaadaaaaiaafaaaaadaaaaaiia
aaaappiaaaaakkiaafaaaaadabaacpiaabaaoeiaaaaaoekaagaaaaacadaaabia
abaaaakaaeaaaaaeaaaaaiiaaaaappiaadaaaaiaabaappiaaeaaaaaeabaaaiia
aaaaffiaadaaaaiaaaaappiaacaaaaadaeaaabiaaaaapplbaeaaaakaacaaaaad
aeaaaciaaaaakklbaeaakkkafkaaaaaeaaaaaciaaeaaoeiaaeaaoeiaafaaaaka
ahaaaaacaaaaaciaaaaaffiaagaaaaacaaaaaciaaaaaffiaacaaaaadaaaaacia
aaaaffibabaaaakaalaaaaadadaaaciaaaaaffiaafaaaakaakaaaaadaaaaacia
abaaaakaadaaffiaafaaaaadaaaaaciaaaaaffiaaaaakkiaaeaaaaaeabaaaiia
aaaaffiaadaaaaiaabaappiaacaaaaadadaaciiaabaappibafaaffkaacaaaaad
abaaciiaaaaaaaiaaaaaaaiaafaaaaadaaaacoiaacaabliaabaappiaafaaaaad
abaaciiaacaappiaafaakkkaafaaaaadacaachiaacaaoeiaabaappiaakaaaaad
aeaachiaaaaabliaacaaoeiaafaaaaadaaaachiaaaaaaaiaacaaoeiaalaaaaad
acaachiaaeaaoeiaaaaaoeiaafaaaaadadaachiaabaaoeiaacaaoeiaabaaaaac
aaaicpiaadaaoeiappppaaaafdeieefcjiafaaaaeaaaaaaaggabaaaafjaaaaae
egiocaaaaaaaaaaaamaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaa
abaaaaaafkaaaaadaagabaaaacaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
gcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaaddcbabaaa
acaaaaaagcbaaaadlcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
adaaaaaaaaaaaaajdcaabaaaaaaaaaaaogbkbaiaebaaaaaaabaaaaaaigiacaaa
aaaaaaaaakaaaaaaapaaaaahbcaabaaaaaaaaaaaegaabaaaaaaaaaaaegaabaaa
aaaaaaaaelaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaajbcaabaaa
aaaaaaaaakaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaadeaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaaddaaaaaibcaabaaa
aaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaaaoaaaaalccaabaaa
aaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpbkiacaaaaaaaaaaa
aiaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaa
aaaaaaajmcaabaaaaaaaaaaakgbobaiaebaaaaaaabaaaaaaagiicaaaaaaaaaaa
ajaaaaaaapaaaaahecaabaaaaaaaaaaaogakbaaaaaaaaaaaogakbaaaaaaaaaaa
elaaaaafecaabaaaaaaaaaaackaabaaaaaaaaaaaaaaaaaajecaabaaaaaaaaaaa
ckaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaadeaaaaahecaabaaa
aaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaaaaddaaaaaiecaabaaaaaaaaaaa
ckaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaadiaaaaahecaabaaaaaaaaaaa
ckaabaaaaaaaaaaabkaabaaaaaaaaaaaaoaaaaaifcaabaaaaaaaaaaaagacbaaa
aaaaaaaaagiacaaaaaaaaaaaaiaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadcaaaaakecaabaaaaaaaaaaa
dkaabaaaabaaaaaadkiacaaaaaaaaaaaahaaaaaackaabaaaaaaaaaaadiaaaaai
hcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaaaaaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaackaabaaaaaaaaaaaaaaaaaajmcaabaaa
aaaaaaaakgbobaiaebaaaaaaabaaaaaaagiicaaaaaaaaaaaalaaaaaaapaaaaah
ecaabaaaaaaaaaaaogakbaaaaaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaa
aaaaaaaackaabaaaaaaaaaaaaaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaa
aaaaaaaaakiacaaaaaaaaaaaaiaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaa
aaaaaaaaabeaaaaaaaaaaaaaddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaa
akiacaaaaaaaaaaaaiaaaaaadiaaaaahccaabaaaaaaaaaaackaabaaaaaaaaaaa
bkaabaaaaaaaaaaaaoaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaa
aaaaaaaaaiaaaaaaaaaaaaahbcaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaa
aaaaaaaaaaaaaaaiiccabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaaabeaaaaa
aaaaiadpaoaaaaahdcaabaaaaaaaaaaaegbabaaaadaaaaaapgbpbaaaadaaaaaa
efaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaabaaaaaaaagabaaa
aaaaaaaaaaaaaaahccaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaa
efaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaaacaaaaaaaagabaaa
acaaaaaadiaaaaahocaabaaaaaaaaaaafgafbaaaaaaaaaaaagajbaaaacaaaaaa
diaaaaahicaabaaaabaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdiaaaaah
hcaabaaaacaaaaaaegacbaaaacaaaaaapgapbaaaabaaaaaaddaaaaahocaabaaa
aaaaaaaafgaobaaaaaaaaaaaagajbaaaacaaaaaadiaaaaahhcaabaaaacaaaaaa
agaabaaaaaaaaaaaegacbaaaacaaaaaadeaaaaahhcaabaaaaaaaaaaajgahbaaa
aaaaaaaaegacbaaaacaaaaaadiaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadoaaaaabejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES3"
}

}
	}
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardAdd" }
		ZWrite Off Blend One One Fog { Color (0,0,0,0) }
Program "vp" {
// Vertex combos: 5
//   opengl - ALU: 13 to 20
//   d3d9 - ALU: 13 to 20
//   d3d11 - ALU: 13 to 26, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 13 to 26, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 14 [unity_Scale]
Matrix 9 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"!!ARBvp1.0
# 19 ALU
PARAM c[16] = { program.local[0],
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[14].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[4].z, R0, c[11];
DP4 result.texcoord[4].y, R0, c[10];
DP4 result.texcoord[4].x, R0, c[9];
ADD result.texcoord[3].xyz, -R0, c[13];
MOV R0.y, R0.z;
DP3 result.texcoord[2].z, R1, c[7];
DP3 result.texcoord[2].y, R1, c[6];
DP3 result.texcoord[2].x, R1, c[5];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[15], c[15].zwzw;
MOV result.texcoord[1].xy, R0;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 19 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 13 [unity_Scale]
Matrix 8 [_LightMatrix0]
Vector 14 [_MainTex_ST]
"vs_2_0
; 19 ALU
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c13.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 oT4.z, r0, c10
dp4 oT4.y, r0, c9
dp4 oT4.x, r0, c8
add oT3.xyz, -r0, c12
mov r0.y, r0.z
dp3 oT2.z, r1, c6
dp3 oT2.y, r1, c5
dp3 oT2.x, r1, c4
mad oT0.xy, v2, c14, c14.zwzw
mov oT1.xy, r0
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 208 // 208 used size, 11 vars
Matrix 48 [_LightMatrix0] 4
Vector 192 [_MainTex_ST] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 27 instructions, 2 temp regs, 0 temp arrays:
// ALU 26 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecednbjihcmjpdfnefaknbamlomdmbijnaepabaaaaaaeaagaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcimaeaaaaeaaaabaacdabaaaafjaaaaae
egiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagiaaaaac
acaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
dcaabaaaaaaaaaaafgbfbaaaaaaaaaaaigiacaaaacaaaaaaanaaaaaadcaaaaak
dcaabaaaaaaaaaaaigiacaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegaabaaa
aaaaaaaadcaaaaakdcaabaaaaaaaaaaaigiacaaaacaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegaabaaaaaaaaaaadcaaaaakmccabaaaabaaaaaaagiicaaaacaaaaaa
apaaaaaapgbpbaaaaaaaaaaaagaebaaaaaaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaamaaaaaaogikcaaaaaaaaaaaamaaaaaa
diaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaacaaaaaabeaaaaaa
diaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaa
dcaaaaaklcaabaaaaaaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaaaaaaaaaaa
egaibaaaabaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaacaaaaaaaoaaaaaa
kgakbaaaaaaaaaaaegadbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
acaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egacbaaaaaaaaaaaaaaaaaajhccabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaa
egiccaaaabaaaaaaaaaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaacaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaa
aeaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaagaabaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaaaaaaaa
afaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaaeaaaaaa
egiccaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = tmpvar_2;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp float tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_5;
  arg0_5 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_6;
  arg0_6 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_7;
  arg0_7 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_8;
  tmpvar_8 = (1.0 - (((tmpvar_4.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_5, arg0_5))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_7, arg0_7))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_3 = tmpvar_8;
  mediump vec3 tmpvar_9;
  tmpvar_9 = normalize(xlv_TEXCOORD3);
  lightDir_2 = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = dot (xlv_TEXCOORD4, xlv_TEXCOORD4);
  lowp vec4 c_11;
  c_11.xyz = ((tmpvar_4.xyz * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, lightDir_2)) * texture2D (_LightTexture0, vec2(tmpvar_10)).w) * 2.0));
  c_11.w = tmpvar_3;
  c_1.xyz = c_11.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "POINT" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = tmpvar_2;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp float tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_5;
  arg0_5 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_6;
  arg0_6 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_7;
  arg0_7 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_8;
  tmpvar_8 = (1.0 - (((tmpvar_4.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_5, arg0_5))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_7, arg0_7))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_3 = tmpvar_8;
  mediump vec3 tmpvar_9;
  tmpvar_9 = normalize(xlv_TEXCOORD3);
  lightDir_2 = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = dot (xlv_TEXCOORD4, xlv_TEXCOORD4);
  lowp vec4 c_11;
  c_11.xyz = ((tmpvar_4.xyz * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, lightDir_2)) * texture2D (_LightTexture0, vec2(tmpvar_10)).w) * 2.0));
  c_11.w = tmpvar_3;
  c_1.xyz = c_11.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 13 [unity_Scale]
Matrix 8 [_LightMatrix0]
Vector 14 [_MainTex_ST]
"agal_vs
[bc]
adaaaaaaabaaahacabaaaaoeaaaaaaaaanaaaappabaaaaaa mul r1.xyz, a1, c13.w
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
bdaaaaaaaeaaaeaeaaaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 v4.z, r0, c10
bdaaaaaaaeaaacaeaaaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 v4.y, r0, c9
bdaaaaaaaeaaabaeaaaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 v4.x, r0, c8
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
abaaaaaaadaaahaeacaaaakeacaaaaaaamaaaaoeabaaaaaa add v3.xyz, r2.xyzz, c12
aaaaaaaaaaaaacacaaaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r0.y, r0.z
bcaaaaaaacaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v2.z, r1.xyzz, c6
bcaaaaaaacaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v2.y, r1.xyzz, c5
bcaaaaaaacaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v2.x, r1.xyzz, c4
adaaaaaaacaaadacadaaaaoeaaaaaaaaaoaaaaoeabaaaaaa mul r2.xy, a3, c14
abaaaaaaaaaaadaeacaaaafeacaaaaaaaoaaaaooabaaaaaa add v0.xy, r2.xyyy, c14.zwzw
aaaaaaaaabaaadaeaaaaaafeacaaaaaaaaaaaaaaaaaaaaaa mov v1.xy, r0.xyyy
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 208 // 208 used size, 11 vars
Matrix 48 [_LightMatrix0] 4
Vector 192 [_MainTex_ST] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 27 instructions, 2 temp regs, 0 temp arrays:
// ALU 26 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedpgnpcfpimlcgoefhfnnbknkkfenfihmlabaaaaaapaaiaaaaaeaaaaaa
daaaaaaanmacaaaahaahaaaadiaiaaaaebgpgodjkeacaaaakeacaaaaaaacpopp
deacaaaahaaaaaaaagaaceaaaaaagmaaaaaagmaaaaaaceaaabaagmaaaaaaadaa
aeaaabaaaaaaaaaaaaaaamaaabaaafaaaaaaaaaaabaaaaaaabaaagaaaaaaaaaa
acaaaaaaaeaaahaaaaaaaaaaacaaamaaaeaaalaaaaaaaaaaacaabeaaabaaapaa
aaaaaaaaaaaaaaaaaaacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaacia
acaaapjabpaaaaacafaaadiaadaaapjaafaaaaadaaaaadiaaaaaffjaamaaocka
aeaaaaaeaaaaadiaalaaockaaaaaaajaaaaaoeiaaeaaaaaeaaaaadiaanaaocka
aaaakkjaaaaaoeiaaeaaaaaeaaaaamoaaoaacekaaaaappjaaaaaeeiaaeaaaaae
aaaaadoaadaaoejaafaaoekaafaaookaafaaaaadaaaaahiaacaaoejaapaappka
afaaaaadabaaahiaaaaaffiaamaaoekaaeaaaaaeaaaaaliaalaakekaaaaaaaia
abaakeiaaeaaaaaeabaaahoaanaaoekaaaaakkiaaaaapeiaafaaaaadaaaaahia
aaaaffjaamaaoekaaeaaaaaeaaaaahiaalaaoekaaaaaaajaaaaaoeiaaeaaaaae
aaaaahiaanaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaahiaaoaaoekaaaaappja
aaaaoeiaacaaaaadacaaahoaaaaaoeibagaaoekaafaaaaadaaaaapiaaaaaffja
amaaoekaaeaaaaaeaaaaapiaalaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapia
anaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaaoaaoekaaaaappjaaaaaoeia
afaaaaadabaaahiaaaaaffiaacaaoekaaeaaaaaeabaaahiaabaaoekaaaaaaaia
abaaoeiaaeaaaaaeaaaaahiaadaaoekaaaaakkiaabaaoeiaaeaaaaaeadaaahoa
aeaaoekaaaaappiaaaaaoeiaafaaaaadaaaaapiaaaaaffjaaiaaoekaaeaaaaae
aaaaapiaahaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaajaaoekaaaaakkja
aaaaoeiaaeaaaaaeaaaaapiaakaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadma
aaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiappppaaaafdeieefc
imaeaaaaeaaaabaacdabaaaafjaaaaaeegiocaaaaaaaaaaaanaaaaaafjaaaaae
egiocaaaabaaaaaaabaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
mccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaa
gfaaaaadhccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadiaaaaaidcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
igiacaaaacaaaaaaanaaaaaadcaaaaakdcaabaaaaaaaaaaaigiacaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaakdcaabaaaaaaaaaaa
igiacaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaak
mccabaaaabaaaaaaagiicaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaagaebaaa
aaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
amaaaaaaogikcaaaaaaaaaaaamaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaa
acaaaaaapgipcaaaacaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaa
aaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaa
acaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaa
acaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaa
diaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaa
egacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
acaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhccabaaa
adaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaaaaaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaanaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaaaaaaaaaafaaaaaakgakbaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaaaaaaaaaaagaaaaaapgapbaaa
aaaaaaaaegacbaaaaaaaaaaadoaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaa
jiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
acaaaaaaahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaa
laaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofe
aaeoepfcenebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaa
agaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
keaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaa
aaaaaaaaadaaaaaaabaaaaaaamadaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaa
acaaaaaaahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaa
keaaaaaaaeaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "POINT" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 400
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 426
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    lowp vec3 normal;
    mediump vec3 lightDir;
    highp vec3 _LightCoord;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
#line 397
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player3_Pos;
#line 407
#line 421
#line 436
uniform highp vec4 _MainTex_ST;
#line 452
#line 77
highp vec3 WorldSpaceLightDir( in highp vec4 v ) {
    highp vec3 worldPos = (_Object2World * v).xyz;
    return (_WorldSpaceLightPos0.xyz - worldPos);
}
#line 407
void vert( inout appdata_full vertexData, out Input outData ) {
    highp vec4 pos = (glstate_matrix_mvp * vertexData.vertex);
    highp vec4 posWorld = (_Object2World * vertexData.vertex);
    #line 411
    outData.uv_MainTex = vec2( vertexData.texcoord);
    outData.location = posWorld.xz;
}
#line 437
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 440
    Input customInputData;
    vert( v, customInputData);
    o.cust_location = customInputData.location;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 444
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.normal = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    highp vec3 lightDir = WorldSpaceLightDir( v.vertex);
    o.lightDir = lightDir;
    #line 448
    o._LightCoord = (_LightMatrix0 * (_Object2World * v.vertex)).xyz;
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out mediump vec3 xlv_TEXCOORD3;
out highp vec3 xlv_TEXCOORD4;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.pack0);
    xlv_TEXCOORD1 = vec2(xl_retval.cust_location);
    xlv_TEXCOORD2 = vec3(xl_retval.normal);
    xlv_TEXCOORD3 = vec3(xl_retval.lightDir);
    xlv_TEXCOORD4 = vec3(xl_retval._LightCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 400
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 426
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    lowp vec3 normal;
    mediump vec3 lightDir;
    highp vec3 _LightCoord;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
#line 397
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player3_Pos;
#line 407
#line 421
#line 436
uniform highp vec4 _MainTex_ST;
#line 452
#line 338
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp vec4 c;
    #line 342
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.0));
    c.w = s.Alpha;
    return c;
}
#line 421
highp float powerForPos( in highp vec4 pos, in highp vec2 nearVertex ) {
    highp float atten = clamp( (_FogRadius - length((pos.xz - nearVertex.xy))), 0.0, _FogRadius);
    return (((1.0 / _FogMaxRadius) * atten) / _FogRadius);
}
#line 414
void surf( in Input IN, inout SurfaceOutput o ) {
    #line 416
    lowp vec4 baseColor = (texture( _MainTex, IN.uv_MainTex) * _Color);
    highp float alpha = (1.0 - (((baseColor.w + powerForPos( _Player1_Pos, IN.location)) + powerForPos( _Player2_Pos, IN.location)) + powerForPos( _Player3_Pos, IN.location)));
    o.Albedo = baseColor.xyz;
    o.Alpha = alpha;
}
#line 452
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    #line 456
    surfIN.location = IN.cust_location;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 460
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    #line 464
    surf( surfIN, o);
    lowp vec3 lightDir = normalize(IN.lightDir);
    lowp vec4 c = LightingLambert( o, lightDir, (texture( _LightTexture0, vec2( dot( IN._LightCoord, IN._LightCoord))).w * 1.0));
    c.w = 0.0;
    #line 468
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in mediump vec3 xlv_TEXCOORD3;
in highp vec3 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec2(xlv_TEXCOORD0);
    xlt_IN.cust_location = vec2(xlv_TEXCOORD1);
    xlt_IN.normal = vec3(xlv_TEXCOORD2);
    xlt_IN.lightDir = vec3(xlv_TEXCOORD3);
    xlt_IN._LightCoord = vec3(xlv_TEXCOORD4);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 10 [unity_Scale]
Vector 11 [_MainTex_ST]
"!!ARBvp1.0
# 13 ALU
PARAM c[12] = { program.local[0],
		state.matrix.mvp,
		program.local[5..11] };
TEMP R0;
MUL R0.xyz, vertex.normal, c[10].w;
DP3 result.texcoord[2].z, R0, c[7];
DP3 result.texcoord[2].y, R0, c[6];
DP3 result.texcoord[2].x, R0, c[5];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[7];
MOV result.texcoord[3].xyz, c[9];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[11], c[11].zwzw;
MOV result.texcoord[1].xy, R0;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 13 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 9 [unity_Scale]
Vector 10 [_MainTex_ST]
"vs_2_0
; 13 ALU
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1, c9.w
dp3 oT2.z, r0, c6
dp3 oT2.y, r0, c5
dp3 oT2.x, r0, c4
dp4 r0.x, v0, c4
dp4 r0.y, v0, c6
mov oT3.xyz, c8
mad oT0.xy, v2, c10, c10.zwzw
mov oT1.xy, r0
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 144 // 144 used size, 10 vars
Vector 128 [_MainTex_ST] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 15 instructions, 2 temp regs, 0 temp arrays:
// ALU 13 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedbojcjaofdfcipegnomkkncmadbgodgemabaaaaaaeiaeaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefckmacaaaaeaaaabaa
klaaaaaafjaaaaaeegiocaaaaaaaaaaaajaaaaaafjaaaaaeegiocaaaabaaaaaa
abaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagiaaaaacacaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
acaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaidcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaigiacaaaacaaaaaaanaaaaaadcaaaaakdcaabaaa
aaaaaaaaigiacaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegaabaaaaaaaaaaa
dcaaaaakdcaabaaaaaaaaaaaigiacaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egaabaaaaaaaaaaadcaaaaakmccabaaaabaaaaaaagiicaaaacaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaagaebaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaaiaaaaaaogikcaaaaaaaaaaaaiaaaaaadiaaaaai
hcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaacaaaaaabeaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
lcaabaaaaaaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaa
abaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaa
aaaaaaaaegadbaaaaaaaaaaadgaaaaaghccabaaaadaaaaaaegiccaaaabaaaaaa
aaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES


#ifdef VERTEX

varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform lowp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_5;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp float tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_5;
  arg0_5 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_6;
  arg0_6 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_7;
  arg0_7 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_8;
  tmpvar_8 = (1.0 - (((tmpvar_4.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_5, arg0_5))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_7, arg0_7))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_3 = tmpvar_8;
  lightDir_2 = xlv_TEXCOORD3;
  lowp vec4 c_9;
  c_9.xyz = ((tmpvar_4.xyz * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD2, lightDir_2)) * 2.0));
  c_9.w = tmpvar_3;
  c_1.xyz = c_9.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" }
"!!GLES


#ifdef VERTEX

varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform lowp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_5;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp float tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_5;
  arg0_5 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_6;
  arg0_6 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_7;
  arg0_7 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_8;
  tmpvar_8 = (1.0 - (((tmpvar_4.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_5, arg0_5))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_7, arg0_7))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_3 = tmpvar_8;
  lightDir_2 = xlv_TEXCOORD3;
  lowp vec4 c_9;
  c_9.xyz = ((tmpvar_4.xyz * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD2, lightDir_2)) * 2.0));
  c_9.w = tmpvar_3;
  c_1.xyz = c_9.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 9 [unity_Scale]
Vector 10 [_MainTex_ST]
"agal_vs
[bc]
adaaaaaaaaaaahacabaaaaoeaaaaaaaaajaaaappabaaaaaa mul r0.xyz, a1, c9.w
bcaaaaaaacaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v2.z, r0.xyzz, c6
bcaaaaaaacaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v2.y, r0.xyzz, c5
bcaaaaaaacaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v2.x, r0.xyzz, c4
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.y, a0, c6
aaaaaaaaadaaahaeaiaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.xyz, c8
adaaaaaaabaaadacadaaaaoeaaaaaaaaakaaaaoeabaaaaaa mul r1.xy, a3, c10
abaaaaaaaaaaadaeabaaaafeacaaaaaaakaaaaooabaaaaaa add v0.xy, r1.xyyy, c10.zwzw
aaaaaaaaabaaadaeaaaaaafeacaaaaaaaaaaaaaaaaaaaaaa mov v1.xy, r0.xyyy
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 144 // 144 used size, 10 vars
Vector 128 [_MainTex_ST] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 15 instructions, 2 temp regs, 0 temp arrays:
// ALU 13 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedioodfnbllnffdmfjnmbhlamknpiifgjdabaaaaaaaeagaaaaaeaaaaaa
daaaaaaaoiabaaaajmaeaaaageafaaaaebgpgodjlaabaaaalaabaaaaaaacpopp
emabaaaageaaaaaaafaaceaaaaaagaaaaaaagaaaaaaaceaaabaagaaaaaaaaiaa
abaaabaaaaaaaaaaabaaaaaaabaaacaaaaaaaaaaacaaaaaaaeaaadaaaaaaaaaa
acaaamaaaeaaahaaaaaaaaaaacaabeaaabaaalaaaaaaaaaaaaaaaaaaaaacpopp
bpaaaaacafaaaaiaaaaaapjabpaaaaacafaaaciaacaaapjabpaaaaacafaaadia
adaaapjaafaaaaadaaaaadiaaaaaffjaaiaaockaaeaaaaaeaaaaadiaahaaocka
aaaaaajaaaaaoeiaaeaaaaaeaaaaadiaajaaockaaaaakkjaaaaaoeiaaeaaaaae
aaaaamoaakaacekaaaaappjaaaaaeeiaaeaaaaaeaaaaadoaadaaoejaabaaoeka
abaaookaafaaaaadaaaaahiaacaaoejaalaappkaafaaaaadabaaahiaaaaaffia
aiaaoekaaeaaaaaeaaaaaliaahaakekaaaaaaaiaabaakeiaaeaaaaaeabaaahoa
ajaaoekaaaaakkiaaaaapeiaafaaaaadaaaaapiaaaaaffjaaeaaoekaaeaaaaae
aaaaapiaadaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaafaaoekaaaaakkja
aaaaoeiaaeaaaaaeaaaaapiaagaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadma
aaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiaabaaaaacacaaahoa
acaaoekappppaaaafdeieefckmacaaaaeaaaabaaklaaaaaafjaaaaaeegiocaaa
aaaaaaaaajaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaaeegiocaaa
acaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaa
fpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
dccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadiaaaaaidcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
igiacaaaacaaaaaaanaaaaaadcaaaaakdcaabaaaaaaaaaaaigiacaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaakdcaabaaaaaaaaaaa
igiacaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaak
mccabaaaabaaaaaaagiicaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaagaebaaa
aaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
aiaaaaaaogikcaaaaaaaaaaaaiaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaa
acaaaaaapgipcaaaacaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaa
aaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaa
acaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaa
acaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaa
dgaaaaaghccabaaaadaaaaaaegiccaaaabaaaaaaaaaaaaaadoaaaaabejfdeheo
maaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakjaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaadaaaaaaapadaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaa
apaaaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaaimaaaaaa
acaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaaimaaaaaaadaaaaaaaaaaaaaa
adaaaaaaadaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 398
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    lowp vec3 normal;
    mediump vec3 lightDir;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 393
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 397
uniform highp vec4 _Player3_Pos;
#line 405
#line 419
#line 433
uniform highp vec4 _MainTex_ST;
#line 77
highp vec3 WorldSpaceLightDir( in highp vec4 v ) {
    highp vec3 worldPos = (_Object2World * v).xyz;
    return _WorldSpaceLightPos0.xyz;
}
#line 405
void vert( inout appdata_full vertexData, out Input outData ) {
    highp vec4 pos = (glstate_matrix_mvp * vertexData.vertex);
    highp vec4 posWorld = (_Object2World * vertexData.vertex);
    #line 409
    outData.uv_MainTex = vec2( vertexData.texcoord);
    outData.location = posWorld.xz;
}
#line 434
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 437
    Input customInputData;
    vert( v, customInputData);
    o.cust_location = customInputData.location;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 441
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.normal = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    highp vec3 lightDir = WorldSpaceLightDir( v.vertex);
    o.lightDir = lightDir;
    #line 446
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out mediump vec3 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.pack0);
    xlv_TEXCOORD1 = vec2(xl_retval.cust_location);
    xlv_TEXCOORD2 = vec3(xl_retval.normal);
    xlv_TEXCOORD3 = vec3(xl_retval.lightDir);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 398
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    lowp vec3 normal;
    mediump vec3 lightDir;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 393
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 397
uniform highp vec4 _Player3_Pos;
#line 405
#line 419
#line 433
uniform highp vec4 _MainTex_ST;
#line 338
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp vec4 c;
    #line 342
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.0));
    c.w = s.Alpha;
    return c;
}
#line 419
highp float powerForPos( in highp vec4 pos, in highp vec2 nearVertex ) {
    highp float atten = clamp( (_FogRadius - length((pos.xz - nearVertex.xy))), 0.0, _FogRadius);
    return (((1.0 / _FogMaxRadius) * atten) / _FogRadius);
}
#line 412
void surf( in Input IN, inout SurfaceOutput o ) {
    #line 414
    lowp vec4 baseColor = (texture( _MainTex, IN.uv_MainTex) * _Color);
    highp float alpha = (1.0 - (((baseColor.w + powerForPos( _Player1_Pos, IN.location)) + powerForPos( _Player2_Pos, IN.location)) + powerForPos( _Player3_Pos, IN.location)));
    o.Albedo = baseColor.xyz;
    o.Alpha = alpha;
}
#line 448
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 450
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.location = IN.cust_location;
    SurfaceOutput o;
    #line 454
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 458
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    surf( surfIN, o);
    lowp vec3 lightDir = IN.lightDir;
    #line 462
    lowp vec4 c = LightingLambert( o, lightDir, 1.0);
    c.w = 0.0;
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in mediump vec3 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec2(xlv_TEXCOORD0);
    xlt_IN.cust_location = vec2(xlv_TEXCOORD1);
    xlt_IN.normal = vec3(xlv_TEXCOORD2);
    xlt_IN.lightDir = vec3(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 14 [unity_Scale]
Matrix 9 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"!!ARBvp1.0
# 20 ALU
PARAM c[16] = { program.local[0],
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[14].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[4].w, R0, c[12];
DP4 result.texcoord[4].z, R0, c[11];
DP4 result.texcoord[4].y, R0, c[10];
DP4 result.texcoord[4].x, R0, c[9];
ADD result.texcoord[3].xyz, -R0, c[13];
MOV R0.y, R0.z;
DP3 result.texcoord[2].z, R1, c[7];
DP3 result.texcoord[2].y, R1, c[6];
DP3 result.texcoord[2].x, R1, c[5];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[15], c[15].zwzw;
MOV result.texcoord[1].xy, R0;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 20 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 13 [unity_Scale]
Matrix 8 [_LightMatrix0]
Vector 14 [_MainTex_ST]
"vs_2_0
; 20 ALU
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c13.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 oT4.w, r0, c11
dp4 oT4.z, r0, c10
dp4 oT4.y, r0, c9
dp4 oT4.x, r0, c8
add oT3.xyz, -r0, c12
mov r0.y, r0.z
dp3 oT2.z, r1, c6
dp3 oT2.y, r1, c5
dp3 oT2.x, r1, c4
mad oT0.xy, v2, c14, c14.zwzw
mov oT1.xy, r0
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 208 // 208 used size, 11 vars
Matrix 48 [_LightMatrix0] 4
Vector 192 [_MainTex_ST] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 27 instructions, 2 temp regs, 0 temp arrays:
// ALU 26 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefieceddhepdknaecnfkchmoghfliieinekmkcmabaaaaaaeaagaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcimaeaaaaeaaaabaacdabaaaafjaaaaae
egiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagiaaaaac
acaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
dcaabaaaaaaaaaaafgbfbaaaaaaaaaaaigiacaaaacaaaaaaanaaaaaadcaaaaak
dcaabaaaaaaaaaaaigiacaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegaabaaa
aaaaaaaadcaaaaakdcaabaaaaaaaaaaaigiacaaaacaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegaabaaaaaaaaaaadcaaaaakmccabaaaabaaaaaaagiicaaaacaaaaaa
apaaaaaapgbpbaaaaaaaaaaaagaebaaaaaaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaamaaaaaaogikcaaaaaaaaaaaamaaaaaa
diaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaacaaaaaabeaaaaaa
diaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaa
dcaaaaaklcaabaaaaaaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaaaaaaaaaaa
egaibaaaabaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaacaaaaaaaoaaaaaa
kgakbaaaaaaaaaaaegadbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
acaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egacbaaaaaaaaaaaaaaaaaajhccabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaa
egiccaaaabaaaaaaaaaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaacaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaaaaaaaaaa
aeaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaaaaaaaaaadaaaaaaagaabaaa
aaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaaaaaaaaa
afaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpccabaaaaeaaaaaa
egiocaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaaegaobaaaabaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = tmpvar_2;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp float tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_5;
  arg0_5 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_6;
  arg0_6 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_7;
  arg0_7 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_8;
  tmpvar_8 = (1.0 - (((tmpvar_4.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_5, arg0_5))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_7, arg0_7))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_3 = tmpvar_8;
  mediump vec3 tmpvar_9;
  tmpvar_9 = normalize(xlv_TEXCOORD3);
  lightDir_2 = tmpvar_9;
  highp vec2 P_10;
  P_10 = ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5);
  highp float tmpvar_11;
  tmpvar_11 = dot (xlv_TEXCOORD4.xyz, xlv_TEXCOORD4.xyz);
  lowp float atten_12;
  atten_12 = ((float((xlv_TEXCOORD4.z > 0.0)) * texture2D (_LightTexture0, P_10).w) * texture2D (_LightTextureB0, vec2(tmpvar_11)).w);
  lowp vec4 c_13;
  c_13.xyz = ((tmpvar_4.xyz * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, lightDir_2)) * atten_12) * 2.0));
  c_13.w = tmpvar_3;
  c_1.xyz = c_13.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "SPOT" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = tmpvar_2;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp float tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_5;
  arg0_5 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_6;
  arg0_6 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_7;
  arg0_7 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_8;
  tmpvar_8 = (1.0 - (((tmpvar_4.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_5, arg0_5))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_7, arg0_7))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_3 = tmpvar_8;
  mediump vec3 tmpvar_9;
  tmpvar_9 = normalize(xlv_TEXCOORD3);
  lightDir_2 = tmpvar_9;
  highp vec2 P_10;
  P_10 = ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5);
  highp float tmpvar_11;
  tmpvar_11 = dot (xlv_TEXCOORD4.xyz, xlv_TEXCOORD4.xyz);
  lowp float atten_12;
  atten_12 = ((float((xlv_TEXCOORD4.z > 0.0)) * texture2D (_LightTexture0, P_10).w) * texture2D (_LightTextureB0, vec2(tmpvar_11)).w);
  lowp vec4 c_13;
  c_13.xyz = ((tmpvar_4.xyz * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, lightDir_2)) * atten_12) * 2.0));
  c_13.w = tmpvar_3;
  c_1.xyz = c_13.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 13 [unity_Scale]
Matrix 8 [_LightMatrix0]
Vector 14 [_MainTex_ST]
"agal_vs
[bc]
adaaaaaaabaaahacabaaaaoeaaaaaaaaanaaaappabaaaaaa mul r1.xyz, a1, c13.w
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
bdaaaaaaaeaaaiaeaaaaaaoeacaaaaaaalaaaaoeabaaaaaa dp4 v4.w, r0, c11
bdaaaaaaaeaaaeaeaaaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 v4.z, r0, c10
bdaaaaaaaeaaacaeaaaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 v4.y, r0, c9
bdaaaaaaaeaaabaeaaaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 v4.x, r0, c8
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
abaaaaaaadaaahaeacaaaakeacaaaaaaamaaaaoeabaaaaaa add v3.xyz, r2.xyzz, c12
aaaaaaaaaaaaacacaaaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r0.y, r0.z
bcaaaaaaacaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v2.z, r1.xyzz, c6
bcaaaaaaacaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v2.y, r1.xyzz, c5
bcaaaaaaacaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v2.x, r1.xyzz, c4
adaaaaaaacaaadacadaaaaoeaaaaaaaaaoaaaaoeabaaaaaa mul r2.xy, a3, c14
abaaaaaaaaaaadaeacaaaafeacaaaaaaaoaaaaooabaaaaaa add v0.xy, r2.xyyy, c14.zwzw
aaaaaaaaabaaadaeaaaaaafeacaaaaaaaaaaaaaaaaaaaaaa mov v1.xy, r0.xyyy
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 208 // 208 used size, 11 vars
Matrix 48 [_LightMatrix0] 4
Vector 192 [_MainTex_ST] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 27 instructions, 2 temp regs, 0 temp arrays:
// ALU 26 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedcieceelkfgebafndbhbojokblkndkbbjabaaaaaapaaiaaaaaeaaaaaa
daaaaaaanmacaaaahaahaaaadiaiaaaaebgpgodjkeacaaaakeacaaaaaaacpopp
deacaaaahaaaaaaaagaaceaaaaaagmaaaaaagmaaaaaaceaaabaagmaaaaaaadaa
aeaaabaaaaaaaaaaaaaaamaaabaaafaaaaaaaaaaabaaaaaaabaaagaaaaaaaaaa
acaaaaaaaeaaahaaaaaaaaaaacaaamaaaeaaalaaaaaaaaaaacaabeaaabaaapaa
aaaaaaaaaaaaaaaaaaacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaacia
acaaapjabpaaaaacafaaadiaadaaapjaafaaaaadaaaaadiaaaaaffjaamaaocka
aeaaaaaeaaaaadiaalaaockaaaaaaajaaaaaoeiaaeaaaaaeaaaaadiaanaaocka
aaaakkjaaaaaoeiaaeaaaaaeaaaaamoaaoaacekaaaaappjaaaaaeeiaaeaaaaae
aaaaadoaadaaoejaafaaoekaafaaookaafaaaaadaaaaahiaacaaoejaapaappka
afaaaaadabaaahiaaaaaffiaamaaoekaaeaaaaaeaaaaaliaalaakekaaaaaaaia
abaakeiaaeaaaaaeabaaahoaanaaoekaaaaakkiaaaaapeiaafaaaaadaaaaahia
aaaaffjaamaaoekaaeaaaaaeaaaaahiaalaaoekaaaaaaajaaaaaoeiaaeaaaaae
aaaaahiaanaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaahiaaoaaoekaaaaappja
aaaaoeiaacaaaaadacaaahoaaaaaoeibagaaoekaafaaaaadaaaaapiaaaaaffja
amaaoekaaeaaaaaeaaaaapiaalaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapia
anaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaaoaaoekaaaaappjaaaaaoeia
afaaaaadabaaapiaaaaaffiaacaaoekaaeaaaaaeabaaapiaabaaoekaaaaaaaia
abaaoeiaaeaaaaaeabaaapiaadaaoekaaaaakkiaabaaoeiaaeaaaaaeadaaapoa
aeaaoekaaaaappiaabaaoeiaafaaaaadaaaaapiaaaaaffjaaiaaoekaaeaaaaae
aaaaapiaahaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaajaaoekaaaaakkja
aaaaoeiaaeaaaaaeaaaaapiaakaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadma
aaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiappppaaaafdeieefc
imaeaaaaeaaaabaacdabaaaafjaaaaaeegiocaaaaaaaaaaaanaaaaaafjaaaaae
egiocaaaabaaaaaaabaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
mccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaa
gfaaaaadpccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadiaaaaaidcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
igiacaaaacaaaaaaanaaaaaadcaaaaakdcaabaaaaaaaaaaaigiacaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaakdcaabaaaaaaaaaaa
igiacaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaak
mccabaaaabaaaaaaagiicaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaagaebaaa
aaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
amaaaaaaogikcaaaaaaaaaaaamaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaa
acaaaaaapgipcaaaacaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaa
aaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaa
acaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaa
acaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaa
diaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaa
egacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
acaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhccabaaa
adaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaaaaaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaanaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaipcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiocaaaaaaaaaaaaeaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaak
pcaabaaaabaaaaaaegiocaaaaaaaaaaaafaaaaaakgakbaaaaaaaaaaaegaobaaa
abaaaaaadcaaaaakpccabaaaaeaaaaaaegiocaaaaaaaaaaaagaaaaaapgapbaaa
aaaaaaaaegaobaaaabaaaaaadoaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaa
jiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
acaaaaaaahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaa
laaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofe
aaeoepfcenebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaa
agaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
keaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaa
aaaaaaaaadaaaaaaabaaaaaaamadaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaa
acaaaaaaahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaa
keaaaaaaaeaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "SPOT" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 409
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 435
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    lowp vec3 normal;
    mediump vec3 lightDir;
    highp vec4 _LightCoord;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _LightTextureB0;
#line 398
#line 402
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
#line 406
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player3_Pos;
#line 416
#line 430
#line 445
uniform highp vec4 _MainTex_ST;
#line 461
#line 77
highp vec3 WorldSpaceLightDir( in highp vec4 v ) {
    highp vec3 worldPos = (_Object2World * v).xyz;
    return (_WorldSpaceLightPos0.xyz - worldPos);
}
#line 416
void vert( inout appdata_full vertexData, out Input outData ) {
    highp vec4 pos = (glstate_matrix_mvp * vertexData.vertex);
    highp vec4 posWorld = (_Object2World * vertexData.vertex);
    #line 420
    outData.uv_MainTex = vec2( vertexData.texcoord);
    outData.location = posWorld.xz;
}
#line 446
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 449
    Input customInputData;
    vert( v, customInputData);
    o.cust_location = customInputData.location;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 453
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.normal = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    highp vec3 lightDir = WorldSpaceLightDir( v.vertex);
    o.lightDir = lightDir;
    #line 457
    o._LightCoord = (_LightMatrix0 * (_Object2World * v.vertex));
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out mediump vec3 xlv_TEXCOORD3;
out highp vec4 xlv_TEXCOORD4;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.pack0);
    xlv_TEXCOORD1 = vec2(xl_retval.cust_location);
    xlv_TEXCOORD2 = vec3(xl_retval.normal);
    xlv_TEXCOORD3 = vec3(xl_retval.lightDir);
    xlv_TEXCOORD4 = vec4(xl_retval._LightCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 409
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 435
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    lowp vec3 normal;
    mediump vec3 lightDir;
    highp vec4 _LightCoord;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _LightTextureB0;
#line 398
#line 402
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
#line 406
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player3_Pos;
#line 416
#line 430
#line 445
uniform highp vec4 _MainTex_ST;
#line 461
#line 338
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp vec4 c;
    #line 342
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.0));
    c.w = s.Alpha;
    return c;
}
#line 398
lowp float UnitySpotAttenuate( in highp vec3 LightCoord ) {
    return texture( _LightTextureB0, vec2( dot( LightCoord, LightCoord))).w;
}
#line 394
lowp float UnitySpotCookie( in highp vec4 LightCoord ) {
    return texture( _LightTexture0, ((LightCoord.xy / LightCoord.w) + 0.5)).w;
}
#line 430
highp float powerForPos( in highp vec4 pos, in highp vec2 nearVertex ) {
    highp float atten = clamp( (_FogRadius - length((pos.xz - nearVertex.xy))), 0.0, _FogRadius);
    return (((1.0 / _FogMaxRadius) * atten) / _FogRadius);
}
#line 423
void surf( in Input IN, inout SurfaceOutput o ) {
    #line 425
    lowp vec4 baseColor = (texture( _MainTex, IN.uv_MainTex) * _Color);
    highp float alpha = (1.0 - (((baseColor.w + powerForPos( _Player1_Pos, IN.location)) + powerForPos( _Player2_Pos, IN.location)) + powerForPos( _Player3_Pos, IN.location)));
    o.Albedo = baseColor.xyz;
    o.Alpha = alpha;
}
#line 461
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    #line 465
    surfIN.location = IN.cust_location;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 469
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    #line 473
    surf( surfIN, o);
    lowp vec3 lightDir = normalize(IN.lightDir);
    lowp vec4 c = LightingLambert( o, lightDir, (((float((IN._LightCoord.z > 0.0)) * UnitySpotCookie( IN._LightCoord)) * UnitySpotAttenuate( IN._LightCoord.xyz)) * 1.0));
    c.w = 0.0;
    #line 477
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in mediump vec3 xlv_TEXCOORD3;
in highp vec4 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec2(xlv_TEXCOORD0);
    xlt_IN.cust_location = vec2(xlv_TEXCOORD1);
    xlt_IN.normal = vec3(xlv_TEXCOORD2);
    xlt_IN.lightDir = vec3(xlv_TEXCOORD3);
    xlt_IN._LightCoord = vec4(xlv_TEXCOORD4);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 14 [unity_Scale]
Matrix 9 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"!!ARBvp1.0
# 19 ALU
PARAM c[16] = { program.local[0],
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[14].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[4].z, R0, c[11];
DP4 result.texcoord[4].y, R0, c[10];
DP4 result.texcoord[4].x, R0, c[9];
ADD result.texcoord[3].xyz, -R0, c[13];
MOV R0.y, R0.z;
DP3 result.texcoord[2].z, R1, c[7];
DP3 result.texcoord[2].y, R1, c[6];
DP3 result.texcoord[2].x, R1, c[5];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[15], c[15].zwzw;
MOV result.texcoord[1].xy, R0;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 19 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 13 [unity_Scale]
Matrix 8 [_LightMatrix0]
Vector 14 [_MainTex_ST]
"vs_2_0
; 19 ALU
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c13.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 oT4.z, r0, c10
dp4 oT4.y, r0, c9
dp4 oT4.x, r0, c8
add oT3.xyz, -r0, c12
mov r0.y, r0.z
dp3 oT2.z, r1, c6
dp3 oT2.y, r1, c5
dp3 oT2.x, r1, c4
mad oT0.xy, v2, c14, c14.zwzw
mov oT1.xy, r0
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 208 // 208 used size, 11 vars
Matrix 48 [_LightMatrix0] 4
Vector 192 [_MainTex_ST] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 27 instructions, 2 temp regs, 0 temp arrays:
// ALU 26 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecednbjihcmjpdfnefaknbamlomdmbijnaepabaaaaaaeaagaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcimaeaaaaeaaaabaacdabaaaafjaaaaae
egiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagiaaaaac
acaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
dcaabaaaaaaaaaaafgbfbaaaaaaaaaaaigiacaaaacaaaaaaanaaaaaadcaaaaak
dcaabaaaaaaaaaaaigiacaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegaabaaa
aaaaaaaadcaaaaakdcaabaaaaaaaaaaaigiacaaaacaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegaabaaaaaaaaaaadcaaaaakmccabaaaabaaaaaaagiicaaaacaaaaaa
apaaaaaapgbpbaaaaaaaaaaaagaebaaaaaaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaamaaaaaaogikcaaaaaaaaaaaamaaaaaa
diaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaacaaaaaabeaaaaaa
diaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaa
dcaaaaaklcaabaaaaaaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaaaaaaaaaaa
egaibaaaabaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaacaaaaaaaoaaaaaa
kgakbaaaaaaaaaaaegadbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
acaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egacbaaaaaaaaaaaaaaaaaajhccabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaa
egiccaaaabaaaaaaaaaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaacaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaa
aeaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaagaabaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaaaaaaaa
afaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaaeaaaaaa
egiccaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = tmpvar_2;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp float tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_5;
  arg0_5 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_6;
  arg0_6 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_7;
  arg0_7 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_8;
  tmpvar_8 = (1.0 - (((tmpvar_4.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_5, arg0_5))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_7, arg0_7))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_3 = tmpvar_8;
  mediump vec3 tmpvar_9;
  tmpvar_9 = normalize(xlv_TEXCOORD3);
  lightDir_2 = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = dot (xlv_TEXCOORD4, xlv_TEXCOORD4);
  lowp vec4 c_11;
  c_11.xyz = ((tmpvar_4.xyz * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, lightDir_2)) * (texture2D (_LightTextureB0, vec2(tmpvar_10)).w * textureCube (_LightTexture0, xlv_TEXCOORD4).w)) * 2.0));
  c_11.w = tmpvar_3;
  c_1.xyz = c_11.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "POINT_COOKIE" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = tmpvar_2;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp float tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_5;
  arg0_5 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_6;
  arg0_6 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_7;
  arg0_7 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_8;
  tmpvar_8 = (1.0 - (((tmpvar_4.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_5, arg0_5))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_7, arg0_7))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_3 = tmpvar_8;
  mediump vec3 tmpvar_9;
  tmpvar_9 = normalize(xlv_TEXCOORD3);
  lightDir_2 = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = dot (xlv_TEXCOORD4, xlv_TEXCOORD4);
  lowp vec4 c_11;
  c_11.xyz = ((tmpvar_4.xyz * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, lightDir_2)) * (texture2D (_LightTextureB0, vec2(tmpvar_10)).w * textureCube (_LightTexture0, xlv_TEXCOORD4).w)) * 2.0));
  c_11.w = tmpvar_3;
  c_1.xyz = c_11.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 13 [unity_Scale]
Matrix 8 [_LightMatrix0]
Vector 14 [_MainTex_ST]
"agal_vs
[bc]
adaaaaaaabaaahacabaaaaoeaaaaaaaaanaaaappabaaaaaa mul r1.xyz, a1, c13.w
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
bdaaaaaaaeaaaeaeaaaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 v4.z, r0, c10
bdaaaaaaaeaaacaeaaaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 v4.y, r0, c9
bdaaaaaaaeaaabaeaaaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 v4.x, r0, c8
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
abaaaaaaadaaahaeacaaaakeacaaaaaaamaaaaoeabaaaaaa add v3.xyz, r2.xyzz, c12
aaaaaaaaaaaaacacaaaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r0.y, r0.z
bcaaaaaaacaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v2.z, r1.xyzz, c6
bcaaaaaaacaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v2.y, r1.xyzz, c5
bcaaaaaaacaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v2.x, r1.xyzz, c4
adaaaaaaacaaadacadaaaaoeaaaaaaaaaoaaaaoeabaaaaaa mul r2.xy, a3, c14
abaaaaaaaaaaadaeacaaaafeacaaaaaaaoaaaaooabaaaaaa add v0.xy, r2.xyyy, c14.zwzw
aaaaaaaaabaaadaeaaaaaafeacaaaaaaaaaaaaaaaaaaaaaa mov v1.xy, r0.xyyy
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 208 // 208 used size, 11 vars
Matrix 48 [_LightMatrix0] 4
Vector 192 [_MainTex_ST] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 27 instructions, 2 temp regs, 0 temp arrays:
// ALU 26 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedpgnpcfpimlcgoefhfnnbknkkfenfihmlabaaaaaapaaiaaaaaeaaaaaa
daaaaaaanmacaaaahaahaaaadiaiaaaaebgpgodjkeacaaaakeacaaaaaaacpopp
deacaaaahaaaaaaaagaaceaaaaaagmaaaaaagmaaaaaaceaaabaagmaaaaaaadaa
aeaaabaaaaaaaaaaaaaaamaaabaaafaaaaaaaaaaabaaaaaaabaaagaaaaaaaaaa
acaaaaaaaeaaahaaaaaaaaaaacaaamaaaeaaalaaaaaaaaaaacaabeaaabaaapaa
aaaaaaaaaaaaaaaaaaacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaacia
acaaapjabpaaaaacafaaadiaadaaapjaafaaaaadaaaaadiaaaaaffjaamaaocka
aeaaaaaeaaaaadiaalaaockaaaaaaajaaaaaoeiaaeaaaaaeaaaaadiaanaaocka
aaaakkjaaaaaoeiaaeaaaaaeaaaaamoaaoaacekaaaaappjaaaaaeeiaaeaaaaae
aaaaadoaadaaoejaafaaoekaafaaookaafaaaaadaaaaahiaacaaoejaapaappka
afaaaaadabaaahiaaaaaffiaamaaoekaaeaaaaaeaaaaaliaalaakekaaaaaaaia
abaakeiaaeaaaaaeabaaahoaanaaoekaaaaakkiaaaaapeiaafaaaaadaaaaahia
aaaaffjaamaaoekaaeaaaaaeaaaaahiaalaaoekaaaaaaajaaaaaoeiaaeaaaaae
aaaaahiaanaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaahiaaoaaoekaaaaappja
aaaaoeiaacaaaaadacaaahoaaaaaoeibagaaoekaafaaaaadaaaaapiaaaaaffja
amaaoekaaeaaaaaeaaaaapiaalaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapia
anaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaaoaaoekaaaaappjaaaaaoeia
afaaaaadabaaahiaaaaaffiaacaaoekaaeaaaaaeabaaahiaabaaoekaaaaaaaia
abaaoeiaaeaaaaaeaaaaahiaadaaoekaaaaakkiaabaaoeiaaeaaaaaeadaaahoa
aeaaoekaaaaappiaaaaaoeiaafaaaaadaaaaapiaaaaaffjaaiaaoekaaeaaaaae
aaaaapiaahaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaajaaoekaaaaakkja
aaaaoeiaaeaaaaaeaaaaapiaakaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadma
aaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiappppaaaafdeieefc
imaeaaaaeaaaabaacdabaaaafjaaaaaeegiocaaaaaaaaaaaanaaaaaafjaaaaae
egiocaaaabaaaaaaabaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
mccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaa
gfaaaaadhccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadiaaaaaidcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
igiacaaaacaaaaaaanaaaaaadcaaaaakdcaabaaaaaaaaaaaigiacaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaakdcaabaaaaaaaaaaa
igiacaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaak
mccabaaaabaaaaaaagiicaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaagaebaaa
aaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
amaaaaaaogikcaaaaaaaaaaaamaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaa
acaaaaaapgipcaaaacaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaa
aaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaa
acaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaa
acaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaa
diaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaa
egacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
acaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhccabaaa
adaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaaaaaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaanaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaaaaaaaaaafaaaaaakgakbaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaaaaaaaaaaagaaaaaapgapbaaa
aaaaaaaaegacbaaaaaaaaaaadoaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaa
jiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
acaaaaaaahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaa
laaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofe
aaeoepfcenebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaa
agaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
keaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaa
aaaaaaaaadaaaaaaabaaaaaaamadaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaa
acaaaaaaahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaa
keaaaaaaaeaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "POINT_COOKIE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 427
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    lowp vec3 normal;
    mediump vec3 lightDir;
    highp vec3 _LightCoord;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform samplerCube _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _LightTextureB0;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform highp float _FogRadius;
#line 397
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player3_Pos;
#line 408
#line 422
#line 437
uniform highp vec4 _MainTex_ST;
#line 453
#line 77
highp vec3 WorldSpaceLightDir( in highp vec4 v ) {
    highp vec3 worldPos = (_Object2World * v).xyz;
    return (_WorldSpaceLightPos0.xyz - worldPos);
}
#line 408
void vert( inout appdata_full vertexData, out Input outData ) {
    highp vec4 pos = (glstate_matrix_mvp * vertexData.vertex);
    highp vec4 posWorld = (_Object2World * vertexData.vertex);
    #line 412
    outData.uv_MainTex = vec2( vertexData.texcoord);
    outData.location = posWorld.xz;
}
#line 438
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 441
    Input customInputData;
    vert( v, customInputData);
    o.cust_location = customInputData.location;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 445
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.normal = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    highp vec3 lightDir = WorldSpaceLightDir( v.vertex);
    o.lightDir = lightDir;
    #line 449
    o._LightCoord = (_LightMatrix0 * (_Object2World * v.vertex)).xyz;
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out mediump vec3 xlv_TEXCOORD3;
out highp vec3 xlv_TEXCOORD4;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.pack0);
    xlv_TEXCOORD1 = vec2(xl_retval.cust_location);
    xlv_TEXCOORD2 = vec3(xl_retval.normal);
    xlv_TEXCOORD3 = vec3(xl_retval.lightDir);
    xlv_TEXCOORD4 = vec3(xl_retval._LightCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 427
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    lowp vec3 normal;
    mediump vec3 lightDir;
    highp vec3 _LightCoord;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform samplerCube _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _LightTextureB0;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform highp float _FogRadius;
#line 397
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player3_Pos;
#line 408
#line 422
#line 437
uniform highp vec4 _MainTex_ST;
#line 453
#line 338
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp vec4 c;
    #line 342
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.0));
    c.w = s.Alpha;
    return c;
}
#line 422
highp float powerForPos( in highp vec4 pos, in highp vec2 nearVertex ) {
    highp float atten = clamp( (_FogRadius - length((pos.xz - nearVertex.xy))), 0.0, _FogRadius);
    return (((1.0 / _FogMaxRadius) * atten) / _FogRadius);
}
#line 415
void surf( in Input IN, inout SurfaceOutput o ) {
    #line 417
    lowp vec4 baseColor = (texture( _MainTex, IN.uv_MainTex) * _Color);
    highp float alpha = (1.0 - (((baseColor.w + powerForPos( _Player1_Pos, IN.location)) + powerForPos( _Player2_Pos, IN.location)) + powerForPos( _Player3_Pos, IN.location)));
    o.Albedo = baseColor.xyz;
    o.Alpha = alpha;
}
#line 453
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    #line 457
    surfIN.location = IN.cust_location;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 461
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    #line 465
    surf( surfIN, o);
    lowp vec3 lightDir = normalize(IN.lightDir);
    lowp vec4 c = LightingLambert( o, lightDir, ((texture( _LightTextureB0, vec2( dot( IN._LightCoord, IN._LightCoord))).w * texture( _LightTexture0, IN._LightCoord).w) * 1.0));
    c.w = 0.0;
    #line 469
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in mediump vec3 xlv_TEXCOORD3;
in highp vec3 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec2(xlv_TEXCOORD0);
    xlt_IN.cust_location = vec2(xlv_TEXCOORD1);
    xlt_IN.normal = vec3(xlv_TEXCOORD2);
    xlt_IN.lightDir = vec3(xlv_TEXCOORD3);
    xlt_IN._LightCoord = vec3(xlv_TEXCOORD4);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 14 [unity_Scale]
Matrix 9 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"!!ARBvp1.0
# 18 ALU
PARAM c[16] = { program.local[0],
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[14].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[4].y, R0, c[10];
DP4 result.texcoord[4].x, R0, c[9];
MOV R0.y, R0.z;
DP3 result.texcoord[2].z, R1, c[7];
DP3 result.texcoord[2].y, R1, c[6];
DP3 result.texcoord[2].x, R1, c[5];
MOV result.texcoord[3].xyz, c[13];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[15], c[15].zwzw;
MOV result.texcoord[1].xy, R0;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 18 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 13 [unity_Scale]
Matrix 8 [_LightMatrix0]
Vector 14 [_MainTex_ST]
"vs_2_0
; 18 ALU
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c13.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 oT4.y, r0, c9
dp4 oT4.x, r0, c8
mov r0.y, r0.z
dp3 oT2.z, r1, c6
dp3 oT2.y, r1, c5
dp3 oT2.x, r1, c4
mov oT3.xyz, c12
mad oT0.xy, v2, c14, c14.zwzw
mov oT1.xy, r0
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 208 // 208 used size, 11 vars
Matrix 48 [_LightMatrix0] 4
Vector 192 [_MainTex_ST] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 23 instructions, 2 temp regs, 0 temp arrays:
// ALU 21 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedjdfegclpeipkkljeiobalmghcianddceabaaaaaajmafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcoiadaaaaeaaaabaapkaaaaaafjaaaaae
egiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaaddccabaaaaeaaaaaagiaaaaac
acaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
dcaabaaaaaaaaaaafgbfbaaaaaaaaaaaigiacaaaacaaaaaaanaaaaaadcaaaaak
dcaabaaaaaaaaaaaigiacaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegaabaaa
aaaaaaaadcaaaaakdcaabaaaaaaaaaaaigiacaaaacaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegaabaaaaaaaaaaadcaaaaakmccabaaaabaaaaaaagiicaaaacaaaaaa
apaaaaaapgbpbaaaaaaaaaaaagaebaaaaaaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaamaaaaaaogikcaaaaaaaaaaaamaaaaaa
diaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaacaaaaaabeaaaaaa
diaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaa
dcaaaaaklcaabaaaaaaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaaaaaaaaaaa
egaibaaaabaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaacaaaaaaaoaaaaaa
kgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaaghccabaaaadaaaaaaegiccaaa
abaaaaaaaaaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaamaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaidcaabaaaabaaaaaafgafbaaaaaaaaaaaegiacaaaaaaaaaaaaeaaaaaa
dcaaaaakdcaabaaaaaaaaaaaegiacaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaa
egaabaaaabaaaaaadcaaaaakdcaabaaaaaaaaaaaegiacaaaaaaaaaaaafaaaaaa
kgakbaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaakdccabaaaaeaaaaaaegiacaaa
aaaaaaaaagaaaaaapgapbaaaaaaaaaaaegaabaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform lowp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_5;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = tmpvar_2;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp float tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_5;
  arg0_5 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_6;
  arg0_6 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_7;
  arg0_7 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_8;
  tmpvar_8 = (1.0 - (((tmpvar_4.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_5, arg0_5))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_7, arg0_7))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_3 = tmpvar_8;
  lightDir_2 = xlv_TEXCOORD3;
  lowp vec4 c_9;
  c_9.xyz = ((tmpvar_4.xyz * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, lightDir_2)) * texture2D (_LightTexture0, xlv_TEXCOORD4).w) * 2.0));
  c_9.w = tmpvar_3;
  c_1.xyz = c_9.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform lowp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_5;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = tmpvar_2;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp float tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_5;
  arg0_5 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_6;
  arg0_6 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_7;
  arg0_7 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_8;
  tmpvar_8 = (1.0 - (((tmpvar_4.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_5, arg0_5))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_7, arg0_7))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_3 = tmpvar_8;
  lightDir_2 = xlv_TEXCOORD3;
  lowp vec4 c_9;
  c_9.xyz = ((tmpvar_4.xyz * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, lightDir_2)) * texture2D (_LightTexture0, xlv_TEXCOORD4).w) * 2.0));
  c_9.w = tmpvar_3;
  c_1.xyz = c_9.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 13 [unity_Scale]
Matrix 8 [_LightMatrix0]
Vector 14 [_MainTex_ST]
"agal_vs
[bc]
adaaaaaaabaaahacabaaaaoeaaaaaaaaanaaaappabaaaaaa mul r1.xyz, a1, c13.w
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
bdaaaaaaaeaaacaeaaaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 v4.y, r0, c9
bdaaaaaaaeaaabaeaaaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 v4.x, r0, c8
aaaaaaaaaaaaacacaaaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r0.y, r0.z
bcaaaaaaacaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v2.z, r1.xyzz, c6
bcaaaaaaacaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v2.y, r1.xyzz, c5
bcaaaaaaacaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v2.x, r1.xyzz, c4
aaaaaaaaadaaahaeamaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.xyz, c12
adaaaaaaabaaadacadaaaaoeaaaaaaaaaoaaaaoeabaaaaaa mul r1.xy, a3, c14
abaaaaaaaaaaadaeabaaaafeacaaaaaaaoaaaaooabaaaaaa add v0.xy, r1.xyyy, c14.zwzw
aaaaaaaaabaaadaeaaaaaafeacaaaaaaaaaaaaaaaaaaaaaa mov v1.xy, r0.xyyy
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.zw, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 208 // 208 used size, 11 vars
Matrix 48 [_LightMatrix0] 4
Vector 192 [_MainTex_ST] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 23 instructions, 2 temp regs, 0 temp arrays:
// ALU 21 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecediiegocoipdakepclhojihechkldbmojeabaaaaaapmahaaaaaeaaaaaa
daaaaaaaimacaaaahmagaaaaeeahaaaaebgpgodjfeacaaaafeacaaaaaaacpopp
oeabaaaahaaaaaaaagaaceaaaaaagmaaaaaagmaaaaaaceaaabaagmaaaaaaadaa
aeaaabaaaaaaaaaaaaaaamaaabaaafaaaaaaaaaaabaaaaaaabaaagaaaaaaaaaa
acaaaaaaaeaaahaaaaaaaaaaacaaamaaaeaaalaaaaaaaaaaacaabeaaabaaapaa
aaaaaaaaaaaaaaaaaaacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaacia
acaaapjabpaaaaacafaaadiaadaaapjaafaaaaadaaaaadiaaaaaffjaamaaocka
aeaaaaaeaaaaadiaalaaockaaaaaaajaaaaaoeiaaeaaaaaeaaaaadiaanaaocka
aaaakkjaaaaaoeiaaeaaaaaeaaaaamoaaoaacekaaaaappjaaaaaeeiaaeaaaaae
aaaaadoaadaaoejaafaaoekaafaaookaafaaaaadaaaaahiaacaaoejaapaappka
afaaaaadabaaahiaaaaaffiaamaaoekaaeaaaaaeaaaaaliaalaakekaaaaaaaia
abaakeiaaeaaaaaeabaaahoaanaaoekaaaaakkiaaaaapeiaafaaaaadaaaaapia
aaaaffjaamaaoekaaeaaaaaeaaaaapiaalaaoekaaaaaaajaaaaaoeiaaeaaaaae
aaaaapiaanaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaaoaaoekaaaaappja
aaaaoeiaafaaaaadabaaadiaaaaaffiaacaaoekaaeaaaaaeaaaaadiaabaaoeka
aaaaaaiaabaaoeiaaeaaaaaeaaaaadiaadaaoekaaaaakkiaaaaaoeiaaeaaaaae
adaaadoaaeaaoekaaaaappiaaaaaoeiaafaaaaadaaaaapiaaaaaffjaaiaaoeka
aeaaaaaeaaaaapiaahaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaajaaoeka
aaaakkjaaaaaoeiaaeaaaaaeaaaaapiaakaaoekaaaaappjaaaaaoeiaaeaaaaae
aaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiaabaaaaac
acaaahoaagaaoekappppaaaafdeieefcoiadaaaaeaaaabaapkaaaaaafjaaaaae
egiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaaddccabaaaaeaaaaaagiaaaaac
acaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
dcaabaaaaaaaaaaafgbfbaaaaaaaaaaaigiacaaaacaaaaaaanaaaaaadcaaaaak
dcaabaaaaaaaaaaaigiacaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegaabaaa
aaaaaaaadcaaaaakdcaabaaaaaaaaaaaigiacaaaacaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegaabaaaaaaaaaaadcaaaaakmccabaaaabaaaaaaagiicaaaacaaaaaa
apaaaaaapgbpbaaaaaaaaaaaagaebaaaaaaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaamaaaaaaogikcaaaaaaaaaaaamaaaaaa
diaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaacaaaaaabeaaaaaa
diaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaa
dcaaaaaklcaabaaaaaaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaaaaaaaaaaa
egaibaaaabaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaacaaaaaaaoaaaaaa
kgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaaghccabaaaadaaaaaaegiccaaa
abaaaaaaaaaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaamaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaidcaabaaaabaaaaaafgafbaaaaaaaaaaaegiacaaaaaaaaaaaaeaaaaaa
dcaaaaakdcaabaaaaaaaaaaaegiacaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaa
egaabaaaabaaaaaadcaaaaakdcaabaaaaaaaaaaaegiacaaaaaaaaaaaafaaaaaa
kgakbaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaakdccabaaaaeaaaaaaegiacaaa
aaaaaaaaagaaaaaapgapbaaaaaaaaaaaegaabaaaaaaaaaaadoaaaaabejfdeheo
maaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakjaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaadaaaaaaapadaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaa
apaaaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaadaaaaaaahaiaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaaeaaaaaa
adamaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 400
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 426
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    lowp vec3 normal;
    mediump vec3 lightDir;
    highp vec2 _LightCoord;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
#line 397
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player3_Pos;
#line 407
#line 421
#line 436
uniform highp vec4 _MainTex_ST;
#line 452
#line 77
highp vec3 WorldSpaceLightDir( in highp vec4 v ) {
    highp vec3 worldPos = (_Object2World * v).xyz;
    return _WorldSpaceLightPos0.xyz;
}
#line 407
void vert( inout appdata_full vertexData, out Input outData ) {
    highp vec4 pos = (glstate_matrix_mvp * vertexData.vertex);
    highp vec4 posWorld = (_Object2World * vertexData.vertex);
    #line 411
    outData.uv_MainTex = vec2( vertexData.texcoord);
    outData.location = posWorld.xz;
}
#line 437
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 440
    Input customInputData;
    vert( v, customInputData);
    o.cust_location = customInputData.location;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 444
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.normal = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    highp vec3 lightDir = WorldSpaceLightDir( v.vertex);
    o.lightDir = lightDir;
    #line 448
    o._LightCoord = (_LightMatrix0 * (_Object2World * v.vertex)).xy;
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out mediump vec3 xlv_TEXCOORD3;
out highp vec2 xlv_TEXCOORD4;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.pack0);
    xlv_TEXCOORD1 = vec2(xl_retval.cust_location);
    xlv_TEXCOORD2 = vec3(xl_retval.normal);
    xlv_TEXCOORD3 = vec3(xl_retval.lightDir);
    xlv_TEXCOORD4 = vec2(xl_retval._LightCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 400
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 426
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    lowp vec3 normal;
    mediump vec3 lightDir;
    highp vec2 _LightCoord;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
#line 397
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player3_Pos;
#line 407
#line 421
#line 436
uniform highp vec4 _MainTex_ST;
#line 452
#line 338
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp vec4 c;
    #line 342
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.0));
    c.w = s.Alpha;
    return c;
}
#line 421
highp float powerForPos( in highp vec4 pos, in highp vec2 nearVertex ) {
    highp float atten = clamp( (_FogRadius - length((pos.xz - nearVertex.xy))), 0.0, _FogRadius);
    return (((1.0 / _FogMaxRadius) * atten) / _FogRadius);
}
#line 414
void surf( in Input IN, inout SurfaceOutput o ) {
    #line 416
    lowp vec4 baseColor = (texture( _MainTex, IN.uv_MainTex) * _Color);
    highp float alpha = (1.0 - (((baseColor.w + powerForPos( _Player1_Pos, IN.location)) + powerForPos( _Player2_Pos, IN.location)) + powerForPos( _Player3_Pos, IN.location)));
    o.Albedo = baseColor.xyz;
    o.Alpha = alpha;
}
#line 452
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    #line 456
    surfIN.location = IN.cust_location;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 460
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    #line 464
    surf( surfIN, o);
    lowp vec3 lightDir = IN.lightDir;
    lowp vec4 c = LightingLambert( o, lightDir, (texture( _LightTexture0, IN._LightCoord).w * 1.0));
    c.w = 0.0;
    #line 468
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in mediump vec3 xlv_TEXCOORD3;
in highp vec2 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec2(xlv_TEXCOORD0);
    xlt_IN.cust_location = vec2(xlv_TEXCOORD1);
    xlt_IN.normal = vec3(xlv_TEXCOORD2);
    xlt_IN.lightDir = vec3(xlv_TEXCOORD3);
    xlt_IN._LightCoord = vec2(xlv_TEXCOORD4);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 5
//   opengl - ALU: 9 to 20, TEX: 1 to 3
//   d3d9 - ALU: 9 to 19, TEX: 1 to 3
//   d3d11 - ALU: 6 to 16, TEX: 1 to 3, FLOW: 1 to 1
//   d3d11_9x - ALU: 6 to 16, TEX: 1 to 3, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"!!ARBfp1.0
# 14 ALU, 2 TEX
PARAM c[8] = { program.local[0..6],
		{ 0, 2 } };
TEMP R0;
TEMP R1;
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
DP3 R0.w, fragment.texcoord[4], fragment.texcoord[4];
DP3 R1.x, fragment.texcoord[3], fragment.texcoord[3];
RSQ R1.x, R1.x;
MUL R1.xyz, R1.x, fragment.texcoord[3];
MUL R0.xyz, R0, c[1];
DP3 R1.x, fragment.texcoord[2], R1;
MUL R0.xyz, R0, c[0];
MAX R1.x, R1, c[7];
MOV result.color.w, c[7].x;
TEX R0.w, R0.w, texture[1], 2D;
MUL R0.w, R1.x, R0;
MUL R0.xyz, R0.w, R0;
MUL result.color.xyz, R0, c[7].y;
END
# 14 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"ps_2_0
; 14 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c2, 0.00000000, 2.00000000, 0, 0
dcl t0.xy
dcl t2.xyz
dcl t3.xyz
dcl t4.xyz
texld r1, t0, s0
dp3 r0.x, t4, t4
mov r0.xy, r0.x
mul r1.xyz, r1, c1
mul_pp r1.xyz, r1, c0
mov_pp r0.w, c2.x
texld r2, r0, s1
dp3_pp r0.x, t3, t3
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, t3
dp3_pp r0.x, t2, r0
max_pp r0.x, r0, c2
mul_pp r0.x, r0, r2
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c2.y
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "POINT" }
ConstBuffer "$Globals" 208 // 128 used size, 11 vars
Vector 16 [_LightColor0] 4
Vector 112 [_Color] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_LightTexture0] 2D 0
// 14 instructions, 2 temp regs, 0 temp arrays:
// ALU 10 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecednnmfanolfealmlplnckbdgdafdaagnloabaaaaaacmadaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amaaaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcamacaaaa
eaaaaaaaidaaaaaafjaaaaaeegiocaaaaaaaaaaaaiaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaabaaaaaahbcaabaaaaaaaaaaa
egbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaaagaabaaaaaaaaaaaegbcbaaaadaaaaaa
baaaaaahbcaabaaaaaaaaaaaegbcbaaaacaaaaaaegacbaaaaaaaaaaadeaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaabaaaaaahccaabaaa
aaaaaaaaegbcbaaaaeaaaaaaegbcbaaaaeaaaaaaefaaaaajpcaabaaaabaaaaaa
fgafbaaaaaaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaaapaaaaahbcaabaaa
aaaaaaaaagaabaaaaaaaaaaaagaabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaaiocaabaaa
aaaaaaaaagajbaaaabaaaaaaagijcaaaaaaaaaaaahaaaaaadiaaaaaiocaabaaa
aaaaaaaafgaobaaaaaaaaaaaagijcaaaaaaaaaaaabaaaaaadiaaaaahhccabaaa
aaaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaa
abeaaaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "POINT" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"agal_ps
c2 0.0 2.0 0.0 0.0
[bc]
ciaaaaaaabaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r1, v0, s0 <2d wrap linear point>
bcaaaaaaaaaaabacaeaaaaoeaeaaaaaaaeaaaaoeaeaaaaaa dp3 r0.x, v4, v4
aaaaaaaaaaaaadacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.xy, r0.x
adaaaaaaabaaahacabaaaakeacaaaaaaabaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c1
adaaaaaaabaaahacabaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c0
ciaaaaaaaaaaapacaaaaaafeacaaaaaaabaaaaaaafaababb tex r0, r0.xyyy, s1 <2d wrap linear point>
bcaaaaaaaaaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r0.x, v3, v3
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r0.xyz, r0.x, v3
bcaaaaaaaaaaabacacaaaaoeaeaaaaaaaaaaaakeacaaaaaa dp3 r0.x, v2, r0.xyzz
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaacaaaaoeabaaaaaa max r0.x, r0.x, c2
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaappacaaaaaa mul r0.x, r0.x, r0.w
adaaaaaaaaaaahacaaaaaaaaacaaaaaaabaaaakeacaaaaaa mul r0.xyz, r0.x, r1.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaacaaaaffabaaaaaa mul r0.xyz, r0.xyzz, c2.y
aaaaaaaaaaaaaiacacaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c2.x
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { "POINT" }
ConstBuffer "$Globals" 208 // 128 used size, 11 vars
Vector 16 [_LightColor0] 4
Vector 112 [_Color] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_LightTexture0] 2D 0
// 14 instructions, 2 temp regs, 0 temp arrays:
// ALU 10 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedpnjppoflfgbbclmdebheaflmdipepbfnabaaaaaaliaeaaaaaeaaaaaa
daaaaaaaliabaaaammadaaaaieaeaaaaebgpgodjiaabaaaaiaabaaaaaaacpppp
dmabaaaaeeaaaaaaacaacmaaaaaaeeaaaaaaeeaaacaaceaaaaaaeeaaabaaaaaa
aaababaaaaaaabaaabaaaaaaaaaaaaaaaaaaahaaabaaabaaaaaaaaaaaaacpppp
fbaaaaafacaaapkaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabpaaaaacaaaaaaia
aaaaaplabpaaaaacaaaaaaiaabaachlabpaaaaacaaaaaaiaacaachlabpaaaaac
aaaaaaiaadaaahlabpaaaaacaaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapka
aiaaaaadaaaaaiiaadaaoelaadaaoelaabaaaaacaaaaadiaaaaappiaecaaaaad
aaaacpiaaaaaoeiaaaaioekaecaaaaadabaaapiaaaaaoelaabaioekaceaaaaac
acaachiaacaaoelaaiaaaaadabaaciiaabaaoelaacaaoeiaafaaaaadaaaacbia
aaaaaaiaabaappiafiaaaaaeabaaciiaabaappiaaaaaaaiaacaaaakaacaaaaad
abaaciiaabaappiaabaappiaafaaaaadaaaachiaabaaoeiaabaaoekaafaaaaad
aaaachiaaaaaoeiaaaaaoekaafaaaaadaaaachiaabaappiaaaaaoeiaabaaaaac
aaaaciiaacaaaakaabaaaaacaaaicpiaaaaaoeiappppaaaafdeieefcamacaaaa
eaaaaaaaidaaaaaafjaaaaaeegiocaaaaaaaaaaaaiaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaabaaaaaahbcaabaaaaaaaaaaa
egbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaaagaabaaaaaaaaaaaegbcbaaaadaaaaaa
baaaaaahbcaabaaaaaaaaaaaegbcbaaaacaaaaaaegacbaaaaaaaaaaadeaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaabaaaaaahccaabaaa
aaaaaaaaegbcbaaaaeaaaaaaegbcbaaaaeaaaaaaefaaaaajpcaabaaaabaaaaaa
fgafbaaaaaaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaaapaaaaahbcaabaaa
aaaaaaaaagaabaaaaaaaaaaaagaabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaaiocaabaaa
aaaaaaaaagajbaaaabaaaaaaagijcaaaaaaaaaaaahaaaaaadiaaaaaiocaabaaa
aaaaaaaafgaobaaaaaaaaaaaagijcaaaaaaaaaaaabaaaaaadiaaaaahhccabaaa
aaaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaa
abeaaaaaaaaaaaaadoaaaaabejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amaaaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { "POINT" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
# 9 ALU, 1 TEX
PARAM c[8] = { program.local[0..6],
		{ 0, 2 } };
TEMP R0;
TEMP R1;
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
MOV R1.xyz, fragment.texcoord[3];
MUL R0.xyz, R0, c[1];
DP3 R0.w, fragment.texcoord[2], R1;
MUL R0.xyz, R0, c[0];
MAX R0.w, R0, c[7].x;
MUL R0.xyz, R0.w, R0;
MUL result.color.xyz, R0, c[7].y;
MOV result.color.w, c[7].x;
END
# 9 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 9 ALU, 1 TEX
dcl_2d s0
def c2, 0.00000000, 2.00000000, 0, 0
dcl t0.xy
dcl t2.xyz
dcl t3.xyz
texld r1, t0, s0
mov_pp r0.xyz, t3
dp3_pp r0.x, t2, r0
mul r1.xyz, r1, c1
mul_pp r1.xyz, r1, c0
max_pp r0.x, r0, c2
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c2.y
mov_pp r0.w, c2.x
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" }
ConstBuffer "$Globals" 144 // 64 used size, 10 vars
Vector 16 [_LightColor0] 4
Vector 48 [_Color] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
// 9 instructions, 1 temp regs, 0 temp arrays:
// ALU 6 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedcljhlbclfoailfkpgamclbccbcbhpmkpabaaaaaagaacaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amaaaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcfiabaaaaeaaaaaaafgaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaa
fkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaad
dcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacabaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaabaaaaaahicaabaaa
aaaaaaaaegbcbaaaacaaaaaaegbcbaaaadaaaaaadeaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaaaaaaaaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahhccabaaaaaaaaaaapgapbaaaaaaaaaaa
egacbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
"agal_ps
c2 0.0 2.0 0.0 0.0
[bc]
ciaaaaaaabaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r1, v0, s0 <2d wrap linear point>
aaaaaaaaaaaaahacadaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, v3
bcaaaaaaaaaaabacacaaaaoeaeaaaaaaaaaaaakeacaaaaaa dp3 r0.x, v2, r0.xyzz
adaaaaaaabaaahacabaaaakeacaaaaaaabaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c1
adaaaaaaabaaahacabaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c0
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaacaaaaoeabaaaaaa max r0.x, r0.x, c2
adaaaaaaaaaaahacaaaaaaaaacaaaaaaabaaaakeacaaaaaa mul r0.xyz, r0.x, r1.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaacaaaaffabaaaaaa mul r0.xyz, r0.xyzz, c2.y
aaaaaaaaaaaaaiacacaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c2.x
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" }
ConstBuffer "$Globals" 144 // 64 used size, 10 vars
Vector 16 [_LightColor0] 4
Vector 48 [_Color] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
// 9 instructions, 1 temp regs, 0 temp arrays:
// ALU 6 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedpmcgmonmgikiefiiaolncpcfggaflacdabaaaaaajaadaaaaaeaaaaaa
daaaaaaafmabaaaalmacaaaafmadaaaaebgpgodjceabaaaaceabaaaaaaacpppp
oeaaaaaaeaaaaaaaacaaciaaaaaaeaaaaaaaeaaaabaaceaaaaaaeaaaaaaaaaaa
aaaaabaaabaaaaaaaaaaaaaaaaaaadaaabaaabaaaaaaaaaaaaacppppfbaaaaaf
acaaapkaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabpaaaaacaaaaaaiaaaaaapla
bpaaaaacaaaaaaiaabaachlabpaaaaacaaaaaaiaacaachlabpaaaaacaaaaaaja
aaaiapkaecaaaaadaaaaapiaaaaaoelaaaaioekaafaaaaadaaaachiaaaaaoeia
abaaoekaafaaaaadaaaachiaaaaaoeiaaaaaoekaabaaaaacabaaahiaabaaoela
aiaaaaadaaaaciiaabaaoeiaacaaoelaalaaaaadabaacbiaaaaappiaacaaaaka
acaaaaadaaaaciiaabaaaaiaabaaaaiaafaaaaadaaaachiaaaaappiaaaaaoeia
abaaaaacaaaaaiiaacaaaakaabaaaaacaaaicpiaaaaaoeiappppaaaafdeieefc
fiabaaaaeaaaaaaafgaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaafkaaaaad
aagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaaddcbabaaa
abaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacabaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaabaaaaaahicaabaaaaaaaaaaa
egbcbaaaacaaaaaaegbcbaaaadaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaaaaaaaaaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhccabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaabejfdeheo
jiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaa
apaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaaimaaaaaa
abaaaaaaaaaaaaaaadaaaaaaabaaaaaaamaaaaaaimaaaaaaacaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahahaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"!!ARBfp1.0
# 20 ALU, 3 TEX
PARAM c[8] = { program.local[0..6],
		{ 0, 0.5, 2 } };
TEMP R0;
TEMP R1;
RCP R0.x, fragment.texcoord[4].w;
MAD R1.xy, fragment.texcoord[4], R0.x, c[7].y;
DP3 R1.z, fragment.texcoord[4], fragment.texcoord[4];
MOV result.color.w, c[7].x;
TEX R0.w, R1, texture[1], 2D;
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
TEX R1.w, R1.z, texture[2], 2D;
DP3 R1.x, fragment.texcoord[3], fragment.texcoord[3];
RSQ R1.x, R1.x;
MUL R1.xyz, R1.x, fragment.texcoord[3];
DP3 R1.x, fragment.texcoord[2], R1;
SLT R1.y, c[7].x, fragment.texcoord[4].z;
MUL R0.w, R1.y, R0;
MUL R1.y, R0.w, R1.w;
MUL R0.xyz, R0, c[1];
MAX R0.w, R1.x, c[7].x;
MUL R0.xyz, R0, c[0];
MUL R0.w, R0, R1.y;
MUL R0.xyz, R0.w, R0;
MUL result.color.xyz, R0, c[7].z;
END
# 20 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"ps_2_0
; 19 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c2, 0.50000000, 0.00000000, 1.00000000, 2.00000000
dcl t0.xy
dcl t2.xyz
dcl t3.xyz
dcl t4
texld r2, t0, s0
dp3 r0.x, t4, t4
rcp r1.x, t4.w
mov r0.xy, r0.x
mad r1.xy, t4, r1.x, c2.x
mul r2.xyz, r2, c1
mul_pp r2.xyz, r2, c0
texld r0, r0, s2
texld r1, r1, s1
cmp r1.x, -t4.z, c2.y, c2.z
mul_pp r3.x, r1, r1.w
dp3_pp r1.x, t3, t3
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, t3
dp3_pp r1.x, t2, r1
mul_pp r0.x, r3, r0
max_pp r1.x, r1, c2.y
mul_pp r0.x, r1, r0
mul_pp r0.xyz, r0.x, r2
mul_pp r0.xyz, r0, c2.w
mov_pp r0.w, c2.y
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "SPOT" }
ConstBuffer "$Globals" 208 // 128 used size, 11 vars
Vector 16 [_LightColor0] 4
Vector 112 [_Color] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 2
SetTexture 1 [_LightTexture0] 2D 0
SetTexture 2 [_LightTextureB0] 2D 1
// 21 instructions, 2 temp regs, 0 temp arrays:
// ALU 15 float, 0 int, 1 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecednkepmjkfndnpadkpepehfjhljmljjneaabaaaaaacaaeaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amaaaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcaaadaaaa
eaaaaaaamaaaaaaafjaaaaaeegiocaaaaaaaaaaaaiaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaae
aahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadpcbabaaaaeaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacacaaaaaaaoaaaaahdcaabaaaaaaaaaaaegbabaaa
aeaaaaaapgbpbaaaaeaaaaaaaaaaaaakdcaabaaaaaaaaaaaegaabaaaaaaaaaaa
aceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaaefaaaaajpcaabaaaaaaaaaaa
egaabaaaaaaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaadbaaaaahbcaabaaa
aaaaaaaaabeaaaaaaaaaaaaackbabaaaaeaaaaaaabaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaahbcaabaaaaaaaaaaadkaabaaa
aaaaaaaaakaabaaaaaaaaaaabaaaaaahccaabaaaaaaaaaaaegbcbaaaaeaaaaaa
egbcbaaaaeaaaaaaefaaaaajpcaabaaaabaaaaaafgafbaaaaaaaaaaaeghobaaa
acaaaaaaaagabaaaabaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
akaabaaaabaaaaaabaaaaaahccaabaaaaaaaaaaaegbcbaaaadaaaaaaegbcbaaa
adaaaaaaeeaaaaafccaabaaaaaaaaaaabkaabaaaaaaaaaaadiaaaaahocaabaaa
aaaaaaaafgafbaaaaaaaaaaaagbjbaaaadaaaaaabaaaaaahccaabaaaaaaaaaaa
egbcbaaaacaaaaaajgahbaaaaaaaaaaadeaaaaahccaabaaaaaaaaaaabkaabaaa
aaaaaaaaabeaaaaaaaaaaaaaapaaaaahbcaabaaaaaaaaaaafgafbaaaaaaaaaaa
agaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaa
aaaaaaaaaagabaaaacaaaaaadiaaaaaiocaabaaaaaaaaaaaagajbaaaabaaaaaa
agijcaaaaaaaaaaaahaaaaaadiaaaaaiocaabaaaaaaaaaaafgaobaaaaaaaaaaa
agijcaaaaaaaaaaaabaaaaaadiaaaaahhccabaaaaaaaaaaaagaabaaaaaaaaaaa
jgahbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "SPOT" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"agal_ps
c2 0.5 0.0 1.0 2.0
[bc]
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r2, v0, s0 <2d wrap linear point>
bcaaaaaaaaaaabacaeaaaaoeaeaaaaaaaeaaaaoeaeaaaaaa dp3 r0.x, v4, v4
afaaaaaaabaaabacaeaaaappaeaaaaaaaaaaaaaaaaaaaaaa rcp r1.x, v4.w
aaaaaaaaaaaaadacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.xy, r0.x
adaaaaaaabaaadacaeaaaaoeaeaaaaaaabaaaaaaacaaaaaa mul r1.xy, v4, r1.x
abaaaaaaabaaadacabaaaafeacaaaaaaacaaaaaaabaaaaaa add r1.xy, r1.xyyy, c2.x
adaaaaaaacaaahacacaaaakeacaaaaaaabaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c1
adaaaaaaacaaahacacaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c0
ciaaaaaaabaaapacabaaaafeacaaaaaaabaaaaaaafaababb tex r1, r1.xyyy, s1 <2d wrap linear point>
ciaaaaaaaaaaapacaaaaaafeacaaaaaaacaaaaaaafaababb tex r0, r0.xyyy, s2 <2d wrap linear point>
bfaaaaaaacaaaiacaeaaaakkaeaaaaaaaaaaaaaaaaaaaaaa neg r2.w, v4.z
ckaaaaaaaaaaabacacaaaappacaaaaaaacaaaaffabaaaaaa slt r0.x, r2.w, c2.y
adaaaaaaaaaaabacaaaaaaaaacaaaaaaabaaaappacaaaaaa mul r0.x, r0.x, r1.w
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaappacaaaaaa mul r0.x, r0.x, r0.w
bcaaaaaaabaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r1.x, v3, v3
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
adaaaaaaabaaahacabaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r1.xyz, r1.x, v3
bcaaaaaaabaaabacacaaaaoeaeaaaaaaabaaaakeacaaaaaa dp3 r1.x, v2, r1.xyzz
ahaaaaaaabaaabacabaaaaaaacaaaaaaacaaaaffabaaaaaa max r1.x, r1.x, c2.y
adaaaaaaaaaaabacabaaaaaaacaaaaaaaaaaaaaaacaaaaaa mul r0.x, r1.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaakeacaaaaaa mul r0.xyz, r0.x, r2.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaacaaaappabaaaaaa mul r0.xyz, r0.xyzz, c2.w
aaaaaaaaaaaaaiacacaaaaffabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c2.y
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { "SPOT" }
ConstBuffer "$Globals" 208 // 128 used size, 11 vars
Vector 16 [_LightColor0] 4
Vector 112 [_Color] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 2
SetTexture 1 [_LightTexture0] 2D 0
SetTexture 2 [_LightTextureB0] 2D 1
// 21 instructions, 2 temp regs, 0 temp arrays:
// ALU 15 float, 0 int, 1 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedoihfddagnhelopdnnhicegkclhkbppccabaaaaaaamagaaaaaeaaaaaa
daaaaaaabiacaaaacaafaaaaniafaaaaebgpgodjoaabaaaaoaabaaaaaaacpppp
jiabaaaaeiaaaaaaacaadaaaaaaaeiaaaaaaeiaaadaaceaaaaaaeiaaabaaaaaa
acababaaaaacacaaaaaaabaaabaaaaaaaaaaaaaaaaaaahaaabaaabaaaaaaaaaa
aaacppppfbaaaaafacaaapkaaaaaaadpaaaaaaaaaaaaaaaaaaaaaaaabpaaaaac
aaaaaaiaaaaaaplabpaaaaacaaaaaaiaabaachlabpaaaaacaaaaaaiaacaachla
bpaaaaacaaaaaaiaadaaaplabpaaaaacaaaaaajaaaaiapkabpaaaaacaaaaaaja
abaiapkabpaaaaacaaaaaajaacaiapkaagaaaaacaaaaaiiaadaapplaaeaaaaae
aaaaadiaadaaoelaaaaappiaacaaaakaaiaaaaadabaaaiiaadaaoelaadaaoela
abaaaaacabaaadiaabaappiaecaaaaadaaaacpiaaaaaoeiaaaaioekaecaaaaad
abaacpiaabaaoeiaabaioekaecaaaaadacaaapiaaaaaoelaacaioekaafaaaaad
acaaciiaaaaappiaabaaaaiafiaaaaaeacaaciiaadaakklbacaaffkaacaappia
ceaaaaacaaaachiaacaaoelaaiaaaaadaaaacbiaabaaoelaaaaaoeiaalaaaaad
abaacbiaaaaaaaiaacaaffkaafaaaaadacaaciiaacaappiaabaaaaiaacaaaaad
acaaciiaacaappiaacaappiaafaaaaadaaaachiaacaaoeiaabaaoekaafaaaaad
aaaachiaaaaaoeiaaaaaoekaafaaaaadaaaachiaacaappiaaaaaoeiaabaaaaac
aaaaaiiaacaaffkaabaaaaacaaaicpiaaaaaoeiappppaaaafdeieefcaaadaaaa
eaaaaaaamaaaaaaafjaaaaaeegiocaaaaaaaaaaaaiaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaae
aahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadpcbabaaaaeaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacacaaaaaaaoaaaaahdcaabaaaaaaaaaaaegbabaaa
aeaaaaaapgbpbaaaaeaaaaaaaaaaaaakdcaabaaaaaaaaaaaegaabaaaaaaaaaaa
aceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaaefaaaaajpcaabaaaaaaaaaaa
egaabaaaaaaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaadbaaaaahbcaabaaa
aaaaaaaaabeaaaaaaaaaaaaackbabaaaaeaaaaaaabaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaahbcaabaaaaaaaaaaadkaabaaa
aaaaaaaaakaabaaaaaaaaaaabaaaaaahccaabaaaaaaaaaaaegbcbaaaaeaaaaaa
egbcbaaaaeaaaaaaefaaaaajpcaabaaaabaaaaaafgafbaaaaaaaaaaaeghobaaa
acaaaaaaaagabaaaabaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
akaabaaaabaaaaaabaaaaaahccaabaaaaaaaaaaaegbcbaaaadaaaaaaegbcbaaa
adaaaaaaeeaaaaafccaabaaaaaaaaaaabkaabaaaaaaaaaaadiaaaaahocaabaaa
aaaaaaaafgafbaaaaaaaaaaaagbjbaaaadaaaaaabaaaaaahccaabaaaaaaaaaaa
egbcbaaaacaaaaaajgahbaaaaaaaaaaadeaaaaahccaabaaaaaaaaaaabkaabaaa
aaaaaaaaabeaaaaaaaaaaaaaapaaaaahbcaabaaaaaaaaaaafgafbaaaaaaaaaaa
agaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaa
aaaaaaaaaagabaaaacaaaaaadiaaaaaiocaabaaaaaaaaaaaagajbaaaabaaaaaa
agijcaaaaaaaaaaaahaaaaaadiaaaaaiocaabaaaaaaaaaaafgaobaaaaaaaaaaa
agijcaaaaaaaaaaaabaaaaaadiaaaaahhccabaaaaaaaaaaaagaabaaaaaaaaaaa
jgahbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaab
ejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaa
keaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamaaaaaakeaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaahahaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaa
adaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaa
abaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaa
fdfgfpfegbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { "SPOT" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"!!ARBfp1.0
# 16 ALU, 3 TEX
PARAM c[8] = { program.local[0..6],
		{ 0, 2 } };
TEMP R0;
TEMP R1;
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
TEX R1.w, fragment.texcoord[4], texture[2], CUBE;
DP3 R0.w, fragment.texcoord[4], fragment.texcoord[4];
DP3 R1.x, fragment.texcoord[3], fragment.texcoord[3];
RSQ R1.x, R1.x;
MUL R1.xyz, R1.x, fragment.texcoord[3];
MUL R0.xyz, R0, c[1];
DP3 R1.x, fragment.texcoord[2], R1;
MUL R0.xyz, R0, c[0];
MOV result.color.w, c[7].x;
TEX R0.w, R0.w, texture[1], 2D;
MUL R1.y, R0.w, R1.w;
MAX R0.w, R1.x, c[7].x;
MUL R0.w, R0, R1.y;
MUL R0.xyz, R0.w, R0;
MUL result.color.xyz, R0, c[7].y;
END
# 16 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"ps_2_0
; 15 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c2, 0.00000000, 2.00000000, 0, 0
dcl t0.xy
dcl t2.xyz
dcl t3.xyz
dcl t4.xyz
texld r2, t4, s2
texld r1, t0, s0
dp3 r0.x, t4, t4
mov r0.xy, r0.x
dp3_pp r2.x, t3, t3
rsq_pp r2.x, r2.x
mul_pp r2.xyz, r2.x, t3
mul r1.xyz, r1, c1
dp3_pp r2.x, t2, r2
mul_pp r1.xyz, r1, c0
max_pp r2.x, r2, c2
texld r0, r0, s1
mul r0.x, r0, r2.w
mul_pp r0.x, r2, r0
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c2.y
mov_pp r0.w, c2.x
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" }
ConstBuffer "$Globals" 208 // 128 used size, 11 vars
Vector 16 [_LightColor0] 4
Vector 112 [_Color] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 2
SetTexture 1 [_LightTextureB0] 2D 1
SetTexture 2 [_LightTexture0] CUBE 0
// 16 instructions, 3 temp regs, 0 temp arrays:
// ALU 11 float, 0 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedilodnplohjidikjnfbeppbijejalkicmabaaaaaaiiadaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amaaaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcgiacaaaa
eaaaaaaajkaaaaaafjaaaaaeegiocaaaaaaaaaaaaiaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafidaaaae
aahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacadaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaa
adaaaaaaegbcbaaaadaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
diaaaaahhcaabaaaaaaaaaaaagaabaaaaaaaaaaaegbcbaaaadaaaaaabaaaaaah
bcaabaaaaaaaaaaaegbcbaaaacaaaaaaegacbaaaaaaaaaaadeaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaabaaaaaahccaabaaaaaaaaaaa
egbcbaaaaeaaaaaaegbcbaaaaeaaaaaaefaaaaajpcaabaaaabaaaaaafgafbaaa
aaaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaaacaaaaaa
egbcbaaaaeaaaaaaeghobaaaacaaaaaaaagabaaaaaaaaaaadiaaaaahccaabaaa
aaaaaaaaakaabaaaabaaaaaadkaabaaaacaaaaaaapaaaaahbcaabaaaaaaaaaaa
agaabaaaaaaaaaaafgafbaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaacaaaaaadiaaaaaiocaabaaaaaaaaaaa
agajbaaaabaaaaaaagijcaaaaaaaaaaaahaaaaaadiaaaaaiocaabaaaaaaaaaaa
fgaobaaaaaaaaaaaagijcaaaaaaaaaaaabaaaaaadiaaaaahhccabaaaaaaaaaaa
agaabaaaaaaaaaaajgahbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaa
aaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"agal_ps
c2 0.0 2.0 0.0 0.0
[bc]
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r2, v0, s0 <2d wrap linear point>
bcaaaaaaaaaaabacaeaaaaoeaeaaaaaaaeaaaaoeaeaaaaaa dp3 r0.x, v4, v4
aaaaaaaaaaaaadacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.xy, r0.x
adaaaaaaacaaahacacaaaakeacaaaaaaabaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c1
adaaaaaaacaaahacacaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c0
ciaaaaaaabaaapacaaaaaafeacaaaaaaabaaaaaaafaababb tex r1, r0.xyyy, s1 <2d wrap linear point>
ciaaaaaaaaaaapacaeaaaaoeaeaaaaaaacaaaaaaafbababb tex r0, v4, s2 <cube wrap linear point>
adaaaaaaaaaaabacabaaaappacaaaaaaaaaaaappacaaaaaa mul r0.x, r1.w, r0.w
bcaaaaaaabaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r1.x, v3, v3
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
adaaaaaaabaaahacabaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r1.xyz, r1.x, v3
bcaaaaaaabaaabacacaaaaoeaeaaaaaaabaaaakeacaaaaaa dp3 r1.x, v2, r1.xyzz
ahaaaaaaabaaabacabaaaaaaacaaaaaaacaaaaoeabaaaaaa max r1.x, r1.x, c2
adaaaaaaaaaaabacabaaaaaaacaaaaaaaaaaaaaaacaaaaaa mul r0.x, r1.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaakeacaaaaaa mul r0.xyz, r0.x, r2.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaacaaaaffabaaaaaa mul r0.xyz, r0.xyzz, c2.y
aaaaaaaaaaaaaiacacaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c2.x
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { "POINT_COOKIE" }
ConstBuffer "$Globals" 208 // 128 used size, 11 vars
Vector 16 [_LightColor0] 4
Vector 112 [_Color] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 2
SetTexture 1 [_LightTextureB0] 2D 1
SetTexture 2 [_LightTexture0] CUBE 0
// 16 instructions, 3 temp regs, 0 temp arrays:
// ALU 11 float, 0 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedgckoacbclhiehhjhgheliagjhbefbaloabaaaaaaeaafaaaaaeaaaaaa
daaaaaaaoeabaaaafeaeaaaaamafaaaaebgpgodjkmabaaaakmabaaaaaaacpppp
geabaaaaeiaaaaaaacaadaaaaaaaeiaaaaaaeiaaadaaceaaaaaaeiaaacaaaaaa
abababaaaaacacaaaaaaabaaabaaaaaaaaaaaaaaaaaaahaaabaaabaaaaaaaaaa
aaacppppfbaaaaafacaaapkaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabpaaaaac
aaaaaaiaaaaaaplabpaaaaacaaaaaaiaabaachlabpaaaaacaaaaaaiaacaachla
bpaaaaacaaaaaaiaadaaahlabpaaaaacaaaaaajiaaaiapkabpaaaaacaaaaaaja
abaiapkabpaaaaacaaaaaajaacaiapkaaiaaaaadaaaaaiiaadaaoelaadaaoela
abaaaaacaaaaadiaaaaappiaecaaaaadaaaaapiaaaaaoeiaabaioekaecaaaaad
abaaapiaadaaoelaaaaioekaecaaaaadacaaapiaaaaaoelaacaioekaafaaaaad
acaaciiaaaaaaaiaabaappiaceaaaaacaaaachiaacaaoelaaiaaaaadaaaacbia
abaaoelaaaaaoeiaalaaaaadabaacbiaaaaaaaiaacaaaakaafaaaaadacaaciia
acaappiaabaaaaiaacaaaaadacaaciiaacaappiaacaappiaafaaaaadaaaachia
acaaoeiaabaaoekaafaaaaadaaaachiaaaaaoeiaaaaaoekaafaaaaadaaaachia
acaappiaaaaaoeiaabaaaaacaaaaciiaacaaaakaabaaaaacaaaicpiaaaaaoeia
ppppaaaafdeieefcgiacaaaaeaaaaaaajkaaaaaafjaaaaaeegiocaaaaaaaaaaa
aiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaad
aagabaaaacaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaafidaaaaeaahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaa
abaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaad
hcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaabaaaaaah
bcaabaaaaaaaaaaaegbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaagaabaaaaaaaaaaa
egbcbaaaadaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaacaaaaaaegacbaaa
aaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaa
baaaaaahccaabaaaaaaaaaaaegbcbaaaaeaaaaaaegbcbaaaaeaaaaaaefaaaaaj
pcaabaaaabaaaaaafgafbaaaaaaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaa
efaaaaajpcaabaaaacaaaaaaegbcbaaaaeaaaaaaeghobaaaacaaaaaaaagabaaa
aaaaaaaadiaaaaahccaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaaacaaaaaa
apaaaaahbcaabaaaaaaaaaaaagaabaaaaaaaaaaafgafbaaaaaaaaaaaefaaaaaj
pcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaacaaaaaa
diaaaaaiocaabaaaaaaaaaaaagajbaaaabaaaaaaagijcaaaaaaaaaaaahaaaaaa
diaaaaaiocaabaaaaaaaaaaafgaobaaaaaaaaaaaagijcaaaaaaaaaaaabaaaaaa
diaaaaahhccabaaaaaaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaadgaaaaaf
iccabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaabejfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamaaaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
"
}

SubProgram "gles3 " {
Keywords { "POINT_COOKIE" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"!!ARBfp1.0
# 11 ALU, 2 TEX
PARAM c[8] = { program.local[0..6],
		{ 0, 2 } };
TEMP R0;
TEMP R1;
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
TEX R0.w, fragment.texcoord[4], texture[1], 2D;
MOV R1.xyz, fragment.texcoord[3];
MUL R0.xyz, R0, c[1];
DP3 R1.x, fragment.texcoord[2], R1;
MAX R1.x, R1, c[7];
MUL R0.xyz, R0, c[0];
MUL R0.w, R1.x, R0;
MUL R0.xyz, R0.w, R0;
MUL result.color.xyz, R0, c[7].y;
MOV result.color.w, c[7].x;
END
# 11 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"ps_2_0
; 10 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c2, 0.00000000, 2.00000000, 0, 0
dcl t0.xy
dcl t2.xyz
dcl t3.xyz
dcl t4.xy
texld r0, t4, s1
texld r1, t0, s0
mov_pp r0.xyz, t3
dp3_pp r0.x, t2, r0
mul r1.xyz, r1, c1
max_pp r0.x, r0, c2
mul_pp r0.x, r0, r0.w
mul_pp r1.xyz, r1, c0
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c2.y
mov_pp r0.w, c2.x
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL_COOKIE" }
ConstBuffer "$Globals" 208 // 128 used size, 11 vars
Vector 16 [_LightColor0] 4
Vector 112 [_Color] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_LightTexture0] 2D 0
// 10 instructions, 2 temp regs, 0 temp arrays:
// ALU 6 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedkennpkggkjdpifgemkhallimjceokfpaabaaaaaameacaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amaaaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaadadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefckeabaaaa
eaaaaaaagjaaaaaafjaaaaaeegiocaaaaaaaaaaaaiaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaaddcbabaaaaeaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaabaaaaaahbcaabaaaaaaaaaaa
egbcbaaaacaaaaaaegbcbaaaadaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaabeaaaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaaeaaaaaa
eghobaaaabaaaaaaaagabaaaaaaaaaaaapaaaaahbcaabaaaaaaaaaaaagaabaaa
aaaaaaaapgapbaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaaiocaabaaaaaaaaaaaagajbaaa
abaaaaaaagijcaaaaaaaaaaaahaaaaaadiaaaaaiocaabaaaaaaaaaaafgaobaaa
aaaaaaaaagijcaaaaaaaaaaaabaaaaaadiaaaaahhccabaaaaaaaaaaaagaabaaa
aaaaaaaajgahbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"agal_ps
c2 0.0 2.0 0.0 0.0
[bc]
ciaaaaaaaaaaapacaeaaaaoeaeaaaaaaabaaaaaaafaababb tex r0, v4, s1 <2d wrap linear point>
ciaaaaaaabaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r1, v0, s0 <2d wrap linear point>
aaaaaaaaaaaaahacadaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, v3
bcaaaaaaaaaaabacacaaaaoeaeaaaaaaaaaaaakeacaaaaaa dp3 r0.x, v2, r0.xyzz
adaaaaaaabaaahacabaaaakeacaaaaaaabaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c1
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaacaaaaoeabaaaaaa max r0.x, r0.x, c2
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaappacaaaaaa mul r0.x, r0.x, r0.w
adaaaaaaabaaahacabaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c0
adaaaaaaaaaaahacaaaaaaaaacaaaaaaabaaaakeacaaaaaa mul r0.xyz, r0.x, r1.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaacaaaaffabaaaaaa mul r0.xyz, r0.xyzz, c2.y
aaaaaaaaaaaaaiacacaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c2.x
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL_COOKIE" }
ConstBuffer "$Globals" 208 // 128 used size, 11 vars
Vector 16 [_LightColor0] 4
Vector 112 [_Color] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_LightTexture0] 2D 0
// 10 instructions, 2 temp regs, 0 temp arrays:
// ALU 6 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedfoiaofpfkigacmhmcopfklobkppeekhiabaaaaaadeaeaaaaaeaaaaaa
daaaaaaajmabaaaaeiadaaaaaaaeaaaaebgpgodjgeabaaaageabaaaaaaacpppp
caabaaaaeeaaaaaaacaacmaaaaaaeeaaaaaaeeaaacaaceaaaaaaeeaaabaaaaaa
aaababaaaaaaabaaabaaaaaaaaaaaaaaaaaaahaaabaaabaaaaaaaaaaaaacpppp
fbaaaaafacaaapkaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabpaaaaacaaaaaaia
aaaaaplabpaaaaacaaaaaaiaabaachlabpaaaaacaaaaaaiaacaachlabpaaaaac
aaaaaaiaadaaadlabpaaaaacaaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapka
ecaaaaadaaaacpiaadaaoelaaaaioekaecaaaaadabaaapiaaaaaoelaabaioeka
abaaaaacaaaaahiaabaaoelaaiaaaaadabaaciiaaaaaoeiaacaaoelaafaaaaad
aaaacbiaaaaappiaabaappiafiaaaaaeabaaciiaabaappiaaaaaaaiaacaaaaka
acaaaaadabaaciiaabaappiaabaappiaafaaaaadaaaachiaabaaoeiaabaaoeka
afaaaaadaaaachiaaaaaoeiaaaaaoekaafaaaaadaaaachiaabaappiaaaaaoeia
abaaaaacaaaaciiaacaaaakaabaaaaacaaaicpiaaaaaoeiappppaaaafdeieefc
keabaaaaeaaaaaaagjaaaaaafjaaaaaeegiocaaaaaaaaaaaaiaaaaaafkaaaaad
aagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaaddcbabaaa
aeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaabaaaaaahbcaabaaa
aaaaaaaaegbcbaaaacaaaaaaegbcbaaaadaaaaaadeaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
aeaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaaapaaaaahbcaabaaaaaaaaaaa
agaabaaaaaaaaaaapgapbaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaaiocaabaaaaaaaaaaa
agajbaaaabaaaaaaagijcaaaaaaaaaaaahaaaaaadiaaaaaiocaabaaaaaaaaaaa
fgaobaaaaaaaaaaaagijcaaaaaaaaaaaabaaaaaadiaaaaahhccabaaaaaaaaaaa
agaabaaaaaaaaaaajgahbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaa
aaaaaaaadoaaaaabejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamaaaaaa
keaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaakeaaaaaaadaaaaaa
aaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaadadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
epfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES3"
}

}
	}
	Pass {
		Name "PREPASS"
		Tags { "LightMode" = "PrePassBase" }
		Fog {Mode Off}
Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 11 to 11
//   d3d9 - ALU: 11 to 11
//   d3d11 - ALU: 12 to 12, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 12 to 12, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 5 [_Object2World]
Vector 9 [unity_Scale]
"!!ARBvp1.0
# 11 ALU
PARAM c[10] = { program.local[0],
		state.matrix.mvp,
		program.local[5..9] };
TEMP R0;
MUL R0.xyz, vertex.normal, c[9].w;
DP3 result.texcoord[1].z, R0, c[7];
DP3 result.texcoord[1].y, R0, c[6];
DP3 result.texcoord[1].x, R0, c[5];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[7];
MOV result.texcoord[0].xy, R0;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 11 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [unity_Scale]
"vs_2_0
; 11 ALU
dcl_position0 v0
dcl_normal0 v1
mul r0.xyz, v1, c8.w
dp3 oT1.z, r0, c6
dp3 oT1.y, r0, c5
dp3 oT1.x, r0, c4
dp4 r0.x, v0, c4
dp4 r0.y, v0, c6
mov oT0.xy, r0
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "UnityPerDraw" 0
// 13 instructions, 2 temp regs, 0 temp arrays:
// ALU 12 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedijdfpoegompcaflkacdpbilpeiacicpbabaaaaaajaadaaaaadaaaaaa
cmaaaaaapeaaaaaageabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheogiaaaaaaadaaaaaa
aiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaafmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcceacaaaaeaaaabaaijaaaaaafjaaaaaeegiocaaaaaaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaaaaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaaaaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pccabaaaaaaaaaaaegiocaaaaaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaaidcaabaaaaaaaaaaafgbfbaaaaaaaaaaaigiacaaaaaaaaaaa
anaaaaaadcaaaaakdcaabaaaaaaaaaaaigiacaaaaaaaaaaaamaaaaaaagbabaaa
aaaaaaaaegaabaaaaaaaaaaadcaaaaakdcaabaaaaaaaaaaaigiacaaaaaaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaakdccabaaaabaaaaaa
igiacaaaaaaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaabaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaaaaaaaaabeaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaanaaaaaadcaaaaak
lcaabaaaaaaaaaaaegiicaaaaaaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaa
abaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaaaaaaaaaaoaaaaaakgakbaaa
aaaaaaaaegadbaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES


#ifdef VERTEX

varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_3;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD1 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 res_1;
  res_1.xyz = ((xlv_TEXCOORD1 * 0.5) + 0.5);
  res_1.w = 0.0;
  gl_FragData[0] = res_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES


#ifdef VERTEX

varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_3;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD1 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 res_1;
  res_1.xyz = ((xlv_TEXCOORD1 * 0.5) + 0.5);
  res_1.w = 0.0;
  gl_FragData[0] = res_1;
}



#endif"
}

SubProgram "d3d11_9x " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "UnityPerDraw" 0
// 13 instructions, 2 temp regs, 0 temp arrays:
// ALU 12 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedpbihampbkdppbmjlhaboolcnfhkohdiiabaaaaaaaiafaaaaaeaaaaaa
daaaaaaakeabaaaanaadaaaajiaeaaaaebgpgodjgmabaaaagmabaaaaaaacpopp
caabaaaaemaaaaaaadaaceaaaaaaeiaaaaaaeiaaaaaaceaaabaaeiaaaaaaaaaa
aeaaabaaaaaaaaaaaaaaamaaaeaaafaaaaaaaaaaaaaabeaaabaaajaaaaaaaaaa
aaaaaaaaaaacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaaciaacaaapja
afaaaaadaaaaadiaaaaaffjaagaaoikaaeaaaaaeaaaaadiaafaaoikaaaaaaaja
aaaaoeiaaeaaaaaeaaaaadiaahaaoikaaaaakkjaaaaaoeiaaeaaaaaeaaaaadoa
aiaaoikaaaaappjaaaaaoeiaafaaaaadaaaaahiaacaaoejaajaappkaafaaaaad
abaaahiaaaaaffiaagaaoekaaeaaaaaeaaaaaliaafaakekaaaaaaaiaabaakeia
aeaaaaaeabaaahoaahaaoekaaaaakkiaaaaapeiaafaaaaadaaaaapiaaaaaffja
acaaoekaaeaaaaaeaaaaapiaabaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapia
adaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaaeaaoekaaaaappjaaaaaoeia
aeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeia
ppppaaaafdeieefcceacaaaaeaaaabaaijaaaaaafjaaaaaeegiocaaaaaaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaaaaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaaaaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pccabaaaaaaaaaaaegiocaaaaaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaaidcaabaaaaaaaaaaafgbfbaaaaaaaaaaaigiacaaaaaaaaaaa
anaaaaaadcaaaaakdcaabaaaaaaaaaaaigiacaaaaaaaaaaaamaaaaaaagbabaaa
aaaaaaaaegaabaaaaaaaaaaadcaaaaakdcaabaaaaaaaaaaaigiacaaaaaaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaakdccabaaaabaaaaaa
igiacaaaaaaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaabaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaaaaaaaaabeaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaanaaaaaadcaaaaak
lcaabaaaaaaaaaaaegiicaaaaaaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaa
abaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaaaaaaaaaaoaaaaaakgakbaaa
aaaaaaaaegadbaaaaaaaaaaadoaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaa
jiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
acaaaaaaahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaa
laaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofe
aaeoepfcenebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheogiaaaaaa
adaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
fmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaafmaaaaaaabaaaaaa
aaaaaaaaadaaaaaaacaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 398
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec2 cust_location;
    lowp vec3 normal;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 393
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 397
uniform highp vec4 _Player3_Pos;
#line 405
#line 419
#line 431
#line 405
void vert( inout appdata_full vertexData, out Input outData ) {
    highp vec4 pos = (glstate_matrix_mvp * vertexData.vertex);
    highp vec4 posWorld = (_Object2World * vertexData.vertex);
    #line 409
    outData.uv_MainTex = vec2( vertexData.texcoord);
    outData.location = posWorld.xz;
}
#line 431
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    Input customInputData;
    #line 435
    vert( v, customInputData);
    o.cust_location = customInputData.location;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.normal = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    #line 439
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out lowp vec3 xlv_TEXCOORD1;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.cust_location);
    xlv_TEXCOORD1 = vec3(xl_retval.normal);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 398
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec2 cust_location;
    lowp vec3 normal;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 393
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 397
uniform highp vec4 _Player3_Pos;
#line 405
#line 419
#line 431
#line 419
highp float powerForPos( in highp vec4 pos, in highp vec2 nearVertex ) {
    highp float atten = clamp( (_FogRadius - length((pos.xz - nearVertex.xy))), 0.0, _FogRadius);
    return (((1.0 / _FogMaxRadius) * atten) / _FogRadius);
}
#line 412
void surf( in Input IN, inout SurfaceOutput o ) {
    #line 414
    lowp vec4 baseColor = (texture( _MainTex, IN.uv_MainTex) * _Color);
    highp float alpha = (1.0 - (((baseColor.w + powerForPos( _Player1_Pos, IN.location)) + powerForPos( _Player2_Pos, IN.location)) + powerForPos( _Player3_Pos, IN.location)));
    o.Albedo = baseColor.xyz;
    o.Alpha = alpha;
}
#line 441
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 443
    Input surfIN;
    surfIN.location = IN.cust_location;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    #line 447
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    #line 451
    o.Normal = IN.normal;
    surf( surfIN, o);
    lowp vec4 res;
    res.xyz = ((o.Normal * 0.5) + 0.5);
    #line 455
    res.w = o.Specular;
    return res;
}
in highp vec2 xlv_TEXCOORD0;
in lowp vec3 xlv_TEXCOORD1;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.cust_location = vec2(xlv_TEXCOORD0);
    xlt_IN.normal = vec3(xlv_TEXCOORD1);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 2 to 2, TEX: 0 to 0
//   d3d9 - ALU: 3 to 3
//   d3d11 - ALU: 1 to 1, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 1 to 1, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
"!!ARBfp1.0
# 2 ALU, 0 TEX
PARAM c[4] = { program.local[0..2],
		{ 0, 0.5 } };
MAD result.color.xyz, fragment.texcoord[1], c[3].y, c[3].y;
MOV result.color.w, c[3].x;
END
# 2 instructions, 0 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
"ps_2_0
; 3 ALU
def c0, 0.50000000, 0.00000000, 0, 0
dcl t1.xyz
mad_pp r0.xyz, t1, c0.x, c0.x
mov_pp r0.w, c0.y
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { }
// 3 instructions, 0 temp regs, 0 temp arrays:
// ALU 1 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedlbgcjocbcbhinngdppgpmhelnlomgaioabaaaaaaemabaaaaadaaaaaa
cmaaaaaajmaaaaaanaaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadaaaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcheaaaaaaeaaaaaaabnaaaaaa
gcbaaaadhcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaadcaaaaaphccabaaa
aaaaaaaaegbcbaaaacaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaaaa
aceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaaaadgaaaaaficcabaaaaaaaaaaa
abeaaaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { }
// 3 instructions, 0 temp regs, 0 temp arrays:
// ALU 1 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedjfmfdmjgdiniddocjjcfgdbkelpnmenlabaaaaaaneabaaaaaeaaaaaa
daaaaaaaleaaaaaadaabaaaakaabaaaaebgpgodjhmaaaaaahmaaaaaaaaacpppp
fiaaaaaaceaaaaaaaaaaceaaaaaaceaaaaaaceaaaaaaceaaaaaaceaaaaacpppp
fbaaaaafaaaaapkaaaaaaadpaaaaaaaaaaaaaaaaaaaaaaaabpaaaaacaaaaaaia
abaachlaaeaaaaaeaaaachiaabaaoelaaaaaaakaaaaaaakaabaaaaacaaaaciia
aaaaffkaabaaaaacaaaicpiaaaaaoeiappppaaaafdeieefcheaaaaaaeaaaaaaa
bnaaaaaagcbaaaadhcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaadcaaaaap
hccabaaaaaaaaaaaegbcbaaaacaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadp
aaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaaaadgaaaaaficcabaaa
aaaaaaaaabeaaaaaaaaaaaaadoaaaaabejfdeheogiaaaaaaadaaaaaaaiaaaaaa
faaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaadaaaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaa
acaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
epfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { }
"!!GLES3"
}

}
	}
	Pass {
		Name "PREPASS"
		Tags { "LightMode" = "PrePassFinal" }
		ZWrite Off
Program "vp" {
// Vertex combos: 6
//   opengl - ALU: 14 to 31
//   d3d9 - ALU: 14 to 31
//   d3d11 - ALU: 13 to 27, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 13 to 27, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_ProjectionParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Matrix 5 [_Object2World]
Vector 17 [unity_Scale]
Vector 18 [_MainTex_ST]
"!!ARBvp1.0
# 31 ALU
PARAM c[19] = { { 0.5, 1 },
		state.matrix.mvp,
		program.local[5..18] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[17].w;
DP3 R2.w, R1, c[6];
DP3 R0.x, R1, c[5];
DP3 R0.z, R1, c[7];
MOV R0.y, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].y;
DP4 R2.z, R0, c[12];
DP4 R2.y, R0, c[11];
DP4 R2.x, R0, c[10];
MUL R0.y, R2.w, R2.w;
DP4 R3.z, R1, c[15];
DP4 R3.y, R1, c[14];
DP4 R3.x, R1, c[13];
DP4 R1.w, vertex.position, c[4];
DP4 R1.z, vertex.position, c[3];
MAD R0.x, R0, R0, -R0.y;
ADD R3.xyz, R2, R3;
MUL R2.xyz, R0.x, c[16];
DP4 R1.x, vertex.position, c[1];
DP4 R1.y, vertex.position, c[2];
MUL R0.xyz, R1.xyww, c[0].x;
MUL R0.y, R0, c[9].x;
ADD result.texcoord[2].xy, R0, R0.z;
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[7];
ADD result.texcoord[3].xyz, R3, R2;
MOV result.position, R1;
MOV result.texcoord[2].zw, R1;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
MOV result.texcoord[1].xy, R0;
END
# 31 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Matrix 4 [_Object2World]
Vector 17 [unity_Scale]
Vector 18 [_MainTex_ST]
"vs_2_0
; 31 ALU
def c19, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c17.w
dp3 r2.w, r1, c5
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.y, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c19.y
dp4 r2.z, r0, c12
dp4 r2.y, r0, c11
dp4 r2.x, r0, c10
mul r0.y, r2.w, r2.w
dp4 r3.z, r1, c15
dp4 r3.y, r1, c14
dp4 r3.x, r1, c13
dp4 r1.w, v0, c3
dp4 r1.z, v0, c2
mad r0.x, r0, r0, -r0.y
add r3.xyz, r2, r3
mul r2.xyz, r0.x, c16
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mul r0.xyz, r1.xyww, c19.x
mul r0.y, r0, c8.x
mad oT2.xy, r0.z, c9.zwzw, r0
dp4 r0.x, v0, c4
dp4 r0.y, v0, c6
add oT3.xyz, r3, r2
mov oPos, r1
mov oT2.zw, r1
mad oT0.xy, v2, c18, c18.zwzw
mov oT1.xy, r0
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 160 // 144 used size, 11 vars
Vector 128 [_MainTex_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 31 instructions, 4 temp regs, 0 temp arrays:
// ALU 27 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedhficideepigmfojkiboikklenpbcjmfpabaaaaaaeeagaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apaaaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefckiaeaaaaeaaaabaa
ckabaaaafjaaaaaeegiocaaaaaaaaaaaajaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaad
hccabaaaadaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
dcaabaaaabaaaaaafgbfbaaaaaaaaaaaigiacaaaadaaaaaaanaaaaaadcaaaaak
dcaabaaaabaaaaaaigiacaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegaabaaa
abaaaaaadcaaaaakdcaabaaaabaaaaaaigiacaaaadaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegaabaaaabaaaaaadcaaaaakmccabaaaabaaaaaaagiicaaaadaaaaaa
apaaaaaapgbpbaaaaaaaaaaaagaebaaaabaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaaiaaaaaaogikcaaaaaaaaaaaaiaaaaaa
diaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaa
aaaaaadpaaaaaadpdgaaaaafmccabaaaacaaaaaakgaobaaaaaaaaaaaaaaaaaah
dccabaaaacaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadiaaaaaihcaabaaa
aaaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaa
abaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaa
aaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaa
egadbaaaaaaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaai
bcaabaaaabaaaaaaegiocaaaacaaaaaacgaaaaaaegaobaaaaaaaaaaabbaaaaai
ccaabaaaabaaaaaaegiocaaaacaaaaaachaaaaaaegaobaaaaaaaaaaabbaaaaai
ecaabaaaabaaaaaaegiocaaaacaaaaaaciaaaaaaegaobaaaaaaaaaaadiaaaaah
pcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaaibcaabaaa
adaaaaaaegiocaaaacaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaa
adaaaaaaegiocaaaacaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaa
adaaaaaaegiocaaaacaaaaaaclaaaaaaegaobaaaacaaaaaaaaaaaaahhcaabaaa
abaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaahccaabaaaaaaaaaaa
bkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaakaabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaadcaaaaakhccabaaa
adaaaaaaegiccaaaacaaaaaacmaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.5);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_2.zw;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = (tmpvar_6 * (normalize(_glesNormal) * unity_Scale.w));
  mediump vec3 tmpvar_8;
  mediump vec4 normal_9;
  normal_9 = tmpvar_7;
  highp float vC_10;
  mediump vec3 x3_11;
  mediump vec3 x2_12;
  mediump vec3 x1_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal_9);
  x1_13.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal_9);
  x1_13.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal_9);
  x1_13.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal_9.xyzz * normal_9.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2_12.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2_12.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2_12.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal_9.x * normal_9.x) - (normal_9.y * normal_9.y));
  vC_10 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC_10);
  x3_11 = tmpvar_22;
  tmpvar_8 = ((x1_13 + x2_12) + x3_11);
  tmpvar_1 = tmpvar_8;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = o_3;
  xlv_TEXCOORD3 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _LightBuffer;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp float tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_6;
  arg0_6 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_7;
  arg0_7 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_8;
  arg0_8 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_9;
  tmpvar_9 = (1.0 - (((tmpvar_5.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_7, arg0_7))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_8, arg0_8))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_4 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2DProj (_LightBuffer, xlv_TEXCOORD2);
  light_3 = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = -(log2(max (light_3, vec4(0.001, 0.001, 0.001, 0.001))));
  light_3.w = tmpvar_11.w;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11.xyz + xlv_TEXCOORD3);
  light_3.xyz = tmpvar_12;
  lowp vec4 c_13;
  mediump vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_5.xyz * light_3.xyz);
  c_13.xyz = tmpvar_14;
  c_13.w = tmpvar_4;
  c_2 = c_13;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.5);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_2.zw;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = (tmpvar_6 * (normalize(_glesNormal) * unity_Scale.w));
  mediump vec3 tmpvar_8;
  mediump vec4 normal_9;
  normal_9 = tmpvar_7;
  highp float vC_10;
  mediump vec3 x3_11;
  mediump vec3 x2_12;
  mediump vec3 x1_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal_9);
  x1_13.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal_9);
  x1_13.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal_9);
  x1_13.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal_9.xyzz * normal_9.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2_12.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2_12.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2_12.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal_9.x * normal_9.x) - (normal_9.y * normal_9.y));
  vC_10 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC_10);
  x3_11 = tmpvar_22;
  tmpvar_8 = ((x1_13 + x2_12) + x3_11);
  tmpvar_1 = tmpvar_8;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = o_3;
  xlv_TEXCOORD3 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _LightBuffer;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp float tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_6;
  arg0_6 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_7;
  arg0_7 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_8;
  arg0_8 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_9;
  tmpvar_9 = (1.0 - (((tmpvar_5.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_7, arg0_7))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_8, arg0_8))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_4 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2DProj (_LightBuffer, xlv_TEXCOORD2);
  light_3 = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = -(log2(max (light_3, vec4(0.001, 0.001, 0.001, 0.001))));
  light_3.w = tmpvar_11.w;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11.xyz + xlv_TEXCOORD3);
  light_3.xyz = tmpvar_12;
  lowp vec4 c_13;
  mediump vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_5.xyz * light_3.xyz);
  c_13.xyz = tmpvar_14;
  c_13.w = tmpvar_4;
  c_2 = c_13;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 160 // 144 used size, 11 vars
Vector 128 [_MainTex_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 31 instructions, 4 temp regs, 0 temp arrays:
// ALU 27 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedomhblcppbibjelclkefdmofbbebpimafabaaaaaaciajaaaaaeaaaaaa
daaaaaaabaadaaaamaahaaaaiiaiaaaaebgpgodjniacaaaaniacaaaaaaacpopp
giacaaaahaaaaaaaagaaceaaaaaagmaaaaaagmaaaaaaceaaabaagmaaaaaaaiaa
abaaabaaaaaaaaaaabaaafaaabaaacaaaaaaaaaaacaacgaaahaaadaaaaaaaaaa
adaaaaaaaeaaakaaaaaaaaaaadaaamaaaeaaaoaaaaaaaaaaadaabeaaabaabcaa
aaaaaaaaaaaaaaaaaaacpoppfbaaaaafbdaaapkaaaaaaadpaaaaiadpaaaaaaaa
aaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaaciaacaaapjabpaaaaac
afaaadiaadaaapjaafaaaaadaaaaadiaaaaaffjaapaaockaaeaaaaaeaaaaadia
aoaaockaaaaaaajaaaaaoeiaaeaaaaaeaaaaadiabaaaockaaaaakkjaaaaaoeia
aeaaaaaeaaaaamoabbaacekaaaaappjaaaaaeeiaaeaaaaaeaaaaadoaadaaoeja
abaaoekaabaaookaafaaaaadaaaaapiaaaaaffjaalaaoekaaeaaaaaeaaaaapia
akaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaamaaoekaaaaakkjaaaaaoeia
aeaaaaaeaaaaapiaanaaoekaaaaappjaaaaaoeiaafaaaaadabaaabiaaaaaffia
acaaaakaafaaaaadabaaaiiaabaaaaiabdaaaakaafaaaaadabaaafiaaaaapeia
bdaaaakaacaaaaadabaaadoaabaakkiaabaaomiaafaaaaadabaaahiaacaaoeja
bcaappkaafaaaaadacaaahiaabaaffiaapaaoekaaeaaaaaeabaaaliaaoaakeka
abaaaaiaacaakeiaaeaaaaaeabaaahiabaaaoekaabaakkiaabaapeiaabaaaaac
abaaaiiabdaaffkaajaaaaadacaaabiaadaaoekaabaaoeiaajaaaaadacaaacia
aeaaoekaabaaoeiaajaaaaadacaaaeiaafaaoekaabaaoeiaafaaaaadadaaapia
abaacjiaabaakeiaajaaaaadaeaaabiaagaaoekaadaaoeiaajaaaaadaeaaacia
ahaaoekaadaaoeiaajaaaaadaeaaaeiaaiaaoekaadaaoeiaacaaaaadacaaahia
acaaoeiaaeaaoeiaafaaaaadabaaaciaabaaffiaabaaffiaaeaaaaaeabaaabia
abaaaaiaabaaaaiaabaaffibaeaaaaaeacaaahoaajaaoekaabaaaaiaacaaoeia
aeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeia
abaaaaacabaaamoaaaaaoeiappppaaaafdeieefckiaeaaaaeaaaabaackabaaaa
fjaaaaaeegiocaaaaaaaaaaaajaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaa
fjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaa
adaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaa
gfaaaaadmccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaadhccabaaa
adaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaidcaabaaa
abaaaaaafgbfbaaaaaaaaaaaigiacaaaadaaaaaaanaaaaaadcaaaaakdcaabaaa
abaaaaaaigiacaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegaabaaaabaaaaaa
dcaaaaakdcaabaaaabaaaaaaigiacaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egaabaaaabaaaaaadcaaaaakmccabaaaabaaaaaaagiicaaaadaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaagaebaaaabaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaaiaaaaaaogikcaaaaaaaaaaaaiaaaaaadiaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaak
ncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaadpdgaaaaafmccabaaaacaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaa
acaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaa
egbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaa
egiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaa
aaaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaa
abaaaaaaegiocaaaacaaaaaacgaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaa
abaaaaaaegiocaaaacaaaaaachaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaa
abaaaaaaegiocaaaacaaaaaaciaaaaaaegaobaaaaaaaaaaadiaaaaahpcaabaaa
acaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaa
egiocaaaacaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaa
egiocaaaacaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaa
egiocaaaacaaaaaaclaaaaaaegaobaaaacaaaaaaaaaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaahccaabaaaaaaaaaaabkaabaaa
aaaaaaaabkaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
akaabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaadcaaaaakhccabaaaadaaaaaa
egiccaaaacaaaaaacmaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab
ejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaa
kjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaa
faepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfcee
aaedepemepfcaaklepfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaadamaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaa
imaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaaimaaaaaaadaaaaaa
aaaaaaaaadaaaaaaadaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 398
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    highp vec4 screen;
    highp vec3 vlight;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 393
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 397
uniform highp vec4 _Player3_Pos;
#line 405
#line 419
#line 433
uniform highp vec4 _MainTex_ST;
uniform sampler2D _LightBuffer;
uniform lowp vec4 unity_Ambient;
#line 449
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 405
void vert( inout appdata_full vertexData, out Input outData ) {
    highp vec4 pos = (glstate_matrix_mvp * vertexData.vertex);
    highp vec4 posWorld = (_Object2World * vertexData.vertex);
    #line 409
    outData.uv_MainTex = vec2( vertexData.texcoord);
    outData.location = posWorld.xz;
}
#line 434
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 437
    Input customInputData;
    vert( v, customInputData);
    o.cust_location = customInputData.location;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 441
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.screen = ComputeScreenPos( o.pos);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.vlight = ShadeSH9( vec4( worldN, 1.0));
    #line 445
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.pack0);
    xlv_TEXCOORD1 = vec2(xl_retval.cust_location);
    xlv_TEXCOORD2 = vec4(xl_retval.screen);
    xlv_TEXCOORD3 = vec3(xl_retval.vlight);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 398
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    highp vec4 screen;
    highp vec3 vlight;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 393
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 397
uniform highp vec4 _Player3_Pos;
#line 405
#line 419
#line 433
uniform highp vec4 _MainTex_ST;
uniform sampler2D _LightBuffer;
uniform lowp vec4 unity_Ambient;
#line 449
#line 346
lowp vec4 LightingLambert_PrePass( in SurfaceOutput s, in mediump vec4 light ) {
    lowp vec4 c;
    c.xyz = (s.Albedo * light.xyz);
    #line 350
    c.w = s.Alpha;
    return c;
}
#line 419
highp float powerForPos( in highp vec4 pos, in highp vec2 nearVertex ) {
    highp float atten = clamp( (_FogRadius - length((pos.xz - nearVertex.xy))), 0.0, _FogRadius);
    return (((1.0 / _FogMaxRadius) * atten) / _FogRadius);
}
#line 412
void surf( in Input IN, inout SurfaceOutput o ) {
    #line 414
    lowp vec4 baseColor = (texture( _MainTex, IN.uv_MainTex) * _Color);
    highp float alpha = (1.0 - (((baseColor.w + powerForPos( _Player1_Pos, IN.location)) + powerForPos( _Player2_Pos, IN.location)) + powerForPos( _Player3_Pos, IN.location)));
    o.Albedo = baseColor.xyz;
    o.Alpha = alpha;
}
#line 449
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    #line 453
    surfIN.location = IN.cust_location;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 457
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    surf( surfIN, o);
    #line 461
    mediump vec4 light = textureProj( _LightBuffer, IN.screen);
    light = max( light, vec4( 0.001));
    light = (-log2(light));
    light.xyz += IN.vlight;
    #line 465
    mediump vec4 c = LightingLambert_PrePass( o, light);
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec2(xlv_TEXCOORD0);
    xlt_IN.cust_location = vec2(xlv_TEXCOORD1);
    xlt_IN.screen = vec4(xlv_TEXCOORD2);
    xlt_IN.vlight = vec3(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 13 [_ProjectionParams]
Vector 14 [unity_ShadowFadeCenterAndType]
Matrix 9 [_Object2World]
Vector 15 [unity_LightmapST]
Vector 16 [_MainTex_ST]
"!!ARBvp1.0
# 22 ALU
PARAM c[17] = { { 0.5, 1 },
		state.matrix.modelview[0],
		state.matrix.mvp,
		program.local[9..16] };
TEMP R0;
TEMP R1;
TEMP R2;
DP4 R1.w, vertex.position, c[8];
DP4 R1.z, vertex.position, c[7];
DP4 R1.x, vertex.position, c[5];
DP4 R1.y, vertex.position, c[6];
MUL R0.xyz, R1.xyww, c[0].x;
MUL R0.y, R0, c[13].x;
ADD result.texcoord[2].xy, R0, R0.z;
DP4 R0.x, vertex.position, c[9];
DP4 R0.z, vertex.position, c[11];
DP4 R0.y, vertex.position, c[10];
ADD R2.xyz, R0, -c[14];
MOV R0.y, R0.z;
MOV result.texcoord[1].xy, R0;
MOV R0.x, c[0].y;
ADD R0.y, R0.x, -c[14].w;
DP4 R0.x, vertex.position, c[3];
MOV result.position, R1;
MOV result.texcoord[2].zw, R1;
MUL result.texcoord[4].xyz, R2, c[14].w;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
MAD result.texcoord[3].xy, vertex.texcoord[1], c[15], c[15].zwzw;
MUL result.texcoord[4].w, -R0.x, R0.y;
END
# 22 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_ShadowFadeCenterAndType]
Matrix 8 [_Object2World]
Vector 15 [unity_LightmapST]
Vector 16 [_MainTex_ST]
"vs_2_0
; 22 ALU
def c17, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
dcl_texcoord1 v2
dp4 r1.w, v0, c7
dp4 r1.z, v0, c6
dp4 r1.x, v0, c4
dp4 r1.y, v0, c5
mul r0.xyz, r1.xyww, c17.x
mul r0.y, r0, c12.x
mad oT2.xy, r0.z, c13.zwzw, r0
dp4 r0.x, v0, c8
dp4 r0.z, v0, c10
dp4 r0.y, v0, c9
add r2.xyz, r0, -c14
mov r0.y, r0.z
mov oT1.xy, r0
mov r0.x, c14.w
add r0.y, c17, -r0.x
dp4 r0.x, v0, c2
mov oPos, r1
mov oT2.zw, r1
mul oT4.xyz, r2, c14.w
mad oT0.xy, v1, c16, c16.zwzw
mad oT3.xy, v2, c15, c15.zwzw
mul oT4.w, -r0.x, r0.y
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 192 // 160 used size, 13 vars
Vector 128 [unity_LightmapST] 4
Vector 144 [_MainTex_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityShadows" 416 // 416 used size, 8 vars
Vector 400 [unity_ShadowFadeCenterAndType] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 64 [glstate_matrix_modelview0] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityShadows" 2
BindCB "UnityPerDraw" 3
// 28 instructions, 2 temp regs, 0 temp arrays:
// ALU 25 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefieceddffkcobdnoaghpaiphmanllbjcmhalocabaaaaaaeeagaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apaaaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaadamaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcjaaeaaaaeaaaabaaceabaaaafjaaaaae
egiocaaaaaaaaaaaakaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaabkaaaaaafjaaaaaeegiocaaaadaaaaaabaaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
mccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaaadaaaaaa
gfaaaaadpccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaidcaabaaaabaaaaaafgbfbaaaaaaaaaaaigiacaaaadaaaaaaanaaaaaa
dcaaaaakdcaabaaaabaaaaaaigiacaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaa
egaabaaaabaaaaaadcaaaaakdcaabaaaabaaaaaaigiacaaaadaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegaabaaaabaaaaaadcaaaaakmccabaaaabaaaaaaagiicaaa
adaaaaaaapaaaaaapgbpbaaaaaaaaaaaagaebaaaabaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaajaaaaaaogikcaaaaaaaaaaa
ajaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaa
afaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadp
aaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaacaaaaaakgaobaaaaaaaaaaa
aaaaaaahdccabaaaacaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadcaaaaal
dccabaaaadaaaaaaegbabaaaaeaaaaaaegiacaaaaaaaaaaaaiaaaaaaogikcaaa
aaaaaaaaaiaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
adaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaa
aaaaaaajhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaiaebaaaaaaacaaaaaa
bjaaaaaadiaaaaaihccabaaaaeaaaaaaegacbaaaaaaaaaaapgipcaaaacaaaaaa
bjaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaaaaaaaaaackiacaaaadaaaaaa
afaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaaeaaaaaaakbabaaa
aaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaa
agaaaaaackbabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaa
ckiacaaaadaaaaaaahaaaaaadkbabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaaj
ccaabaaaaaaaaaaadkiacaiaebaaaaaaacaaaaaabjaaaaaaabeaaaaaaaaaiadp
diaaaaaiiccabaaaaeaaaaaabkaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.5);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_2.zw;
  tmpvar_1.xyz = (((_Object2World * _glesVertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_1.w = (-((glstate_matrix_modelview0 * _glesVertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = o_3;
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD4 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec3 lmIndirect_3;
  mediump vec3 lmFull_4;
  mediump float lmFade_5;
  mediump vec4 light_6;
  lowp float tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_9;
  arg0_9 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_10;
  arg0_10 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_11;
  arg0_11 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_12;
  tmpvar_12 = (1.0 - (((tmpvar_8.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_9, arg0_9))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_10, arg0_10))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_11, arg0_11))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_7 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2DProj (_LightBuffer, xlv_TEXCOORD2);
  light_6 = tmpvar_13;
  mediump vec4 tmpvar_14;
  tmpvar_14 = -(log2(max (light_6, vec4(0.001, 0.001, 0.001, 0.001))));
  light_6.w = tmpvar_14.w;
  highp float tmpvar_15;
  tmpvar_15 = ((sqrt(dot (xlv_TEXCOORD4, xlv_TEXCOORD4)) * unity_LightmapFade.z) + unity_LightmapFade.w);
  lmFade_5 = tmpvar_15;
  lowp vec3 tmpvar_16;
  tmpvar_16 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD3).xyz);
  lmFull_4 = tmpvar_16;
  lowp vec3 tmpvar_17;
  tmpvar_17 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD3).xyz);
  lmIndirect_3 = tmpvar_17;
  light_6.xyz = (tmpvar_14.xyz + mix (lmIndirect_3, lmFull_4, vec3(clamp (lmFade_5, 0.0, 1.0))));
  lowp vec4 c_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = (tmpvar_8.xyz * light_6.xyz);
  c_18.xyz = tmpvar_19;
  c_18.w = tmpvar_7;
  c_2 = c_18;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.5);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_2.zw;
  tmpvar_1.xyz = (((_Object2World * _glesVertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_1.w = (-((glstate_matrix_modelview0 * _glesVertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = o_3;
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD4 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec3 lmIndirect_3;
  mediump vec3 lmFull_4;
  mediump float lmFade_5;
  mediump vec4 light_6;
  lowp float tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_9;
  arg0_9 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_10;
  arg0_10 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_11;
  arg0_11 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_12;
  tmpvar_12 = (1.0 - (((tmpvar_8.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_9, arg0_9))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_10, arg0_10))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_11, arg0_11))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_7 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2DProj (_LightBuffer, xlv_TEXCOORD2);
  light_6 = tmpvar_13;
  mediump vec4 tmpvar_14;
  tmpvar_14 = -(log2(max (light_6, vec4(0.001, 0.001, 0.001, 0.001))));
  light_6.w = tmpvar_14.w;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (unity_Lightmap, xlv_TEXCOORD3);
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (unity_LightmapInd, xlv_TEXCOORD3);
  highp float tmpvar_17;
  tmpvar_17 = ((sqrt(dot (xlv_TEXCOORD4, xlv_TEXCOORD4)) * unity_LightmapFade.z) + unity_LightmapFade.w);
  lmFade_5 = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = ((8.0 * tmpvar_15.w) * tmpvar_15.xyz);
  lmFull_4 = tmpvar_18;
  lowp vec3 tmpvar_19;
  tmpvar_19 = ((8.0 * tmpvar_16.w) * tmpvar_16.xyz);
  lmIndirect_3 = tmpvar_19;
  light_6.xyz = (tmpvar_14.xyz + mix (lmIndirect_3, lmFull_4, vec3(clamp (lmFade_5, 0.0, 1.0))));
  lowp vec4 c_20;
  mediump vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_8.xyz * light_6.xyz);
  c_20.xyz = tmpvar_21;
  c_20.w = tmpvar_7;
  c_2 = c_20;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 192 // 160 used size, 13 vars
Vector 128 [unity_LightmapST] 4
Vector 144 [_MainTex_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityShadows" 416 // 416 used size, 8 vars
Vector 400 [unity_ShadowFadeCenterAndType] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 64 [glstate_matrix_modelview0] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityShadows" 2
BindCB "UnityPerDraw" 3
// 28 instructions, 2 temp regs, 0 temp arrays:
// ALU 25 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedkbkgipmebefkaajfebdpbiphkhngidbdabaaaaaaaiajaaaaaeaaaaaa
daaaaaaapaacaaaaiiahaaaafaaiaaaaebgpgodjliacaaaaliacaaaaaaacpopp
feacaaaageaaaaaaafaaceaaaaaagaaaaaaagaaaaaaaceaaabaagaaaaaaaaiaa
acaaabaaaaaaaaaaabaaafaaabaaadaaaaaaaaaaacaabjaaabaaaeaaaaaaaaaa
adaaaaaaaiaaafaaaaaaaaaaadaaamaaaeaaanaaaaaaaaaaaaaaaaaaaaacpopp
fbaaaaafbbaaapkaaaaaaadpaaaaiadpaaaaaaaaaaaaaaaabpaaaaacafaaaaia
aaaaapjabpaaaaacafaaadiaadaaapjabpaaaaacafaaaeiaaeaaapjaafaaaaad
aaaaadiaaaaaffjaaoaaockaaeaaaaaeaaaaadiaanaaockaaaaaaajaaaaaoeia
aeaaaaaeaaaaadiaapaaockaaaaakkjaaaaaoeiaaeaaaaaeaaaaamoabaaaceka
aaaappjaaaaaeeiaaeaaaaaeaaaaadoaadaaoejaacaaoekaacaaookaafaaaaad
aaaaapiaaaaaffjaagaaoekaaeaaaaaeaaaaapiaafaaoekaaaaaaajaaaaaoeia
aeaaaaaeaaaaapiaahaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaaiaaoeka
aaaappjaaaaaoeiaafaaaaadabaaabiaaaaaffiaadaaaakaafaaaaadabaaaiia
abaaaaiabbaaaakaafaaaaadabaaafiaaaaapeiabbaaaakaacaaaaadabaaadoa
abaakkiaabaaomiaaeaaaaaeacaaadoaaeaaoejaabaaoekaabaaookaafaaaaad
abaaahiaaaaaffjaaoaaoekaaeaaaaaeabaaahiaanaaoekaaaaaaajaabaaoeia
aeaaaaaeabaaahiaapaaoekaaaaakkjaabaaoeiaaeaaaaaeabaaahiabaaaoeka
aaaappjaabaaoeiaacaaaaadabaaahiaabaaoeiaaeaaoekbafaaaaadadaaahoa
abaaoeiaaeaappkaafaaaaadabaaabiaaaaaffjaakaakkkaaeaaaaaeabaaabia
ajaakkkaaaaaaajaabaaaaiaaeaaaaaeabaaabiaalaakkkaaaaakkjaabaaaaia
aeaaaaaeabaaabiaamaakkkaaaaappjaabaaaaiaabaaaaacabaaaiiaaeaappka
acaaaaadabaaaciaabaappibbbaaffkaafaaaaadadaaaioaabaaffiaabaaaaib
aeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeia
abaaaaacabaaamoaaaaaoeiappppaaaafdeieefcjaaeaaaaeaaaabaaceabaaaa
fjaaaaaeegiocaaaaaaaaaaaakaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaa
fjaaaaaeegiocaaaacaaaaaabkaaaaaafjaaaaaeegiocaaaadaaaaaabaaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaa
aeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaa
gfaaaaadmccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaa
adaaaaaagfaaaaadpccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaaidcaabaaaabaaaaaafgbfbaaaaaaaaaaaigiacaaaadaaaaaa
anaaaaaadcaaaaakdcaabaaaabaaaaaaigiacaaaadaaaaaaamaaaaaaagbabaaa
aaaaaaaaegaabaaaabaaaaaadcaaaaakdcaabaaaabaaaaaaigiacaaaadaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegaabaaaabaaaaaadcaaaaakmccabaaaabaaaaaa
agiicaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaagaebaaaabaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaajaaaaaaogikcaaa
aaaaaaaaajaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaa
abaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaa
aaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaacaaaaaakgaobaaa
aaaaaaaaaaaaaaahdccabaaaacaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaa
dcaaaaaldccabaaaadaaaaaaegbabaaaaeaaaaaaegiacaaaaaaaaaaaaiaaaaaa
ogikcaaaaaaaaaaaaiaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaaaaaaaaajhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaiaebaaaaaa
acaaaaaabjaaaaaadiaaaaaihccabaaaaeaaaaaaegacbaaaaaaaaaaapgipcaaa
acaaaaaabjaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaaaaaaaaaackiacaaa
adaaaaaaafaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaaeaaaaaa
akbabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaa
adaaaaaaagaaaaaackbabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaa
aaaaaaaackiacaaaadaaaaaaahaaaaaadkbabaaaaaaaaaaaakaabaaaaaaaaaaa
aaaaaaajccaabaaaaaaaaaaadkiacaiaebaaaaaaacaaaaaabjaaaaaaabeaaaaa
aaaaiadpdiaaaaaiiccabaaaaeaaaaaabkaabaaaaaaaaaaaakaabaiaebaaaaaa
aaaaaaaadoaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaaaaaa
laaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaaabaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
afaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaa
feeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaaaiaaaaaa
jiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaa
abaaaaaaamadaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaa
keaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaadamaaaakeaaaaaaaeaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 398
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    highp vec4 screen;
    highp vec2 lmap;
    highp vec4 lmapFadePos;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 393
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 397
uniform highp vec4 _Player3_Pos;
#line 405
#line 419
#line 434
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
#line 450
uniform sampler2D _LightBuffer;
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
#line 454
uniform lowp vec4 unity_Ambient;
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 405
void vert( inout appdata_full vertexData, out Input outData ) {
    highp vec4 pos = (glstate_matrix_mvp * vertexData.vertex);
    highp vec4 posWorld = (_Object2World * vertexData.vertex);
    #line 409
    outData.uv_MainTex = vec2( vertexData.texcoord);
    outData.location = posWorld.xz;
}
#line 436
v2f_surf vert_surf( in appdata_full v ) {
    #line 438
    v2f_surf o;
    Input customInputData;
    vert( v, customInputData);
    o.cust_location = customInputData.location;
    #line 442
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.screen = ComputeScreenPos( o.pos);
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    #line 446
    o.lmapFadePos.xyz = (((_Object2World * v.vertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
    o.lmapFadePos.w = ((-(glstate_matrix_modelview0 * v.vertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
out highp vec2 xlv_TEXCOORD3;
out highp vec4 xlv_TEXCOORD4;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.pack0);
    xlv_TEXCOORD1 = vec2(xl_retval.cust_location);
    xlv_TEXCOORD2 = vec4(xl_retval.screen);
    xlv_TEXCOORD3 = vec2(xl_retval.lmap);
    xlv_TEXCOORD4 = vec4(xl_retval.lmapFadePos);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 398
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    highp vec4 screen;
    highp vec2 lmap;
    highp vec4 lmapFadePos;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 393
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 397
uniform highp vec4 _Player3_Pos;
#line 405
#line 419
#line 434
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
#line 450
uniform sampler2D _LightBuffer;
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
#line 454
uniform lowp vec4 unity_Ambient;
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 346
lowp vec4 LightingLambert_PrePass( in SurfaceOutput s, in mediump vec4 light ) {
    lowp vec4 c;
    c.xyz = (s.Albedo * light.xyz);
    #line 350
    c.w = s.Alpha;
    return c;
}
#line 419
highp float powerForPos( in highp vec4 pos, in highp vec2 nearVertex ) {
    highp float atten = clamp( (_FogRadius - length((pos.xz - nearVertex.xy))), 0.0, _FogRadius);
    return (((1.0 / _FogMaxRadius) * atten) / _FogRadius);
}
#line 412
void surf( in Input IN, inout SurfaceOutput o ) {
    #line 414
    lowp vec4 baseColor = (texture( _MainTex, IN.uv_MainTex) * _Color);
    highp float alpha = (1.0 - (((baseColor.w + powerForPos( _Player1_Pos, IN.location)) + powerForPos( _Player2_Pos, IN.location)) + powerForPos( _Player3_Pos, IN.location)));
    o.Albedo = baseColor.xyz;
    o.Alpha = alpha;
}
#line 455
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    #line 458
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.location = IN.cust_location;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    #line 462
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    #line 466
    surf( surfIN, o);
    mediump vec4 light = textureProj( _LightBuffer, IN.screen);
    light = max( light, vec4( 0.001));
    light = (-log2(light));
    #line 470
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec4 lmtex2 = texture( unity_LightmapInd, IN.lmap.xy);
    mediump float lmFade = ((length(IN.lmapFadePos) * unity_LightmapFade.z) + unity_LightmapFade.w);
    mediump vec3 lmFull = DecodeLightmap( lmtex);
    #line 474
    mediump vec3 lmIndirect = DecodeLightmap( lmtex2);
    mediump vec3 lm = mix( lmIndirect, lmFull, vec3( xll_saturate_f(lmFade)));
    light.xyz += lm;
    mediump vec4 c = LightingLambert_PrePass( o, light);
    #line 478
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
in highp vec2 xlv_TEXCOORD3;
in highp vec4 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec2(xlv_TEXCOORD0);
    xlt_IN.cust_location = vec2(xlv_TEXCOORD1);
    xlt_IN.screen = vec4(xlv_TEXCOORD2);
    xlt_IN.lmap = vec2(xlv_TEXCOORD3);
    xlt_IN.lmapFadePos = vec4(xlv_TEXCOORD4);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 9 [_ProjectionParams]
Matrix 5 [_Object2World]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
"!!ARBvp1.0
# 14 ALU
PARAM c[12] = { { 0.5 },
		state.matrix.mvp,
		program.local[5..11] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MOV result.position, R0;
MUL R1.y, R1, c[9].x;
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[7];
ADD result.texcoord[2].xy, R1, R1.z;
MOV result.texcoord[2].zw, R0;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[11], c[11].zwzw;
MOV result.texcoord[1].xy, R0;
MAD result.texcoord[3].xy, vertex.texcoord[1], c[10], c[10].zwzw;
END
# 14 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Matrix 4 [_Object2World]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
"vs_2_0
; 14 ALU
def c12, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
dcl_texcoord1 v2
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c12.x
mov oPos, r0
mul r1.y, r1, c8.x
dp4 r0.x, v0, c4
dp4 r0.y, v0, c6
mad oT2.xy, r1.z, c9.zwzw, r1
mov oT2.zw, r0
mad oT0.xy, v1, c11, c11.zwzw
mov oT1.xy, r0
mad oT3.xy, v2, c10, c10.zwzw
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 192 // 160 used size, 13 vars
Vector 128 [unity_LightmapST] 4
Vector 144 [_MainTex_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 16 instructions, 2 temp regs, 0 temp arrays:
// ALU 13 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedimbejcbjkjebcoeopfmlamgodmdpdgcoabaaaaaafiaeaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apaaaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaadamaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefclmacaaaaeaaaabaa
kpaaaaaafjaaaaaeegiocaaaaaaaaaaaakaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
gfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaaadaaaaaagiaaaaacacaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaa
aaaaaaaaegaobaaaaaaaaaaadiaaaaaidcaabaaaabaaaaaafgbfbaaaaaaaaaaa
igiacaaaacaaaaaaanaaaaaadcaaaaakdcaabaaaabaaaaaaigiacaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegaabaaaabaaaaaadcaaaaakdcaabaaaabaaaaaa
igiacaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaabaaaabaaaaaadcaaaaak
mccabaaaabaaaaaaagiicaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaagaebaaa
abaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
ajaaaaaaogikcaaaaaaaaaaaajaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaa
aaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaa
acaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaacaaaaaakgakbaaaabaaaaaa
mgaabaaaabaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaaaeaaaaaaegiacaaa
aaaaaaaaaiaaaaaaogikcaaaaaaaaaaaaiaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = o_2;
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp float tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_6;
  arg0_6 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_7;
  arg0_7 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_8;
  arg0_8 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_9;
  tmpvar_9 = (1.0 - (((tmpvar_5.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_7, arg0_7))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_8, arg0_8))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_4 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2DProj (_LightBuffer, xlv_TEXCOORD2);
  light_3 = tmpvar_10;
  mediump vec3 lm_11;
  lowp vec3 tmpvar_12;
  tmpvar_12 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD3).xyz);
  lm_11 = tmpvar_12;
  mediump vec4 tmpvar_13;
  tmpvar_13.w = 0.0;
  tmpvar_13.xyz = lm_11;
  mediump vec4 tmpvar_14;
  tmpvar_14 = (-(log2(max (light_3, vec4(0.001, 0.001, 0.001, 0.001)))) + tmpvar_13);
  light_3 = tmpvar_14;
  lowp vec4 c_15;
  mediump vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_5.xyz * tmpvar_14.xyz);
  c_15.xyz = tmpvar_16;
  c_15.w = tmpvar_4;
  c_2 = c_15;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = o_2;
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp float tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_6;
  arg0_6 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_7;
  arg0_7 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_8;
  arg0_8 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_9;
  tmpvar_9 = (1.0 - (((tmpvar_5.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_7, arg0_7))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_8, arg0_8))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_4 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2DProj (_LightBuffer, xlv_TEXCOORD2);
  light_3 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (unity_Lightmap, xlv_TEXCOORD3);
  mediump vec3 lm_12;
  lowp vec3 tmpvar_13;
  tmpvar_13 = ((8.0 * tmpvar_11.w) * tmpvar_11.xyz);
  lm_12 = tmpvar_13;
  mediump vec4 tmpvar_14;
  tmpvar_14.w = 0.0;
  tmpvar_14.xyz = lm_12;
  mediump vec4 tmpvar_15;
  tmpvar_15 = (-(log2(max (light_3, vec4(0.001, 0.001, 0.001, 0.001)))) + tmpvar_14);
  light_3 = tmpvar_15;
  lowp vec4 c_16;
  mediump vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_5.xyz * tmpvar_15.xyz);
  c_16.xyz = tmpvar_17;
  c_16.w = tmpvar_4;
  c_2 = c_16;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 192 // 160 used size, 13 vars
Vector 128 [unity_LightmapST] 4
Vector 144 [_MainTex_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 16 instructions, 2 temp regs, 0 temp arrays:
// ALU 13 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedjmcchakocfhjafapnmcnehcjkjpagmddabaaaaaacmagaaaaaeaaaaaa
daaaaaaaaaacaaaameaeaaaaimafaaaaebgpgodjmiabaaaamiabaaaaaaacpopp
haabaaaafiaaaaaaaeaaceaaaaaafeaaaaaafeaaaaaaceaaabaafeaaaaaaaiaa
acaaabaaaaaaaaaaabaaafaaabaaadaaaaaaaaaaacaaaaaaaeaaaeaaaaaaaaaa
acaaamaaaeaaaiaaaaaaaaaaaaaaaaaaaaacpoppfbaaaaafamaaapkaaaaaaadp
aaaaaaaaaaaaaaaaaaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaadia
adaaapjabpaaaaacafaaaeiaaeaaapjaafaaaaadaaaaadiaaaaaffjaajaaocka
aeaaaaaeaaaaadiaaiaaockaaaaaaajaaaaaoeiaaeaaaaaeaaaaadiaakaaocka
aaaakkjaaaaaoeiaaeaaaaaeaaaaamoaalaacekaaaaappjaaaaaeeiaaeaaaaae
aaaaadoaadaaoejaacaaoekaacaaookaafaaaaadaaaaapiaaaaaffjaafaaoeka
aeaaaaaeaaaaapiaaeaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaagaaoeka
aaaakkjaaaaaoeiaaeaaaaaeaaaaapiaahaaoekaaaaappjaaaaaoeiaafaaaaad
abaaabiaaaaaffiaadaaaakaafaaaaadabaaaiiaabaaaaiaamaaaakaafaaaaad
abaaafiaaaaapeiaamaaaakaacaaaaadabaaadoaabaakkiaabaaomiaaeaaaaae
acaaadoaaeaaoejaabaaoekaabaaookaaeaaaaaeaaaaadmaaaaappiaaaaaoeka
aaaaoeiaabaaaaacaaaaammaaaaaoeiaabaaaaacabaaamoaaaaaoeiappppaaaa
fdeieefclmacaaaaeaaaabaakpaaaaaafjaaaaaeegiocaaaaaaaaaaaakaaaaaa
fjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaabaaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaa
aeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaa
gfaaaaadmccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaa
adaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaidcaabaaa
abaaaaaafgbfbaaaaaaaaaaaigiacaaaacaaaaaaanaaaaaadcaaaaakdcaabaaa
abaaaaaaigiacaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegaabaaaabaaaaaa
dcaaaaakdcaabaaaabaaaaaaigiacaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egaabaaaabaaaaaadcaaaaakmccabaaaabaaaaaaagiicaaaacaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaagaebaaaabaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaajaaaaaaogikcaaaaaaaaaaaajaaaaaadiaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaak
ncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaadpdgaaaaafmccabaaaacaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaa
acaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadcaaaaaldccabaaaadaaaaaa
egbabaaaaeaaaaaaegiacaaaaaaaaaaaaiaaaaaaogikcaaaaaaaaaaaaiaaaaaa
doaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
apaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaaaaaalaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaaabaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffied
epepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadamaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amadaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaadaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 398
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    highp vec4 screen;
    highp vec2 lmap;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 393
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 397
uniform highp vec4 _Player3_Pos;
#line 405
#line 419
#line 433
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform sampler2D _LightBuffer;
uniform sampler2D unity_Lightmap;
#line 449
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
uniform lowp vec4 unity_Ambient;
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 405
void vert( inout appdata_full vertexData, out Input outData ) {
    highp vec4 pos = (glstate_matrix_mvp * vertexData.vertex);
    highp vec4 posWorld = (_Object2World * vertexData.vertex);
    #line 409
    outData.uv_MainTex = vec2( vertexData.texcoord);
    outData.location = posWorld.xz;
}
#line 435
v2f_surf vert_surf( in appdata_full v ) {
    #line 437
    v2f_surf o;
    Input customInputData;
    vert( v, customInputData);
    o.cust_location = customInputData.location;
    #line 441
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.screen = ComputeScreenPos( o.pos);
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    #line 445
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
out highp vec2 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.pack0);
    xlv_TEXCOORD1 = vec2(xl_retval.cust_location);
    xlv_TEXCOORD2 = vec4(xl_retval.screen);
    xlv_TEXCOORD3 = vec2(xl_retval.lmap);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 398
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    highp vec4 screen;
    highp vec2 lmap;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 393
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 397
uniform highp vec4 _Player3_Pos;
#line 405
#line 419
#line 433
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform sampler2D _LightBuffer;
uniform sampler2D unity_Lightmap;
#line 449
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
uniform lowp vec4 unity_Ambient;
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 325
mediump vec3 DirLightmapDiffuse( in mediump mat3 dirBasis, in lowp vec4 color, in lowp vec4 scale, in mediump vec3 normal, in bool surfFuncWritesNormal, out mediump vec3 scalePerBasisVector ) {
    mediump vec3 lm = DecodeLightmap( color);
    scalePerBasisVector = DecodeLightmap( scale);
    #line 329
    if (surfFuncWritesNormal){
        mediump vec3 normalInRnmBasis = xll_saturate_vf3((dirBasis * normal));
        lm *= dot( normalInRnmBasis, scalePerBasisVector);
    }
    #line 334
    return lm;
}
#line 353
mediump vec4 LightingLambert_DirLightmap( in SurfaceOutput s, in lowp vec4 color, in lowp vec4 scale, in bool surfFuncWritesNormal ) {
    #line 355
    highp mat3 unity_DirBasis = xll_transpose_mf3x3(mat3( vec3( 0.816497, 0.0, 0.57735), vec3( -0.408248, 0.707107, 0.57735), vec3( -0.408248, -0.707107, 0.57735)));
    mediump vec3 scalePerBasisVector;
    mediump vec3 lm = DirLightmapDiffuse( unity_DirBasis, color, scale, s.Normal, surfFuncWritesNormal, scalePerBasisVector);
    return vec4( lm, 0.0);
}
#line 346
lowp vec4 LightingLambert_PrePass( in SurfaceOutput s, in mediump vec4 light ) {
    lowp vec4 c;
    c.xyz = (s.Albedo * light.xyz);
    #line 350
    c.w = s.Alpha;
    return c;
}
#line 419
highp float powerForPos( in highp vec4 pos, in highp vec2 nearVertex ) {
    highp float atten = clamp( (_FogRadius - length((pos.xz - nearVertex.xy))), 0.0, _FogRadius);
    return (((1.0 / _FogMaxRadius) * atten) / _FogRadius);
}
#line 412
void surf( in Input IN, inout SurfaceOutput o ) {
    #line 414
    lowp vec4 baseColor = (texture( _MainTex, IN.uv_MainTex) * _Color);
    highp float alpha = (1.0 - (((baseColor.w + powerForPos( _Player1_Pos, IN.location)) + powerForPos( _Player2_Pos, IN.location)) + powerForPos( _Player3_Pos, IN.location)));
    o.Albedo = baseColor.xyz;
    o.Alpha = alpha;
}
#line 452
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 454
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.location = IN.cust_location;
    SurfaceOutput o;
    #line 458
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 462
    o.Gloss = 0.0;
    surf( surfIN, o);
    mediump vec4 light = textureProj( _LightBuffer, IN.screen);
    light = max( light, vec4( 0.001));
    #line 466
    light = (-log2(light));
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec4 lmIndTex = texture( unity_LightmapInd, IN.lmap.xy);
    mediump vec4 lm = LightingLambert_DirLightmap( o, lmtex, lmIndTex, false);
    #line 470
    light += lm;
    mediump vec4 c = LightingLambert_PrePass( o, light);
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
in highp vec2 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec2(xlv_TEXCOORD0);
    xlt_IN.cust_location = vec2(xlv_TEXCOORD1);
    xlt_IN.screen = vec4(xlv_TEXCOORD2);
    xlt_IN.lmap = vec2(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_ProjectionParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Matrix 5 [_Object2World]
Vector 17 [unity_Scale]
Vector 18 [_MainTex_ST]
"!!ARBvp1.0
# 31 ALU
PARAM c[19] = { { 0.5, 1 },
		state.matrix.mvp,
		program.local[5..18] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[17].w;
DP3 R2.w, R1, c[6];
DP3 R0.x, R1, c[5];
DP3 R0.z, R1, c[7];
MOV R0.y, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].y;
DP4 R2.z, R0, c[12];
DP4 R2.y, R0, c[11];
DP4 R2.x, R0, c[10];
MUL R0.y, R2.w, R2.w;
DP4 R3.z, R1, c[15];
DP4 R3.y, R1, c[14];
DP4 R3.x, R1, c[13];
DP4 R1.w, vertex.position, c[4];
DP4 R1.z, vertex.position, c[3];
MAD R0.x, R0, R0, -R0.y;
ADD R3.xyz, R2, R3;
MUL R2.xyz, R0.x, c[16];
DP4 R1.x, vertex.position, c[1];
DP4 R1.y, vertex.position, c[2];
MUL R0.xyz, R1.xyww, c[0].x;
MUL R0.y, R0, c[9].x;
ADD result.texcoord[2].xy, R0, R0.z;
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[7];
ADD result.texcoord[3].xyz, R3, R2;
MOV result.position, R1;
MOV result.texcoord[2].zw, R1;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
MOV result.texcoord[1].xy, R0;
END
# 31 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Matrix 4 [_Object2World]
Vector 17 [unity_Scale]
Vector 18 [_MainTex_ST]
"vs_2_0
; 31 ALU
def c19, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c17.w
dp3 r2.w, r1, c5
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.y, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c19.y
dp4 r2.z, r0, c12
dp4 r2.y, r0, c11
dp4 r2.x, r0, c10
mul r0.y, r2.w, r2.w
dp4 r3.z, r1, c15
dp4 r3.y, r1, c14
dp4 r3.x, r1, c13
dp4 r1.w, v0, c3
dp4 r1.z, v0, c2
mad r0.x, r0, r0, -r0.y
add r3.xyz, r2, r3
mul r2.xyz, r0.x, c16
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mul r0.xyz, r1.xyww, c19.x
mul r0.y, r0, c8.x
mad oT2.xy, r0.z, c9.zwzw, r0
dp4 r0.x, v0, c4
dp4 r0.y, v0, c6
add oT3.xyz, r3, r2
mov oPos, r1
mov oT2.zw, r1
mad oT0.xy, v2, c18, c18.zwzw
mov oT1.xy, r0
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 160 // 144 used size, 11 vars
Vector 128 [_MainTex_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 31 instructions, 4 temp regs, 0 temp arrays:
// ALU 27 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedhficideepigmfojkiboikklenpbcjmfpabaaaaaaeeagaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apaaaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefckiaeaaaaeaaaabaa
ckabaaaafjaaaaaeegiocaaaaaaaaaaaajaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaad
hccabaaaadaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
dcaabaaaabaaaaaafgbfbaaaaaaaaaaaigiacaaaadaaaaaaanaaaaaadcaaaaak
dcaabaaaabaaaaaaigiacaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegaabaaa
abaaaaaadcaaaaakdcaabaaaabaaaaaaigiacaaaadaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegaabaaaabaaaaaadcaaaaakmccabaaaabaaaaaaagiicaaaadaaaaaa
apaaaaaapgbpbaaaaaaaaaaaagaebaaaabaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaaiaaaaaaogikcaaaaaaaaaaaaiaaaaaa
diaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaa
aaaaaadpaaaaaadpdgaaaaafmccabaaaacaaaaaakgaobaaaaaaaaaaaaaaaaaah
dccabaaaacaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadiaaaaaihcaabaaa
aaaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaa
abaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaa
aaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaa
egadbaaaaaaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaai
bcaabaaaabaaaaaaegiocaaaacaaaaaacgaaaaaaegaobaaaaaaaaaaabbaaaaai
ccaabaaaabaaaaaaegiocaaaacaaaaaachaaaaaaegaobaaaaaaaaaaabbaaaaai
ecaabaaaabaaaaaaegiocaaaacaaaaaaciaaaaaaegaobaaaaaaaaaaadiaaaaah
pcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaaibcaabaaa
adaaaaaaegiocaaaacaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaa
adaaaaaaegiocaaaacaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaa
adaaaaaaegiocaaaacaaaaaaclaaaaaaegaobaaaacaaaaaaaaaaaaahhcaabaaa
abaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaahccaabaaaaaaaaaaa
bkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaakaabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaadcaaaaakhccabaaa
adaaaaaaegiccaaaacaaaaaacmaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.5);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_2.zw;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = (tmpvar_6 * (normalize(_glesNormal) * unity_Scale.w));
  mediump vec3 tmpvar_8;
  mediump vec4 normal_9;
  normal_9 = tmpvar_7;
  highp float vC_10;
  mediump vec3 x3_11;
  mediump vec3 x2_12;
  mediump vec3 x1_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal_9);
  x1_13.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal_9);
  x1_13.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal_9);
  x1_13.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal_9.xyzz * normal_9.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2_12.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2_12.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2_12.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal_9.x * normal_9.x) - (normal_9.y * normal_9.y));
  vC_10 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC_10);
  x3_11 = tmpvar_22;
  tmpvar_8 = ((x1_13 + x2_12) + x3_11);
  tmpvar_1 = tmpvar_8;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = o_3;
  xlv_TEXCOORD3 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _LightBuffer;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp float tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_6;
  arg0_6 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_7;
  arg0_7 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_8;
  arg0_8 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_9;
  tmpvar_9 = (1.0 - (((tmpvar_5.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_7, arg0_7))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_8, arg0_8))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_4 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2DProj (_LightBuffer, xlv_TEXCOORD2);
  light_3 = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = max (light_3, vec4(0.001, 0.001, 0.001, 0.001));
  light_3.w = tmpvar_11.w;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11.xyz + xlv_TEXCOORD3);
  light_3.xyz = tmpvar_12;
  lowp vec4 c_13;
  mediump vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_5.xyz * light_3.xyz);
  c_13.xyz = tmpvar_14;
  c_13.w = tmpvar_4;
  c_2 = c_13;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.5);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_2.zw;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = (tmpvar_6 * (normalize(_glesNormal) * unity_Scale.w));
  mediump vec3 tmpvar_8;
  mediump vec4 normal_9;
  normal_9 = tmpvar_7;
  highp float vC_10;
  mediump vec3 x3_11;
  mediump vec3 x2_12;
  mediump vec3 x1_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal_9);
  x1_13.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal_9);
  x1_13.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal_9);
  x1_13.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal_9.xyzz * normal_9.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2_12.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2_12.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2_12.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal_9.x * normal_9.x) - (normal_9.y * normal_9.y));
  vC_10 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC_10);
  x3_11 = tmpvar_22;
  tmpvar_8 = ((x1_13 + x2_12) + x3_11);
  tmpvar_1 = tmpvar_8;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = o_3;
  xlv_TEXCOORD3 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _LightBuffer;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp float tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_6;
  arg0_6 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_7;
  arg0_7 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_8;
  arg0_8 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_9;
  tmpvar_9 = (1.0 - (((tmpvar_5.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_7, arg0_7))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_8, arg0_8))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_4 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2DProj (_LightBuffer, xlv_TEXCOORD2);
  light_3 = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = max (light_3, vec4(0.001, 0.001, 0.001, 0.001));
  light_3.w = tmpvar_11.w;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11.xyz + xlv_TEXCOORD3);
  light_3.xyz = tmpvar_12;
  lowp vec4 c_13;
  mediump vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_5.xyz * light_3.xyz);
  c_13.xyz = tmpvar_14;
  c_13.w = tmpvar_4;
  c_2 = c_13;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 160 // 144 used size, 11 vars
Vector 128 [_MainTex_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 31 instructions, 4 temp regs, 0 temp arrays:
// ALU 27 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedomhblcppbibjelclkefdmofbbebpimafabaaaaaaciajaaaaaeaaaaaa
daaaaaaabaadaaaamaahaaaaiiaiaaaaebgpgodjniacaaaaniacaaaaaaacpopp
giacaaaahaaaaaaaagaaceaaaaaagmaaaaaagmaaaaaaceaaabaagmaaaaaaaiaa
abaaabaaaaaaaaaaabaaafaaabaaacaaaaaaaaaaacaacgaaahaaadaaaaaaaaaa
adaaaaaaaeaaakaaaaaaaaaaadaaamaaaeaaaoaaaaaaaaaaadaabeaaabaabcaa
aaaaaaaaaaaaaaaaaaacpoppfbaaaaafbdaaapkaaaaaaadpaaaaiadpaaaaaaaa
aaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaaciaacaaapjabpaaaaac
afaaadiaadaaapjaafaaaaadaaaaadiaaaaaffjaapaaockaaeaaaaaeaaaaadia
aoaaockaaaaaaajaaaaaoeiaaeaaaaaeaaaaadiabaaaockaaaaakkjaaaaaoeia
aeaaaaaeaaaaamoabbaacekaaaaappjaaaaaeeiaaeaaaaaeaaaaadoaadaaoeja
abaaoekaabaaookaafaaaaadaaaaapiaaaaaffjaalaaoekaaeaaaaaeaaaaapia
akaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaamaaoekaaaaakkjaaaaaoeia
aeaaaaaeaaaaapiaanaaoekaaaaappjaaaaaoeiaafaaaaadabaaabiaaaaaffia
acaaaakaafaaaaadabaaaiiaabaaaaiabdaaaakaafaaaaadabaaafiaaaaapeia
bdaaaakaacaaaaadabaaadoaabaakkiaabaaomiaafaaaaadabaaahiaacaaoeja
bcaappkaafaaaaadacaaahiaabaaffiaapaaoekaaeaaaaaeabaaaliaaoaakeka
abaaaaiaacaakeiaaeaaaaaeabaaahiabaaaoekaabaakkiaabaapeiaabaaaaac
abaaaiiabdaaffkaajaaaaadacaaabiaadaaoekaabaaoeiaajaaaaadacaaacia
aeaaoekaabaaoeiaajaaaaadacaaaeiaafaaoekaabaaoeiaafaaaaadadaaapia
abaacjiaabaakeiaajaaaaadaeaaabiaagaaoekaadaaoeiaajaaaaadaeaaacia
ahaaoekaadaaoeiaajaaaaadaeaaaeiaaiaaoekaadaaoeiaacaaaaadacaaahia
acaaoeiaaeaaoeiaafaaaaadabaaaciaabaaffiaabaaffiaaeaaaaaeabaaabia
abaaaaiaabaaaaiaabaaffibaeaaaaaeacaaahoaajaaoekaabaaaaiaacaaoeia
aeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeia
abaaaaacabaaamoaaaaaoeiappppaaaafdeieefckiaeaaaaeaaaabaackabaaaa
fjaaaaaeegiocaaaaaaaaaaaajaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaa
fjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaa
adaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaa
gfaaaaadmccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaadhccabaaa
adaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaidcaabaaa
abaaaaaafgbfbaaaaaaaaaaaigiacaaaadaaaaaaanaaaaaadcaaaaakdcaabaaa
abaaaaaaigiacaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegaabaaaabaaaaaa
dcaaaaakdcaabaaaabaaaaaaigiacaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egaabaaaabaaaaaadcaaaaakmccabaaaabaaaaaaagiicaaaadaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaagaebaaaabaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaaiaaaaaaogikcaaaaaaaaaaaaiaaaaaadiaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaak
ncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaadpdgaaaaafmccabaaaacaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaa
acaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaa
egbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaa
egiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaa
aaaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaa
abaaaaaaegiocaaaacaaaaaacgaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaa
abaaaaaaegiocaaaacaaaaaachaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaa
abaaaaaaegiocaaaacaaaaaaciaaaaaaegaobaaaaaaaaaaadiaaaaahpcaabaaa
acaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaa
egiocaaaacaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaa
egiocaaaacaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaa
egiocaaaacaaaaaaclaaaaaaegaobaaaacaaaaaaaaaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaahccaabaaaaaaaaaaabkaabaaa
aaaaaaaabkaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
akaabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaadcaaaaakhccabaaaadaaaaaa
egiccaaaacaaaaaacmaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab
ejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaa
kjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaa
faepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfcee
aaedepemepfcaaklepfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaadamaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaa
imaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaaimaaaaaaadaaaaaa
aaaaaaaaadaaaaaaadaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 398
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    highp vec4 screen;
    highp vec3 vlight;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 393
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 397
uniform highp vec4 _Player3_Pos;
#line 405
#line 419
#line 433
uniform highp vec4 _MainTex_ST;
uniform sampler2D _LightBuffer;
uniform lowp vec4 unity_Ambient;
#line 449
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 405
void vert( inout appdata_full vertexData, out Input outData ) {
    highp vec4 pos = (glstate_matrix_mvp * vertexData.vertex);
    highp vec4 posWorld = (_Object2World * vertexData.vertex);
    #line 409
    outData.uv_MainTex = vec2( vertexData.texcoord);
    outData.location = posWorld.xz;
}
#line 434
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 437
    Input customInputData;
    vert( v, customInputData);
    o.cust_location = customInputData.location;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 441
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.screen = ComputeScreenPos( o.pos);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.vlight = ShadeSH9( vec4( worldN, 1.0));
    #line 445
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.pack0);
    xlv_TEXCOORD1 = vec2(xl_retval.cust_location);
    xlv_TEXCOORD2 = vec4(xl_retval.screen);
    xlv_TEXCOORD3 = vec3(xl_retval.vlight);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 398
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    highp vec4 screen;
    highp vec3 vlight;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 393
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 397
uniform highp vec4 _Player3_Pos;
#line 405
#line 419
#line 433
uniform highp vec4 _MainTex_ST;
uniform sampler2D _LightBuffer;
uniform lowp vec4 unity_Ambient;
#line 449
#line 346
lowp vec4 LightingLambert_PrePass( in SurfaceOutput s, in mediump vec4 light ) {
    lowp vec4 c;
    c.xyz = (s.Albedo * light.xyz);
    #line 350
    c.w = s.Alpha;
    return c;
}
#line 419
highp float powerForPos( in highp vec4 pos, in highp vec2 nearVertex ) {
    highp float atten = clamp( (_FogRadius - length((pos.xz - nearVertex.xy))), 0.0, _FogRadius);
    return (((1.0 / _FogMaxRadius) * atten) / _FogRadius);
}
#line 412
void surf( in Input IN, inout SurfaceOutput o ) {
    #line 414
    lowp vec4 baseColor = (texture( _MainTex, IN.uv_MainTex) * _Color);
    highp float alpha = (1.0 - (((baseColor.w + powerForPos( _Player1_Pos, IN.location)) + powerForPos( _Player2_Pos, IN.location)) + powerForPos( _Player3_Pos, IN.location)));
    o.Albedo = baseColor.xyz;
    o.Alpha = alpha;
}
#line 449
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    #line 453
    surfIN.location = IN.cust_location;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 457
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    surf( surfIN, o);
    #line 461
    mediump vec4 light = textureProj( _LightBuffer, IN.screen);
    light = max( light, vec4( 0.001));
    light.xyz += IN.vlight;
    mediump vec4 c = LightingLambert_PrePass( o, light);
    #line 465
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec2(xlv_TEXCOORD0);
    xlt_IN.cust_location = vec2(xlv_TEXCOORD1);
    xlt_IN.screen = vec4(xlv_TEXCOORD2);
    xlt_IN.vlight = vec3(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 13 [_ProjectionParams]
Vector 14 [unity_ShadowFadeCenterAndType]
Matrix 9 [_Object2World]
Vector 15 [unity_LightmapST]
Vector 16 [_MainTex_ST]
"!!ARBvp1.0
# 22 ALU
PARAM c[17] = { { 0.5, 1 },
		state.matrix.modelview[0],
		state.matrix.mvp,
		program.local[9..16] };
TEMP R0;
TEMP R1;
TEMP R2;
DP4 R1.w, vertex.position, c[8];
DP4 R1.z, vertex.position, c[7];
DP4 R1.x, vertex.position, c[5];
DP4 R1.y, vertex.position, c[6];
MUL R0.xyz, R1.xyww, c[0].x;
MUL R0.y, R0, c[13].x;
ADD result.texcoord[2].xy, R0, R0.z;
DP4 R0.x, vertex.position, c[9];
DP4 R0.z, vertex.position, c[11];
DP4 R0.y, vertex.position, c[10];
ADD R2.xyz, R0, -c[14];
MOV R0.y, R0.z;
MOV result.texcoord[1].xy, R0;
MOV R0.x, c[0].y;
ADD R0.y, R0.x, -c[14].w;
DP4 R0.x, vertex.position, c[3];
MOV result.position, R1;
MOV result.texcoord[2].zw, R1;
MUL result.texcoord[4].xyz, R2, c[14].w;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
MAD result.texcoord[3].xy, vertex.texcoord[1], c[15], c[15].zwzw;
MUL result.texcoord[4].w, -R0.x, R0.y;
END
# 22 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_ShadowFadeCenterAndType]
Matrix 8 [_Object2World]
Vector 15 [unity_LightmapST]
Vector 16 [_MainTex_ST]
"vs_2_0
; 22 ALU
def c17, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
dcl_texcoord1 v2
dp4 r1.w, v0, c7
dp4 r1.z, v0, c6
dp4 r1.x, v0, c4
dp4 r1.y, v0, c5
mul r0.xyz, r1.xyww, c17.x
mul r0.y, r0, c12.x
mad oT2.xy, r0.z, c13.zwzw, r0
dp4 r0.x, v0, c8
dp4 r0.z, v0, c10
dp4 r0.y, v0, c9
add r2.xyz, r0, -c14
mov r0.y, r0.z
mov oT1.xy, r0
mov r0.x, c14.w
add r0.y, c17, -r0.x
dp4 r0.x, v0, c2
mov oPos, r1
mov oT2.zw, r1
mul oT4.xyz, r2, c14.w
mad oT0.xy, v1, c16, c16.zwzw
mad oT3.xy, v2, c15, c15.zwzw
mul oT4.w, -r0.x, r0.y
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 192 // 160 used size, 13 vars
Vector 128 [unity_LightmapST] 4
Vector 144 [_MainTex_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityShadows" 416 // 416 used size, 8 vars
Vector 400 [unity_ShadowFadeCenterAndType] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 64 [glstate_matrix_modelview0] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityShadows" 2
BindCB "UnityPerDraw" 3
// 28 instructions, 2 temp regs, 0 temp arrays:
// ALU 25 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefieceddffkcobdnoaghpaiphmanllbjcmhalocabaaaaaaeeagaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apaaaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaadamaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcjaaeaaaaeaaaabaaceabaaaafjaaaaae
egiocaaaaaaaaaaaakaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaabkaaaaaafjaaaaaeegiocaaaadaaaaaabaaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
mccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaaadaaaaaa
gfaaaaadpccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaidcaabaaaabaaaaaafgbfbaaaaaaaaaaaigiacaaaadaaaaaaanaaaaaa
dcaaaaakdcaabaaaabaaaaaaigiacaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaa
egaabaaaabaaaaaadcaaaaakdcaabaaaabaaaaaaigiacaaaadaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegaabaaaabaaaaaadcaaaaakmccabaaaabaaaaaaagiicaaa
adaaaaaaapaaaaaapgbpbaaaaaaaaaaaagaebaaaabaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaajaaaaaaogikcaaaaaaaaaaa
ajaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaa
afaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadp
aaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaacaaaaaakgaobaaaaaaaaaaa
aaaaaaahdccabaaaacaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadcaaaaal
dccabaaaadaaaaaaegbabaaaaeaaaaaaegiacaaaaaaaaaaaaiaaaaaaogikcaaa
aaaaaaaaaiaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
adaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaa
aaaaaaajhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaiaebaaaaaaacaaaaaa
bjaaaaaadiaaaaaihccabaaaaeaaaaaaegacbaaaaaaaaaaapgipcaaaacaaaaaa
bjaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaaaaaaaaaackiacaaaadaaaaaa
afaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaaeaaaaaaakbabaaa
aaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaa
agaaaaaackbabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaa
ckiacaaaadaaaaaaahaaaaaadkbabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaaj
ccaabaaaaaaaaaaadkiacaiaebaaaaaaacaaaaaabjaaaaaaabeaaaaaaaaaiadp
diaaaaaiiccabaaaaeaaaaaabkaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.5);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_2.zw;
  tmpvar_1.xyz = (((_Object2World * _glesVertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_1.w = (-((glstate_matrix_modelview0 * _glesVertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = o_3;
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD4 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec3 lmIndirect_3;
  mediump vec3 lmFull_4;
  mediump float lmFade_5;
  mediump vec4 light_6;
  lowp float tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_9;
  arg0_9 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_10;
  arg0_10 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_11;
  arg0_11 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_12;
  tmpvar_12 = (1.0 - (((tmpvar_8.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_9, arg0_9))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_10, arg0_10))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_11, arg0_11))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_7 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2DProj (_LightBuffer, xlv_TEXCOORD2);
  light_6 = tmpvar_13;
  mediump vec4 tmpvar_14;
  tmpvar_14 = max (light_6, vec4(0.001, 0.001, 0.001, 0.001));
  light_6.w = tmpvar_14.w;
  highp float tmpvar_15;
  tmpvar_15 = ((sqrt(dot (xlv_TEXCOORD4, xlv_TEXCOORD4)) * unity_LightmapFade.z) + unity_LightmapFade.w);
  lmFade_5 = tmpvar_15;
  lowp vec3 tmpvar_16;
  tmpvar_16 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD3).xyz);
  lmFull_4 = tmpvar_16;
  lowp vec3 tmpvar_17;
  tmpvar_17 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD3).xyz);
  lmIndirect_3 = tmpvar_17;
  light_6.xyz = (tmpvar_14.xyz + mix (lmIndirect_3, lmFull_4, vec3(clamp (lmFade_5, 0.0, 1.0))));
  lowp vec4 c_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = (tmpvar_8.xyz * light_6.xyz);
  c_18.xyz = tmpvar_19;
  c_18.w = tmpvar_7;
  c_2 = c_18;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.5);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_2.zw;
  tmpvar_1.xyz = (((_Object2World * _glesVertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_1.w = (-((glstate_matrix_modelview0 * _glesVertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = o_3;
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD4 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec3 lmIndirect_3;
  mediump vec3 lmFull_4;
  mediump float lmFade_5;
  mediump vec4 light_6;
  lowp float tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_9;
  arg0_9 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_10;
  arg0_10 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_11;
  arg0_11 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_12;
  tmpvar_12 = (1.0 - (((tmpvar_8.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_9, arg0_9))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_10, arg0_10))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_11, arg0_11))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_7 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2DProj (_LightBuffer, xlv_TEXCOORD2);
  light_6 = tmpvar_13;
  mediump vec4 tmpvar_14;
  tmpvar_14 = max (light_6, vec4(0.001, 0.001, 0.001, 0.001));
  light_6.w = tmpvar_14.w;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (unity_Lightmap, xlv_TEXCOORD3);
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (unity_LightmapInd, xlv_TEXCOORD3);
  highp float tmpvar_17;
  tmpvar_17 = ((sqrt(dot (xlv_TEXCOORD4, xlv_TEXCOORD4)) * unity_LightmapFade.z) + unity_LightmapFade.w);
  lmFade_5 = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = ((8.0 * tmpvar_15.w) * tmpvar_15.xyz);
  lmFull_4 = tmpvar_18;
  lowp vec3 tmpvar_19;
  tmpvar_19 = ((8.0 * tmpvar_16.w) * tmpvar_16.xyz);
  lmIndirect_3 = tmpvar_19;
  light_6.xyz = (tmpvar_14.xyz + mix (lmIndirect_3, lmFull_4, vec3(clamp (lmFade_5, 0.0, 1.0))));
  lowp vec4 c_20;
  mediump vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_8.xyz * light_6.xyz);
  c_20.xyz = tmpvar_21;
  c_20.w = tmpvar_7;
  c_2 = c_20;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 192 // 160 used size, 13 vars
Vector 128 [unity_LightmapST] 4
Vector 144 [_MainTex_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityShadows" 416 // 416 used size, 8 vars
Vector 400 [unity_ShadowFadeCenterAndType] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 64 [glstate_matrix_modelview0] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityShadows" 2
BindCB "UnityPerDraw" 3
// 28 instructions, 2 temp regs, 0 temp arrays:
// ALU 25 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedkbkgipmebefkaajfebdpbiphkhngidbdabaaaaaaaiajaaaaaeaaaaaa
daaaaaaapaacaaaaiiahaaaafaaiaaaaebgpgodjliacaaaaliacaaaaaaacpopp
feacaaaageaaaaaaafaaceaaaaaagaaaaaaagaaaaaaaceaaabaagaaaaaaaaiaa
acaaabaaaaaaaaaaabaaafaaabaaadaaaaaaaaaaacaabjaaabaaaeaaaaaaaaaa
adaaaaaaaiaaafaaaaaaaaaaadaaamaaaeaaanaaaaaaaaaaaaaaaaaaaaacpopp
fbaaaaafbbaaapkaaaaaaadpaaaaiadpaaaaaaaaaaaaaaaabpaaaaacafaaaaia
aaaaapjabpaaaaacafaaadiaadaaapjabpaaaaacafaaaeiaaeaaapjaafaaaaad
aaaaadiaaaaaffjaaoaaockaaeaaaaaeaaaaadiaanaaockaaaaaaajaaaaaoeia
aeaaaaaeaaaaadiaapaaockaaaaakkjaaaaaoeiaaeaaaaaeaaaaamoabaaaceka
aaaappjaaaaaeeiaaeaaaaaeaaaaadoaadaaoejaacaaoekaacaaookaafaaaaad
aaaaapiaaaaaffjaagaaoekaaeaaaaaeaaaaapiaafaaoekaaaaaaajaaaaaoeia
aeaaaaaeaaaaapiaahaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaaiaaoeka
aaaappjaaaaaoeiaafaaaaadabaaabiaaaaaffiaadaaaakaafaaaaadabaaaiia
abaaaaiabbaaaakaafaaaaadabaaafiaaaaapeiabbaaaakaacaaaaadabaaadoa
abaakkiaabaaomiaaeaaaaaeacaaadoaaeaaoejaabaaoekaabaaookaafaaaaad
abaaahiaaaaaffjaaoaaoekaaeaaaaaeabaaahiaanaaoekaaaaaaajaabaaoeia
aeaaaaaeabaaahiaapaaoekaaaaakkjaabaaoeiaaeaaaaaeabaaahiabaaaoeka
aaaappjaabaaoeiaacaaaaadabaaahiaabaaoeiaaeaaoekbafaaaaadadaaahoa
abaaoeiaaeaappkaafaaaaadabaaabiaaaaaffjaakaakkkaaeaaaaaeabaaabia
ajaakkkaaaaaaajaabaaaaiaaeaaaaaeabaaabiaalaakkkaaaaakkjaabaaaaia
aeaaaaaeabaaabiaamaakkkaaaaappjaabaaaaiaabaaaaacabaaaiiaaeaappka
acaaaaadabaaaciaabaappibbbaaffkaafaaaaadadaaaioaabaaffiaabaaaaib
aeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeia
abaaaaacabaaamoaaaaaoeiappppaaaafdeieefcjaaeaaaaeaaaabaaceabaaaa
fjaaaaaeegiocaaaaaaaaaaaakaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaa
fjaaaaaeegiocaaaacaaaaaabkaaaaaafjaaaaaeegiocaaaadaaaaaabaaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaa
aeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaa
gfaaaaadmccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaa
adaaaaaagfaaaaadpccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaaidcaabaaaabaaaaaafgbfbaaaaaaaaaaaigiacaaaadaaaaaa
anaaaaaadcaaaaakdcaabaaaabaaaaaaigiacaaaadaaaaaaamaaaaaaagbabaaa
aaaaaaaaegaabaaaabaaaaaadcaaaaakdcaabaaaabaaaaaaigiacaaaadaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegaabaaaabaaaaaadcaaaaakmccabaaaabaaaaaa
agiicaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaagaebaaaabaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaajaaaaaaogikcaaa
aaaaaaaaajaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaa
abaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaa
aaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaacaaaaaakgaobaaa
aaaaaaaaaaaaaaahdccabaaaacaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaa
dcaaaaaldccabaaaadaaaaaaegbabaaaaeaaaaaaegiacaaaaaaaaaaaaiaaaaaa
ogikcaaaaaaaaaaaaiaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaaaaaaaaajhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaiaebaaaaaa
acaaaaaabjaaaaaadiaaaaaihccabaaaaeaaaaaaegacbaaaaaaaaaaapgipcaaa
acaaaaaabjaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaaaaaaaaaackiacaaa
adaaaaaaafaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaaeaaaaaa
akbabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaa
adaaaaaaagaaaaaackbabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaa
aaaaaaaackiacaaaadaaaaaaahaaaaaadkbabaaaaaaaaaaaakaabaaaaaaaaaaa
aaaaaaajccaabaaaaaaaaaaadkiacaiaebaaaaaaacaaaaaabjaaaaaaabeaaaaa
aaaaiadpdiaaaaaiiccabaaaaeaaaaaabkaabaaaaaaaaaaaakaabaiaebaaaaaa
aaaaaaaadoaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaaaaaa
laaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaaabaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
afaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaa
feeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaaaiaaaaaa
jiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaa
abaaaaaaamadaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaa
keaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaadamaaaakeaaaaaaaeaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 398
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    highp vec4 screen;
    highp vec2 lmap;
    highp vec4 lmapFadePos;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 393
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 397
uniform highp vec4 _Player3_Pos;
#line 405
#line 419
#line 434
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
#line 450
uniform sampler2D _LightBuffer;
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
#line 454
uniform lowp vec4 unity_Ambient;
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 405
void vert( inout appdata_full vertexData, out Input outData ) {
    highp vec4 pos = (glstate_matrix_mvp * vertexData.vertex);
    highp vec4 posWorld = (_Object2World * vertexData.vertex);
    #line 409
    outData.uv_MainTex = vec2( vertexData.texcoord);
    outData.location = posWorld.xz;
}
#line 436
v2f_surf vert_surf( in appdata_full v ) {
    #line 438
    v2f_surf o;
    Input customInputData;
    vert( v, customInputData);
    o.cust_location = customInputData.location;
    #line 442
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.screen = ComputeScreenPos( o.pos);
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    #line 446
    o.lmapFadePos.xyz = (((_Object2World * v.vertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
    o.lmapFadePos.w = ((-(glstate_matrix_modelview0 * v.vertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
out highp vec2 xlv_TEXCOORD3;
out highp vec4 xlv_TEXCOORD4;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.pack0);
    xlv_TEXCOORD1 = vec2(xl_retval.cust_location);
    xlv_TEXCOORD2 = vec4(xl_retval.screen);
    xlv_TEXCOORD3 = vec2(xl_retval.lmap);
    xlv_TEXCOORD4 = vec4(xl_retval.lmapFadePos);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 398
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    highp vec4 screen;
    highp vec2 lmap;
    highp vec4 lmapFadePos;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 393
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 397
uniform highp vec4 _Player3_Pos;
#line 405
#line 419
#line 434
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
#line 450
uniform sampler2D _LightBuffer;
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
#line 454
uniform lowp vec4 unity_Ambient;
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 346
lowp vec4 LightingLambert_PrePass( in SurfaceOutput s, in mediump vec4 light ) {
    lowp vec4 c;
    c.xyz = (s.Albedo * light.xyz);
    #line 350
    c.w = s.Alpha;
    return c;
}
#line 419
highp float powerForPos( in highp vec4 pos, in highp vec2 nearVertex ) {
    highp float atten = clamp( (_FogRadius - length((pos.xz - nearVertex.xy))), 0.0, _FogRadius);
    return (((1.0 / _FogMaxRadius) * atten) / _FogRadius);
}
#line 412
void surf( in Input IN, inout SurfaceOutput o ) {
    #line 414
    lowp vec4 baseColor = (texture( _MainTex, IN.uv_MainTex) * _Color);
    highp float alpha = (1.0 - (((baseColor.w + powerForPos( _Player1_Pos, IN.location)) + powerForPos( _Player2_Pos, IN.location)) + powerForPos( _Player3_Pos, IN.location)));
    o.Albedo = baseColor.xyz;
    o.Alpha = alpha;
}
#line 455
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    #line 458
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.location = IN.cust_location;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    #line 462
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    #line 466
    surf( surfIN, o);
    mediump vec4 light = textureProj( _LightBuffer, IN.screen);
    light = max( light, vec4( 0.001));
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    #line 470
    lowp vec4 lmtex2 = texture( unity_LightmapInd, IN.lmap.xy);
    mediump float lmFade = ((length(IN.lmapFadePos) * unity_LightmapFade.z) + unity_LightmapFade.w);
    mediump vec3 lmFull = DecodeLightmap( lmtex);
    mediump vec3 lmIndirect = DecodeLightmap( lmtex2);
    #line 474
    mediump vec3 lm = mix( lmIndirect, lmFull, vec3( xll_saturate_f(lmFade)));
    light.xyz += lm;
    mediump vec4 c = LightingLambert_PrePass( o, light);
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
in highp vec2 xlv_TEXCOORD3;
in highp vec4 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec2(xlv_TEXCOORD0);
    xlt_IN.cust_location = vec2(xlv_TEXCOORD1);
    xlt_IN.screen = vec4(xlv_TEXCOORD2);
    xlt_IN.lmap = vec2(xlv_TEXCOORD3);
    xlt_IN.lmapFadePos = vec4(xlv_TEXCOORD4);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 9 [_ProjectionParams]
Matrix 5 [_Object2World]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
"!!ARBvp1.0
# 14 ALU
PARAM c[12] = { { 0.5 },
		state.matrix.mvp,
		program.local[5..11] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MOV result.position, R0;
MUL R1.y, R1, c[9].x;
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[7];
ADD result.texcoord[2].xy, R1, R1.z;
MOV result.texcoord[2].zw, R0;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[11], c[11].zwzw;
MOV result.texcoord[1].xy, R0;
MAD result.texcoord[3].xy, vertex.texcoord[1], c[10], c[10].zwzw;
END
# 14 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Matrix 4 [_Object2World]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
"vs_2_0
; 14 ALU
def c12, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
dcl_texcoord1 v2
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c12.x
mov oPos, r0
mul r1.y, r1, c8.x
dp4 r0.x, v0, c4
dp4 r0.y, v0, c6
mad oT2.xy, r1.z, c9.zwzw, r1
mov oT2.zw, r0
mad oT0.xy, v1, c11, c11.zwzw
mov oT1.xy, r0
mad oT3.xy, v2, c10, c10.zwzw
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 192 // 160 used size, 13 vars
Vector 128 [unity_LightmapST] 4
Vector 144 [_MainTex_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 16 instructions, 2 temp regs, 0 temp arrays:
// ALU 13 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedimbejcbjkjebcoeopfmlamgodmdpdgcoabaaaaaafiaeaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apaaaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaadamaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefclmacaaaaeaaaabaa
kpaaaaaafjaaaaaeegiocaaaaaaaaaaaakaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
gfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaaadaaaaaagiaaaaacacaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaa
aaaaaaaaegaobaaaaaaaaaaadiaaaaaidcaabaaaabaaaaaafgbfbaaaaaaaaaaa
igiacaaaacaaaaaaanaaaaaadcaaaaakdcaabaaaabaaaaaaigiacaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegaabaaaabaaaaaadcaaaaakdcaabaaaabaaaaaa
igiacaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaabaaaabaaaaaadcaaaaak
mccabaaaabaaaaaaagiicaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaagaebaaa
abaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
ajaaaaaaogikcaaaaaaaaaaaajaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaa
aaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaa
acaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaacaaaaaakgakbaaaabaaaaaa
mgaabaaaabaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaaaeaaaaaaegiacaaa
aaaaaaaaaiaaaaaaogikcaaaaaaaaaaaaiaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = o_2;
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp float tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_6;
  arg0_6 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_7;
  arg0_7 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_8;
  arg0_8 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_9;
  tmpvar_9 = (1.0 - (((tmpvar_5.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_7, arg0_7))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_8, arg0_8))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_4 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2DProj (_LightBuffer, xlv_TEXCOORD2);
  light_3 = tmpvar_10;
  mediump vec3 lm_11;
  lowp vec3 tmpvar_12;
  tmpvar_12 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD3).xyz);
  lm_11 = tmpvar_12;
  mediump vec4 tmpvar_13;
  tmpvar_13.w = 0.0;
  tmpvar_13.xyz = lm_11;
  mediump vec4 tmpvar_14;
  tmpvar_14 = (max (light_3, vec4(0.001, 0.001, 0.001, 0.001)) + tmpvar_13);
  light_3 = tmpvar_14;
  lowp vec4 c_15;
  mediump vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_5.xyz * tmpvar_14.xyz);
  c_15.xyz = tmpvar_16;
  c_15.w = tmpvar_4;
  c_2 = c_15;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xz;
  xlv_TEXCOORD2 = o_2;
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform highp vec4 _Player3_Pos;
uniform highp vec4 _Player2_Pos;
uniform highp vec4 _Player1_Pos;
uniform highp float _FogMaxRadius;
uniform highp float _FogRadius;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp float tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec2 arg0_6;
  arg0_6 = (_Player1_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_7;
  arg0_7 = (_Player2_Pos.xz - xlv_TEXCOORD1);
  highp vec2 arg0_8;
  arg0_8 = (_Player3_Pos.xz - xlv_TEXCOORD1);
  highp float tmpvar_9;
  tmpvar_9 = (1.0 - (((tmpvar_5.w + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_6, arg0_6))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_7, arg0_7))), 0.0, _FogRadius)) / _FogRadius)) + (((1.0/(_FogMaxRadius)) * clamp ((_FogRadius - sqrt(dot (arg0_8, arg0_8))), 0.0, _FogRadius)) / _FogRadius)));
  tmpvar_4 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2DProj (_LightBuffer, xlv_TEXCOORD2);
  light_3 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (unity_Lightmap, xlv_TEXCOORD3);
  mediump vec3 lm_12;
  lowp vec3 tmpvar_13;
  tmpvar_13 = ((8.0 * tmpvar_11.w) * tmpvar_11.xyz);
  lm_12 = tmpvar_13;
  mediump vec4 tmpvar_14;
  tmpvar_14.w = 0.0;
  tmpvar_14.xyz = lm_12;
  mediump vec4 tmpvar_15;
  tmpvar_15 = (max (light_3, vec4(0.001, 0.001, 0.001, 0.001)) + tmpvar_14);
  light_3 = tmpvar_15;
  lowp vec4 c_16;
  mediump vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_5.xyz * tmpvar_15.xyz);
  c_16.xyz = tmpvar_17;
  c_16.w = tmpvar_4;
  c_2 = c_16;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 192 // 160 used size, 13 vars
Vector 128 [unity_LightmapST] 4
Vector 144 [_MainTex_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 16 instructions, 2 temp regs, 0 temp arrays:
// ALU 13 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedjmcchakocfhjafapnmcnehcjkjpagmddabaaaaaacmagaaaaaeaaaaaa
daaaaaaaaaacaaaameaeaaaaimafaaaaebgpgodjmiabaaaamiabaaaaaaacpopp
haabaaaafiaaaaaaaeaaceaaaaaafeaaaaaafeaaaaaaceaaabaafeaaaaaaaiaa
acaaabaaaaaaaaaaabaaafaaabaaadaaaaaaaaaaacaaaaaaaeaaaeaaaaaaaaaa
acaaamaaaeaaaiaaaaaaaaaaaaaaaaaaaaacpoppfbaaaaafamaaapkaaaaaaadp
aaaaaaaaaaaaaaaaaaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaadia
adaaapjabpaaaaacafaaaeiaaeaaapjaafaaaaadaaaaadiaaaaaffjaajaaocka
aeaaaaaeaaaaadiaaiaaockaaaaaaajaaaaaoeiaaeaaaaaeaaaaadiaakaaocka
aaaakkjaaaaaoeiaaeaaaaaeaaaaamoaalaacekaaaaappjaaaaaeeiaaeaaaaae
aaaaadoaadaaoejaacaaoekaacaaookaafaaaaadaaaaapiaaaaaffjaafaaoeka
aeaaaaaeaaaaapiaaeaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaagaaoeka
aaaakkjaaaaaoeiaaeaaaaaeaaaaapiaahaaoekaaaaappjaaaaaoeiaafaaaaad
abaaabiaaaaaffiaadaaaakaafaaaaadabaaaiiaabaaaaiaamaaaakaafaaaaad
abaaafiaaaaapeiaamaaaakaacaaaaadabaaadoaabaakkiaabaaomiaaeaaaaae
acaaadoaaeaaoejaabaaoekaabaaookaaeaaaaaeaaaaadmaaaaappiaaaaaoeka
aaaaoeiaabaaaaacaaaaammaaaaaoeiaabaaaaacabaaamoaaaaaoeiappppaaaa
fdeieefclmacaaaaeaaaabaakpaaaaaafjaaaaaeegiocaaaaaaaaaaaakaaaaaa
fjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaabaaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaa
aeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaa
gfaaaaadmccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaa
adaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaidcaabaaa
abaaaaaafgbfbaaaaaaaaaaaigiacaaaacaaaaaaanaaaaaadcaaaaakdcaabaaa
abaaaaaaigiacaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegaabaaaabaaaaaa
dcaaaaakdcaabaaaabaaaaaaigiacaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egaabaaaabaaaaaadcaaaaakmccabaaaabaaaaaaagiicaaaacaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaagaebaaaabaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaajaaaaaaogikcaaaaaaaaaaaajaaaaaadiaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaak
ncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaadpdgaaaaafmccabaaaacaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaa
acaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadcaaaaaldccabaaaadaaaaaa
egbabaaaaeaaaaaaegiacaaaaaaaaaaaaiaaaaaaogikcaaaaaaaaaaaaiaaaaaa
doaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
apaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaaaaaalaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaaabaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffied
epepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadamaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amadaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaadaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 398
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    highp vec4 screen;
    highp vec2 lmap;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 393
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 397
uniform highp vec4 _Player3_Pos;
#line 405
#line 419
#line 433
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform sampler2D _LightBuffer;
uniform sampler2D unity_Lightmap;
#line 449
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
uniform lowp vec4 unity_Ambient;
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 405
void vert( inout appdata_full vertexData, out Input outData ) {
    highp vec4 pos = (glstate_matrix_mvp * vertexData.vertex);
    highp vec4 posWorld = (_Object2World * vertexData.vertex);
    #line 409
    outData.uv_MainTex = vec2( vertexData.texcoord);
    outData.location = posWorld.xz;
}
#line 435
v2f_surf vert_surf( in appdata_full v ) {
    #line 437
    v2f_surf o;
    Input customInputData;
    vert( v, customInputData);
    o.cust_location = customInputData.location;
    #line 441
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.screen = ComputeScreenPos( o.pos);
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    #line 445
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
out highp vec2 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.pack0);
    xlv_TEXCOORD1 = vec2(xl_retval.cust_location);
    xlv_TEXCOORD2 = vec4(xl_retval.screen);
    xlv_TEXCOORD3 = vec2(xl_retval.lmap);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 398
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 location;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    highp vec2 cust_location;
    highp vec4 screen;
    highp vec2 lmap;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
#line 393
uniform highp float _FogRadius;
uniform highp float _FogMaxRadius;
uniform highp vec4 _Player1_Pos;
uniform highp vec4 _Player2_Pos;
#line 397
uniform highp vec4 _Player3_Pos;
#line 405
#line 419
#line 433
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform sampler2D _LightBuffer;
uniform sampler2D unity_Lightmap;
#line 449
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
uniform lowp vec4 unity_Ambient;
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 325
mediump vec3 DirLightmapDiffuse( in mediump mat3 dirBasis, in lowp vec4 color, in lowp vec4 scale, in mediump vec3 normal, in bool surfFuncWritesNormal, out mediump vec3 scalePerBasisVector ) {
    mediump vec3 lm = DecodeLightmap( color);
    scalePerBasisVector = DecodeLightmap( scale);
    #line 329
    if (surfFuncWritesNormal){
        mediump vec3 normalInRnmBasis = xll_saturate_vf3((dirBasis * normal));
        lm *= dot( normalInRnmBasis, scalePerBasisVector);
    }
    #line 334
    return lm;
}
#line 353
mediump vec4 LightingLambert_DirLightmap( in SurfaceOutput s, in lowp vec4 color, in lowp vec4 scale, in bool surfFuncWritesNormal ) {
    #line 355
    highp mat3 unity_DirBasis = xll_transpose_mf3x3(mat3( vec3( 0.816497, 0.0, 0.57735), vec3( -0.408248, 0.707107, 0.57735), vec3( -0.408248, -0.707107, 0.57735)));
    mediump vec3 scalePerBasisVector;
    mediump vec3 lm = DirLightmapDiffuse( unity_DirBasis, color, scale, s.Normal, surfFuncWritesNormal, scalePerBasisVector);
    return vec4( lm, 0.0);
}
#line 346
lowp vec4 LightingLambert_PrePass( in SurfaceOutput s, in mediump vec4 light ) {
    lowp vec4 c;
    c.xyz = (s.Albedo * light.xyz);
    #line 350
    c.w = s.Alpha;
    return c;
}
#line 419
highp float powerForPos( in highp vec4 pos, in highp vec2 nearVertex ) {
    highp float atten = clamp( (_FogRadius - length((pos.xz - nearVertex.xy))), 0.0, _FogRadius);
    return (((1.0 / _FogMaxRadius) * atten) / _FogRadius);
}
#line 412
void surf( in Input IN, inout SurfaceOutput o ) {
    #line 414
    lowp vec4 baseColor = (texture( _MainTex, IN.uv_MainTex) * _Color);
    highp float alpha = (1.0 - (((baseColor.w + powerForPos( _Player1_Pos, IN.location)) + powerForPos( _Player2_Pos, IN.location)) + powerForPos( _Player3_Pos, IN.location)));
    o.Albedo = baseColor.xyz;
    o.Alpha = alpha;
}
#line 452
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 454
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.location = IN.cust_location;
    SurfaceOutput o;
    #line 458
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 462
    o.Gloss = 0.0;
    surf( surfIN, o);
    mediump vec4 light = textureProj( _LightBuffer, IN.screen);
    light = max( light, vec4( 0.001));
    #line 466
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec4 lmIndTex = texture( unity_LightmapInd, IN.lmap.xy);
    mediump vec4 lm = LightingLambert_DirLightmap( o, lmtex, lmIndTex, false);
    light += lm;
    #line 470
    mediump vec4 c = LightingLambert_PrePass( o, light);
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
in highp vec2 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec2(xlv_TEXCOORD0);
    xlt_IN.cust_location = vec2(xlv_TEXCOORD1);
    xlt_IN.screen = vec4(xlv_TEXCOORD2);
    xlt_IN.lmap = vec2(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 6
//   opengl - ALU: 38 to 52, TEX: 2 to 4
//   d3d9 - ALU: 43 to 55, TEX: 2 to 4
//   d3d11 - ALU: 32 to 41, TEX: 2 to 4, FLOW: 1 to 1
//   d3d11_9x - ALU: 32 to 41, TEX: 2 to 4, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Color]
Float 1 [_FogRadius]
Float 2 [_FogMaxRadius]
Vector 3 [_Player1_Pos]
Vector 4 [_Player2_Pos]
Vector 5 [_Player3_Pos]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
"!!ARBfp1.0
# 41 ALU, 2 TEX
PARAM c[7] = { program.local[0..5],
		{ 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TXP R1.xyz, fragment.texcoord[2], texture[1], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
ADD R2.xy, -fragment.texcoord[1], c[3].xzzw;
MUL R2.xy, R2, R2;
ADD R1.w, R2.x, R2.y;
RSQ R1.w, R1.w;
RCP R1.w, R1.w;
ADD R1.w, -R1, c[1].x;
MIN R1.w, R1, c[1].x;
MAX R2.x, R1.w, c[6].y;
RCP R1.w, c[2].x;
ADD R2.zw, -fragment.texcoord[1].xyxy, c[5].xyxz;
MUL R0, R0, c[0];
RCP R3.x, c[1].x;
MUL R2.x, R1.w, R2;
MAD R0.w, R2.x, R3.x, R0;
ADD R2.xy, -fragment.texcoord[1], c[4].xzzw;
MUL R2.xy, R2, R2;
ADD R2.x, R2, R2.y;
MUL R2.zw, R2, R2;
ADD R2.y, R2.z, R2.w;
RSQ R2.x, R2.x;
RSQ R2.y, R2.y;
RCP R2.x, R2.x;
RCP R2.y, R2.y;
ADD R2.x, -R2, c[1];
ADD R2.y, -R2, c[1].x;
MIN R2.x, R2, c[1];
MIN R2.y, R2, c[1].x;
MAX R2.x, R2, c[6].y;
MUL R2.x, R2, R1.w;
MAD R2.x, R2, R3, R0.w;
MAX R2.y, R2, c[6];
MUL R0.w, R2.y, R1;
MAD R0.w, R0, R3.x, R2.x;
LG2 R1.x, R1.x;
LG2 R1.y, R1.y;
LG2 R1.z, R1.z;
ADD R1.xyz, -R1, fragment.texcoord[3];
MUL result.color.xyz, R0, R1;
ADD result.color.w, -R0, c[6].x;
END
# 41 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Color]
Float 1 [_FogRadius]
Float 2 [_FogMaxRadius]
Vector 3 [_Player1_Pos]
Vector 4 [_Player2_Pos]
Vector 5 [_Player3_Pos]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
"ps_2_0
; 46 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c6, 0.00000000, 1.00000000, 0, 0
dcl t0.xy
dcl t1.xy
dcl t2
dcl t3.xyz
texld r0, t0, s0
texldp r1, t2, s1
mul r0, r0, c0
log_pp r3.x, r1.x
rcp r4.x, c1.x
mov r2.y, c3.z
mov r2.x, c3
add r2.xy, -t1, r2
mul r2.xy, r2, r2
add r1.x, r2, r2.y
rsq r1.x, r1.x
rcp r1.x, r1.x
add r1.x, -r1, c1
min r1.x, r1, c1
log_pp r3.y, r1.y
log_pp r3.z, r1.z
add_pp r2.xyz, -r3, t3
rcp r3.x, c2.x
max r1.x, r1, c6
mul r1.x, r3, r1
mad r1.x, r1, r4, r0.w
mov r5.y, c4.z
mov r5.x, c4
add r5.xy, -t1, r5
mul r5.xy, r5, r5
add r5.x, r5, r5.y
rsq r5.x, r5.x
rcp r5.x, r5.x
add r5.x, -r5, c1
min r5.x, r5, c1
max r5.x, r5, c6
mul r5.x, r5, r3
mov r6.y, c5.z
mov r6.x, c5
add r6.xy, -t1, r6
mul r6.xy, r6, r6
add r6.x, r6, r6.y
rsq r6.x, r6.x
rcp r6.x, r6.x
add r6.x, -r6, c1
min r6.x, r6, c1
max r6.x, r6, c6
mad r1.x, r5, r4, r1
mul r3.x, r6, r3
mad r1.x, r3, r4, r1
mul_pp r0.xyz, r0, r2
add r0.w, -r1.x, c6.y
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
ConstBuffer "$Globals" 160 // 128 used size, 11 vars
Vector 48 [_Color] 4
Float 64 [_FogRadius]
Float 68 [_FogMaxRadius]
Vector 80 [_Player1_Pos] 4
Vector 96 [_Player2_Pos] 4
Vector 112 [_Player3_Pos] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_LightBuffer] 2D 1
// 36 instructions, 2 temp regs, 0 temp arrays:
// ALU 33 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedafaocpjbpnlhffgdigiijafaaaikgagaabaaaaaanaafaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaapalaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcmiaeaaaaeaaaaaaadcabaaaafjaaaaaeegiocaaaaaaaaaaaaiaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaa
abaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaadlcbabaaaacaaaaaagcbaaaad
hcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaaaaaaaaaj
dcaabaaaaaaaaaaaogbkbaiaebaaaaaaabaaaaaaigiacaaaaaaaaaaaagaaaaaa
apaaaaahbcaabaaaaaaaaaaaegaabaaaaaaaaaaaegaabaaaaaaaaaaaelaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaajbcaabaaaaaaaaaaaakaabaia
ebaaaaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaadeaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaaaaddaaaaaibcaabaaaaaaaaaaaakaabaaa
aaaaaaaaakiacaaaaaaaaaaaaeaaaaaaaoaaaaalccaabaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpbkiacaaaaaaaaaaaaeaaaaaadiaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaaaaaaaaajmcaabaaa
aaaaaaaakgbobaiaebaaaaaaabaaaaaaagiicaaaaaaaaaaaafaaaaaaapaaaaah
ecaabaaaaaaaaaaaogakbaaaaaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaa
aaaaaaaackaabaaaaaaaaaaaaaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaa
aaaaaaaaakiacaaaaaaaaaaaaeaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaa
aaaaaaaaabeaaaaaaaaaaaaaddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaa
akiacaaaaaaaaaaaaeaaaaaadiaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaa
bkaabaaaaaaaaaaaaoaaaaaifcaabaaaaaaaaaaaagacbaaaaaaaaaaaagiacaaa
aaaaaaaaaeaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaa
aaaaaaaaaagabaaaaaaaaaaadcaaaaakecaabaaaaaaaaaaadkaabaaaabaaaaaa
dkiacaaaaaaaaaaaadaaaaaackaabaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaa
egacbaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaaaaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaackaabaaaaaaaaaaaaaaaaaajmcaabaaaaaaaaaaakgbobaia
ebaaaaaaabaaaaaaagiicaaaaaaaaaaaahaaaaaaapaaaaahecaabaaaaaaaaaaa
ogakbaaaaaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaaaaaaaaaackaabaaa
aaaaaaaaaaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaaakiacaaa
aaaaaaaaaeaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaa
aaaaaaaaddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaaaaaaaaaa
aeaaaaaadiaaaaahccaabaaaaaaaaaaackaabaaaaaaaaaaabkaabaaaaaaaaaaa
aoaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaa
aaaaaaahbcaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaai
iccabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpaoaaaaah
dcaabaaaaaaaaaaaegbabaaaacaaaaaapgbpbaaaacaaaaaaefaaaaajpcaabaaa
aaaaaaaaegaabaaaaaaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaacpaaaaaf
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaia
ebaaaaaaaaaaaaaaegbcbaaaadaaaaaadiaaaaahhccabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
ConstBuffer "$Globals" 160 // 128 used size, 11 vars
Vector 48 [_Color] 4
Float 64 [_FogRadius]
Float 68 [_FogMaxRadius]
Vector 80 [_Player1_Pos] 4
Vector 96 [_Player2_Pos] 4
Vector 112 [_Player3_Pos] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_LightBuffer] 2D 1
// 36 instructions, 2 temp regs, 0 temp arrays:
// ALU 33 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedaijjalejcippohofaalohkjfnfkgknohabaaaaaabeajaaaaaeaaaaaa
daaaaaaahaadaaaaeaaiaaaaoaaiaaaaebgpgodjdiadaaaadiadaaaaaaacpppp
aaadaaaadiaaaaaaabaacmaaaaaadiaaaaaadiaaacaaceaaaaaadiaaaaaaaaaa
abababaaaaaaadaaafaaaaaaaaaaaaaaaaacppppfbaaaaafafaaapkaaaaaaaaa
aaaaiadpaaaaaaaaaaaaaaaabpaaaaacaaaaaaiaaaaaaplabpaaaaacaaaaaaia
abaaaplabpaaaaacaaaaaaiaacaaahlabpaaaaacaaaaaajaaaaiapkabpaaaaac
aaaaaajaabaiapkaagaaaaacaaaaaiiaabaapplaafaaaaadaaaaadiaaaaappia
abaaoelaecaaaaadabaaapiaaaaaoelaaaaioekaecaaaaadaaaacpiaaaaaoeia
abaioekaacaaaaadacaaabiaaaaapplbadaaaakaacaaaaadacaaaciaaaaakklb
adaakkkafkaaaaaeaaaaaiiaacaaoeiaacaaoeiaafaaaakaahaaaaacaaaaaiia
aaaappiaagaaaaacaaaaaiiaaaaappiaacaaaaadaaaaaiiaaaaappibabaaaaka
alaaaaadacaaabiaaaaappiaafaaaakaakaaaaadaaaaaiiaabaaaakaacaaaaia
agaaaaacacaaabiaabaaffkaafaaaaadaaaaaiiaaaaappiaacaaaaiaacaaaaad
adaaabiaaaaapplbacaaaakaacaaaaadadaaaciaaaaakklbacaakkkafkaaaaae
acaaaciaadaaoeiaadaaoeiaafaaaakaahaaaaacacaaaciaacaaffiaagaaaaac
acaaaciaacaaffiaacaaaaadacaaaciaacaaffibabaaaakaalaaaaadadaaabia
acaaffiaafaaaakaakaaaaadacaaaciaabaaaakaadaaaaiaafaaaaadacaaacia
acaaffiaacaaaaiaafaaaaadabaacpiaabaaoeiaaaaaoekaagaaaaacacaaaeia
abaaaakaaeaaaaaeabaaaiiaacaaffiaacaakkiaabaappiaaeaaaaaeaaaaaiia
aaaappiaacaakkiaabaappiaacaaaaadadaaabiaaaaapplbaeaaaakaacaaaaad
adaaaciaaaaakklbaeaakkkafkaaaaaeabaaaiiaadaaoeiaadaaoeiaafaaaaka
ahaaaaacabaaaiiaabaappiaagaaaaacabaaaiiaabaappiaacaaaaadabaaaiia
abaappibabaaaakaalaaaaadacaaaciaabaappiaafaaaakaakaaaaadabaaaiia
abaaaakaacaaffiaafaaaaadabaaaiiaabaappiaacaaaaiaaeaaaaaeaaaaaiia
abaappiaacaakkiaaaaappiaacaaaaadacaaciiaaaaappibafaaffkaapaaaaac
adaacbiaaaaaaaiaapaaaaacadaacciaaaaaffiaapaaaaacadaaceiaaaaakkia
acaaaaadaaaachiaadaaoeibacaaoelaafaaaaadacaachiaaaaaoeiaabaaoeia
abaaaaacaaaicpiaacaaoeiappppaaaafdeieefcmiaeaaaaeaaaaaaadcabaaaa
fjaaaaaeegiocaaaaaaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaa
gcbaaaadlcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacacaaaaaaaaaaaaajdcaabaaaaaaaaaaaogbkbaiaebaaaaaa
abaaaaaaigiacaaaaaaaaaaaagaaaaaaapaaaaahbcaabaaaaaaaaaaaegaabaaa
aaaaaaaaegaabaaaaaaaaaaaelaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
aaaaaaajbcaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaa
aeaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaa
ddaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaa
aoaaaaalccaabaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadp
bkiacaaaaaaaaaaaaeaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
bkaabaaaaaaaaaaaaaaaaaajmcaabaaaaaaaaaaakgbobaiaebaaaaaaabaaaaaa
agiicaaaaaaaaaaaafaaaaaaapaaaaahecaabaaaaaaaaaaaogakbaaaaaaaaaaa
ogakbaaaaaaaaaaaelaaaaafecaabaaaaaaaaaaackaabaaaaaaaaaaaaaaaaaaj
ecaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaa
deaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaaaaddaaaaai
ecaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaadiaaaaah
ecaabaaaaaaaaaaackaabaaaaaaaaaaabkaabaaaaaaaaaaaaoaaaaaifcaabaaa
aaaaaaaaagacbaaaaaaaaaaaagiacaaaaaaaaaaaaeaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadcaaaaak
ecaabaaaaaaaaaaadkaabaaaabaaaaaadkiacaaaaaaaaaaaadaaaaaackaabaaa
aaaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaa
adaaaaaaaaaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaackaabaaaaaaaaaaa
aaaaaaajmcaabaaaaaaaaaaakgbobaiaebaaaaaaabaaaaaaagiicaaaaaaaaaaa
ahaaaaaaapaaaaahecaabaaaaaaaaaaaogakbaaaaaaaaaaaogakbaaaaaaaaaaa
elaaaaafecaabaaaaaaaaaaackaabaaaaaaaaaaaaaaaaaajecaabaaaaaaaaaaa
ckaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaadeaaaaahecaabaaa
aaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaaaaddaaaaaiecaabaaaaaaaaaaa
ckaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaadiaaaaahccaabaaaaaaaaaaa
ckaabaaaaaaaaaaabkaabaaaaaaaaaaaaoaaaaaiccaabaaaaaaaaaaabkaabaaa
aaaaaaaaakiacaaaaaaaaaaaaeaaaaaaaaaaaaahbcaabaaaaaaaaaaabkaabaaa
aaaaaaaaakaabaaaaaaaaaaaaaaaaaaiiccabaaaaaaaaaaaakaabaiaebaaaaaa
aaaaaaaaabeaaaaaaaaaiadpaoaaaaahdcaabaaaaaaaaaaaegbabaaaacaaaaaa
pgbpbaaaacaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaa
abaaaaaaaagabaaaabaaaaaacpaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
aaaaaaaihcaabaaaaaaaaaaaegacbaiaebaaaaaaaaaaaaaaegbcbaaaadaaaaaa
diaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab
ejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaa
imaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamamaaaaimaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaapalaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaa
adaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
epfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Color]
Float 1 [_FogRadius]
Float 2 [_FogMaxRadius]
Vector 3 [_Player1_Pos]
Vector 4 [_Player2_Pos]
Vector 5 [_Player3_Pos]
Vector 6 [unity_LightmapFade]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
"!!ARBfp1.0
# 52 ALU, 4 TEX
PARAM c[8] = { program.local[0..6],
		{ 1, 0, 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R2, fragment.texcoord[3], texture[2], 2D;
TEX R1, fragment.texcoord[3], texture[3], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TXP R3.xyz, fragment.texcoord[2], texture[1], 2D;
MUL R1.xyz, R1.w, R1;
DP4 R1.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R1.w;
ADD R4.xy, -fragment.texcoord[1], c[3].xzzw;
RCP R1.w, R1.w;
MUL R0, R0, c[0];
MUL R2.xyz, R2.w, R2;
MUL R1.xyz, R1, c[7].z;
MAD R2.xyz, R2, c[7].z, -R1;
MAD_SAT R1.w, R1, c[6].z, c[6];
MAD R1.xyz, R1.w, R2, R1;
LG2 R2.x, R3.x;
MUL R4.xy, R4, R4;
ADD R1.w, R4.x, R4.y;
RSQ R1.w, R1.w;
RCP R1.w, R1.w;
ADD R1.w, -R1, c[1].x;
RCP R3.x, c[1].x;
LG2 R2.y, R3.y;
LG2 R2.z, R3.z;
ADD R1.xyz, -R2, R1;
MIN R1.w, R1, c[1].x;
MAX R2.x, R1.w, c[7].y;
RCP R1.w, c[2].x;
MUL R2.x, R1.w, R2;
MAD R0.w, R2.x, R3.x, R0;
ADD R2.xy, -fragment.texcoord[1], c[4].xzzw;
MUL R2.xy, R2, R2;
ADD R2.x, R2, R2.y;
ADD R2.zw, -fragment.texcoord[1].xyxy, c[5].xyxz;
MUL R2.zw, R2, R2;
ADD R2.y, R2.z, R2.w;
RSQ R2.x, R2.x;
RSQ R2.y, R2.y;
RCP R2.x, R2.x;
RCP R2.y, R2.y;
ADD R2.x, -R2, c[1];
ADD R2.y, -R2, c[1].x;
MIN R2.x, R2, c[1];
MIN R2.y, R2, c[1].x;
MAX R2.x, R2, c[7].y;
MUL R2.x, R2, R1.w;
MAD R2.x, R2, R3, R0.w;
MAX R2.y, R2, c[7];
MUL R0.w, R2.y, R1;
MAD R0.w, R0, R3.x, R2.x;
MUL result.color.xyz, R0, R1;
ADD result.color.w, -R0, c[7].x;
END
# 52 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Color]
Float 1 [_FogRadius]
Float 2 [_FogMaxRadius]
Vector 3 [_Player1_Pos]
Vector 4 [_Player2_Pos]
Vector 5 [_Player3_Pos]
Vector 6 [unity_LightmapFade]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
"ps_2_0
; 55 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c7, 0.00000000, 1.00000000, 8.00000000, 0
dcl t0.xy
dcl t1.xy
dcl t2
dcl t3.xy
dcl t4
texld r0, t0, s0
texldp r1, t2, s1
texld r2, t3, s2
texld r3, t3, s3
dp4 r4.x, t4, t4
mul_pp r3.xyz, r3.w, r3
rsq r4.x, r4.x
rcp r4.x, r4.x
mul_pp r3.xyz, r3, c7.z
mul_pp r2.xyz, r2.w, r2
mad_pp r2.xyz, r2, c7.z, -r3
mad_sat r4.x, r4, c6.z, c6.w
mad_pp r2.xyz, r4.x, r2, r3
mul r0, r0, c0
log_pp r4.x, r1.x
mov r3.y, c3.z
mov r3.x, c3
add r3.xy, -t1, r3
mul r3.xy, r3, r3
add r1.x, r3, r3.y
rsq r1.x, r1.x
rcp r1.x, r1.x
add r1.x, -r1, c1
min r1.x, r1, c1
rcp r3.x, c2.x
max r1.x, r1, c7
mul r1.x, r3, r1
log_pp r4.y, r1.y
log_pp r4.z, r1.z
add_pp r2.xyz, -r4, r2
rcp r4.x, c1.x
mad r1.x, r1, r4, r0.w
mov r5.y, c4.z
mov r5.x, c4
add r5.xy, -t1, r5
mul r5.xy, r5, r5
add r5.x, r5, r5.y
rsq r5.x, r5.x
rcp r5.x, r5.x
add r5.x, -r5, c1
min r5.x, r5, c1
max r5.x, r5, c7
mul r5.x, r5, r3
mov r6.y, c5.z
mov r6.x, c5
add r6.xy, -t1, r6
mul r6.xy, r6, r6
add r6.x, r6, r6.y
rsq r6.x, r6.x
rcp r6.x, r6.x
add r6.x, -r6, c1
min r6.x, r6, c1
max r6.x, r6, c7
mad r1.x, r5, r4, r1
mul r3.x, r6, r3
mad r1.x, r3, r4, r1
mul_pp r0.xyz, r0, r2
add r0.w, -r1.x, c7.y
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
ConstBuffer "$Globals" 192 // 176 used size, 13 vars
Vector 48 [_Color] 4
Float 64 [_FogRadius]
Float 68 [_FogMaxRadius]
Vector 80 [_Player1_Pos] 4
Vector 96 [_Player2_Pos] 4
Vector 112 [_Player3_Pos] 4
Vector 160 [unity_LightmapFade] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_LightBuffer] 2D 1
SetTexture 2 [unity_Lightmap] 2D 2
SetTexture 3 [unity_LightmapInd] 2D 3
// 46 instructions, 3 temp regs, 0 temp arrays:
// ALU 41 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedllfnmfkkomeleclnamnblkepblcdbiefabaaaaaahaahaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaapalaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcfaagaaaa
eaaaaaaajeabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaa
adaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaa
gcbaaaadlcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaadpcbabaaa
aeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaajdcaabaaa
aaaaaaaaogbkbaiaebaaaaaaabaaaaaaigiacaaaaaaaaaaaagaaaaaaapaaaaah
bcaabaaaaaaaaaaaegaabaaaaaaaaaaaegaabaaaaaaaaaaaelaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaaaaaaaajbcaabaaaaaaaaaaaakaabaiaebaaaaaa
aaaaaaaaakiacaaaaaaaaaaaaeaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaabeaaaaaaaaaaaaaddaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaa
akiacaaaaaaaaaaaaeaaaaaaaoaaaaalccaabaaaaaaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpbkiacaaaaaaaaaaaaeaaaaaadiaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaaaaaaaaajmcaabaaaaaaaaaaa
kgbobaiaebaaaaaaabaaaaaaagiicaaaaaaaaaaaafaaaaaaapaaaaahecaabaaa
aaaaaaaaogakbaaaaaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaaaaaaaaaa
ckaabaaaaaaaaaaaaaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaa
akiacaaaaaaaaaaaaeaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaa
abeaaaaaaaaaaaaaddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaa
aaaaaaaaaeaaaaaadiaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaabkaabaaa
aaaaaaaaaoaaaaaifcaabaaaaaaaaaaaagacbaaaaaaaaaaaagiacaaaaaaaaaaa
aeaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaadcaaaaakecaabaaaaaaaaaaadkaabaaaabaaaaaadkiacaaa
aaaaaaaaadaaaaaackaabaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaa
abaaaaaaegiccaaaaaaaaaaaadaaaaaaaaaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaackaabaaaaaaaaaaaaaaaaaajmcaabaaaaaaaaaaakgbobaiaebaaaaaa
abaaaaaaagiicaaaaaaaaaaaahaaaaaaapaaaaahecaabaaaaaaaaaaaogakbaaa
aaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaaaaaaaaaackaabaaaaaaaaaaa
aaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaa
aeaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaaaa
ddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaa
diaaaaahccaabaaaaaaaaaaackaabaaaaaaaaaaabkaabaaaaaaaaaaaaoaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaaaaaaaaah
bcaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaaiiccabaaa
aaaaaaaaakaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaahbcaabaaa
aaaaaaaaegbobaaaaeaaaaaaegbobaaaaeaaaaaaelaaaaafbcaabaaaaaaaaaaa
akaabaaaaaaaaaaadccaaaalbcaabaaaaaaaaaaaakaabaaaaaaaaaaackiacaaa
aaaaaaaaakaaaaaadkiacaaaaaaaaaaaakaaaaaaefaaaaajpcaabaaaacaaaaaa
egbabaaaadaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaadiaaaaahccaabaaa
aaaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdiaaaaahocaabaaaaaaaaaaa
agajbaaaacaaaaaafgafbaaaaaaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaa
adaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaahicaabaaaabaaaaaa
dkaabaaaacaaaaaaabeaaaaaaaaaaaebdcaaaaakhcaabaaaacaaaaaapgapbaaa
abaaaaaaegacbaaaacaaaaaajgahbaiaebaaaaaaaaaaaaaadcaaaaajhcaabaaa
aaaaaaaaagaabaaaaaaaaaaaegacbaaaacaaaaaajgahbaaaaaaaaaaaaoaaaaah
dcaabaaaacaaaaaaegbabaaaacaaaaaapgbpbaaaacaaaaaaefaaaaajpcaabaaa
acaaaaaaegaabaaaacaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaacpaaaaaf
hcaabaaaacaaaaaaegacbaaaacaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaiaebaaaaaaacaaaaaadiaaaaahhccabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
ConstBuffer "$Globals" 192 // 176 used size, 13 vars
Vector 48 [_Color] 4
Float 64 [_FogRadius]
Float 68 [_FogMaxRadius]
Vector 80 [_Player1_Pos] 4
Vector 96 [_Player2_Pos] 4
Vector 112 [_Player3_Pos] 4
Vector 160 [unity_LightmapFade] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_LightBuffer] 2D 1
SetTexture 2 [unity_Lightmap] 2D 2
SetTexture 3 [unity_LightmapInd] 2D 3
// 46 instructions, 3 temp regs, 0 temp arrays:
// ALU 41 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedhjihplkgfnekicbpjkdmlgniobkjfapbabaaaaaakaalaaaaaeaaaaaa
daaaaaaafmaeaaaaleakaaaagmalaaaaebgpgodjceaeaaaaceaeaaaaaaacpppp
niadaaaaemaaaaaaacaadeaaaaaaemaaaaaaemaaaeaaceaaaaaaemaaaaaaaaaa
abababaaacacacaaadadadaaaaaaadaaafaaaaaaaaaaaaaaaaaaakaaabaaafaa
aaaaaaaaaaacppppfbaaaaafagaaapkaaaaaaaaaaaaaiadpaaaaaaebaaaaaaaa
bpaaaaacaaaaaaiaaaaaaplabpaaaaacaaaaaaiaabaaaplabpaaaaacaaaaaaia
acaaadlabpaaaaacaaaaaaiaadaaaplabpaaaaacaaaaaajaaaaiapkabpaaaaac
aaaaaajaabaiapkabpaaaaacaaaaaajaacaiapkabpaaaaacaaaaaajaadaiapka
agaaaaacaaaaaiiaabaapplaafaaaaadaaaaadiaaaaappiaabaaoelaecaaaaad
abaaapiaaaaaoelaaaaioekaecaaaaadacaacpiaacaaoelaadaioekaecaaaaad
adaacpiaacaaoelaacaioekaecaaaaadaaaacpiaaaaaoeiaabaioekaacaaaaad
aeaaabiaaaaapplbadaaaakaacaaaaadaeaaaciaaaaakklbadaakkkafkaaaaae
aaaaaiiaaeaaoeiaaeaaoeiaagaaaakaahaaaaacaaaaaiiaaaaappiaagaaaaac
aaaaaiiaaaaappiaacaaaaadaaaaaiiaaaaappibabaaaakaalaaaaadaeaaabia
aaaappiaagaaaakaakaaaaadaaaaaiiaabaaaakaaeaaaaiaagaaaaacaeaaabia
abaaffkaafaaaaadaaaaaiiaaaaappiaaeaaaaiaacaaaaadafaaabiaaaaapplb
acaaaakaacaaaaadafaaaciaaaaakklbacaakkkafkaaaaaeaeaaaciaafaaoeia
afaaoeiaagaaaakaahaaaaacaeaaaciaaeaaffiaagaaaaacaeaaaciaaeaaffia
acaaaaadaeaaaciaaeaaffibabaaaakaalaaaaadafaaabiaaeaaffiaagaaaaka
akaaaaadaeaaaciaabaaaakaafaaaaiaafaaaaadaeaaaciaaeaaffiaaeaaaaia
afaaaaadabaacpiaabaaoeiaaaaaoekaagaaaaacaeaaaeiaabaaaakaaeaaaaae
abaaaiiaaeaaffiaaeaakkiaabaappiaaeaaaaaeaaaaaiiaaaaappiaaeaakkia
abaappiaacaaaaadafaaabiaaaaapplbaeaaaakaacaaaaadafaaaciaaaaakklb
aeaakkkafkaaaaaeabaaaiiaafaaoeiaafaaoeiaagaaaakaahaaaaacabaaaiia
abaappiaagaaaaacabaaaiiaabaappiaacaaaaadabaaaiiaabaappibabaaaaka
alaaaaadaeaaaciaabaappiaagaaaakaakaaaaadabaaaiiaabaaaakaaeaaffia
afaaaaadabaaaiiaabaappiaaeaaaaiaaeaaaaaeaaaaaiiaabaappiaaeaakkia
aaaappiaacaaaaadaeaaciiaaaaappibagaaffkaajaaaaadaaaaaiiaadaaoela
adaaoelaahaaaaacaaaaaiiaaaaappiaagaaaaacaaaaaiiaaaaappiaaeaaaaae
aaaadiiaaaaappiaafaakkkaafaappkaafaaaaadabaaciiaacaappiaagaakkka
afaaaaadacaachiaacaaoeiaabaappiaafaaaaadabaaciiaadaappiaagaakkka
aeaaaaaeadaachiaabaappiaadaaoeiaacaaoeibaeaaaaaeacaachiaaaaappia
adaaoeiaacaaoeiaapaaaaacadaacbiaaaaaaaiaapaaaaacadaacciaaaaaffia
apaaaaacadaaceiaaaaakkiaacaaaaadaaaachiaacaaoeiaadaaoeibafaaaaad
aeaachiaaaaaoeiaabaaoeiaabaaaaacaaaicpiaaeaaoeiappppaaaafdeieefc
faagaaaaeaaaaaaajeabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafkaaaaad
aagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaa
fkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaae
aahabaaaadaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaa
abaaaaaagcbaaaadlcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaad
pcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaaj
dcaabaaaaaaaaaaaogbkbaiaebaaaaaaabaaaaaaigiacaaaaaaaaaaaagaaaaaa
apaaaaahbcaabaaaaaaaaaaaegaabaaaaaaaaaaaegaabaaaaaaaaaaaelaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaajbcaabaaaaaaaaaaaakaabaia
ebaaaaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaadeaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaaaaddaaaaaibcaabaaaaaaaaaaaakaabaaa
aaaaaaaaakiacaaaaaaaaaaaaeaaaaaaaoaaaaalccaabaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpbkiacaaaaaaaaaaaaeaaaaaadiaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaaaaaaaaajmcaabaaa
aaaaaaaakgbobaiaebaaaaaaabaaaaaaagiicaaaaaaaaaaaafaaaaaaapaaaaah
ecaabaaaaaaaaaaaogakbaaaaaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaa
aaaaaaaackaabaaaaaaaaaaaaaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaa
aaaaaaaaakiacaaaaaaaaaaaaeaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaa
aaaaaaaaabeaaaaaaaaaaaaaddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaa
akiacaaaaaaaaaaaaeaaaaaadiaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaa
bkaabaaaaaaaaaaaaoaaaaaifcaabaaaaaaaaaaaagacbaaaaaaaaaaaagiacaaa
aaaaaaaaaeaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaa
aaaaaaaaaagabaaaaaaaaaaadcaaaaakecaabaaaaaaaaaaadkaabaaaabaaaaaa
dkiacaaaaaaaaaaaadaaaaaackaabaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaa
egacbaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaaaaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaackaabaaaaaaaaaaaaaaaaaajmcaabaaaaaaaaaaakgbobaia
ebaaaaaaabaaaaaaagiicaaaaaaaaaaaahaaaaaaapaaaaahecaabaaaaaaaaaaa
ogakbaaaaaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaaaaaaaaaackaabaaa
aaaaaaaaaaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaaakiacaaa
aaaaaaaaaeaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaa
aaaaaaaaddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaaaaaaaaaa
aeaaaaaadiaaaaahccaabaaaaaaaaaaackaabaaaaaaaaaaabkaabaaaaaaaaaaa
aoaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaa
aaaaaaahbcaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaai
iccabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaah
bcaabaaaaaaaaaaaegbobaaaaeaaaaaaegbobaaaaeaaaaaaelaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaadccaaaalbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
ckiacaaaaaaaaaaaakaaaaaadkiacaaaaaaaaaaaakaaaaaaefaaaaajpcaabaaa
acaaaaaaegbabaaaadaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaadiaaaaah
ccaabaaaaaaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdiaaaaahocaabaaa
aaaaaaaaagajbaaaacaaaaaafgafbaaaaaaaaaaaefaaaaajpcaabaaaacaaaaaa
egbabaaaadaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaahicaabaaa
abaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdcaaaaakhcaabaaaacaaaaaa
pgapbaaaabaaaaaaegacbaaaacaaaaaajgahbaiaebaaaaaaaaaaaaaadcaaaaaj
hcaabaaaaaaaaaaaagaabaaaaaaaaaaaegacbaaaacaaaaaajgahbaaaaaaaaaaa
aoaaaaahdcaabaaaacaaaaaaegbabaaaacaaaaaapgbpbaaaacaaaaaaefaaaaaj
pcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaa
cpaaaaafhcaabaaaacaaaaaaegacbaaaacaaaaaaaaaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaadiaaaaahhccabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaabejfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamamaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apalaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Color]
Float 1 [_FogRadius]
Float 2 [_FogMaxRadius]
Vector 3 [_Player1_Pos]
Vector 4 [_Player2_Pos]
Vector 5 [_Player3_Pos]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
"!!ARBfp1.0
# 43 ALU, 3 TEX
PARAM c[7] = { program.local[0..5],
		{ 1, 0, 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TXP R2.xyz, fragment.texcoord[2], texture[1], 2D;
TEX R1, fragment.texcoord[3], texture[2], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
ADD R3.xy, -fragment.texcoord[1], c[3].xzzw;
MUL R0, R0, c[0];
MUL R3.xy, R3, R3;
MUL R1.xyz, R1.w, R1;
ADD R1.w, R3.x, R3.y;
RSQ R1.w, R1.w;
RCP R1.w, R1.w;
ADD R1.w, -R1, c[1].x;
RCP R3.x, c[1].x;
LG2 R2.x, R2.x;
LG2 R2.y, R2.y;
LG2 R2.z, R2.z;
MAD R1.xyz, R1, c[6].z, -R2;
MIN R1.w, R1, c[1].x;
MAX R2.x, R1.w, c[6].y;
RCP R1.w, c[2].x;
MUL R2.x, R1.w, R2;
MAD R0.w, R2.x, R3.x, R0;
ADD R2.xy, -fragment.texcoord[1], c[4].xzzw;
MUL R2.xy, R2, R2;
ADD R2.x, R2, R2.y;
ADD R2.zw, -fragment.texcoord[1].xyxy, c[5].xyxz;
MUL R2.zw, R2, R2;
ADD R2.y, R2.z, R2.w;
RSQ R2.x, R2.x;
RSQ R2.y, R2.y;
RCP R2.x, R2.x;
RCP R2.y, R2.y;
ADD R2.x, -R2, c[1];
ADD R2.y, -R2, c[1].x;
MIN R2.x, R2, c[1];
MIN R2.y, R2, c[1].x;
MAX R2.x, R2, c[6].y;
MUL R2.x, R2, R1.w;
MAD R2.x, R2, R3, R0.w;
MAX R2.y, R2, c[6];
MUL R0.w, R2.y, R1;
MAD R0.w, R0, R3.x, R2.x;
MUL result.color.xyz, R0, R1;
ADD result.color.w, -R0, c[6].x;
END
# 43 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Color]
Float 1 [_FogRadius]
Float 2 [_FogMaxRadius]
Vector 3 [_Player1_Pos]
Vector 4 [_Player2_Pos]
Vector 5 [_Player3_Pos]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
"ps_2_0
; 47 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c6, 0.00000000, 1.00000000, 8.00000000, 0
dcl t0.xy
dcl t1.xy
dcl t2
dcl t3.xy
texld r0, t0, s0
texld r1, t3, s2
texldp r2, t2, s1
mul r0, r0, c0
log_pp r4.x, r2.x
mul_pp r1.xyz, r1.w, r1
mov r3.y, c3.z
mov r3.x, c3
add r3.xy, -t1, r3
mul r3.xy, r3, r3
add r2.x, r3, r3.y
rsq r2.x, r2.x
rcp r2.x, r2.x
add r2.x, -r2, c1
min r2.x, r2, c1
rcp r3.x, c2.x
max r2.x, r2, c6
mul r2.x, r3, r2
log_pp r4.y, r2.y
log_pp r4.z, r2.z
mad_pp r1.xyz, r1, c6.z, -r4
rcp r4.x, c1.x
mad r2.x, r2, r4, r0.w
mov r5.y, c4.z
mov r5.x, c4
add r5.xy, -t1, r5
mul r5.xy, r5, r5
add r5.x, r5, r5.y
rsq r5.x, r5.x
rcp r5.x, r5.x
add r5.x, -r5, c1
min r5.x, r5, c1
max r5.x, r5, c6
mul r5.x, r5, r3
mov r6.y, c5.z
mov r6.x, c5
add r6.xy, -t1, r6
mul r6.xy, r6, r6
add r6.x, r6, r6.y
rsq r6.x, r6.x
rcp r6.x, r6.x
add r6.x, -r6, c1
min r6.x, r6, c1
max r6.x, r6, c6
mad r2.x, r5, r4, r2
mul r3.x, r6, r3
mad r2.x, r3, r4, r2
mul_pp r0.xyz, r0, r1
add r0.w, -r2.x, c6.y
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
ConstBuffer "$Globals" 192 // 128 used size, 13 vars
Vector 48 [_Color] 4
Float 64 [_FogRadius]
Float 68 [_FogMaxRadius]
Vector 80 [_Player1_Pos] 4
Vector 96 [_Player2_Pos] 4
Vector 112 [_Player3_Pos] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_LightBuffer] 2D 1
SetTexture 2 [unity_Lightmap] 2D 2
// 38 instructions, 3 temp regs, 0 temp arrays:
// ALU 34 float, 0 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedadcphjcgmimkahndnifphikpgemhhjpeabaaaaaadeagaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaapalaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefccmafaaaaeaaaaaaaelabaaaafjaaaaaeegiocaaaaaaaaaaaaiaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadmcbabaaaabaaaaaagcbaaaadlcbabaaaacaaaaaagcbaaaaddcbabaaa
adaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaajdcaabaaa
aaaaaaaaogbkbaiaebaaaaaaabaaaaaaigiacaaaaaaaaaaaagaaaaaaapaaaaah
bcaabaaaaaaaaaaaegaabaaaaaaaaaaaegaabaaaaaaaaaaaelaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaaaaaaaajbcaabaaaaaaaaaaaakaabaiaebaaaaaa
aaaaaaaaakiacaaaaaaaaaaaaeaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaabeaaaaaaaaaaaaaddaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaa
akiacaaaaaaaaaaaaeaaaaaaaoaaaaalccaabaaaaaaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpbkiacaaaaaaaaaaaaeaaaaaadiaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaaaaaaaaajmcaabaaaaaaaaaaa
kgbobaiaebaaaaaaabaaaaaaagiicaaaaaaaaaaaafaaaaaaapaaaaahecaabaaa
aaaaaaaaogakbaaaaaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaaaaaaaaaa
ckaabaaaaaaaaaaaaaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaa
akiacaaaaaaaaaaaaeaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaa
abeaaaaaaaaaaaaaddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaa
aaaaaaaaaeaaaaaadiaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaabkaabaaa
aaaaaaaaaoaaaaaifcaabaaaaaaaaaaaagacbaaaaaaaaaaaagiacaaaaaaaaaaa
aeaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaadcaaaaakecaabaaaaaaaaaaadkaabaaaabaaaaaadkiacaaa
aaaaaaaaadaaaaaackaabaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaa
abaaaaaaegiccaaaaaaaaaaaadaaaaaaaaaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaackaabaaaaaaaaaaaaaaaaaajmcaabaaaaaaaaaaakgbobaiaebaaaaaa
abaaaaaaagiicaaaaaaaaaaaahaaaaaaapaaaaahecaabaaaaaaaaaaaogakbaaa
aaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaaaaaaaaaackaabaaaaaaaaaaa
aaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaa
aeaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaaaa
ddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaa
diaaaaahccaabaaaaaaaaaaackaabaaaaaaaaaaabkaabaaaaaaaaaaaaoaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaaaaaaaaah
bcaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaaiiccabaaa
aaaaaaaaakaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpaoaaaaahdcaabaaa
aaaaaaaaegbabaaaacaaaaaapgbpbaaaacaaaaaaefaaaaajpcaabaaaaaaaaaaa
egaabaaaaaaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaacpaaaaafhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaadaaaaaa
eghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaa
acaaaaaaabeaaaaaaaaaaaebdcaaaaakhcaabaaaaaaaaaaapgapbaaaaaaaaaaa
egacbaaaacaaaaaaegacbaiaebaaaaaaaaaaaaaadiaaaaahhccabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
ConstBuffer "$Globals" 192 // 128 used size, 13 vars
Vector 48 [_Color] 4
Float 64 [_FogRadius]
Float 68 [_FogMaxRadius]
Vector 80 [_Player1_Pos] 4
Vector 96 [_Player2_Pos] 4
Vector 112 [_Player3_Pos] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_LightBuffer] 2D 1
SetTexture 2 [unity_Lightmap] 2D 2
// 38 instructions, 3 temp regs, 0 temp arrays:
// ALU 34 float, 0 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedflblllokbcdgbfcgjacaahdednhdhajcabaaaaaakmajaaaaaeaaaaaa
daaaaaaakeadaaaaniaiaaaahiajaaaaebgpgodjgmadaaaagmadaaaaaaacpppp
daadaaaadmaaaaaaabaadaaaaaaadmaaaaaadmaaadaaceaaaaaadmaaaaaaaaaa
abababaaacacacaaaaaaadaaafaaaaaaaaaaaaaaaaacppppfbaaaaafafaaapka
aaaaaaaaaaaaiadpaaaaaaebaaaaaaaabpaaaaacaaaaaaiaaaaaaplabpaaaaac
aaaaaaiaabaaaplabpaaaaacaaaaaaiaacaaadlabpaaaaacaaaaaajaaaaiapka
bpaaaaacaaaaaajaabaiapkabpaaaaacaaaaaajaacaiapkaagaaaaacaaaaaiia
abaapplaafaaaaadaaaaadiaaaaappiaabaaoelaecaaaaadabaaapiaaaaaoela
aaaioekaecaaaaadaaaacpiaaaaaoeiaabaioekaecaaaaadacaacpiaacaaoela
acaioekaacaaaaadadaaabiaaaaapplbadaaaakaacaaaaadadaaaciaaaaakklb
adaakkkafkaaaaaeaaaaaiiaadaaoeiaadaaoeiaafaaaakaahaaaaacaaaaaiia
aaaappiaagaaaaacaaaaaiiaaaaappiaacaaaaadaaaaaiiaaaaappibabaaaaka
alaaaaadadaaabiaaaaappiaafaaaakaakaaaaadaaaaaiiaabaaaakaadaaaaia
agaaaaacadaaabiaabaaffkaafaaaaadaaaaaiiaaaaappiaadaaaaiaacaaaaad
aeaaabiaaaaapplbacaaaakaacaaaaadaeaaaciaaaaakklbacaakkkafkaaaaae
adaaaciaaeaaoeiaaeaaoeiaafaaaakaahaaaaacadaaaciaadaaffiaagaaaaac
adaaaciaadaaffiaacaaaaadadaaaciaadaaffibabaaaakaalaaaaadaeaaabia
adaaffiaafaaaakaakaaaaadadaaaciaabaaaakaaeaaaaiaafaaaaadadaaacia
adaaffiaadaaaaiaafaaaaadabaacpiaabaaoeiaaaaaoekaagaaaaacadaaaeia
abaaaakaaeaaaaaeabaaaiiaadaaffiaadaakkiaabaappiaaeaaaaaeaaaaaiia
aaaappiaadaakkiaabaappiaacaaaaadaeaaabiaaaaapplbaeaaaakaacaaaaad
aeaaaciaaaaakklbaeaakkkafkaaaaaeabaaaiiaaeaaoeiaaeaaoeiaafaaaaka
ahaaaaacabaaaiiaabaappiaagaaaaacabaaaiiaabaappiaacaaaaadabaaaiia
abaappibabaaaakaalaaaaadadaaaciaabaappiaafaaaakaakaaaaadabaaaiia
abaaaakaadaaffiaafaaaaadabaaaiiaabaappiaadaaaaiaaeaaaaaeaaaaaiia
abaappiaadaakkiaaaaappiaacaaaaadadaaciiaaaaappibafaaffkaapaaaaac
aeaacbiaaaaaaaiaapaaaaacaeaacciaaaaaffiaapaaaaacaeaaceiaaaaakkia
afaaaaadabaaciiaacaappiaafaakkkaaeaaaaaeaaaachiaabaappiaacaaoeia
aeaaoeibafaaaaadadaachiaaaaaoeiaabaaoeiaabaaaaacaaaicpiaadaaoeia
ppppaaaafdeieefccmafaaaaeaaaaaaaelabaaaafjaaaaaeegiocaaaaaaaaaaa
aiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaad
aagabaaaacaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaa
abaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaadlcbabaaaacaaaaaagcbaaaad
dcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaaj
dcaabaaaaaaaaaaaogbkbaiaebaaaaaaabaaaaaaigiacaaaaaaaaaaaagaaaaaa
apaaaaahbcaabaaaaaaaaaaaegaabaaaaaaaaaaaegaabaaaaaaaaaaaelaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaajbcaabaaaaaaaaaaaakaabaia
ebaaaaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaadeaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaaaaddaaaaaibcaabaaaaaaaaaaaakaabaaa
aaaaaaaaakiacaaaaaaaaaaaaeaaaaaaaoaaaaalccaabaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpbkiacaaaaaaaaaaaaeaaaaaadiaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaaaaaaaaajmcaabaaa
aaaaaaaakgbobaiaebaaaaaaabaaaaaaagiicaaaaaaaaaaaafaaaaaaapaaaaah
ecaabaaaaaaaaaaaogakbaaaaaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaa
aaaaaaaackaabaaaaaaaaaaaaaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaa
aaaaaaaaakiacaaaaaaaaaaaaeaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaa
aaaaaaaaabeaaaaaaaaaaaaaddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaa
akiacaaaaaaaaaaaaeaaaaaadiaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaa
bkaabaaaaaaaaaaaaoaaaaaifcaabaaaaaaaaaaaagacbaaaaaaaaaaaagiacaaa
aaaaaaaaaeaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaa
aaaaaaaaaagabaaaaaaaaaaadcaaaaakecaabaaaaaaaaaaadkaabaaaabaaaaaa
dkiacaaaaaaaaaaaadaaaaaackaabaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaa
egacbaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaaaaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaackaabaaaaaaaaaaaaaaaaaajmcaabaaaaaaaaaaakgbobaia
ebaaaaaaabaaaaaaagiicaaaaaaaaaaaahaaaaaaapaaaaahecaabaaaaaaaaaaa
ogakbaaaaaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaaaaaaaaaackaabaaa
aaaaaaaaaaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaaakiacaaa
aaaaaaaaaeaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaa
aaaaaaaaddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaaaaaaaaaa
aeaaaaaadiaaaaahccaabaaaaaaaaaaackaabaaaaaaaaaaabkaabaaaaaaaaaaa
aoaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaa
aaaaaaahbcaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaai
iccabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpaoaaaaah
dcaabaaaaaaaaaaaegbabaaaacaaaaaapgbpbaaaacaaaaaaefaaaaajpcaabaaa
aaaaaaaaegaabaaaaaaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaacpaaaaaf
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaa
adaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaahicaabaaaaaaaaaaa
dkaabaaaacaaaaaaabeaaaaaaaaaaaebdcaaaaakhcaabaaaaaaaaaaapgapbaaa
aaaaaaaaegacbaaaacaaaaaaegacbaiaebaaaaaaaaaaaaaadiaaaaahhccabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaabejfdeheojiaaaaaa
afaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
imaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaa
aaaaaaaaadaaaaaaabaaaaaaamamaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaa
acaaaaaaapalaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaa
abaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaa
fdfgfpfegbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Color]
Float 1 [_FogRadius]
Float 2 [_FogMaxRadius]
Vector 3 [_Player1_Pos]
Vector 4 [_Player2_Pos]
Vector 5 [_Player3_Pos]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
"!!ARBfp1.0
# 38 ALU, 2 TEX
PARAM c[7] = { program.local[0..5],
		{ 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TXP R1.xyz, fragment.texcoord[2], texture[1], 2D;
ADD R2.xy, -fragment.texcoord[1], c[3].xzzw;
MUL R2.xy, R2, R2;
ADD R1.w, R2.x, R2.y;
RSQ R1.w, R1.w;
RCP R1.w, R1.w;
ADD R1.w, -R1, c[1].x;
MIN R1.w, R1, c[1].x;
MAX R2.z, R1.w, c[6].y;
RCP R1.w, c[2].x;
ADD R2.xy, -fragment.texcoord[1], c[4].xzzw;
MUL R2.xy, R2, R2;
MUL R0, R0, c[0];
ADD R1.xyz, R1, fragment.texcoord[3];
RCP R3.x, c[1].x;
MUL R2.z, R1.w, R2;
MAD R0.w, R2.z, R3.x, R0;
ADD R2.zw, -fragment.texcoord[1].xyxy, c[5].xyxz;
ADD R3.y, R2.x, R2;
MUL R2.xy, R2.zwzw, R2.zwzw;
ADD R2.y, R2.x, R2;
RSQ R2.z, R3.y;
RCP R2.x, R2.z;
RSQ R2.y, R2.y;
ADD R2.x, -R2, c[1];
RCP R2.y, R2.y;
MIN R2.x, R2, c[1];
ADD R2.y, -R2, c[1].x;
MAX R2.x, R2, c[6].y;
MUL R2.x, R2, R1.w;
MAD R2.x, R2, R3, R0.w;
MIN R2.y, R2, c[1].x;
MAX R0.w, R2.y, c[6].y;
MUL R0.w, R0, R1;
MAD R0.w, R0, R3.x, R2.x;
MUL result.color.xyz, R0, R1;
ADD result.color.w, -R0, c[6].x;
END
# 38 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Color]
Float 1 [_FogRadius]
Float 2 [_FogMaxRadius]
Vector 3 [_Player1_Pos]
Vector 4 [_Player2_Pos]
Vector 5 [_Player3_Pos]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
"ps_2_0
; 43 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c6, 0.00000000, 1.00000000, 0, 0
dcl t0.xy
dcl t1.xy
dcl t2
dcl t3.xyz
texld r0, t0, s0
texldp r1, t2, s1
mul r0, r0, c0
add_pp r1.xyz, r1, t3
rcp r3.x, c2.x
rcp r4.x, c1.x
mov r2.y, c3.z
mov r2.x, c3
add r2.xy, -t1, r2
mul r2.xy, r2, r2
add r2.x, r2, r2.y
rsq r2.x, r2.x
rcp r2.x, r2.x
add r2.x, -r2, c1
min r2.x, r2, c1
max r2.x, r2, c6
mul r2.x, r3, r2
mad r2.x, r2, r4, r0.w
mov r5.y, c4.z
mov r5.x, c4
add r5.xy, -t1, r5
mul r5.xy, r5, r5
add r5.x, r5, r5.y
rsq r5.x, r5.x
rcp r5.x, r5.x
add r5.x, -r5, c1
min r5.x, r5, c1
max r5.x, r5, c6
mul r5.x, r5, r3
mov r6.y, c5.z
mov r6.x, c5
add r6.xy, -t1, r6
mul r6.xy, r6, r6
add r6.x, r6, r6.y
rsq r6.x, r6.x
rcp r6.x, r6.x
add r6.x, -r6, c1
min r6.x, r6, c1
max r6.x, r6, c6
mad r2.x, r5, r4, r2
mul r3.x, r6, r3
mad r2.x, r3, r4, r2
mul_pp r0.xyz, r0, r1
add r0.w, -r2.x, c6.y
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
ConstBuffer "$Globals" 160 // 128 used size, 11 vars
Vector 48 [_Color] 4
Float 64 [_FogRadius]
Float 68 [_FogMaxRadius]
Vector 80 [_Player1_Pos] 4
Vector 96 [_Player2_Pos] 4
Vector 112 [_Player3_Pos] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_LightBuffer] 2D 1
// 35 instructions, 2 temp regs, 0 temp arrays:
// ALU 32 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedcoaejihmkkmhpmbfllempljeophocpnlabaaaaaaliafaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaapalaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefclaaeaaaaeaaaaaaacmabaaaafjaaaaaeegiocaaaaaaaaaaaaiaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaa
abaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaadlcbabaaaacaaaaaagcbaaaad
hcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaaaaaaaaaj
dcaabaaaaaaaaaaaogbkbaiaebaaaaaaabaaaaaaigiacaaaaaaaaaaaagaaaaaa
apaaaaahbcaabaaaaaaaaaaaegaabaaaaaaaaaaaegaabaaaaaaaaaaaelaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaajbcaabaaaaaaaaaaaakaabaia
ebaaaaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaadeaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaaaaddaaaaaibcaabaaaaaaaaaaaakaabaaa
aaaaaaaaakiacaaaaaaaaaaaaeaaaaaaaoaaaaalccaabaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpbkiacaaaaaaaaaaaaeaaaaaadiaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaaaaaaaaajmcaabaaa
aaaaaaaakgbobaiaebaaaaaaabaaaaaaagiicaaaaaaaaaaaafaaaaaaapaaaaah
ecaabaaaaaaaaaaaogakbaaaaaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaa
aaaaaaaackaabaaaaaaaaaaaaaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaa
aaaaaaaaakiacaaaaaaaaaaaaeaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaa
aaaaaaaaabeaaaaaaaaaaaaaddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaa
akiacaaaaaaaaaaaaeaaaaaadiaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaa
bkaabaaaaaaaaaaaaoaaaaaifcaabaaaaaaaaaaaagacbaaaaaaaaaaaagiacaaa
aaaaaaaaaeaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaa
aaaaaaaaaagabaaaaaaaaaaadcaaaaakecaabaaaaaaaaaaadkaabaaaabaaaaaa
dkiacaaaaaaaaaaaadaaaaaackaabaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaa
egacbaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaaaaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaackaabaaaaaaaaaaaaaaaaaajmcaabaaaaaaaaaaakgbobaia
ebaaaaaaabaaaaaaagiicaaaaaaaaaaaahaaaaaaapaaaaahecaabaaaaaaaaaaa
ogakbaaaaaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaaaaaaaaaackaabaaa
aaaaaaaaaaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaaakiacaaa
aaaaaaaaaeaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaa
aaaaaaaaddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaaaaaaaaaa
aeaaaaaadiaaaaahccaabaaaaaaaaaaackaabaaaaaaaaaaabkaabaaaaaaaaaaa
aoaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaa
aaaaaaahbcaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaai
iccabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpaoaaaaah
dcaabaaaaaaaaaaaegbabaaaacaaaaaapgbpbaaaacaaaaaaefaaaaajpcaabaaa
aaaaaaaaegaabaaaaaaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaaaaaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegbcbaaaadaaaaaadiaaaaahhccabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
ConstBuffer "$Globals" 160 // 128 used size, 11 vars
Vector 48 [_Color] 4
Float 64 [_FogRadius]
Float 68 [_FogMaxRadius]
Vector 80 [_Player1_Pos] 4
Vector 96 [_Player2_Pos] 4
Vector 112 [_Player3_Pos] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_LightBuffer] 2D 1
// 35 instructions, 2 temp regs, 0 temp arrays:
// ALU 32 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedpfkddljbbmgbmfilolamjpacndjjmnbhabaaaaaaniaiaaaaaeaaaaaa
daaaaaaaemadaaaaaeaiaaaakeaiaaaaebgpgodjbeadaaaabeadaaaaaaacpppp
nmacaaaadiaaaaaaabaacmaaaaaadiaaaaaadiaaacaaceaaaaaadiaaaaaaaaaa
abababaaaaaaadaaafaaaaaaaaaaaaaaaaacppppfbaaaaafafaaapkaaaaaaaaa
aaaaiadpaaaaaaaaaaaaaaaabpaaaaacaaaaaaiaaaaaaplabpaaaaacaaaaaaia
abaaaplabpaaaaacaaaaaaiaacaaahlabpaaaaacaaaaaajaaaaiapkabpaaaaac
aaaaaajaabaiapkaagaaaaacaaaaaiiaabaapplaafaaaaadaaaaadiaaaaappia
abaaoelaecaaaaadabaaapiaaaaaoelaaaaioekaecaaaaadaaaacpiaaaaaoeia
abaioekaacaaaaadacaaabiaaaaapplbadaaaakaacaaaaadacaaaciaaaaakklb
adaakkkafkaaaaaeaaaaaiiaacaaoeiaacaaoeiaafaaaakaahaaaaacaaaaaiia
aaaappiaagaaaaacaaaaaiiaaaaappiaacaaaaadaaaaaiiaaaaappibabaaaaka
alaaaaadacaaabiaaaaappiaafaaaakaakaaaaadaaaaaiiaabaaaakaacaaaaia
agaaaaacacaaabiaabaaffkaafaaaaadaaaaaiiaaaaappiaacaaaaiaacaaaaad
adaaabiaaaaapplbacaaaakaacaaaaadadaaaciaaaaakklbacaakkkafkaaaaae
acaaaciaadaaoeiaadaaoeiaafaaaakaahaaaaacacaaaciaacaaffiaagaaaaac
acaaaciaacaaffiaacaaaaadacaaaciaacaaffibabaaaakaalaaaaadadaaabia
acaaffiaafaaaakaakaaaaadacaaaciaabaaaakaadaaaaiaafaaaaadacaaacia
acaaffiaacaaaaiaafaaaaadabaacpiaabaaoeiaaaaaoekaagaaaaacacaaaeia
abaaaakaaeaaaaaeabaaaiiaacaaffiaacaakkiaabaappiaaeaaaaaeaaaaaiia
aaaappiaacaakkiaabaappiaacaaaaadadaaabiaaaaapplbaeaaaakaacaaaaad
adaaaciaaaaakklbaeaakkkafkaaaaaeabaaaiiaadaaoeiaadaaoeiaafaaaaka
ahaaaaacabaaaiiaabaappiaagaaaaacabaaaiiaabaappiaacaaaaadabaaaiia
abaappibabaaaakaalaaaaadacaaaciaabaappiaafaaaakaakaaaaadabaaaiia
abaaaakaacaaffiaafaaaaadabaaaiiaabaappiaacaaaaiaaeaaaaaeaaaaaiia
abaappiaacaakkiaaaaappiaacaaaaadacaaciiaaaaappibafaaffkaacaaaaad
aaaachiaaaaaoeiaacaaoelaafaaaaadacaachiaaaaaoeiaabaaoeiaabaaaaac
aaaicpiaacaaoeiappppaaaafdeieefclaaeaaaaeaaaaaaacmabaaaafjaaaaae
egiocaaaaaaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaa
abaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaad
lcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacacaaaaaaaaaaaaajdcaabaaaaaaaaaaaogbkbaiaebaaaaaaabaaaaaa
igiacaaaaaaaaaaaagaaaaaaapaaaaahbcaabaaaaaaaaaaaegaabaaaaaaaaaaa
egaabaaaaaaaaaaaelaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaaj
bcaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaa
deaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaaddaaaaai
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaaaoaaaaal
ccaabaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpbkiacaaa
aaaaaaaaaeaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaa
aaaaaaaaaaaaaaajmcaabaaaaaaaaaaakgbobaiaebaaaaaaabaaaaaaagiicaaa
aaaaaaaaafaaaaaaapaaaaahecaabaaaaaaaaaaaogakbaaaaaaaaaaaogakbaaa
aaaaaaaaelaaaaafecaabaaaaaaaaaaackaabaaaaaaaaaaaaaaaaaajecaabaaa
aaaaaaaackaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaadeaaaaah
ecaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaaaaddaaaaaiecaabaaa
aaaaaaaackaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaadiaaaaahecaabaaa
aaaaaaaackaabaaaaaaaaaaabkaabaaaaaaaaaaaaoaaaaaifcaabaaaaaaaaaaa
agacbaaaaaaaaaaaagiacaaaaaaaaaaaaeaaaaaaefaaaaajpcaabaaaabaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadcaaaaakecaabaaa
aaaaaaaadkaabaaaabaaaaaadkiacaaaaaaaaaaaadaaaaaackaabaaaaaaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaa
aaaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaackaabaaaaaaaaaaaaaaaaaaj
mcaabaaaaaaaaaaakgbobaiaebaaaaaaabaaaaaaagiicaaaaaaaaaaaahaaaaaa
apaaaaahecaabaaaaaaaaaaaogakbaaaaaaaaaaaogakbaaaaaaaaaaaelaaaaaf
ecaabaaaaaaaaaaackaabaaaaaaaaaaaaaaaaaajecaabaaaaaaaaaaackaabaia
ebaaaaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaadeaaaaahecaabaaaaaaaaaaa
ckaabaaaaaaaaaaaabeaaaaaaaaaaaaaddaaaaaiecaabaaaaaaaaaaackaabaaa
aaaaaaaaakiacaaaaaaaaaaaaeaaaaaadiaaaaahccaabaaaaaaaaaaackaabaaa
aaaaaaaabkaabaaaaaaaaaaaaoaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaa
akiacaaaaaaaaaaaaeaaaaaaaaaaaaahbcaabaaaaaaaaaaabkaabaaaaaaaaaaa
akaabaaaaaaaaaaaaaaaaaaiiccabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaa
abeaaaaaaaaaiadpaoaaaaahdcaabaaaaaaaaaaaegbabaaaacaaaaaapgbpbaaa
acaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegbcbaaa
adaaaaaadiaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
doaaaaabejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamamaaaaimaaaaaa
acaaaaaaaaaaaaaaadaaaaaaacaaaaaaapalaaaaimaaaaaaadaaaaaaaaaaaaaa
adaaaaaaadaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Color]
Float 1 [_FogRadius]
Float 2 [_FogMaxRadius]
Vector 3 [_Player1_Pos]
Vector 4 [_Player2_Pos]
Vector 5 [_Player3_Pos]
Vector 6 [unity_LightmapFade]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
"!!ARBfp1.0
# 49 ALU, 4 TEX
PARAM c[8] = { program.local[0..6],
		{ 1, 0, 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R2, fragment.texcoord[3], texture[2], 2D;
TEX R1, fragment.texcoord[3], texture[3], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TXP R3.xyz, fragment.texcoord[2], texture[1], 2D;
MUL R1.xyz, R1.w, R1;
DP4 R1.w, fragment.texcoord[4], fragment.texcoord[4];
ADD R4.xy, -fragment.texcoord[1], c[3].xzzw;
MUL R0, R0, c[0];
MUL R2.xyz, R2.w, R2;
MUL R1.xyz, R1, c[7].z;
MUL R4.xy, R4, R4;
MAD R2.xyz, R2, c[7].z, -R1;
ADD R2.w, R4.x, R4.y;
RSQ R3.w, R1.w;
RSQ R1.w, R2.w;
RCP R2.w, R3.w;
MAD_SAT R2.w, R2, c[6].z, c[6];
MAD R1.xyz, R2.w, R2, R1;
ADD R1.xyz, R3, R1;
RCP R1.w, R1.w;
ADD R1.w, -R1, c[1].x;
MIN R1.w, R1, c[1].x;
MAX R2.x, R1.w, c[7].y;
RCP R1.w, c[2].x;
ADD R2.zw, -fragment.texcoord[1].xyxy, c[5].xyxz;
RCP R3.x, c[1].x;
MUL R2.x, R1.w, R2;
MAD R0.w, R2.x, R3.x, R0;
ADD R2.xy, -fragment.texcoord[1], c[4].xzzw;
MUL R2.xy, R2, R2;
ADD R2.x, R2, R2.y;
MUL R2.zw, R2, R2;
ADD R2.y, R2.z, R2.w;
RSQ R2.x, R2.x;
RSQ R2.y, R2.y;
RCP R2.x, R2.x;
RCP R2.y, R2.y;
ADD R2.x, -R2, c[1];
ADD R2.y, -R2, c[1].x;
MIN R2.x, R2, c[1];
MIN R2.y, R2, c[1].x;
MAX R2.x, R2, c[7].y;
MUL R2.x, R2, R1.w;
MAD R2.x, R2, R3, R0.w;
MAX R2.y, R2, c[7];
MUL R0.w, R2.y, R1;
MAD R0.w, R0, R3.x, R2.x;
MUL result.color.xyz, R0, R1;
ADD result.color.w, -R0, c[7].x;
END
# 49 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Color]
Float 1 [_FogRadius]
Float 2 [_FogMaxRadius]
Vector 3 [_Player1_Pos]
Vector 4 [_Player2_Pos]
Vector 5 [_Player3_Pos]
Vector 6 [unity_LightmapFade]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
"ps_2_0
; 52 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c7, 0.00000000, 1.00000000, 8.00000000, 0
dcl t0.xy
dcl t1.xy
dcl t2
dcl t3.xy
dcl t4
texld r0, t0, s0
texldp r1, t2, s1
texld r2, t3, s3
texld r3, t3, s2
mul_pp r2.xyz, r2.w, r2
dp4 r4.x, t4, t4
rsq r4.x, r4.x
rcp r4.x, r4.x
mul r0, r0, c0
mul_pp r2.xyz, r2, c7.z
mul_pp r3.xyz, r3.w, r3
mad_pp r3.xyz, r3, c7.z, -r2
mad_sat r4.x, r4, c6.z, c6.w
mad_pp r2.xyz, r4.x, r3, r2
add_pp r1.xyz, r1, r2
rcp r4.x, c1.x
mov r5.y, c3.z
mov r5.x, c3
add r5.xy, -t1, r5
mul r5.xy, r5, r5
add r5.x, r5, r5.y
rsq r3.x, r5.x
rcp r3.x, r3.x
add r2.x, -r3, c1
min r2.x, r2, c1
rcp r3.x, c2.x
max r2.x, r2, c7
mul r2.x, r3, r2
mad r2.x, r2, r4, r0.w
mov r5.y, c4.z
mov r5.x, c4
add r5.xy, -t1, r5
mul r5.xy, r5, r5
add r5.x, r5, r5.y
rsq r5.x, r5.x
rcp r5.x, r5.x
add r5.x, -r5, c1
min r5.x, r5, c1
max r5.x, r5, c7
mul r5.x, r5, r3
mov r6.y, c5.z
mov r6.x, c5
add r6.xy, -t1, r6
mul r6.xy, r6, r6
add r6.x, r6, r6.y
rsq r6.x, r6.x
rcp r6.x, r6.x
add r6.x, -r6, c1
min r6.x, r6, c1
max r6.x, r6, c7
mad r2.x, r5, r4, r2
mul r3.x, r6, r3
mad r2.x, r3, r4, r2
mul_pp r0.xyz, r0, r1
add r0.w, -r2.x, c7.y
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
ConstBuffer "$Globals" 192 // 176 used size, 13 vars
Vector 48 [_Color] 4
Float 64 [_FogRadius]
Float 68 [_FogMaxRadius]
Vector 80 [_Player1_Pos] 4
Vector 96 [_Player2_Pos] 4
Vector 112 [_Player3_Pos] 4
Vector 160 [unity_LightmapFade] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_LightBuffer] 2D 1
SetTexture 2 [unity_Lightmap] 2D 2
SetTexture 3 [unity_LightmapInd] 2D 3
// 45 instructions, 3 temp regs, 0 temp arrays:
// ALU 40 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedempoichegphcjcajbepdhcminddhoopjabaaaaaafiahaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaapalaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcdiagaaaa
eaaaaaaaioabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaa
adaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaa
gcbaaaadlcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaadpcbabaaa
aeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaajdcaabaaa
aaaaaaaaogbkbaiaebaaaaaaabaaaaaaigiacaaaaaaaaaaaagaaaaaaapaaaaah
bcaabaaaaaaaaaaaegaabaaaaaaaaaaaegaabaaaaaaaaaaaelaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaaaaaaaajbcaabaaaaaaaaaaaakaabaiaebaaaaaa
aaaaaaaaakiacaaaaaaaaaaaaeaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaabeaaaaaaaaaaaaaddaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaa
akiacaaaaaaaaaaaaeaaaaaaaoaaaaalccaabaaaaaaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpbkiacaaaaaaaaaaaaeaaaaaadiaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaaaaaaaaajmcaabaaaaaaaaaaa
kgbobaiaebaaaaaaabaaaaaaagiicaaaaaaaaaaaafaaaaaaapaaaaahecaabaaa
aaaaaaaaogakbaaaaaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaaaaaaaaaa
ckaabaaaaaaaaaaaaaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaa
akiacaaaaaaaaaaaaeaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaa
abeaaaaaaaaaaaaaddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaa
aaaaaaaaaeaaaaaadiaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaabkaabaaa
aaaaaaaaaoaaaaaifcaabaaaaaaaaaaaagacbaaaaaaaaaaaagiacaaaaaaaaaaa
aeaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaadcaaaaakecaabaaaaaaaaaaadkaabaaaabaaaaaadkiacaaa
aaaaaaaaadaaaaaackaabaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaa
abaaaaaaegiccaaaaaaaaaaaadaaaaaaaaaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaackaabaaaaaaaaaaaaaaaaaajmcaabaaaaaaaaaaakgbobaiaebaaaaaa
abaaaaaaagiicaaaaaaaaaaaahaaaaaaapaaaaahecaabaaaaaaaaaaaogakbaaa
aaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaaaaaaaaaackaabaaaaaaaaaaa
aaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaa
aeaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaaaa
ddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaa
diaaaaahccaabaaaaaaaaaaackaabaaaaaaaaaaabkaabaaaaaaaaaaaaoaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaaaaaaaaah
bcaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaaiiccabaaa
aaaaaaaaakaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaahbcaabaaa
aaaaaaaaegbobaaaaeaaaaaaegbobaaaaeaaaaaaelaaaaafbcaabaaaaaaaaaaa
akaabaaaaaaaaaaadccaaaalbcaabaaaaaaaaaaaakaabaaaaaaaaaaackiacaaa
aaaaaaaaakaaaaaadkiacaaaaaaaaaaaakaaaaaaefaaaaajpcaabaaaacaaaaaa
egbabaaaadaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaadiaaaaahccaabaaa
aaaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdiaaaaahocaabaaaaaaaaaaa
agajbaaaacaaaaaafgafbaaaaaaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaa
adaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaahicaabaaaabaaaaaa
dkaabaaaacaaaaaaabeaaaaaaaaaaaebdcaaaaakhcaabaaaacaaaaaapgapbaaa
abaaaaaaegacbaaaacaaaaaajgahbaiaebaaaaaaaaaaaaaadcaaaaajhcaabaaa
aaaaaaaaagaabaaaaaaaaaaaegacbaaaacaaaaaajgahbaaaaaaaaaaaaoaaaaah
dcaabaaaacaaaaaaegbabaaaacaaaaaapgbpbaaaacaaaaaaefaaaaajpcaabaaa
acaaaaaaegaabaaaacaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaaaaaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaadiaaaaahhccabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
ConstBuffer "$Globals" 192 // 176 used size, 13 vars
Vector 48 [_Color] 4
Float 64 [_FogRadius]
Float 68 [_FogMaxRadius]
Vector 80 [_Player1_Pos] 4
Vector 96 [_Player2_Pos] 4
Vector 112 [_Player3_Pos] 4
Vector 160 [unity_LightmapFade] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_LightBuffer] 2D 1
SetTexture 2 [unity_Lightmap] 2D 2
SetTexture 3 [unity_LightmapInd] 2D 3
// 45 instructions, 3 temp regs, 0 temp arrays:
// ALU 40 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedcnfmppncmhcncmogpcmhcmdgbfejlmfcabaaaaaagealaaaaaeaaaaaa
daaaaaaadiaeaaaahiakaaaadaalaaaaebgpgodjaaaeaaaaaaaeaaaaaaacpppp
leadaaaaemaaaaaaacaadeaaaaaaemaaaaaaemaaaeaaceaaaaaaemaaaaaaaaaa
abababaaacacacaaadadadaaaaaaadaaafaaaaaaaaaaaaaaaaaaakaaabaaafaa
aaaaaaaaaaacppppfbaaaaafagaaapkaaaaaaaaaaaaaiadpaaaaaaebaaaaaaaa
bpaaaaacaaaaaaiaaaaaaplabpaaaaacaaaaaaiaabaaaplabpaaaaacaaaaaaia
acaaadlabpaaaaacaaaaaaiaadaaaplabpaaaaacaaaaaajaaaaiapkabpaaaaac
aaaaaajaabaiapkabpaaaaacaaaaaajaacaiapkabpaaaaacaaaaaajaadaiapka
agaaaaacaaaaaiiaabaapplaafaaaaadaaaaadiaaaaappiaabaaoelaecaaaaad
abaaapiaaaaaoelaaaaioekaecaaaaadacaacpiaacaaoelaadaioekaecaaaaad
adaacpiaacaaoelaacaioekaecaaaaadaaaacpiaaaaaoeiaabaioekaacaaaaad
aeaaabiaaaaapplbadaaaakaacaaaaadaeaaaciaaaaakklbadaakkkafkaaaaae
aaaaaiiaaeaaoeiaaeaaoeiaagaaaakaahaaaaacaaaaaiiaaaaappiaagaaaaac
aaaaaiiaaaaappiaacaaaaadaaaaaiiaaaaappibabaaaakaalaaaaadaeaaabia
aaaappiaagaaaakaakaaaaadaaaaaiiaabaaaakaaeaaaaiaagaaaaacaeaaabia
abaaffkaafaaaaadaaaaaiiaaaaappiaaeaaaaiaacaaaaadafaaabiaaaaapplb
acaaaakaacaaaaadafaaaciaaaaakklbacaakkkafkaaaaaeaeaaaciaafaaoeia
afaaoeiaagaaaakaahaaaaacaeaaaciaaeaaffiaagaaaaacaeaaaciaaeaaffia
acaaaaadaeaaaciaaeaaffibabaaaakaalaaaaadafaaabiaaeaaffiaagaaaaka
akaaaaadaeaaaciaabaaaakaafaaaaiaafaaaaadaeaaaciaaeaaffiaaeaaaaia
afaaaaadabaacpiaabaaoeiaaaaaoekaagaaaaacaeaaaeiaabaaaakaaeaaaaae
abaaaiiaaeaaffiaaeaakkiaabaappiaaeaaaaaeaaaaaiiaaaaappiaaeaakkia
abaappiaacaaaaadafaaabiaaaaapplbaeaaaakaacaaaaadafaaaciaaaaakklb
aeaakkkafkaaaaaeabaaaiiaafaaoeiaafaaoeiaagaaaakaahaaaaacabaaaiia
abaappiaagaaaaacabaaaiiaabaappiaacaaaaadabaaaiiaabaappibabaaaaka
alaaaaadaeaaaciaabaappiaagaaaakaakaaaaadabaaaiiaabaaaakaaeaaffia
afaaaaadabaaaiiaabaappiaaeaaaaiaaeaaaaaeaaaaaiiaabaappiaaeaakkia
aaaappiaacaaaaadaeaaciiaaaaappibagaaffkaajaaaaadaaaaaiiaadaaoela
adaaoelaahaaaaacaaaaaiiaaaaappiaagaaaaacaaaaaiiaaaaappiaaeaaaaae
aaaadiiaaaaappiaafaakkkaafaappkaafaaaaadabaaciiaacaappiaagaakkka
afaaaaadacaachiaacaaoeiaabaappiaafaaaaadabaaciiaadaappiaagaakkka
aeaaaaaeadaachiaabaappiaadaaoeiaacaaoeibaeaaaaaeacaachiaaaaappia
adaaoeiaacaaoeiaacaaaaadaaaachiaaaaaoeiaacaaoeiaafaaaaadaeaachia
aaaaoeiaabaaoeiaabaaaaacaaaicpiaaeaaoeiappppaaaafdeieefcdiagaaaa
eaaaaaaaioabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaa
adaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaa
gcbaaaadlcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaadpcbabaaa
aeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaajdcaabaaa
aaaaaaaaogbkbaiaebaaaaaaabaaaaaaigiacaaaaaaaaaaaagaaaaaaapaaaaah
bcaabaaaaaaaaaaaegaabaaaaaaaaaaaegaabaaaaaaaaaaaelaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaaaaaaaajbcaabaaaaaaaaaaaakaabaiaebaaaaaa
aaaaaaaaakiacaaaaaaaaaaaaeaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaabeaaaaaaaaaaaaaddaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaa
akiacaaaaaaaaaaaaeaaaaaaaoaaaaalccaabaaaaaaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpbkiacaaaaaaaaaaaaeaaaaaadiaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaaaaaaaaajmcaabaaaaaaaaaaa
kgbobaiaebaaaaaaabaaaaaaagiicaaaaaaaaaaaafaaaaaaapaaaaahecaabaaa
aaaaaaaaogakbaaaaaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaaaaaaaaaa
ckaabaaaaaaaaaaaaaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaa
akiacaaaaaaaaaaaaeaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaa
abeaaaaaaaaaaaaaddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaa
aaaaaaaaaeaaaaaadiaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaabkaabaaa
aaaaaaaaaoaaaaaifcaabaaaaaaaaaaaagacbaaaaaaaaaaaagiacaaaaaaaaaaa
aeaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaadcaaaaakecaabaaaaaaaaaaadkaabaaaabaaaaaadkiacaaa
aaaaaaaaadaaaaaackaabaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaa
abaaaaaaegiccaaaaaaaaaaaadaaaaaaaaaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaackaabaaaaaaaaaaaaaaaaaajmcaabaaaaaaaaaaakgbobaiaebaaaaaa
abaaaaaaagiicaaaaaaaaaaaahaaaaaaapaaaaahecaabaaaaaaaaaaaogakbaaa
aaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaaaaaaaaaackaabaaaaaaaaaaa
aaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaa
aeaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaaaa
ddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaa
diaaaaahccaabaaaaaaaaaaackaabaaaaaaaaaaabkaabaaaaaaaaaaaaoaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaaaaaaaaah
bcaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaaiiccabaaa
aaaaaaaaakaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaahbcaabaaa
aaaaaaaaegbobaaaaeaaaaaaegbobaaaaeaaaaaaelaaaaafbcaabaaaaaaaaaaa
akaabaaaaaaaaaaadccaaaalbcaabaaaaaaaaaaaakaabaaaaaaaaaaackiacaaa
aaaaaaaaakaaaaaadkiacaaaaaaaaaaaakaaaaaaefaaaaajpcaabaaaacaaaaaa
egbabaaaadaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaadiaaaaahccaabaaa
aaaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdiaaaaahocaabaaaaaaaaaaa
agajbaaaacaaaaaafgafbaaaaaaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaa
adaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaahicaabaaaabaaaaaa
dkaabaaaacaaaaaaabeaaaaaaaaaaaebdcaaaaakhcaabaaaacaaaaaapgapbaaa
abaaaaaaegacbaaaacaaaaaajgahbaiaebaaaaaaaaaaaaaadcaaaaajhcaabaaa
aaaaaaaaagaabaaaaaaaaaaaegacbaaaacaaaaaajgahbaaaaaaaaaaaaoaaaaah
dcaabaaaacaaaaaaegbabaaaacaaaaaapgbpbaaaacaaaaaaefaaaaajpcaabaaa
acaaaaaaegaabaaaacaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaaaaaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaadiaaaaahhccabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaabejfdeheolaaaaaaa
agaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
keaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaa
aaaaaaaaadaaaaaaabaaaaaaamamaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaa
acaaaaaaapalaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaa
keaaaaaaaeaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaa
caaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgf
heaaklkl"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Color]
Float 1 [_FogRadius]
Float 2 [_FogMaxRadius]
Vector 3 [_Player1_Pos]
Vector 4 [_Player2_Pos]
Vector 5 [_Player3_Pos]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
"!!ARBfp1.0
# 40 ALU, 3 TEX
PARAM c[7] = { program.local[0..5],
		{ 1, 0, 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R1, fragment.texcoord[3], texture[2], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TXP R2.xyz, fragment.texcoord[2], texture[1], 2D;
MUL R1.xyz, R1.w, R1;
ADD R3.xy, -fragment.texcoord[1], c[3].xzzw;
MUL R3.xy, R3, R3;
ADD R2.w, R3.x, R3.y;
RSQ R2.w, R2.w;
RCP R2.w, R2.w;
ADD R1.w, -R2, c[1].x;
MAD R1.xyz, R1, c[6].z, R2;
MUL R0, R0, c[0];
MIN R1.w, R1, c[1].x;
MAX R2.x, R1.w, c[6].y;
RCP R1.w, c[2].x;
ADD R2.zw, -fragment.texcoord[1].xyxy, c[5].xyxz;
RCP R3.x, c[1].x;
MUL R2.x, R1.w, R2;
MAD R0.w, R2.x, R3.x, R0;
ADD R2.xy, -fragment.texcoord[1], c[4].xzzw;
MUL R2.xy, R2, R2;
ADD R2.x, R2, R2.y;
MUL R2.zw, R2, R2;
ADD R2.y, R2.z, R2.w;
RSQ R2.x, R2.x;
RSQ R2.y, R2.y;
RCP R2.x, R2.x;
RCP R2.y, R2.y;
ADD R2.x, -R2, c[1];
ADD R2.y, -R2, c[1].x;
MIN R2.x, R2, c[1];
MIN R2.y, R2, c[1].x;
MAX R2.x, R2, c[6].y;
MUL R2.x, R2, R1.w;
MAD R2.x, R2, R3, R0.w;
MAX R2.y, R2, c[6];
MUL R0.w, R2.y, R1;
MAD R0.w, R0, R3.x, R2.x;
MUL result.color.xyz, R0, R1;
ADD result.color.w, -R0, c[6].x;
END
# 40 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Color]
Float 1 [_FogRadius]
Float 2 [_FogMaxRadius]
Vector 3 [_Player1_Pos]
Vector 4 [_Player2_Pos]
Vector 5 [_Player3_Pos]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
"ps_2_0
; 44 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c6, 0.00000000, 1.00000000, 8.00000000, 0
dcl t0.xy
dcl t1.xy
dcl t2
dcl t3.xy
texld r0, t0, s0
texldp r1, t2, s1
texld r2, t3, s2
mul r0, r0, c0
rcp r4.x, c1.x
mul_pp r2.xyz, r2.w, r2
mad_pp r1.xyz, r2, c6.z, r1
mov r3.y, c3.z
mov r3.x, c3
add r3.xy, -t1, r3
mul r3.xy, r3, r3
add r3.x, r3, r3.y
rsq r3.x, r3.x
rcp r3.x, r3.x
add r2.x, -r3, c1
min r2.x, r2, c1
rcp r3.x, c2.x
max r2.x, r2, c6
mul r2.x, r3, r2
mad r2.x, r2, r4, r0.w
mov r5.y, c4.z
mov r5.x, c4
add r5.xy, -t1, r5
mul r5.xy, r5, r5
add r5.x, r5, r5.y
rsq r5.x, r5.x
rcp r5.x, r5.x
add r5.x, -r5, c1
min r5.x, r5, c1
max r5.x, r5, c6
mul r5.x, r5, r3
mov r6.y, c5.z
mov r6.x, c5
add r6.xy, -t1, r6
mul r6.xy, r6, r6
add r6.x, r6, r6.y
rsq r6.x, r6.x
rcp r6.x, r6.x
add r6.x, -r6, c1
min r6.x, r6, c1
max r6.x, r6, c6
mad r2.x, r5, r4, r2
mul r3.x, r6, r3
mad r2.x, r3, r4, r2
mul_pp r0.xyz, r0, r1
add r0.w, -r2.x, c6.y
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
ConstBuffer "$Globals" 192 // 128 used size, 13 vars
Vector 48 [_Color] 4
Float 64 [_FogRadius]
Float 68 [_FogMaxRadius]
Vector 80 [_Player1_Pos] 4
Vector 96 [_Player2_Pos] 4
Vector 112 [_Player3_Pos] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_LightBuffer] 2D 1
SetTexture 2 [unity_Lightmap] 2D 2
// 37 instructions, 3 temp regs, 0 temp arrays:
// ALU 33 float, 0 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedkpikkhlladnpkeccbdjobjmfcilkbldlabaaaaaabmagaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaapalaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcbeafaaaaeaaaaaaaefabaaaafjaaaaaeegiocaaaaaaaaaaaaiaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadmcbabaaaabaaaaaagcbaaaadlcbabaaaacaaaaaagcbaaaaddcbabaaa
adaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaajdcaabaaa
aaaaaaaaogbkbaiaebaaaaaaabaaaaaaigiacaaaaaaaaaaaagaaaaaaapaaaaah
bcaabaaaaaaaaaaaegaabaaaaaaaaaaaegaabaaaaaaaaaaaelaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaaaaaaaajbcaabaaaaaaaaaaaakaabaiaebaaaaaa
aaaaaaaaakiacaaaaaaaaaaaaeaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaabeaaaaaaaaaaaaaddaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaa
akiacaaaaaaaaaaaaeaaaaaaaoaaaaalccaabaaaaaaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpbkiacaaaaaaaaaaaaeaaaaaadiaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaaaaaaaaajmcaabaaaaaaaaaaa
kgbobaiaebaaaaaaabaaaaaaagiicaaaaaaaaaaaafaaaaaaapaaaaahecaabaaa
aaaaaaaaogakbaaaaaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaaaaaaaaaa
ckaabaaaaaaaaaaaaaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaa
akiacaaaaaaaaaaaaeaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaa
abeaaaaaaaaaaaaaddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaa
aaaaaaaaaeaaaaaadiaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaabkaabaaa
aaaaaaaaaoaaaaaifcaabaaaaaaaaaaaagacbaaaaaaaaaaaagiacaaaaaaaaaaa
aeaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaadcaaaaakecaabaaaaaaaaaaadkaabaaaabaaaaaadkiacaaa
aaaaaaaaadaaaaaackaabaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaa
abaaaaaaegiccaaaaaaaaaaaadaaaaaaaaaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaackaabaaaaaaaaaaaaaaaaaajmcaabaaaaaaaaaaakgbobaiaebaaaaaa
abaaaaaaagiicaaaaaaaaaaaahaaaaaaapaaaaahecaabaaaaaaaaaaaogakbaaa
aaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaaaaaaaaaackaabaaaaaaaaaaa
aaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaa
aeaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaaaa
ddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaa
diaaaaahccaabaaaaaaaaaaackaabaaaaaaaaaaabkaabaaaaaaaaaaaaoaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaaaaaaaaah
bcaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaaiiccabaaa
aaaaaaaaakaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpaoaaaaahdcaabaaa
aaaaaaaaegbabaaaacaaaaaapgbpbaaaacaaaaaaefaaaaajpcaabaaaaaaaaaaa
egaabaaaaaaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaa
acaaaaaaegbabaaaadaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaah
icaabaaaaaaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdcaaaaajhcaabaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaaaaaaaaadiaaaaah
hccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
ConstBuffer "$Globals" 192 // 128 used size, 13 vars
Vector 48 [_Color] 4
Float 64 [_FogRadius]
Float 68 [_FogMaxRadius]
Vector 80 [_Player1_Pos] 4
Vector 96 [_Player2_Pos] 4
Vector 112 [_Player3_Pos] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_LightBuffer] 2D 1
SetTexture 2 [unity_Lightmap] 2D 2
// 37 instructions, 3 temp regs, 0 temp arrays:
// ALU 33 float, 0 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedjncajmfigkknalhfnajfnpiebfjgffbaabaaaaaahaajaaaaaeaaaaaa
daaaaaaaiaadaaaajmaiaaaadmajaaaaebgpgodjeiadaaaaeiadaaaaaaacpppp
amadaaaadmaaaaaaabaadaaaaaaadmaaaaaadmaaadaaceaaaaaadmaaaaaaaaaa
abababaaacacacaaaaaaadaaafaaaaaaaaaaaaaaaaacppppfbaaaaafafaaapka
aaaaaaaaaaaaiadpaaaaaaebaaaaaaaabpaaaaacaaaaaaiaaaaaaplabpaaaaac
aaaaaaiaabaaaplabpaaaaacaaaaaaiaacaaadlabpaaaaacaaaaaajaaaaiapka
bpaaaaacaaaaaajaabaiapkabpaaaaacaaaaaajaacaiapkaecaaaaadaaaaapia
aaaaoelaaaaioekaecaaaaadabaacpiaacaaoelaacaioekaacaaaaadacaaabia
aaaapplbadaaaakaacaaaaadacaaaciaaaaakklbadaakkkafkaaaaaeacaaabia
acaaoeiaacaaoeiaafaaaakaahaaaaacacaaabiaacaaaaiaagaaaaacacaaabia
acaaaaiaacaaaaadacaaabiaacaaaaibabaaaakaalaaaaadadaaaiiaacaaaaia
afaaaakaakaaaaadacaaabiaabaaaakaadaappiaagaaaaacacaaaciaabaaffka
afaaaaadacaaabiaacaaaaiaacaaffiaacaaaaadadaaabiaaaaapplbacaaaaka
acaaaaadadaaaciaaaaakklbacaakkkafkaaaaaeacaaaeiaadaaoeiaadaaoeia
afaaaakaahaaaaacacaaaeiaacaakkiaagaaaaacacaaaeiaacaakkiaacaaaaad
acaaaeiaacaakkibabaaaakaalaaaaadadaaabiaacaakkiaafaaaakaakaaaaad
acaaaeiaabaaaakaadaaaaiaafaaaaadacaaaeiaacaakkiaacaaffiaafaaaaad
aaaacpiaaaaaoeiaaaaaoekaagaaaaacacaaaiiaabaaaakaaeaaaaaeaaaaaiia
acaakkiaacaappiaaaaappiaaeaaaaaeaaaaaiiaacaaaaiaacaappiaaaaappia
acaaaaadadaaabiaaaaapplbaeaaaakaacaaaaadadaaaciaaaaakklbaeaakkka
fkaaaaaeacaaabiaadaaoeiaadaaoeiaafaaaakaahaaaaacacaaabiaacaaaaia
agaaaaacacaaabiaacaaaaiaacaaaaadacaaabiaacaaaaibabaaaakaalaaaaad
adaaabiaacaaaaiaafaaaakaakaaaaadacaaabiaabaaaakaadaaaaiaafaaaaad
acaaabiaacaaaaiaacaaffiaaeaaaaaeaaaaaiiaacaaaaiaacaappiaaaaappia
acaaaaadacaaciiaaaaappibafaaffkaagaaaaacaaaaaiiaabaapplaafaaaaad
adaaadiaaaaappiaabaaoelaecaaaaadadaacpiaadaaoeiaabaioekaafaaaaad
aaaaciiaabaappiaafaakkkaaeaaaaaeabaachiaaaaappiaabaaoeiaadaaoeia
afaaaaadacaachiaaaaaoeiaabaaoeiaabaaaaacaaaicpiaacaaoeiappppaaaa
fdeieefcbeafaaaaeaaaaaaaefabaaaafjaaaaaeegiocaaaaaaaaaaaaiaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadmcbabaaaabaaaaaagcbaaaadlcbabaaaacaaaaaagcbaaaaddcbabaaa
adaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaajdcaabaaa
aaaaaaaaogbkbaiaebaaaaaaabaaaaaaigiacaaaaaaaaaaaagaaaaaaapaaaaah
bcaabaaaaaaaaaaaegaabaaaaaaaaaaaegaabaaaaaaaaaaaelaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaaaaaaaajbcaabaaaaaaaaaaaakaabaiaebaaaaaa
aaaaaaaaakiacaaaaaaaaaaaaeaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaabeaaaaaaaaaaaaaddaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaa
akiacaaaaaaaaaaaaeaaaaaaaoaaaaalccaabaaaaaaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpbkiacaaaaaaaaaaaaeaaaaaadiaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaaaaaaaaajmcaabaaaaaaaaaaa
kgbobaiaebaaaaaaabaaaaaaagiicaaaaaaaaaaaafaaaaaaapaaaaahecaabaaa
aaaaaaaaogakbaaaaaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaaaaaaaaaa
ckaabaaaaaaaaaaaaaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaa
akiacaaaaaaaaaaaaeaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaa
abeaaaaaaaaaaaaaddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaa
aaaaaaaaaeaaaaaadiaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaabkaabaaa
aaaaaaaaaoaaaaaifcaabaaaaaaaaaaaagacbaaaaaaaaaaaagiacaaaaaaaaaaa
aeaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaadcaaaaakecaabaaaaaaaaaaadkaabaaaabaaaaaadkiacaaa
aaaaaaaaadaaaaaackaabaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaa
abaaaaaaegiccaaaaaaaaaaaadaaaaaaaaaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaackaabaaaaaaaaaaaaaaaaaajmcaabaaaaaaaaaaakgbobaiaebaaaaaa
abaaaaaaagiicaaaaaaaaaaaahaaaaaaapaaaaahecaabaaaaaaaaaaaogakbaaa
aaaaaaaaogakbaaaaaaaaaaaelaaaaafecaabaaaaaaaaaaackaabaaaaaaaaaaa
aaaaaaajecaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaa
aeaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaaaa
ddaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaa
diaaaaahccaabaaaaaaaaaaackaabaaaaaaaaaaabkaabaaaaaaaaaaaaoaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaaaaaaaaah
bcaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaaiiccabaaa
aaaaaaaaakaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpaoaaaaahdcaabaaa
aaaaaaaaegbabaaaacaaaaaapgbpbaaaacaaaaaaefaaaaajpcaabaaaaaaaaaaa
egaabaaaaaaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaa
acaaaaaaegbabaaaadaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaah
icaabaaaaaaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdcaaaaajhcaabaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaaaaaaaaadiaaaaah
hccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaabejfdeheo
jiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaa
apaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaaimaaaaaa
abaaaaaaaaaaaaaaadaaaaaaabaaaaaaamamaaaaimaaaaaaacaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapalaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES3"
}

}
	}

#LINE 64

}
 
Fallback "Transparent/VertexLit"
}