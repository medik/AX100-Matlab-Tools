tcpserver = 0;
if tcpserver == 1
    
    % Listen to 4012 and wait for a connection
    t = tcpip('0.0.0.0', 30000, 'NetworkRole', ...
        'server', 'InputBufferSize', 24000);
    
    disp('Start TCP Server')
    syncArr = [1 1 0 1 0 1 0 0 0 1 1 1 0 1 1 1 1 0];
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
            packetHandler('data.test.bin', dataStreamInt, syncArr, 0);
        end
        fclose(t);
    end
    fclose(t);
else
    disp('Read output file')
    %analyse_file('output-length-sync-15-descram.bin','930b51de', 'descram-c985a8ef');
    syncArr = [1 1 0 1 0 1 0 0 0 1 1 1 0 1 1 1 1 0];
    %syncArr = hexStrToBinArr('c985a8ef');
    for i=15:5:30
        sourcefilename = strcat('output-length-sync-', ...
            int2str(i) ,'-descram.bin');
        
        targetf = strcat('descram-newsync-',int2str(i));
        analyse_file(sourcefilename, syncArr, targetf);
    end
end