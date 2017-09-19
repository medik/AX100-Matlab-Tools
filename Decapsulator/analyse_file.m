function analyse_file(filename, syncSeq, outputname)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    fileID = fopen(filename);
    dataStreamInt = fread(fileID, 'ubit8');
    
    packetHandler(strcat(outputname,'-hex.csv'), dataStreamInt, syncSeq, 0);
    %packetHandler(strcat(outputname,'-binary.csv'), dataStreamInt, syncSeq, 1);
    fclose(fileID);
end