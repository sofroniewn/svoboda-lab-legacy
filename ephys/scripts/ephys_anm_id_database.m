function [base_dir trial_range_start exp_type layer_4] = ephys_anm_id_database(anm_id,laser_on)

layer_4 = [];
switch anm_id
    case '235585'
        if laser_on
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_235585/2014_06_04/run_06'; % laser data
            trial_range_start = 1;
            global exp_type; exp_type = 'classic_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        else
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_235585/2014_06_04/run_03'; %anm #2 for olR and old cl
            trial_range_start = 85;
            layer_4 = 17.6;
            global exp_type; exp_type = 'classic_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        end
    case '237723'
        if laser_on
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_237723/2014_06_17/run_04'; %laser
            trial_range_start = 1;
            global exp_type; exp_type = 'classic_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        else
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_237723/2014_06_17/run_03'; %anm #3 for olR and old cl
            trial_range_start = 40;
            layer_4 = 19.5;
            global exp_type; exp_type = 'classic_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        end
    case '245918'
        if laser_on
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_245918/2014_06_21/run_03'; %laser data
            trial_range_start = 1;
            global exp_type; exp_type = 'classic_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        else
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_245918/2014_06_21/run_02'; %anm #1 for olR and old cl
            trial_range_start = 40;
            layer_4 = 22.6;
            global exp_type; exp_type = 'classic_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        end
    case '249872'
        if laser_on
        else
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_249872/2014_06_27/run_02'; %anm #1 for olR and old cl
            trial_range_start = 10;
            layer_4 = 18.5;
            global exp_type; exp_type = 'classic_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        end
    case '246702'
        if laser_on
        else
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_246702/2014_08_14/run_02'; %anm #1 for olR and old cl
            trial_range_start = 40;
            layer_4 = 21.3;
            global exp_type; exp_type = 'bilateral_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        end
    case '250492'
        if laser_on
           % base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_237723/2014_06_17/run_04'; %laser
           % trial_range_start = 1;
           % global exp_type; exp_type = 'bilateral_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        else
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_250492/2014_08_15/run_02'; %anm #3 for olR and old cl
            trial_range_start = 40;
            layer_4 = 15.3;
            global exp_type; exp_type = 'bilateral_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        end
    case '250494'
        if laser_on
           % base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_237723/2014_06_17/run_04'; %laser
           % trial_range_start = 1;
           % global exp_type; exp_type = 'bilateral_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        else
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_250494/2014_08_21/run_02'; %anm #3 for olR and old cl
            trial_range_start = 650;
            layer_4 = 18.9;
            global exp_type; exp_type = 'ol_cl_different_widths'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        end
    case '250495'
        if laser_on
           % base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_237723/2014_06_17/run_04'; %laser
           % trial_range_start = 1;
           % global exp_type; exp_type = 'bilateral_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        else
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_250495/2014_08_14/run_02'; %anm #3 for olR and old cl
            trial_range_start = 345;
            layer_4 = 17.2;
            global exp_type; exp_type = 'bilateral_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        end
    case '247871'
        if laser_on
           % base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_237723/2014_06_17/run_04'; %laser
           % trial_range_start = 1;
           % global exp_type; exp_type = 'bilateral_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        else
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_247871/2014_08_20/run_02'; %anm #3 for olR and old cl
            trial_range_start = 400;
            layer_4 = 18.3;
            global exp_type; exp_type = 'ol_cl_different_widths'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        end

    case '252776'
        if laser_on
           % base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_237723/2014_06_17/run_04'; %laser
           % trial_range_start = 1;
           % global exp_type; exp_type = 'bilateral_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        else
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_252776/2014_09_02/run_04'; %anm #3 for olR and old cl
            trial_range_start = 40;
            %layer_4 = 20;
            global exp_type; exp_type = 'bilateral_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
            layer_4 = 28.7;
        end









    case '250496'
        base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_250496/2014_09_04/run_03'; %anm #3 for olR and old cl
        trial_range_start = 100;
        global exp_type; exp_type = 'laser_ol'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
                layer_4 = 27.4;
case '256043'
        base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_256043/2014_09_03/run_02'; %anm #3 for olR and old cl
        trial_range_start = 100;
        global exp_type; exp_type = 'laser_ol'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
            layer_4 = 10.4;



    case '247868'
        if laser_on
        else
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_247868/2014_06_26/run_02'; %anm #1 for olR and old cl
            trial_range_start = 40;
            layer_4 = 15.65;
            global exp_type; exp_type = 'classic_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        end


    case '246699'
        if laser_on
        else
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_246699/2014_07_23/run_02'; %anm #1 for olR and old cl
            trial_range_start = 40;
            layer_4 = 15.65;
            global exp_type; exp_type = 'classic_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        end



    case '245914'
        if laser_on
            base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_245914/2014_06_23/run_06'; %laser
            trial_range_start = 1;
            global exp_type; exp_type = 'classic_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl' or 'laser_ol';
        else
        end
       otherwise
        error('Unrecognized animal id')
end


