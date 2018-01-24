function ret = descramble_input(binaryInput, initial)
    ret = containers.Map;
    
    binary_output = [];
    state_vec = initial;
    for i = 1:length(binaryInput)
        % obs! the order?? What is the first input? 
        ns = nextState(binaryInput(i), state_vec);
        binary_output = [binary_output ns];
        
        % shift 
        state_vec = [binaryInput(i) state_vec(1:end-1)];
    end
    
    ret('state_vec') = state_vec;
    ret('binary_output') = binary_output;
    
end

function n = nextState(input, state_vec)
    t = mod(input + state_vec(12), 2);
    n = mod(t + state_vec(17), 2);
end