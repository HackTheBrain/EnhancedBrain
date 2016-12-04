function [] = invokeStimulus(ind)
pref = 'python stimuli\';


switch ind
    case 1 
        commandStr = 'sound.py stimuli\comic003.mp3';
    case 2
        commandStr = 'background.py';
    case 3
        commandStr = 'sound.py stimuli\comic018.mp3';
    case 4
        commandStr = 'fish.py stimuli\fish.jpg';
    case 5
        commandStr = 'sound.py stimuli\emergency001.mp3';
    case 6
        commandStr = 'blink.py';
    case 7
        commandStr = 'sound.py stimuli\horror015.mp3';
    case 8
        commandStr = 'zoom.py';
    case 9
        commandStr = 'sound.py stimuli\industry005.mp3';
    case 10 
        commandStr = 'zoom.py';
end

[status, commandOut] = system(strcat(pref,commandStr));

end


