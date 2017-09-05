function packetHandler(filename, dataStreamInt)
    syncSeqHex = 'c985a8ef';
    dataStreamHexArr = dec2hex(dataStreamInt);

    dataStreamHex = '';
    for i=1:length(dataStreamHexArr)
        dataStreamHex = strcat(dataStreamHex, dataStreamHexArr(i,:));
    end

    dataStream = hexStrToBinArr(dataStreamHex);

    fid_w = fopen(filename, 'a');

    %packetsFound = containers.Map('KeyType','int32','ValueType','any')
    extractedData = [];
    EOF = 0;
    while EOF ~= 1
        output = findSync(syncSeqHex, dataStream);
        if output('sync_index') ~= -1
            pac = output('packet');
            % TODO: What happens if the message is longer than 255 bytes while in RS?

            %% Reed-Solomon
            % Should we RS the length parameter as well? Maybe, let's assume it
            % first.
            includeLengthParam = 0;
            includeCSPHeader = 1;
            includePayload = 1;
            bitshift = 2;

            enableReedSolomon = 1;
            if enableReedSolomon == 1
                startIndex = (1-includeLengthParam)*8+(1-includeCSPHeader)*32;
                pac = rsdecoder(pac(startIndex:end));
            end

            %% Payload stripping
            output_bits = [];

            if includeLengthParam == 1
                len = pac(1:8);
                output_bits = [output_bits len];
            end

            if includeCSPHeader == 1
                startIndex = includeLengthParam*8+1;
                endIndex = includeLengthParam*8+32;
                cspHeader = pac(startIndex:endIndex);

                priority = cspHeader(1:2);
                source = cspHeader(3:7);
                destination = cspHeader(8:12);
                destPort = cspHeader(13:18);
                sourcePort = cspHeader(19:24);
                reserved = cspHeader(25:28);
                hmac = cspHeader(29);
                xtea = cspHeader(30);
                rdp = cspHeader(31);
                crc = cspHeader(32);

                output_bits = [output_bits cspHeader];
            end

            if includePayload == 1
                startIndex = 8*includeLengthParam+32*includeCSPHeader+1;
                payload = pac(startIndex:end);
                output_bits = [output_bits payload];
            end

            if bitshift > 0
                output_bits = output_bits(bitshift+1:end);
            end

            %packet = packet(33+8+1:end);

            str_output = strcat(binArrToHexStr(output_bits));
            disp(str_output);
            %% Add packet to array
            fprintf(fid_w, strcat(str_output,'\n'));
            extractedData = [extractedData output_bits];

            %% Update dataStream
            synclen = length(syncSeqHex)*4; % 4 bits per number
            len = output('length') * 8;

            newStartIndex = output('sync_index') + synclen + len; % maybe?

            dataStream = dataStream(newStartIndex:end);
        else
            EOF = 1;
        end
    end
    fclose(fid_w);
end