function [base_dir anm_params] = ephys_anm_id_database(anm_id,laser_on)

layer_4 = [];
boundaries = [];
boundary_labels = {'Pia', 'L1', 'L2/3', 'L4', 'L5A', 'L5B', 'L6'};
switch anm_id
    case '235585'
        if laser_on
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_235585/2014_06_04/run_06'; % laser data
            trial_range_start = 1;
            exp_type = 'classic_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        else
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_235585/2014_06_04/run_03'; %anm #2 for olR and old cl
            trial_range_start = 85;
            trial_range_end = Inf;
            cell_reject = [];
            layer_4 = 17.6;
            layer_4_corr = 19.8;
            AP = 2.0;
            ML = 3.525;
            barrel_loc = 'C1';
            run_thresh = 5;
            boundaries = [NaN NaN -78 75  230 380 520];
            exp_type = 'classic_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        end
    case '237723'
        if laser_on
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_237723/2014_06_17/run_04'; %laser
            trial_range_start = 1;
            global exp_type; exp_type = 'classic_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        else
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_237723/2014_06_17/run_03'; %anm #3 for olR and old cl
            trial_range_start = 70;
            trial_range_end = Inf;
            cell_reject = [27,28];
            layer_4 = 19.5;
            layer_4_corr = 20.3;
            AP = 1.91;
            ML = 3.6;
            barrel_loc = 'C2';
            run_thresh = 5;
            boundaries = [NaN NaN -95 85  240 425 650];
            exp_type = 'classic_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        end
    case '245918'
        if laser_on
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_245918/2014_06_21/run_03'; %laser data
            trial_range_start = 1;
            exp_type = 'classic_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        else
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_245918/2014_06_21/run_02'; %anm #1 for olR and old cl
            trial_range_start = 30;
            trial_range_end = 440;
            cell_reject = [9];
            run_thresh = 5;
            layer_4 = 22.6;
            layer_4_corr = 22.3;
            AP = 1.84;
            ML = 3.54;
            barrel_loc = 'D1';
            boundaries = [-460  -320    -85 95  230 375 600];
            exp_type = 'classic_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        end
    case '249872'
        if laser_on
        else
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_249872/2014_06_27/run_02'; %anm #1 for olR and old cl
            trial_range_start = 30;
            trial_range_end = Inf;
            cell_reject = [];
            run_thresh = 1;
            layer_4 = 18.5;
            layer_4_corr = 19.8;
            AP = 1.67;
            ML = 3.65;
            barrel_loc = 'C3';
            boundaries = [-670  -410    -80 80  250 440 680];
            exp_type = 'classic_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        end
    case '246702'
        if laser_on
        else
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_246702/2014_08_14/run_02'; %anm #1 for olR and old cl
            trial_range_start = 20;
            trial_range_end = Inf;
            cell_reject = [4 14];
            run_thresh = 5; 
            layer_4 = 21.3;
            layer_4_corr = 23.0;
            AP = 1.64;
            ML = 3.34;
            barrel_loc = 'D2';
            boundaries = [NaN NaN -95 100 280 420 650];
            exp_type = 'bilateral_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        end
    case '250492'
        if laser_on
           % base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_237723/2014_06_17/run_04'; %laser
           % trial_range_start = 1;
           % global exp_type; exp_type = 'bilateral_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        else
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_250492/2014_08_15/run_02'; %anm #3 for olR and old cl
            trial_range_start = 20;
            trial_range_end = Inf;
            cell_reject = [4 33 37];
            run_thresh = 3; 
            layer_4 = 15.3;
            layer_4_corr = 16.4;
            AP = 2.06;
            ML = 3.63;
            barrel_loc = 'C1';
            boundaries = [NaN  -390 -100 100 230 470 540];
            exp_type = 'bilateral_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        end
    case '250494'
        if laser_on
           % base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_237723/2014_06_17/run_04'; %laser
           % trial_range_start = 1;
           % global exp_type; exp_type = 'bilateral_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        else
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_250494/2014_08_21/run_02'; %anm #3 for olR and old cl
            trial_range_start = 700;
            trial_range_end = Inf;
            cell_reject = [];
            run_thresh = 5; 
            layer_4 = 18.9;
            layer_4_corr = 20.2;
            AP = 2.27;
            ML = 3.6;
            barrel_loc = 'B1';
            boundaries = [NaN NaN -75 75  200 395 600];
            exp_type = 'ol_cl_different_widths'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        end
    case '250495'
        if laser_on
           % base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_237723/2014_06_17/run_04'; %laser
           % trial_range_start = 1;
           % global exp_type; exp_type = 'bilateral_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        else
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_250495/2014_08_14/run_02'; %anm #3 for olR and old cl
            trial_range_start = 100;
            trial_range_end = Inf;
            cell_reject = [];
            run_thresh = 3; 
            layer_4 = 17.2;
            layer_4_corr = 19.5;
            AP = 1.61;
            ML = 3.78;
            barrel_loc = 'C4';
            boundaries = [-520 -400    -120    120 310 520 860];
            exp_type = 'bilateral_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        end
    case '247871'
        if laser_on
           % base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_237723/2014_06_17/run_04'; %laser
           % trial_range_start = 1;
           % global exp_type; exp_type = 'bilateral_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        else
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_247871/2014_08_20/run_02'; %anm #3 for olR and old cl
            trial_range_start = 400;
            trial_range_end = 770;
            cell_reject = [];
            run_thresh = 3; 
            layer_4 = 18.3;
            layer_4_corr = 19.0;
            AP = 1.93;
            ML = 3.47;
            barrel_loc = 'C2'; % could be C1
            boundaries = [-500  -325    -90 100 300 450 750];
            exp_type = 'ol_cl_different_widths'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        end



    case '250496'
        base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_250496/2014_09_04/run_03'; %anm #3 for olR and old cl
            trial_range_start = 400;
            trial_range_end = Inf;
            cell_reject = [];
            run_thresh = 5; 
            exp_type = 'laser_ol'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
            layer_4 = 12.4;
            layer_4_corr = 13.0;
            AP = 2.6;
            ML = 3.33;
            barrel_loc = 'V1';
            boundaries = [NaN NaN      -80 80  220 350 500];
case '256043'
        base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_256043/2014_09_03/run_02'; %anm #3 for olR and old cl
            trial_range_start = 100;
            trial_range_end = 1800;
            cell_reject = [];
            run_thresh = 5; 
            exp_type = 'laser_ol'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
            layer_4 = 10.4;
            layer_4_corr = 12.0;
            AP = 1.84;
            ML = 3.62;
            barrel_loc = 'C2';
            boundaries = [-500  -350    -95 100 270 500 750];

    case '252776'
        if laser_on
           % base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_237723/2014_06_17/run_04'; %laser
           % trial_range_start = 1;
           % global exp_type; exp_type = 'bilateral_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        else
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_252776/2014_09_02/run_04'; %anm #3 for olR and old cl
            trial_range_start = 200;
            trial_range_end = 1200;
            cell_reject = [];
            run_thresh = 3; 
                        %layer_4 = 20;
            exp_type = 'bilateral_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
            layer_4 = 15.7;
            layer_4_corr = 21.5;
            AP = 1.97;
            ML = 3.6;
            barrel_loc = 'C2';
            boundaries = [-550 -395    -130    70  220 425 670];
       end



    case '247868'
        if laser_on
        else
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_247868/2014_06_26/run_02'; %anm #1 for olR and old cl
            trial_range_start = 40;
            layer_4 = 15.65;
             boundaries = [-500 -380    -75 75  230 360 605];
           exp_type = 'classic_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        end


    case '246699'
        if laser_on
        else
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_246699/2014_07_23/run_02'; %anm #1 for olR and old cl
            trial_range_start = 40;
            layer_4 = 15.65;
            boundaries = [NaN NaN NaN NaN NaN NaN NaN];
            exp_type = 'classic_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        end



    case '245914'
        if laser_on
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_245914/2014_06_23/run_06'; %laser
            trial_range_start = 1;
            exp_type = 'classic_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        else
        end

    case '252778'
        if laser_on
        else
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_252778/2014_12_11/run_02'; %anm #1 for olR and old cl
            trial_range_start = 1;
            trial_range_end = 4000;
            cell_reject = [];
            run_thresh = 5; 
            exp_type = 'laser_ol_new'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
            layer_4 = 11.1;
            layer_4_corr = 11.1;
            AP = 1.97;
            ML = 3.6;
            barrel_loc = 'C2';
            boundaries = [-550 -395    -130    70  220 425 670];
        end

    case '266642'
        if laser_on
        else
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_266642/2014_12_16/run_02'; %anm #1 for olR and old cl
            trial_range_start = 1;
            trial_range_end = 4000;
            cell_reject = [];
            run_thresh = 5; 
            exp_type = 'laser_ol_new'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
            layer_4 = 5.4;
            layer_4_corr = 5.4;
            AP = 1.97;
            ML = 3.6;
            barrel_loc = 'C2';
            boundaries = [-550 -395    -130    70  220 425 670];
        end

    case '266644'
        if laser_on
        else
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_266644/2014_12_17/run_02'; %anm #1 for olR and old cl
            trial_range_start = 1;
            trial_range_end = 4000;
            cell_reject = [];
            run_thresh = 5; 
            exp_type = 'laser_ol_new'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
            layer_4 = 6.4;
            layer_4_corr = 6.4;
            AP = 1.97;
            ML = 3.6;
            barrel_loc = 'C2';
            boundaries = [-550 -395    -130    70  220 425 670];
        end

    case '270330'
        if laser_on
        else
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_270330/2014_12_18/run_02'; %anm #1 for olR and old cl
            trial_range_start = 1;
            trial_range_end = 4000;
            cell_reject = [];
            run_thresh = 5; 
            exp_type = 'laser_ol_new'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
            layer_4 = 21.4;
            layer_4_corr = 21.4;
            AP = 1.97;
            ML = 3.6;
            barrel_loc = 'C2';
            boundaries = [-550 -395    -130    70  220 425 670];
        end

    case '270329'
        if laser_on
        else
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_270329/2014_12_18/run_02'; %anm #1 for olR and old cl
            trial_range_start = 1;
            trial_range_end = 4000;
            cell_reject = [];
            run_thresh = 5; 
            exp_type = 'laser_ol_new'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
            layer_4 = 23.4;
            layer_4_corr = 23.4;
            AP = 1.97;
            ML = 3.6;
            barrel_loc = 'C2';
            boundaries = [-550 -395    -130    70  220 425 670];
        end

    case '270331'
        if laser_on
        else
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_270331/2014_12_17/run_02'; %anm #1 for olR and old cl
            trial_range_start = 1;
            trial_range_end = 4000;
            cell_reject = [];
            run_thresh = 5; 
            exp_type = 'laser_ol_new'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
            layer_4 = 10.0;
            layer_4_corr = 10.0;
            AP = 1.97;
            ML = 3.6;
            barrel_loc = 'C2';
            boundaries = [-550 -395    -130    70  220 425 670];
        end
        
       otherwise
        error('Unrecognized animal id')
end

trial_range_start = repmat(trial_range_start(1),50,1);
trial_range_end = repmat(trial_range_end(1),50,1);


anm_params.run_thresh = run_thresh;
anm_params.trial_range_start = trial_range_start;
anm_params.trial_range_end = trial_range_end;
anm_params.cell_reject = cell_reject;
anm_params.exp_type = exp_type;
anm_params.layer_4 = layer_4;
anm_params.boundaries = boundaries;
anm_params.boundary_labels = boundary_labels;
anm_params.layer_4_corr = layer_4_corr;
anm_params.AP = AP;
anm_params.ML = ML;
anm_params.barrel_loc = barrel_loc;
