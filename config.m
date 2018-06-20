global dataset;
dataset = [];

% Dependency configuration
gurobiPath      = 'D:\utilities\gurobi\win64\matlab';
ffmpegPath      = 'D:\utilities\ffmpeg\bin\ffmpeg.exe';
dataset.path    = 'D:\lab\MCMT\final\MCT\Data\'; % local directory to download the dataset

% data set parameters (no need to change below this point)
dataset.cameras = [1 2 5];
dataset.framesFormat = '%d.jpg';
dataset.masksFormat = '%d.png';
dataset.imageWidth = 1920;
dataset.imageHeight = 1080;