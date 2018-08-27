global dataset;
dataset = [];

% Dependency configuration
gurobiPath      = '/opt/gurobi800/linux64/matlab';
ffmpegPath      = '/usr/bin/ffmpeg';
dataset.path    = '/vol2/MCT/data'; % local directory to download the dataset

% data set parameters (no need to change below this point)
dataset.cameras = [1 2 5];
dataset.framesFormat = '%d.jpg';
dataset.masksFormat = '%d.png';
dataset.imageWidth = 1920;
dataset.imageHeight = 1080;