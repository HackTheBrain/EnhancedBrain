function [floatsArray] = streamToDouble(byteArray)
    fA = zeros(1,10000);

    counter = 0;
    for i=1:8:length(byteArray)-8
        seq = byteArray(i:i+7);
        bA = uint8(seq);
        f = typecast(bA,'double');
        counter = counter+1;
        fA(counter) = f;
    end

    floatsArray = fA(1:counter);
end
