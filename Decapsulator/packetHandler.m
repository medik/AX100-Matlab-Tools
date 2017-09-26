function response = packetHandler(filename, dataStreamInt, syncSeq, doOutputBits)
    response = [];
    
    dataStream = dec8BitArrToBinArr(dataStreamInt);
    %output = descramble_input(dataStream, [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]);
    %dataStream = output('binary_output');
    
    fid_w = fopen(filename, 'a');
    %packetsFound = containers.Map('KeyType','int32','ValueType','any')
    extractedData = [];
    EOF = 0;
    while EOF ~= 1
        syncIndex = findSync(syncSeq, dataStream);
        if syncIndex ~= -1
            %% Retrieve the length parameter

            possiblePacket = dataStream(syncIndex:end);

            offset = 1;
            lengthParamLocation = length(syncSeq) + offset; % this is the first bit of the length param

            %% Return packet

            % TODO: require that the the packet length is smaller than the array
            % TODO: handle if there aren't a sync in the packet stream

            firstBitIndex = lengthParamLocation;
            packetLength = ...
                hex2dec( ...
                    binArrToHexStr( ...
                        possiblePacket(firstBitIndex:firstBitIndex+8) ...
                    ) ...
                );
            % The length parameter is in bytes

            packetLenBits = 8*packetLength;
            lastBitIndex = lengthParamLocation+packetLenBits;

            pac = possiblePacket(firstBitIndex:lastBitIndex);

            % TODO: What happens if the message is longer than 255 bytes while in RS?
            
            % Do only payload stripping if the length of the packet is at
            % least length param + csp header + reedsolomon,
            % skip also if longer than 255 bytes
            
            if length(pac) > 8+32+255 && length(pac) < 255*8
                %% Reed-Solomon
                % Should we RS the length parameter as well? Maybe, let's assume it
                % first.
                includeLengthParam = 1;
                includeCSPHeader = 1;
                includePayload = 1;
                bitshift = 0;

                enableReedSolomon = 1;
                if enableReedSolomon == 1
                    startIndex = (1-includeLengthParam)*8+(1-includeCSPHeader)*32+1;
                    pac = rsdecoder(pac(startIndex:end));
                end

                %% Payload stripping
                output_bits = [];
                output_str = '';
                output_hex_str = '';

                if includeLengthParam == 1
                    len = pac(1:8);
                    len_hex = binArrToHexStr(len);
                    len_str = binArrToStr(len);

                    output_bits = [output_bits len];
                    output_str = strcat(len_str, ',');
                    output_hex_str = strcat(len_hex, ',');
                end

                if includeCSPHeader == 1
                    startIndex = includeLengthParam*8+1;
                    endIndex = includeLengthParam*8+32;
                    cspHeader = pac(startIndex:endIndex);
                    cspHeader_str = binArrToStr(cspHeader);
                    cspHeader_hex = binArrToHexStr(cspHeader);

                    priority = cspHeader(1:2);
                                
                    source = cspHeader(3:7);
                    sourceDec = binArrToDec(source);
                                
                    destination = cspHeader(8:12);
                    destinationDec = binArrToDec(destination);
                                
                    destPort = cspHeader(13:18);
                    destPortDec = binArrToDec(destPort);
                            
                    sourcePort = cspHeader(19:24);
                    sourcePortDec = binArrToDec(sourcePort);
                                
                    reserved = cspHeader(25:28);
                                
                    hmac = cspHeader(29);
                    xtea = cspHeader(30);
                    rdp = cspHeader(31);
                    crc = cspHeader(32);

                    output_bits = [output_bits cspHeader];
                    output_str = strcat(output_str, cspHeader_str, ',');
                    output_hex_str = strcat(output_hex_str, cspHeader_hex, ',');
                end

                if includePayload == 1
                    startIndex = 8*includeLengthParam+32*includeCSPHeader+1; % remove extra zero
                    payload = pac(startIndex:end);

                    if bitshift > 0
                        payload = payload(bitshift+1:end);
                    end

                    payload_str = binArrToStr(payload);
                    payload_hex = binArrToHexStr(payload);

                    output_bits = [output_bits payload];
                    output_str = strcat(output_str, payload_str);
                    output_hex_str = strcat(output_hex_str, payload_hex);
                end
                
                %% Test implementation of ping response
                
                % Check if the incoming packet has destination port 1 
                if destPortDec == 1
                    pingDestAddr = source;
                    pingSrcAddr = destination;
                    pingDestPort = sourcePort;
                    pingSrcPort = destPort;
                    
                    newPac = [priority pingSrcAddr pingDestAddr pingDestPort pingSrcPort reserved hmac xtea rdp crc];
                    newPac = [newPac payload];
                            
                    disp(binArrToHexStr(newPac));
                    
                    newPac = rsencoder(newPac);
                    newPac = prependLengthParam(newPac);
                    
                    response = [response newPac];
                end

                if (doOutputBits == 1)
                    str_output = output_str;
                else
                    str_output = output_hex_str;
                end

                disp(str_output);
                %% Add packet to array
                fprintf(fid_w, strcat(str_output,'\n'));
                extractedData = [extractedData output_bits];
                
            end
            
            %% Update dataStream
            synclen = length(syncSeq);
            len = packetLength * 8;
            
            newStartIndex = syncIndex + synclen + len; % maybe?
            dataStream = dataStream(newStartIndex:end);
        else
            EOF = 1;
        end
    end
    fclose(fid_w);
 end

    