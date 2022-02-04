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
LinearTransformation(Input="Linear_BT601_PAL", Output="Linear_BT709")
LinearTransformation(Input="Linear_BT709", Output="Linear_BT601_NTSC")
LinearTransformation(Input="Linear_BT709", Output="Linear_BT601_PAL")
LinearTransformation(Input="Linear_BT709", Output="BT2020_HLG")
LinearTransformation(Input="Linear_BT709", Output=""BT2100_PQ")
LinearTransformation(Input="Linear_BT709", Output=""DCI_XYZ")
LinearTransformation(Input="Linear_BT709", Output=""ZLog")
LinearTransformation(Input="BT2100_PQ", Output=""Linear_BT2020")
LinearTransformation(Input="BT2100_PQ", Output=""Linear_BT709")
LinearTransformation(Input="BT2100_PQ", Output=""BT2020_HLG")
LinearTransformation(Input="CLog3", Output=""Linear_BT709")
LinearTransformation(Input="CLog3", Output=""BT2020_HLG")
LinearTransformation(Input="CLog3", Output=""BT2100_PQ")
LinearTransformation(Input="SLog2", Output=""Linear_BT709")
LinearTransformation(Input="SLog3", Output=""Linear_BT709")
LinearTransformation(Input="BT2020_HLG", Output=""Linear_BT709")
LinearTransformation(Input="BT2020_HLG", Output=""BT2100_PQ")
LinearTransformation(Input="DCI_XYZ", Output=""Linear_BT709")
LinearTransformation(Input="LogC", Output=""Linear_BT709")
LinearTransformation(Input="VLog", Output=""Linear_BT709")
LinearTransformation(Input="dvhe0509", Output=""Linear_BT709")
        \ : ""


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
