# EnhancedBrain

## Who
Eduard Alibekov, Lisa Saifutdinova, Veronika Jirásková, Martina Janíková

## Why
Concentration plays crucial role for many jobs: flight management, technical monitoring, writing a scientific paper.. So, developed method is able to keep the concentration on the same level and helps to do the job as productively as it is possible. Besides the concentration the method could be applied on any measurable conditions like happiness or passion.
## What
The method maintains human at the certain concentration level. It changes the environment using stimuli (it could be background music/disturbing sound/visual stimulation/something else) to achieve maximum concentration. It could be used when a person is working on something and suddenly concentration is falling and the system would be able to stimulate a person to return to the previous concentration level and continue to work productively.

## How


![How it works](https://github.com/HackTheBrain/EnhancedBrain/blob/master/enhanced_brain.jpg)


We used g-tec cap for recording brain activity in frontal lobe (F3). Frontal lobe is responsible for many functions including concentration, which is corresponding to 12-18 Hz frequency band. We obtained the data from the device using openVibe and via tcp sent the data in Matlab. Than using standard functions we’ve calculated relative spectra in 12-18 Hz. Thus we use online model-free reinforcement learning in order to the optimal behaviour. The short description of the algorithm is placed into Appendix.

Then we take a task requiring concentration like solving arithmetical problems. During that task concentration level is measured and the method applies stimuli to keep this level stable. At the first steps it applies everything since it doesn’t know how it influences the system. To verify the functioning of our programme, we also measure time required for solving one arithmetical problem. The hypothesis is that without the stimuli the time needed for solving one arithmetical problem is longer then with the stimuli. 

During the programme preparation we make a ten minutes trial where we record the EEG signal on some volunteers during a concentration demanding task - solving arithmetical problems, which provide beta waves and so learn our programme the algorithm to work well. We divide the one trial session into two 5min long parts – one without the stimuli and the other with the stimuli. We control the trial, due to process of learning and tiredness, by doing the stimuli once in the first part of the session and once with another user in the second part.

We use visual and audio stimuli like blinking, changing background color, playing annoying sounds and showing disturbing images for few seconds. Stimuli can be altered for more sophisticated graphics and sounds depending on what kind of task the person would be working on. More aesthetically appealing images of plants or abstract geometric shapes in certain arrangement could be used to enhance creative thinking. Stimuli were programmed in python, codes are available.

![Appendix](https://github.com/HackTheBrain/EnhancedBrain/blob/master/appendix.pdf)

## Ethical considerations
At first our project brings beneficence when we benefit BCI as a tool which can help people. Already according to the name of the project it is clear that there is enhancement engaged, which serves to increase concentration and then provides better efficacy in solving concentration demanding task. In this field it is important to warn all of the users of the programme that the used stimuli may not be harmless for people with epilepsy. The protection has been made by slower frequency of the stimuli. Next, our project is respectful regarded to the programme user – it depends on his or her motivation to use the programme and it respects the privacy when there are just on-line data collecting without any storage of pure EEG signal or concentration level. There are also issues of responsibility and equity on both creators and users of the programme. The creator is obliged to make the programme without any intention to harm and provide the information open to the public. On the other hand creators are not responsible for users’ misuse of the programme to different profit than it is designed for. 