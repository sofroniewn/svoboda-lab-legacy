

stim_type_name_1 = 'speed2D';
stim_type_name_2 = 'corPos2D';
keep_type_name = 'base';
trial_range = [0 Inf];


roi_id = 21;
tuning_curve = generate_tuning_curve_2D(roi_id,stim_type_name_1,stim_type_name_2,keep_type_name,trial_range)

fig_id = 32;
col_mat = [0 0 0];
plot_tuning_curves_2D(5,tuning_curve)


	tuning_curve{ij} = generate_tuning_curve(roi_id,stim_type_name,keep_type_name,trial_range);


y = [0 .1 .15 .2 .25 .3 .33 .36 .38 .395 .405 .41 .412 .412];
x = [1:length(y)];
figure(34)
clf(34)
hold on
plot(x,y)
out = fitSigmoid(x,y,[]);
prs = out.estPrs;
predic = fitSigmoid_modelFun(x,prs);
plot(x,predic,'r')

y = [0 .1 .15 .2 .25 .3 .33 .36 .38 .395 .405 .41 .412 .412];
x = [1:length(y)];
z = rand(length(y)) + 3*x.*y;

out = fitGS2D(x,y,z,[])
