# LinearTransformation
![alt text](https://i.ytimg.com/vi/kYB8IZa5AuE/maxresdefault.jpg)
This script performs Linear Transformations based on a matrix conversion.
<br>
The function has two mandatory parameters: Input and Output.
<br>
The function also has one optional parameter: Interpolation.
<br>
The interpolation parameter can either be set to "Trilinear" or "Tetrahedral" and by default it's set to Tetrahedral as it achieves better results.
<br>
Source (left) - Trilinear (center) - Tetrahedral (right):
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/f742fb52-e382-4317-abf4-342c55a1790c)
As you can see, in the right hand side waveform (tetrahedral) there are no ripples, unlike the ones you can see in the trilinear interpolation at the center.
<br>
Currently, only those conversions are supported:
<br>
<br>
LinearTransformation(Input="Linear_BT601_NTSC", Output="Linear_BT709")
<br>
LinearTransformation(Input="Linear_BT601_PAL", Output="Linear_BT709")
<br>
LinearTransformation(Input="Linear_BT709", Output="Linear_BT601_NTSC")
<br>
LinearTransformation(Input="Linear_BT709", Output="Linear_BT601_PAL")
<br>
LinearTransformation(Input="Linear_BT709", Output="Linear_BT2020")
<br>
LinearTransformation(Input="Linear_BT709", Output="BT2020_HLG")
<br>
LinearTransformation(Input="Linear_BT709", Output="BT2100_PQ")
<br>
LinearTransformation(Input="Linear_BT709", Output="DCI_XYZ")
<br>
LinearTransformation(Input="Linear_BT2020", Output="Linear_BT709")
<br>
LinearTransformation(Input="BT2100_PQ", Output="Linear_BT2020")
<br>
LinearTransformation(Input="BT2100_PQ", Output="Linear_BT709")
<br>
LinearTransformation(Input="BT2100_PQ", Output="BT2020_HLG")
<br>
LinearTransformation(Input="BT2100_PQ", Output="DCI_XYZ")
<br>
LinearTransformation(Input="CLog3", Output="Linear_BT709")
<br>
LinearTransformation(Input="CLog3", Output="BT2020_HLG")
<br>
LinearTransformation(Input="CLog3", Output="BT2100_PQ")
<br>
LinearTransformation(Input="SLog2", Output="Linear_BT709")
<br>
LinearTransformation(Input="SLog3", Output="Linear_BT709")
<br>
LinearTransformation(Input="BT2020_HLG", Output="Linear_BT709")
<br>
LinearTransformation(Input="BT2020_HLG", Output="BT2100_PQ")
<br>
LinearTransformation(Input="BT2020_HLG", Output="DCI_XYZ")
<br>
LinearTransformation(Input="DCI_XYZ", Output="Linear_BT709")
<br>
LinearTransformation(Input="DCI_XYZ", Output="BT2020_HLG")
<br>
LinearTransformation(Input="DCI_XYZ", Output="BT2100_PQ")
<br>
LinearTransformation(Input="LogC", Output="Linear_BT709")
<br>
LinearTransformation(Input="VLog", Output="Linear_BT709")
<br>
LinearTransformation(Input="ZLog", Output="Linear_BT709")
<br>
LinearTransformation(Input="ZLog2", Output="Linear_BT709")
<br>
LinearTransformation(Input="dvhe0509", Output="Linear_BT709")
<br>
<br>
A Linear Transformation is essentially a matrix that maps all points of a certain space to another, which includes of course points belonging to a certain curve to other in order to get a different curve.
<br>
Of course, a linear transformation can be used in encoding to map some values to some other values and therefore have conversions from curves like PQ to HLG and so on.
<br>
The transformation is performed with 16bit precision, which means that if your input source is lower, let's say, 8bit planar yv12, it will be brought to 16bit planar RGB internally, the linear transformation will be applied with 16bit planar precision and then the result will be brought down to 8bit planar yv12.
<br>
Planar RGB 16bit is strongly suggested as your source as it's gonna be faster, in fact 4:2:0, 4:2:2, 4:4:4 planar up to 16bit will be converted back and forth internally.
<br>
Inside the plugin, the path specified for the matrices is "mypath" and by default is:  mypath = "C:\Program Files (x86)\AviSynth+\LUTs\" which means that it's gonna look for my LUTs in a folder in such a location. It's not mandatory to have my LUTs there, you can have them in any location you want, provided that you do update that string.
<br>
<br>
<br>
**How to use my LUTs in Avisynth without using the function "Linear Transformation()":**
<br>
FFVideoSource("example.mxf")
<br>
ConvertBits(16)
<br>
ConvertToPlanarRGB()
<br>
Cube("C:\Programmi\AviSynth+\LUTs\example.cube")
<br>
<br>
**How to use my LUTs in VapourSynth:**
<br>
import vapoursynth as vs
<br>
core = vs.core
<br>
core.ffms2.Source(r'example.mxf')
<br>
vid = core.resize.Spline64(vid, format=vs.RGBS)
<br>
vid = core.timecube.Cube(vid, cube=r"C:\Programmi\AviSynth+\LUTs\example.cube")
<br>
vid.set_output ()
<br>
<br>
**How to use my LUTs in FFMpeg**:
<br>
ffmpeg.exe -i "source.m2ts" -vf lut3d='example.cube' -c:v whatever -c:a whatever -f mkv "output.mkv"
<br>
<br>
<br>
**Who made those LUTs**?
<br>
Those matrices are made by [Francesco Bucciantini (FranceBB)](https://www.linkedin.com/in/francesco-bucciantini-3392b4ab/), computer science engineer and Linear Algebra lover and [Livio Aloja (aligia)](https://www.linkedin.com/in/livio-aloja-9a287424/), former Senior Sky Editor and Encoder, using both free open source tools and closed source ones and cross-checking them with broadcast grade equipment (TVs, waveform monitors, scopes) provided by Sony, Canon and Tektronix.
<br>
<br>
**Who uses those LUTs**?
<br>
Those LUTs are used by everyone for free, from companies that deal with broadcasting video content in any way (Post-production, OTT, etc) like public and private broadcasters all around the world to regular people that want to convert their video archives.
<br>
<br>
**Compatibility with third party programs**:
<br>
- Compatible with Avisynth+
- Compatible with VapourSynth
- Compatible with FFMpeg
- Compatible with AVID Media Composer
- Compatible with Davinci Resolve
- Compatible with Adobe Premiere
- Compatible with Colorfront Transkoder
<br>

# Slog3 to BT709 SDR 100 nits
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/d0efb065-8c47-47aa-87aa-586c7858206f)
<br>
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/b69e757b-13c1-4ae7-80eb-56118f9b736a)
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/ffc85947-6b60-4adc-9cd6-f7fa46b6015d)
<br>
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/be1b3ae5-edf7-4c71-9551-cacd41af651e)
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/adb129e3-6846-46a6-aab1-b090cc17adea)
<br>
# Slog2 to BT709 SDR 100 nits
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/35911b2e-f26c-4f05-bb35-0a375d3997e3)
<br>
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/485b71e2-231a-4ddd-b041-88af7b1fa444)
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/ed676963-68ab-4831-9c7d-af7fcbd27c3c)
<br>
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/f4722fe6-7472-4bf1-8aa8-45155cd3529b)
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/2547ed58-450e-4f76-928b-0eeef5a5ca1f)
<br>
# LogC to BT709 SDR 100 nits
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/e3bd1303-3729-4675-96ad-e3bfb68c3b73)
<br>
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/3f58f8ff-49ff-46a5-a429-c88fb9064edd)
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/52d67d54-7916-4512-a14d-58fd7bf3d58d)
<br>
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/dfefa7cd-146f-44f3-aab9-ea5e105eed94)
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/3b7b8068-83a5-48e6-9235-3aa5c174e8f5)
<br>
# Vlog to BT709 SDR 100 nits
![image](https://github.com/user-attachments/assets/1696fcdf-0941-4f35-bb56-c0d7687fbabd)
<br>
![image](https://github.com/user-attachments/assets/777f3679-4398-43d7-90e1-7aa8dd71283c)
![image](https://github.com/user-attachments/assets/7a0a3b5e-44ae-4681-9762-6beeabbcfd04)
<br>
# DCI P3 XYZ to BT709 RGB SDR 100 nits
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/f19c704f-b039-4484-88e6-b50339a83ac8)
<br>
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/ae6ed523-97c8-452b-be1f-63fac5a2b7b4)
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/93d09c21-4d8d-4b88-9ae6-13a868162d31)
<br>
# Zlog2 to BT709 SDR 100 nits
![alt text](https://i.imgur.com/pBC0YSQ.png)
<br>
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/8982cb0b-27c0-467a-a365-499c5c33b3ad)
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/e80f0a65-0ca1-46e3-96ce-340b1974f66a)
<br>
# Clog3 to HLG HDR 1000 nits
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/406d798b-9ee3-424b-81cf-f00a0cdf3a76)
<br>
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/6abbef5d-0f2a-4564-8c6f-2390967bbfca)
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/08c25656-0843-42dc-8b49-91ac5599a779)
<br>
# PQ HDR to BT2020 SDR 100 nits
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/b1d117ed-d18c-40fb-acbb-abdc7f791ae8)
<br>
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/0bb22dd1-985f-43b0-b507-e963b2e0c25c)
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/bca76652-0ed9-46cf-a787-eeab20aeccaa)
<br>
# BT709 SDR to BT601 SDR
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/92833b16-877a-40a1-ae98-9b414bb2655c)
<br>
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/e03cf7ae-5de4-4ff7-82f3-15fb7664e10a)
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/930a2ca1-5e2b-45aa-9b16-31129ea8fd10)
<br>
# Dolby Vision Version 1.0 IPTc2 dvhe0509 (left) to BT709 SDR 100 nits (right)
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/78269153-491a-4972-be4c-7a4893b59241)
<br>
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/ef7bdbb0-b979-4be3-9995-1ea88ec5a9b4)
<br>
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/005a1235-2804-4f19-bc1b-98e94cea533a)
<br>
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/7887486b-d5d5-4133-aa29-c492e0731806)
<br>
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/b31027b6-598e-4fff-8401-2771d0afffa6)
<br>
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/4e0cca7e-aa9e-499a-a03e-e5663eac2b74)
<br>
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/ad6f163b-efc5-4673-9934-63abef13f244)
<br>
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/cc362fd8-f386-40e2-b686-9a1fd9282e65)
<br>
![image](https://github.com/FranceBB/LinearTransformation/assets/18946343/4751f37e-e188-4fe3-a454-e3e9b65422ea)
