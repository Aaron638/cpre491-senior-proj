function writeHeader(fid, gcodepath, outputpath)
    fprintf(fid, "[Info]\n");
    fprintf(fid, "datetime = '%s'\n", string(datetime));
    fprintf(fid, "gcodepath = '%s'\n", gcodepath);
    fprintf(fid, "outputpath = '%s'\n\n", outputpath);
end