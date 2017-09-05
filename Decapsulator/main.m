tcpserver = 1;
if tcpserver == 1
    
    % Listen to 4012 and wait for a connection
    t = tcpip('0.0.0.0', 30000, 'NetworkRole', 'server','InputBufferSize',24000);
    disp('Start TCP Server')
    while 1
        fopen(t);
        disp('Got a connection');
        disp('Waiting');
        while t.BytesAvailable == 0
            disp('...');
        end
        if t.BytesAvailable > 0
            disp('There is data available...');
            dataStreamInt = fread(t, t.BytesAvailable, 'uint8');
            packetHandler('data.test.bin', dataStreamInt);
        end
        fclose(t);
    end
    fclose(t);
else
    disp('Read output file')
    fileID = fopen('output');
    dataStreamInt = fread(fileID, 'ubit8');
    packetHandler('data.test2.bin', dataStreamInt);
    fclose(fileID);
end