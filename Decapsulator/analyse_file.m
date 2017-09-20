function analyse_file(filename, syncSeq, outputname)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    fileID = fopen(filename);
    dataStreamInt = fread(fileID, 'uint8');
    
    resp = packetHandler(strcat(outputname,'-hex.csv'), dataStreamInt, syncSeq, 0);
    disp(strcat('Response:', binArrToHexStr(resp)))
    %packetHandler(strcat(outputname,'-binary.csv'), dataStreamInt, syncSeq, 1);
    fclose(fileID);
end