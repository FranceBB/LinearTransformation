# LinearTransformation
![alt text](https://i.ytimg.com/vi/kYB8IZa5AuE/maxresdefault.jpg)
This script performs Linear Transformations based on a matrix conversion. Matrices are made by Francesco Bucciantini.
<br>
The function has two parameters: Input and Output.
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
LinearTransformation(Input="Linear_BT709", Output="BT2020_HLG")
<br>
LinearTransformation(Input="Linear_BT709", Output="BT2100_PQ")
<br>
LinearTransformation(Input="Linear_BT709", Output="DCI_XYZ")
<br>
LinearTransformation(Input="BT2100_PQ", Output="Linear_BT2020")
<br>
LinearTransformation(Input="BT2100_PQ", Output="Linear_BT709")
<br>
LinearTransformation(Input="BT2100_PQ", Output="BT2020_HLG")
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
LinearTransformation(Input="DCI_XYZ", Output="Linear_BT709")
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
- Compatible with AVID Media Composer
- Compatible with Davinci Resolve
- Compatible with Adobe Premiere
- Compatible with Colorfront Transkoder
<br>

# Slog3 to BT709 SDR 100 nits
![alt text](https://i.imgur.com/TIRdtG5.png)
<br>
![alt text](https://i.imgur.com/9E6yr7S.png)
![alt text](https://i.imgur.com/7DHYloZ.png)
<br>
![alt text](https://i.imgur.com/kYlmAet.png)
![alt text](https://i.imgur.com/VaDIB0M.png)
<br>
# Zlog2 to BT709 SDR 100 nits
![alt text](https://i.imgur.com/pBC0YSQ.png)
![alt text](https://i.imgur.com/wOOdIb4.png)
![alt text](https://i.imgur.com/NzxlprK.png)
# Dolby Vision Version 1.0 dvhe0509 (left) to BT709 SDR 100 nits (right)
![alt text](https://i.imgur.com/2RSX7iQ.png)
![alt text](https://i.imgur.com/XaG01v4.png)
![alt text](https://i.imgur.com/ewnF3yj.png)
![alt text](https://i.imgur.com/1XuQzoU.png)
![alt text](https://i.imgur.com/cqRiSMw.png)
![alt text](https://i.imgur.com/EPurW3b.png)
![alt text](https://i.imgur.com/ZRZFgL4.png)
![alt text](https://i.imgur.com/5z8ABGm.png)
![alt text](https://i.imgur.com/IM1nuA2.png)
![alt text](https://i.imgur.com/PGtRZQm.png)
![alt text](https://i.imgur.com/vZ5gIQV.png)
