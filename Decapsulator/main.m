tcpserver = 0;
if tcpserver == 1
    
    % Listen to 4012 and wait for a connection
    t = tcpip('0.0.0.0', 30000, 'NetworkRole', ...
        'server');
    
    disp('Start TCP Server')
    syncArr = [1 1 0 1 0 1 0 0 0 1 1 1 0 1 1 1 1 0];
    while 1
        fopen(t);
        disp('Got a connection');
        disp('Waiting');
        while t.BytesAvailable == 0
            disp('...');
            pause(1);
        end
        
        dataStreamInt = [];
        while t.BytesAvailable > 0
            disp(int2str(t.BytesAvailable));
            temp = fread(t, t.BytesAvailable, 'uint8');
            dataStreamInt = [dataStreamInt; temp];
            pause(0.5);
        end

        resp = packetHandler('recieved-data.bin', dataStreamInt, ...
                syncArr, 0);
        if length(resp) >= 512*8
            towrite = binArrToDec8BitArr(resp);
            bufsize = t.OutputBufferSize;


            buffer = towrite(1:512);

            while length(buffer) > 0
              fwrite(t, buffer);

              if length(resp) > 512
                  towrite = towrite(512:end);
                  buffer = towrite(1:512);
              else
                  buffer = towrite(1:end);
                  towrite = [];
              end
            end
            disp('Done handling data');
        end
        
        fclose(t);
    end
    fclose(t);
else
    disp('Read output file')
    %analyse_file('output-length-sync-15-descram.bin','930b51de', 'descram-c985a8ef');
    %syncArr = [1 1 0 1 0 1 0 0 0 1 1 1 0 1 1 1 1 0];
    syncArr = hexStrToBinArr('D9F15051');
    i=20;
    sourcefilename = strcat('output-length-sync-', ...
        int2str(i) ,'-undescram.bin');

    targetf = strcat('descram-newsync-',int2str(i));
    analyse_file(sourcefilename, syncArr, targetf);
end