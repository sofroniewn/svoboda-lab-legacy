classdef trial_config_class < handle
    % Trial configuration class
    properties
        dat; % data in table
        column_names; % column names from table
        laser_calibration;
        random_order; % column names from table
        repeating_order; % column names from table
        repeating_numbers; % column names from table
        plot_options; % column names from table
        processed_dat; % column names from table
        file_name; % column names from table
        version; % column names from table
    end
    
    methods
        % Constructor
        function obj = trial_config_class
            obj.dat = [];
            obj.column_names = [];
            obj.random_order = [];
            obj.repeating_order = [];
            obj.repeating_numbers = [];
            obj.plot_options.dat = cell(1,1);
            obj.plot_options.names = 'DEFAULT';
            obj.processed_dat = [];
            obj.file_name = [];
            obj.version = 3.0; % column names from table
        end
    end
    
end

