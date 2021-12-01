function writeHeader(fid, gcodepath, outputpath, w, l, numDefects)
    fprintf(fid, "[Info]\n");
    fprintf(fid, "datetime = '%s'\n", string(datetime));
    fprintf(fid, "gcodepath = '%s'\n", gcodepath);
    fprintf(fid, "width = '%d'\n", w);
    fprintf(fid, "length = '%d'\n", l);
    fprintf(fid, "numDefects = '%d'\n\n", numDefects);
end