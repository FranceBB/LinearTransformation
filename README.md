# LinearTransformation
![alt text](https://i.ytimg.com/vi/kYB8IZa5AuE/maxresdefault.jpg)
This script performs Linear Transformations based on a matrix conversion. Matrices are made by Francesco Bucciantini.
<br>
The function has two parameters: Input and Output.
<br>
Currently, only those conversions are supported:
<br>
<br>
From "Linear_BT601_NTSC" to "Linear_BT709"
<br>
From "Linear_BT601_PAL"  to "Linear_BT709"
<br>
From "Linear_BT709"       to "Linear_BT601_NTSC"
<br>
From "Linear_BT709"       to "Linear_BT601_PAL"
<br>
From "Linear_BT709"       to "BT2020_HLG"
<br>
From "Linear_BT709"       to "BT2100_PQ"
<br>
From "Linear_BT709"         to "DCI_XYZ"
<br>
From "Linear_BT709"             to "ZLog"
<br>
From "Linear_BT2020"             to "BT2020_HLG"
<br>
From "BT2100_PQ"             to "Linear_BT2020"
<br>
From "BT2100_PQ"             to "Linear_BT709"
<br>
From "BT2100_PQ"           to "BT2020_HLG"
<br>
From "CLog3"        to "Linear_BT709"
<br>
From "CLog3"        to "BT2020_HLG"
<br>
From "CLog3"              to "BT2100_PQ"
<br>
From "SLog2"         to "Linear_BT709"
<br>
From "SLog3"         to "Linear_BT709"
<br>
From "BT2020_HLG"             to "Linear_BT709"
<br>
From "BT2020_HLG_A"             to "Linear_BT709"
<br>
From "BT2020_HLG"             to "BT2100_PQ"
<br>
From "DCI_XYZ"              to "Linear_BT709"
<br>
From "LogC"      to "Linear_BT709"
<br>
From "VLog"      to "Linear_BT709"
<br>
<br>
<br>
<br>
A Linear Transformation is essentially a matrix that maps all points of a certain space to another, which includes of course points belonging to a certain curve to other in order to get a different curve.
<br>
Of course, a linear transformation can be used in encoding to map some values to some other values and therefore have conversions from curves like PQ to HLG and so on.
<br>
<br>
The transformation is performed with 16bit precision, which means that if your input source is lower, let's say, 8bit planar yv12, it will be brought to 16bit planar RGB internally, the linear transformation will be applied with 16bit planar precision and then the result will be brought down to 8bit planar yv12.
<br>
<br>
Planar RGB 16bit is strongly suggested as your source as it's gonna be faster, in fact 4:2:0, 4:2:2, 4:4:4 planar up to 16bit will be converted back and forth internally.
<br>
Inside the plugin, the path specified for the matrices is "mypath" and by default is:  mypath = "C:\Program Files (x86)\AviSynth+\LUTs\" which means that it's gonna look for my LUTs in a folder in such a location. It's not mandatory to have my LUTs there, you can have them in any location you want, provided that you do update that string.
