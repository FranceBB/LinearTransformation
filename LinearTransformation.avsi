Function LinearTransformation(clip clp, string "Input", string "Output", string "Interpolation") {

    Input  = Default(Input ,"")        
    Output = Default(Output,"")
    Interpolation = Default(Interpolation, "1")
    
    #Check interpolation method and align to avscube (Trilinear = 0, Tetrahedral = 1)
    if (Interpolation == "Trilinear") {
        Interpolation = 0
       }
    else
    {
        Interpolation = 1
     }
    
    #set the location of your Avisynth installation and/orthe LUTs downloaded
    mypath = "C:\Program Files (x86)\AviSynth+\LUTs\"

    # Removed IsRGB, that just means Any type of RGB at all, Interleaved, planar, any bit depth at all.
    # We've used "RGBP" for Planar RGB
    Original = clp.IsYV12   ? "YV12"  : clp.IsYUY2  ? "YUY2"  : clp.IsRGB24() ? "RGB24" : clp.IsRGB32() ? "RGB32"
        \ : clp.IsYV16      ? "YV16"  : clp.IsYV24  ? "YV24"
        \ : clp.IsRGB48     ? "RGB48" : clp.IsRGB64 ? "RGB64" : clp.Is420 ? "YUV420" : clp.Is422 ? "YUV422" : clp.Is444() ? "YUV444"
        \ : clp.IsPlanarRGB ? "RGBP"
        \ : ""

    Assert(original != "", "LinearTransformation: Color Format not supported," + Chr(10)+"only 4:2:0, 4:2:2, 4:4:4 and RGB are supported")

    #Save original bits per component
    Bpc = clp.BitsPerComponent

    #There's no 16bit version of 422 interleaved so we gotta convert to planar first
    clp = (Original=="YUY2") ? clp.ConvertToYV16 : clp
    
    #Check if the input has the alpha channel
     if (Original == "RGB32") {
        my_alpha = clp.ShowAlpha(pixel_type="RGB24")
        clp = clp.RemoveAlphaPlane()
        has_alpha_plane = true
       }
    else
    {
        has_alpha_plane = false
     }


    # Convert to 16 bit first, reduce YUV -> RGB colorspace conversion losses
    clp = clp.ConvertBits(bits=16).ConvertToPlanarRGB()               # If already PlanarRGB 16 bit then should do nearly nothing

    # Generating the string for the LUT selection
        CubeStr =
        \   Input=="Linear_BT601_NTSC"        && Output=="Linear_BT709"                      ? "BT601_NTSC_to_BT709"
        \ : Input=="Linear_BT601_PAL"          && Output=="Linear_BT709"                      ? "BT601_PAL_to_BT709"
        \ : Input=="Linear_BT709"                && Output=="Linear_BT601_NTSC"              ? "BT709_to_BT601_NTSC"
        \ : Input=="Linear_BT709"                && Output=="Linear_BT601_PAL"                ? "BT709_to_BT601_PAL"
        \ : Input=="Linear_BT709"                && Output=="Linear_BT2020"                     ? "BT709_to_BT2020"
        \ : Input=="Linear_BT709"                && Output=="BT2020_HLG"                          ? "BT709_to_HLG"
        \ : Input=="Linear_BT709"                && Output=="BT2100_PQ"                           ? "BT709_to_PQ"
        \ : Input=="Linear_BT709"                && Output=="DCI_XYZ"                               ? "YUVBT709_to_DCIXYZ"
        \ : Input=="Linear_BT2020"              && Output=="Linear_BT709"                       ? "BT2020_to_BT709"                                        
        \ : Input=="BT2100_PQ"                     && Output=="Linear_BT2020"                     ? "BT2100_HDR_PQ_to_BT2020_SDR"
        \ : Input=="BT2100_PQ"                     && Output=="Linear_BT709"                       ? "PQ_to_BT709_v1"
        \ : Input=="BT2100_PQ"                     && Output=="BT2020_HLG"                          ? "PQ_to_HLG"
        \ : Input=="BT2100_PQ"                     && Output=="DCI_XYZ"                               ? "BT2020_PQ_to_DCI_XYZ"
        \ : Input=="CLog3"                           && Output=="Linear_BT709"                       ? "CLog3_to_BT709"
        \ : Input=="CLog3"                           && Output=="BT2020_HLG"                           ? "CLog3_to_HDR_HLG"
        \ : Input=="CLog3"                           && Output=="BT2100_PQ"                            ? "CLog3_to_HDR_PQ"
        \ : Input=="SLog2"                           && Output=="Linear_BT709"                        ? "Slog2_to_BT709"
        \ : Input=="SLog3"                           && Output=="Linear_BT709"                        ? "Slog3_to_BT709"
        \ : Input=="BT2020_HLG"                   && Output=="Linear_BT709"                        ? "HLG_BT2020_to_Linear_BT709"
        \ : Input=="BT2020_HLG"                   && Output=="BT2100_PQ"                             ? "HLG_to_PQ"
        \ : Input=="BT2020_HLG"                   && Output=="DCI_XYZ"                                ? "BT2020_HLG_to_DCI_XYZ"
        \ : Input=="DCI_XYZ"                        && Output=="Linear_BT709"                        ? "DCIXYZ_to_YUVBT709"
        \ : Input=="DCI_XYZ"                        && Output=="BT2020_HLG"                           ? "DCI_XYZ_to_BT2020_HLG"
        \ : Input=="DCI_XYZ"                        && Output=="BT2100_PQ"                             ? "DCI_XYZ_to_BT2020_PQ"
        \ : Input=="LogC"                             && Output=="Linear_BT709"                        ? "LogC_to_BT709"
        \ : Input=="VLog"                             && Output=="Linear_BT709"                        ? "Vlog_to_BT709"
        \ : Input=="ZLog"                             && Output=="Linear_BT709"                        ? "Z-Log_to_BT709"
        \ : Input=="ZLog2"                            && Output=="Linear_BT709"                        ? "ZLog2_to_BT709"
        \ : Input=="dvhe0509"                       && Output=="Linear_BT709"                        ? "dvhe0509_to_BT709"
        \ : ""
       
    # Populating frame properties               
                my_Matrix =
        \   Input=="Linear_BT601_NTSC"       && Output=="Linear_BT709"                        ? (1)
        \ : Input=="Linear_BT601_PAL"        && Output=="Linear_BT709"                         ? (1)
        \ : Input=="Linear_BT709"              && Output=="Linear_BT601_NTSC"                 ? (6)
        \ : Input=="Linear_BT709"              && Output=="Linear_BT601_PAL"                   ? (5)
        \ : Input=="Linear_BT709"              && Output=="Linear_BT2020"                       ? (9)
        \ : Input=="Linear_BT709"              && Output=="BT2020_HLG"                            ? (9)
        \ : Input=="Linear_BT709"              && Output=="BT2100_PQ"                              ? (9)
        \ : Input=="Linear_BT709"              && Output=="DCI_XYZ"                                 ? (2)
        \ : Input=="BT2100_PQ"                   && Output=="Linear_BT2020"                       ? (9)
        \ : Input=="BT2100_PQ"                   && Output=="Linear_BT709"                         ? (1)
        \ : Input=="BT2100_PQ"                   && Output=="BT2020_HLG"                            ? (9)
        \ : Input=="BT2100_PQ"                   && Output=="DCI_XYZ"                                 ? (2)
        \ : Input=="Linear_BT2020"            && Output=="Linear_BT709"                         ? (1)
        \ : Input=="CLog3"                         && Output=="Linear_BT709"                         ? (1)
        \ : Input=="CLog3"                         && Output=="BT2020_HLG"                            ? (9)
        \ : Input=="CLog3"                         && Output=="BT2100_PQ"                              ? (9)
        \ : Input=="SLog2"                         && Output=="Linear_BT709"                         ? (1)
        \ : Input=="SLog3"                         && Output=="Linear_BT709"                         ? (1)
        \ : Input=="BT2020_HLG"                 && Output=="Linear_BT709"                         ? (1)
        \ : Input=="BT2020_HLG"                 && Output=="BT2100_PQ"                              ? (9)
        \ : Input=="BT2020_HLG"                 && Output=="DCI_XYZ"                                 ? (2)
        \ : Input=="DCI_XYZ"                      && Output=="Linear_BT709"                         ? (1)
        \ : Input=="DCI_XYZ"                      && Output=="BT2020_HLG"                            ? (9)
        \ : Input=="DCI_XYZ"                      && Output=="BT2100_PQ"                              ? (9)
        \ : Input=="LogC"                           && Output=="Linear_BT709"                         ? (1)
        \ : Input=="VLog"                           && Output=="Linear_BT709"                         ? (1)
        \ : Input=="ZLog"                           && Output=="Linear_BT709"                        ? (1)
        \ : Input=="ZLog2"                          && Output=="Linear_BT709"                        ? (1)
        \ : Input=="dvhe0509"                     && Output=="Linear_BT709"                         ? (1)
        \ : (2)

                my_transfer =
        \   Input=="Linear_BT601_NTSC"      && Output=="Linear_BT709"                         ? (1)
        \ : Input=="Linear_BT601_PAL"        && Output=="Linear_BT709"                         ? (1)
        \ : Input=="Linear_BT709"              && Output=="Linear_BT601_NTSC"                 ? (6)
        \ : Input=="Linear_BT709"              && Output=="Linear_BT601_PAL"                   ? (6)
        \ : Input=="Linear_BT709"              && Output=="Linear_BT2020"                       ? (14)
        \ : Input=="Linear_BT709"              && Output=="BT2020_HLG"                            ? (18)
        \ : Input=="Linear_BT709"              && Output=="BT2100_PQ"                              ? (16)
        \ : Input=="Linear_BT709"              && Output=="DCI_XYZ"                                 ? (17)
        \ : Input=="BT2100_PQ"                   && Output=="Linear_BT2020"                       ? (14)
        \ : Input=="BT2100_PQ"                   && Output=="Linear_BT709"                         ? (1)
        \ : Input=="BT2100_PQ"                   && Output=="BT2020_HLG"                            ? (18)
        \ : Input=="BT2100_PQ"                   && Output=="DCI_XYZ"                                 ? (17)
        \ : Input=="Linear_BT2020"            && Output=="Linear_BT709"                         ? (1)
        \ : Input=="CLog3"                         && Output=="Linear_BT709"                         ? (1)
        \ : Input=="CLog3"                         && Output=="BT2020_HLG"                            ? (18)
        \ : Input=="CLog3"                         && Output=="BT2100_PQ"                              ? (16)
        \ : Input=="SLog2"                         && Output=="Linear_BT709"                         ? (1)
        \ : Input=="SLog3"                         && Output=="Linear_BT709"                         ? (1)
        \ : Input=="BT2020_HLG"                 && Output=="Linear_BT709"                         ? (1)
        \ : Input=="BT2020_HLG"                 && Output=="BT2100_PQ"                              ? (16)
        \ : Input=="BT2020_HLG"                 && Output=="DCI_XYZ"                                 ? (17)
        \ : Input=="DCI_XYZ"                      && Output=="Linear_BT709"                         ? (1)
        \ : Input=="DCI_XYZ"                      && Output=="BT2020_HLG"                            ? (18)
        \ : Input=="DCI_XYZ"                      && Output=="BT2100_PQ"                              ? (16)
        \ : Input=="LogC"                           && Output=="Linear_BT709"                         ? (1)
        \ : Input=="VLog"                           && Output=="Linear_BT709"                         ? (1)
        \ : Input=="ZLog"                           && Output=="Linear_BT709"                        ? (1)
        \ : Input=="ZLog2"                          && Output=="Linear_BT709"                        ? (1)
        \ : Input=="dvhe0509"                     && Output=="Linear_BT709"                         ? (1)
        \ : (2)

            my_primaries =
        \   Input=="Linear_BT601_NTSC"       && Output=="Linear_BT709"                        ? (1)
        \ : Input=="Linear_BT601_PAL"        && Output=="Linear_BT709"                         ? (1)
        \ : Input=="Linear_BT709"              && Output=="Linear_BT601_NTSC"                 ? (6)
        \ : Input=="Linear_BT709"              && Output=="Linear_BT601_PAL"                   ? (5)
        \ : Input=="Linear_BT709"              && Output=="Linear_BT2020"                        ? (9)
        \ : Input=="Linear_BT709"              && Output=="BT2020_HLG"                            ? (9)
        \ : Input=="Linear_BT709"              && Output=="BT2100_PQ"                              ? (9)
        \ : Input=="Linear_BT709"              && Output=="DCI_XYZ"                                 ? (11)
        \ : Input=="BT2100_PQ"                   && Output=="Linear_BT2020"                       ? (9)
        \ : Input=="BT2100_PQ"                   && Output=="Linear_BT709"                         ? (1)
        \ : Input=="BT2100_PQ"                   && Output=="BT2020_HLG"                            ? (9)
        \ : Input=="BT2100_PQ"                   && Output=="DCI_XYZ"                                 ? (11)
        \ : Input=="Linear_BT2020"            && Output=="Linear_BT709"                         ? (1)
        \ : Input=="CLog3"                         && Output=="Linear_BT709"                         ? (1)
        \ : Input=="CLog3"                         && Output=="BT2020_HLG"                            ? (9)
        \ : Input=="CLog3"                         && Output=="BT2100_PQ"                              ? (9)
        \ : Input=="SLog2"                         && Output=="Linear_BT709"                         ? (1)
        \ : Input=="SLog3"                         && Output=="Linear_BT709"                         ? (1)
        \ : Input=="BT2020_HLG"                 && Output=="Linear_BT709"                         ? (1)
        \ : Input=="BT2020_HLG"                 && Output=="BT2100_PQ"                              ? (9)
        \ : Input=="BT2020_HLG"                 && Output=="DCI_XYZ"                                 ? (11)
        \ : Input=="DCI_XYZ"                      && Output=="Linear_BT709"                         ? (1)
        \ : Input=="DCI_XYZ"                      && Output=="BT2020_HLG"                            ? (9)
        \ : Input=="DCI_XYZ"                      && Output=="BT2100_PQ"                              ? (9)
        \ : Input=="LogC"                           && Output=="Linear_BT709"                         ? (1)
        \ : Input=="VLog"                           && Output=="Linear_BT709"                         ? (1)
        \ : Input=="ZLog"                           && Output=="Linear_BT709"                        ? (1)
        \ : Input=="ZLog2"                          && Output=="Linear_BT709"                        ? (1)
        \ : Input=="dvhe0509"                     && Output=="Linear_BT709"                         ? (1)
        \ : (2)
                   
                output_Matrix =
        \   Input=="Linear_BT601_NTSC"       && Output=="Linear_BT709"                        ? ("Rec709")
        \ : Input=="Linear_BT601_PAL"        && Output=="Linear_BT709"                         ? ("Rec709")
        \ : Input=="Linear_BT709"              && Output=="Linear_BT601_NTSC"                 ? ("Rec601")
        \ : Input=="Linear_BT709"              && Output=="Linear_BT601_PAL"                   ? ("Rec601")
        \ : Input=="Linear_BT709"              && Output=="Linear_BT2020"                       ? ("Rec2020")
        \ : Input=="Linear_BT709"              && Output=="BT2020_HLG"                            ? ("Rec2020")
        \ : Input=="Linear_BT709"              && Output=="BT2100_PQ"                              ? ("Rec2020")
        \ : Input=="Linear_BT709"              && Output=="DCI_XYZ"                                 ? ("Rec709")
        \ : Input=="BT2100_PQ"                   && Output=="Linear_BT2020"                       ? ("Rec2020")
        \ : Input=="BT2100_PQ"                   && Output=="Linear_BT709"                         ? ("Rec709")
        \ : Input=="BT2100_PQ"                   && Output=="BT2020_HLG"                            ? ("Rec2020")
        \ : Input=="BT2100_PQ"                   && Output=="DCI_XYZ"                                 ? ("Rec709")
        \ : Input=="Linear_BT2020"            && Output=="Linear_BT709"                         ? ("Rec709")
        \ : Input=="CLog3"                         && Output=="Linear_BT709"                         ? ("Rec709")
        \ : Input=="CLog3"                         && Output=="BT2020_HLG"                            ? ("Rec2020")
        \ : Input=="CLog3"                         && Output=="BT2100_PQ"                              ? ("Rec2020")
        \ : Input=="SLog2"                         && Output=="Linear_BT709"                         ? ("Rec709")
        \ : Input=="SLog3"                         && Output=="Linear_BT709"                         ? ("Rec709")
        \ : Input=="BT2020_HLG"                 && Output=="Linear_BT709"                         ? ("Rec709")
        \ : Input=="BT2020_HLG"                 && Output=="BT2100_PQ"                              ? ("Rec2020")
        \ : Input=="BT2020_HLG"                 && Output=="DCI_XYZ"                                 ? ("Rec709")
        \ : Input=="DCI_XYZ"                      && Output=="Linear_BT709"                         ? ("Rec709")
        \ : Input=="DCI_XYZ"                      && Output=="BT2020_HLG"                            ? ("Rec2020")
        \ : Input=="DCI_XYZ"                      && Output=="BT2100_PQ"                              ? ("Rec2020")
        \ : Input=="LogC"                           && Output=="Linear_BT709"                         ? ("Rec709")
        \ : Input=="VLog"                           && Output=="Linear_BT709"                         ? ("Rec709")
        \ : Input=="ZLog"                           && Output=="Linear_BT709"                        ? ("Rec709")
        \ : Input=="ZLog2"                          && Output=="Linear_BT709"                        ? ("Rec709")
        \ : Input=="dvhe0509"                     && Output=="Linear_BT709"                         ? ("Rec709")
        \ : ("Rec709")


    Assert(CubeStr != "","LinearTransformation: Transformation not supported, please choose a valid input and output Input='"+Input+"' Output='"+Output+"'" )
    
    #If the input has the alpha channel it needs to be converted too
    if (has_alpha_plane == true) {
        
        #Alpha channel conversion
        ConvertBits(my_alpha, 16)
        ConvertToPlanarRGB()
        Cube(myPath + CubeStr + ".cube", interp=Interpolation, fullrange=1)
        ConverttoY()
        my_alpha=last
        
        #Normal channel conversion
        Cube(clp, myPath + CubeStr + ".cube", interp=Interpolation, fullrange=1)
        my_video=last
        
        #Merge converted normal channel with converted alpha channel
        AddAlphaPlane(my_video, my_alpha)
        
        #Set frame properties
        propset("_Matrix", my_Matrix)
        propset("_Transfer", my_transfer)
        
        out=last
        
       }
    else
    {
        #Normal channel conversion
        Cube(clp, myPath + CubeStr + ".cube", interp=Interpolation, fullrange=1)
        
        #Set frame properties
        propset("_Matrix", my_Matrix)
        propset("_Transfer", my_transfer)
        propset("_Primaries", my_primaries)
        
        out=last
        
     }

    out = ConvertBits(out, bits=bpc, dither=1)

    out   = original == "YV12"   ? out.ConverttoYV12(matrix=output_Matrix)
        \ : original == "YUY2"   ? out.ConverttoYUY2
        \ : original == "RGB24"  ? out.ConverttoRGB24(matrix=output_Matrix)
        \ : original == "RGB32"  ? out.ConverttoRGB32(matrix=output_Matrix)
        \ : original == "YV16"   ? out.ConverttoYV16(matrix=output_Matrix)
        \ : original == "YV24"   ? out.ConverttoYV24(matrix=output_Matrix)
        \ : original == "RGB48"  ? out.ConverttoRGB48(matrix=output_Matrix)
        \ : original == "RGB64"  ? out.ConverttoRGB64(matrix=output_Matrix)
        \ : original == "YUV420" ? out.ConverttoYUV420(matrix=output_Matrix)
        \ : original == "YUV422" ? out.ConverttoYUV422(matrix=output_Matrix)
        \ : original == "YUV444" ? out.ConverttoYUV444(matrix=output_Matrix)
        \ : out [* Must be RGBP *]
    return out
}
