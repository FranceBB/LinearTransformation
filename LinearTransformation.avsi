Function LinearTransformation(clip clp, string "Input", string "Output") {

    Input  = Default(Input ,"")        
    Output = Default(Output,"")

    mypath = "C:\Program Files (x86)\AviSynth+\LUTs\"

    # Removed IsRGB, that just means Any type of RGB at all, Interleaved, planar, any bit depth at all.
    # We've used "RGBP" for Planar RGB
    Original = clp.IsYV12   ? "YV12"  : clp.IsYUY2  ? "YUY2"  : clp.IsRGB24() ? "RGB24" : clp.IsRGB32() ? "RGB32"
        \ : clp.IsYV16      ? "YV16"  : clp.IsYV24  ? "YV24"
        \ : clp.IsRGB48     ? "RGB48" : clp.IsRGB64 ? "RGB64" : clp.Is420 ? "YUV420" : clp.Is422 ? "YUV422" : clp.Is444() ? "YUV444"
        \ : clp.IsPlanarRGB ? "RGBP"
        \ : ""

    Assert(original != "", "LinearTransformation: Color Format not supported," + Chr(10)+"only 4:2:0, 4:2:2, 4:4:4 and RGB are supported")

    Bpc = clp.BitsPerComponent     # original bits per component

    clp = (Original=="YUY2") ? clp.ConvertToYV16 : clp              # There is not 16 bit version of YUY2


    # Convert to 16 bit first, reduce YUV -> RGB colorspace conversion losses
    clp = clp.ConvertBits(bits=16).ConvertToPlanarRGB               # If already PlanarRGB 16 bit then should do nearly nothing

    # Generating the string for the LUT selection
        CubeStr =
        \   Input=="Linear_BT601_NTSC"        && Output=="Linear_BT709"                      ? "BT601_NTSC_to_BT709"
        \ : Input=="Linear_BT601_PAL"          && Output=="Linear_BT709"                      ? "BT601_PAL_to_BT709"
        \ : Input=="Linear_BT709"                && Output=="Linear_BT601_NTSC"              ? "BT709_to_BT601_NTSC"
        \ : Input=="Linear_BT709"                && Output=="Linear_BT601_PAL"                ? "BT709_to_BT601_PAL"
        \ : Input=="Linear_BT709"                && Output=="BT2020_HLG"                          ? "BT709_to_HLG"
        \ : Input=="Linear_BT709"                && Output=="BT2100_PQ"                           ? "BT709_to_PQ"
        \ : Input=="Linear_BT709"                && Output=="DCI_XYZ"                               ? "YUVBT709_to_DCIXYZ"                       
        \ : Input=="Linear_BT709"                && Output=="ZLog"                                   ? "ZLog_to_BT709"                            
        \ : Input=="BT2100_PQ"                     && Output=="Linear_BT2020"                     ? "BT2100_HDR_PQ_to_BT2020_SDR"
        \ : Input=="BT2100_PQ"                     && Output=="Linear_BT709"                       ? "PQ_to_BT709_v1"
        \ : Input=="BT2100_PQ"                     && Output=="BT2020_HLG"                          ? "PQ_to_HLG"
        \ : Input=="CLog3"                           && Output=="Linear_BT709"                       ? "CLog3_to_BT709"
        \ : Input=="CLog3"                           && Output=="BT2020_HLG"                           ? "CLog3_to_HDR_HLG"
        \ : Input=="CLog3"                           && Output=="BT2100_PQ"                            ? "CLog3_to_HDR_PQ"
        \ : Input=="SLog2"                           && Output=="Linear_BT709"                        ? "Slog2_to_BT709"
        \ : Input=="SLog3"                           && Output=="Linear_BT709"                        ? "Slog3_to_BT709"
        \ : Input=="BT2020_HLG"                   && Output=="Linear_BT709"                        ? "HLG_to_BT709"
        \ : Input=="BT2020_HLG"                   && Output=="BT2100_PQ"                             ? "HLG_to_PQ"
        \ : Input=="DCI_XYZ"                        && Output=="Linear_BT709"                        ? "DCIXYZ_to_YUVBT709"
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
        \ : Input=="Linear_BT709"              && Output=="Linear_BT601_PAL"                   ? (3)
        \ : Input=="Linear_BT709"              && Output=="BT2020_HLG"                            ? (9)
        \ : Input=="Linear_BT709"              && Output=="BT2100_PQ"                              ? (9)
        \ : Input=="Linear_BT709"              && Output=="DCI_XYZ"                                 ? (2)
        \ : Input=="Linear_BT709"              && Output=="ZLog"                                      ? (2)
        \ : Input=="BT2100_PQ"                   && Output=="Linear_BT2020"                       ? (9)
        \ : Input=="BT2100_PQ"                   && Output=="Linear_BT709"                         ? (1)
        \ : Input=="BT2100_PQ"                   && Output=="BT2020_HLG"                            ? (9)
        \ : Input=="CLog3"                         && Output=="Linear_BT709"                         ? (1)
        \ : Input=="CLog3"                         && Output=="BT2020_HLG"                            ? (9)
        \ : Input=="CLog3"                         && Output=="BT2100_PQ"                              ? (9)
        \ : Input=="SLog2"                         && Output=="Linear_BT709"                         ? (1)
        \ : Input=="SLog3"                         && Output=="Linear_BT709"                         ? (1)
        \ : Input=="BT2020_HLG"                 && Output=="Linear_BT709"                         ? (1)
        \ : Input=="BT2020_HLG"                 && Output=="BT2100_PQ"                              ? (9)
        \ : Input=="DCI_XYZ"                      && Output=="Linear_BT709"                         ? (1)
        \ : Input=="LogC"                           && Output=="Linear_BT709"                         ? (1)
        \ : Input=="VLog"                           && Output=="Linear_BT709"                         ? (1)
        \ : Input=="ZLog"                           && Output=="Linear_BT709"                        ? (1)
        \ : Input=="ZLog2"                          && Output=="Linear_BT709"                        ? (1)
        \ : Input=="dvhe0509"                     && Output=="Linear_BT709"                         ? (1)
        \ : (2)

                my_transfer =
        \   Input=="Linear_BT601_NTSC"      && Output=="Linear_BT709"                         ? (1)
        \ : Input=="Linear_BT601_PAL"        && Output=="Linear_BT709"                         ? (1)
        \ : Input=="Linear_BT709"              && Output=="Linear_BT601_NTSC"                 ? (2)
        \ : Input=="Linear_BT709"              && Output=="Linear_BT601_PAL"                   ? (2)
        \ : Input=="Linear_BT709"              && Output=="BT2020_HLG"                            ? (18)
        \ : Input=="Linear_BT709"              && Output=="BT2100_PQ"                              ? (16)
        \ : Input=="Linear_BT709"              && Output=="DCI_XYZ"                                 ? (2)
        \ : Input=="Linear_BT709"              && Output=="ZLog"                                      ? (8)
        \ : Input=="BT2100_PQ"                   && Output=="Linear_BT2020"                       ? (14)
        \ : Input=="BT2100_PQ"                   && Output=="Linear_BT709"                         ? (1)
        \ : Input=="BT2100_PQ"                   && Output=="BT2020_HLG"                            ? (18)
        \ : Input=="CLog3"                         && Output=="Linear_BT709"                         ? (1)
        \ : Input=="CLog3"                         && Output=="BT2020_HLG"                            ? (18)
        \ : Input=="CLog3"                         && Output=="BT2100_PQ"                              ? (16)
        \ : Input=="SLog2"                         && Output=="Linear_BT709"                         ? (1)
        \ : Input=="SLog3"                         && Output=="Linear_BT709"                         ? (1)
        \ : Input=="BT2020_HLG"                 && Output=="Linear_BT709"                         ? (1)
        \ : Input=="BT2020_HLG"                 && Output=="BT2100_PQ"                              ? (16)
        \ : Input=="DCI_XYZ"                      && Output=="Linear_BT709"                         ? (1)
        \ : Input=="LogC"                           && Output=="Linear_BT709"                         ? (1)
        \ : Input=="VLog"                           && Output=="Linear_BT709"                         ? (1)
        \ : Input=="ZLog"                           && Output=="Linear_BT709"                        ? (1)
        \ : Input=="ZLog2"                          && Output=="Linear_BT709"                        ? (1)
        \ : Input=="dvhe0509"                     && Output=="Linear_BT709"                         ? (1)
        \ : (2)


    Assert(CubeStr != "","LinearTransformation: Transformation not supported, please choose a valid input and output Input='"+Input+"' Output='"+Output+"'" )

    Cube(clp, myPath + CubeStr + ".cube", fullrange=true).propset("_Matrix", my_Matrix).propset("_Transfer", my_transfer)

    out = Last.ConvertBits(bits=bpc, dither=1)

    out   = original == "YV12"   ? out.ConverttoYV12
        \ : original == "YUY2"   ? out.ConverttoYUY2
        \ : original == "RGB24"  ? out.ConverttoRGB24
        \ : original == "RGB32"  ? out.ConverttoRGB32
        \ : original == "YV16"   ? out.ConverttoYV16
        \ : original == "YV24"   ? out.ConverttoYV24
        \ : original == "RGB48"  ? out.ConverttoRGB48
        \ : original == "RGB64"  ? out.ConverttoRGB64
        \ : original == "YUV420" ? out.ConverttoYUV420
        \ : original == "YUV422" ? out.ConverttoYUV422
        \ : original == "YUV444" ? out.ConverttoYUV444
        \ : out [* Must be RGBP *]
    return out
}
