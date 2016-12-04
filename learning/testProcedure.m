global maximalExecutionTime useStimuli randNum


randNum = randi(2^32);




!run.bat
maximalExecutionTime = 60*5; useStimuli = true;
plotOnline;
!taskkill /IM python.exe


maximalExecutionTime = 60*5; useStimuli = false; !run.bat
plotOnline;
!taskkill /IM python.exe
