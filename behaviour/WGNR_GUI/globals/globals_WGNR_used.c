/* Whisker Guided Navigation Rig
 *
 * NJS JFRC 10/10/13 
 * NJS JFRC 01/26/14 revision */

/******************************************/
/* TRIAL PARAMETERS SET FROM MATLAB */
const unsigned trial_num_types = 2; /* Number of trial types */
const unsigned trial_num_turns = 6; /* Max number of trial turns */
const unsigned trial_num_gain = 1; /* Max number of trial gain changes */
const unsigned trial_num_open_loop = 2; /* Max number of trial corridor open loop changes */
const unsigned trial_num_cor_widths = 2; /* Max number of trial corridor width changes */
const unsigned trial_num_water_drops = 1; /* Max number of water drops per trial */
const unsigned trial_random_order = 0; /* 1 if in random order, 0 if in sequence */
const unsigned trial_num_sequence_length = 2; /* 0 if random, otherwise length of sequence */
const unsigned trial_num_sequence[2] = {1, 2}; /* 1 if random, sequence */
const unsigned trial_num_repeats[2] = {20, 20}; /* 1 if random, num repeats */

const unsigned laser_calibration_mode = 0;

const unsigned trial_type[2] = {1, 1}; /* Trial type, 1 for distance, 0 for time */
const double trial_duration[2] = {160, 160}; /* Trial duration, (cm) for distance, (s) for time */
const double trial_timeout[2] = {30, 30}; /* Trial timeout (s) */
const double trial_iti[2] = {0.2, 0.2}; /* Intertrial interval (s) */
const unsigned trial_left_wall[2] = {1, 1}; /* 1 if left wall on, 0 if left wall off */
const unsigned trial_right_wall[2] = {1, 1}; /* 1 if right wall on, 0 if right wall off */
const unsigned trial_cor_reset[2] = {1, 1}; /* 1 for reset walls at beginning of trial, 0 otherwise */
const double trial_ol_positions[2][2] = {{0, 1}, {0, 1}}; /* Change positions in corridor width */
const double trial_ol_values[2][2] = {{10, 10}, {10, 10}}; /* Corridor width (mm) */
const double trial_cor_width_positions[2][2] = {{0, 1}, {0, 1}}; /* Change positions in corridor width */
const double trial_cor_width[2][2] = {{10, 10}, {10, 10}}; /* Corridor width (mm) */
const double trial_turn_positions[2][7] = {{0, .125, .25, .375, .5, 1, 1}, {0, .375, .5, .625, .75, .875, 1}}; /* Turn positions within trial */
const double trial_turn_values[2][6] = {{ -10, +10, -10, +10, 0, 0}, {+10, 0, +10, 0, +10, 0}}; /* Turn angles if closed loop, wall positions if open loop */
const double trial_gain_positions[2][2] = {{0, 1}, {0, 1}}; /* Gain changes within trial */
const double trial_gain_values[2][1] = {{1}, {1}}; /* Gain values within trial */
const double trial_test_period[2][2] = {{.25, .75}, {.25, .75}}; /* Trial test period */
const unsigned trial_water_enabled[2] = {1, 1}; /* Water enabled on trial */
const double trial_water_pos[2][1] = {{0.95}, {0.95}}; /* Trial water period */
const double trial_water_range_min[2][1] = {{2}, {2}}; /* Trial corridor range for water */
const double trial_water_range_max[2][1] = {{8}, {8}}; /* Trial corridor range for water */
const unsigned trial_water_range_type[2] = {0, 0}; /* If 0 then range of wall distance (mm), if 1 then range of fraction of corridor with, if 2 then range of lateral run position */
const double trial_water_drop_size[2][1] = {{100}, {100}}; /* Trial corridor range for water */

const unsigned trial_masking_flash[2] = {0, 0}; /* 0 if off, 1 if blue, 2 if yellow */
const double trial_mf_period[2][2] = {{0, .75}, {0, .75}}; /* Trial masking flash period */
const unsigned trial_mf_pulse_dur[2] = {1, 1}; /* Trial masking flash pulse duration, if 0 then off ,1 = 2ms, 2 = 4ms etc */
const unsigned trial_mf_pulse_iti[2] = {0, 0}; /* Trial masking flash iti, if 0 then continuous pulses,1 = 2ms, 2 = 4ms etc */

const unsigned trial_photostim[2] = {0, 0}; /* 0 if off, 1 if blue, 2 if yellow */
const double trial_ps_period[2][2] = {{.25, .75}, {.25, .75}}; /* Trial ps period */
const unsigned trial_ps_pulse_dur[2] = {1, 1}; /* Trial ps pulse duration, if 0 then off pulses,1 = 2ms, 2 = 4ms etc */
const unsigned trial_ps_pulse_iti[2] = {0, 0}; /* Trial ps iti, if 0 then continuous pulses,1 = 2ms, 2 = 4ms etc */
const unsigned trial_ps_num_sites[2] = {1, 1}; /* Trial ps number of siter */
const double trial_ps_peak_power[2] = {0.1, 0.1}; /* Peak laser power */
const unsigned trial_ps_stop_threshold[2] = {1, 1}; /* 1 if stop photostimulation when mouse stopped */
const unsigned trial_ps_closed_loop[2] = {0, 0}; /* 1 if closed loop to corridor position */
const double trial_ps_x_pos[2][1] = {{3.6}, {3.6}}; /* Trial ps site */
const double trial_ps_y_pos[2][1] = {{-1.3}, {-1.3}}; /* Trial ps site */

/******************************************/
/* DEFINE EXTERNAL AND INTERNAL FUNCTIONS */
extern double readAI(unsigned chan);
extern int writeAO(unsigned chan, double voltage);
extern int writeDIO(unsigned chan, unsigned bitval);
extern void logValue(const char *varname, double val);
extern double round(double);
extern double floor(double);
extern double rand(void);
extern double log(double);
extern double sin(double);
extern double cos(double);
extern double powi(double d, int i);

/* INTERNAL FUNCTIONS */
void tick_func(void);
void init_func(void);
void cleanupfunc(void);

/* ENTRY FUNCTIONS*/
void default_state(void);
void give_water(void);
void raise_dist_thresh(void);
void lower_dist_thresh(void);
void stop_state(void);


/******************************************/
/* DEFINE DIGITAL / ANALOG INPUT AND OUTPUT CHANNELS */
/* Analog input channels */
const unsigned ball_tracker_clock_ai_chan = 0; /* Clock signal from ball tracker */
const unsigned cam_ai_chan[4] = {1, 2, 3, 4}; /* AI channels from camerea, x0, y0, x1, y1 */
const unsigned scan_image_frame_clock_chan = 5; /* Frame clock from scan image */
const unsigned lick_in_chan = 6; /* Lick signal*/
const unsigned scim_logging_chan = 7; /* Lick signal*/

/* Analog output channels */
const unsigned laser_power_ao_chan = 0; /* laser power */
const unsigned synch_ao_chan = 8; /* synch channel at 500 Hz */
const unsigned iti_ao_chan = 1; /* AO intertrial trig  */
const unsigned l_wall_lat_ao_chan = 2; /* left wall lateral position */
const unsigned l_wall_for_ao_chan = 3; /* left wall forward position */
const unsigned r_wall_lat_ao_chan = 4; /* right wall lateral position */
const unsigned r_wall_for_ao_chan = 5; /* right wall lateral position */
const unsigned x_mirror_ao_chan = 6; /* x galvo mirror */
const unsigned y_mirror_ao_chan = 7; /* y galvo mirror */

/* Analog output channel offsets */
const double laser_power_ao_offset = -0.115;
const double synch_ao_offset = 0;
const double iti_ao_offset = -0.113;
const double l_wall_lat_ao_offset = -0.118;
const double l_wall_for_ao_offset = -0.12;
const double r_wall_lat_ao_offset = -0.121;
const double r_wall_for_ao_offset = -0.12;
const double x_mirror_ao_offset = -0.115;
const double y_mirror_ao_offset = -0.115;

/* Digital output channels */
const unsigned water_valve_trig = 0; /* Water valve trigger */
const unsigned trial_iti_trig = 1;
const unsigned wv_trig = 2;
const unsigned bv_trig = 3;
const unsigned sound_trig = 4;
const unsigned synch_pulse = 5;
const unsigned sound_trig_2 = 7;
const unsigned trial_on_trig = 6;
const unsigned trial_ephys_trig = 11;
const unsigned trial_test_trig = 8;
const unsigned mf_dio_yellow = 9;
const unsigned mf_dio_blue = 10;


/***************************************/
/***************************************/
/* DEFINE CONSTANTS */
/* Convert to steps params */
const double zero_V[4] =  {2.59, 2.61, 2.60, 2.61};
const double step_V =  0.154;
const double A_calib[3][4] =  {{-0.0665, -3.8941, 0.0835, 0.0428}, {0.0566, 0.0558, 0.1107, 4.0800}, {-2.0361, 0, -2.2392, 0}};

const double sample_freq =  500;
const unsigned ai_threshold =  3; /* Threshold ai signal needs to pass to be considered high */
const double run_speed_thresh =  5;
const unsigned speed_time_length =  250;
const double wall_ball_gain =  -0.2;

const double max_wall_pos =  40;
const double max_cor_width =  99;
const double l_for_pos_default =  20;
const double r_for_pos_default =  20;

const unsigned bv_period =  5; /* behavioural video frame period / 2 in ms */
const unsigned wv_period =  1; /* whisker video frame period / 2 in ms */

const double valve_open_time_default =  50; /* Time water valve open for at 500 Hz */

const double max_galvo_pos =  5;

const unsigned ao_trial_trig_on =  1;

double dist_thresh =  200;

/***************************************/
/***************************************/
/* DEFINE VARIABLES */
/* Define tick counter */
unsigned stop_run = 0;

/* Define Ball Motion Variables */
double  cam_vel_ai_vlt[4]; /* Raw voltage signal from camerea, x0, y0, x1, y1 */
double ball_tracker_clock_ai_vlt; /* Voltage of clock signal from ball tracker - goes high every 2ms and stays high for 200us */
unsigned ball_tracker_clock_low_flag = 0; /* Flag to indicate that the clock signal has gone back to low */
unsigned second_ai_read = 0;
double  cam_vel_steps[4]; /* Steps from camerea, x0, y0, x1, y1 */
double for_ball_motion;
double lat_ball_motion;
unsigned cur_speed_ind = 0;
unsigned jj = 0;
unsigned ii = 0;
double for_vel_history[250]; /* Forward speed for the past 500ms */
double lat_vel_history[250]; /* Forward speed for the past 500ms */
double mean_for_vel;
double mean_lat_vel;
unsigned running_ind;

unsigned led_pulse_on = 0;

/* Define licking variables */
double lick_in_vlt;
unsigned lick_state;
double valve_open_time = 0; /* Time water valve open for at 500 Hz */

/* Define trial variables */
double inter_trial_time = 0;
unsigned inter_trial_trig = 0;
double frac_trial = 1.1;
double frac_trial_prev = 1.09;
double cur_trial_dist = 0;
double cur_trial_time = 0;
double cur_trial_lat = 0;
unsigned cur_trial_num = 0;
unsigned test_val;
unsigned test_val_exit;
unsigned water_period;
unsigned mf_val;
unsigned mf_val_exit;
unsigned ps_val;
unsigned ps_val_exit;
unsigned turn_period;
unsigned cor_period;
unsigned gain_period;
unsigned ol_period;
double gain_val;
double turn_val;
unsigned wv_time;
unsigned bv_time;
unsigned cur_trial_block = 0;
unsigned cur_trial_repeat = 0;

/* Define Wall Motion Variables */
double l_lat_pos_target;
double r_lat_pos_target;
double r_for_pos;
double l_for_pos;
double r_lat_pos;
double l_lat_pos;
double r_for_vlt;
double l_for_vlt;
double r_lat_vlt;
double l_lat_vlt;
double cor_pos;
double cor_width;
double cor_width_offset;
double cor_width_start;
double cor_width_stop;
double cor_pos_target_start;
double cor_pos_target_stop;
double cor_width_update;
double cor_pos_update;

unsigned water_on = 0;
unsigned water_on_ext = 0;
unsigned valve_time = 0;
unsigned valve_time_ext = 0;
unsigned ext_valve_trig = 0;
double water_dist = 0;
double water_pos_val;

unsigned masking_flash_on = 0;

unsigned scim_logging = 0; /* Define Scan Image Frame Clock Params */
unsigned scim_state = 1; /* Define Scan Image Frame Clock Params */
double scim_ai_vlt; /* Define Scan Image Frame Clock Params */
double scim_logging_ai_vlt; /* Define Scan Image Frame Clock Params */

/* logging variables */
unsigned log_cur_state;
unsigned log_state_a;
unsigned log_state_b;
unsigned log_state_c;
double log_ball_motion;
double log_cor_pos;
unsigned log_photo_stim;

/* Masking flash & Photostimulation variables */
unsigned tick_period = 0;
unsigned mf_period_counter = 0;
unsigned ps_period_counter = 0;
unsigned ps_spots_counter = 0;
unsigned laser_shutter = 0;
double x_mirror_pos = 0;
double y_mirror_pos = 0;
double laser_power = 0;
double laser_power_vlt;
double x_mirror_pos_vlt;
double y_mirror_pos_vlt;
unsigned cur_site_ind = 0;
/*************************************************************************/
/*************************************************************************/
/*************************************************************************/

/* Mirror calibration function*/
double galvo_x_mm_to_vlt(double x) {
    if (x > 0) {
        return x/1.15;
    } else {
        return x/1.00;
    }
}

double galvo_y_mm_to_vlt(double x) {
    return -x/1.5;
}

/* Blue laser Calibration Function*/
double blue_laser_mW_to_vlt(double x) {
    double out_vlt;
    out_vlt = x;
    
    if (out_vlt > 5){
        out_vlt = 5;
    }
    if (out_vlt < 0){
        out_vlt = 0;
    }
    
    return out_vlt;
}

/* Yellow laser calibration Function*/
double yellow_laser_mW_to_vlt(double x) {
    double out_vlt;
    out_vlt = x;
    
    if (out_vlt > 5){
        out_vlt = 5;
    }
    if (out_vlt < 0){
        out_vlt = 0;
    }
    
    return out_vlt;
}

/***********************************/
/* Wall Calibration Function*/
double wall_mm_to_vlt(double x) {
    if (x<0) {
        x = 0;
    }
    if (x>40) {
        x = 40;
    }
    return (x-20)/2.22;
}

/***********************************/
/* DEFINE ENTRY FUNCS */
void default_state(void) {
}

void give_water(void) {
    ext_valve_trig = 1;
}

void raise_dist_thresh(void) {
    dist_thresh = dist_thresh + 20;
}

void lower_dist_thresh(void) {
    dist_thresh = dist_thresh - 20;
}

void stop_state(void) {
    stop_run = 1;
}


/****************************************/
/* TICK FUNCTION GETS CALLED EVERY TICK - i.e. at 6kHz*/
void tick_func(void) {
    /* Check if run is stopping */
    if (stop_run == 0){
        /* Monitor scim ai vlt - if voltage is low set scim_state low */
        scim_ai_vlt = readAI(scan_image_frame_clock_chan);
        if (scim_ai_vlt <= ai_threshold) {
            scim_state = 0;
        }
        
        /* Read ball tracker ai vlt */
        ball_tracker_clock_ai_vlt = readAI(ball_tracker_clock_ai_chan);
        
        /* If second read - i.e. at 500Hz */
        if (second_ai_read == 1) {
            second_ai_read = 0;
            /* Check if ball clock low*/
            if (ball_tracker_clock_ai_vlt < ai_threshold) {
                ball_tracker_clock_low_flag = 1;
            }
            
            /* Generate camera displacement vector */
            /* average current AI read with AI read from last tick */
            for (ii = 0; ii < 4; ii++) {
                cam_vel_ai_vlt[ii] = (cam_vel_ai_vlt[ii] + readAI(cam_ai_chan[ii]))/2;
                /* convert to steps */
                cam_vel_steps[ii] = round((cam_vel_ai_vlt[ii] - zero_V[ii])/step_V);
            }
            /* calculate forward and lateral motion */
            for_ball_motion = 0;
            lat_ball_motion = 0;
            for (ii = 0; ii < 4; ii++) {
                for_ball_motion = for_ball_motion + A_calib[0][ii]*cam_vel_steps[ii];
                lat_ball_motion = lat_ball_motion + A_calib[1][ii]*cam_vel_steps[ii];
            }
            
            /* Calculate mean forward and lateral velocity */
            if (cur_speed_ind == speed_time_length) {
                cur_speed_ind = 0;
            }
            for_vel_history[cur_speed_ind] = for_ball_motion;
            lat_vel_history[cur_speed_ind] = lat_ball_motion;
            cur_speed_ind++;
            mean_for_vel = 0;
            mean_lat_vel = 0;
            for (jj = 0; jj < speed_time_length; jj++) {
                mean_for_vel = mean_for_vel + for_vel_history[jj];
                mean_lat_vel = mean_lat_vel + lat_vel_history[jj];
            }
            mean_for_vel = mean_for_vel/speed_time_length;
            mean_lat_vel = mean_lat_vel/speed_time_length;
            
            /* Check if running or not */
            if (mean_for_vel > run_speed_thresh) {
                running_ind = 1;
            } else {
                running_ind = 0;
            }
            
            /* Check if licked */
            lick_in_vlt = readAI(lick_in_chan);
            if (lick_in_vlt > 1) {
                lick_state = 1;
            } else {
                lick_state = 0;
            }
            
            /* Check if trial has ended, and if so make a new one */
            if (frac_trial >= 1 || cur_trial_time >= trial_timeout[cur_trial_num]) {
                /* Pick new trial number */
                if (trial_random_order == 1) {
                    cur_trial_num = (unsigned int) (trial_num_types)*rand();
                } else {
                    cur_trial_num = trial_num_sequence[cur_trial_block]-1;
                    cur_trial_repeat++;
                    if (cur_trial_repeat >= trial_num_repeats[cur_trial_block]){
                        cur_trial_block++;
                        cur_trial_repeat = 0;
                    }
                    if (cur_trial_block >= trial_num_sequence_length) {
                        cur_trial_block = 0;
                    }
                }
                /* Determine target left and right starting wall positions */
                if (trial_cor_reset[cur_trial_num] == 1) {
                    cor_pos = trial_ol_values[cur_trial_num][0];
                }
                cor_width = trial_cor_width[cur_trial_num][0];
                l_lat_pos_target = cor_width - cor_pos;
                r_lat_pos_target = cor_pos;
                
                if (trial_left_wall[cur_trial_num] == 0){
                    l_lat_pos_target = max_wall_pos;
                }
                if (trial_right_wall[cur_trial_num] == 0){
                    r_lat_pos_target = max_wall_pos;
                }
                
                inter_trial_time = 0;
                test_val = 0;
                test_val_exit = 0;
                mf_val = 0;
                mf_val_exit = 0;
                ps_val = 0;
                ps_val_exit = 0;
                turn_period = 0;
                gain_period = 0;
                ol_period = 0;
                water_period = 0;
                cur_trial_time = 0;
                cur_trial_dist = 0;
                cur_trial_lat = 0;
                frac_trial = 0;
                frac_trial_prev = 0;
                wv_time = 0;
                bv_time = 0;
                mf_period_counter = 0;
                ps_period_counter = 0;
                ps_spots_counter = 0;
            }
            
            /* Check if in iti */
            if (inter_trial_time <= trial_iti[cur_trial_num]) {
                inter_trial_trig = 1;
                inter_trial_time = inter_trial_time + 1/sample_freq;
                /* send left and right walls to target positions */
                l_lat_pos = l_lat_pos + .03*(l_lat_pos_target - l_lat_pos);
                r_lat_pos = r_lat_pos + .03*(r_lat_pos_target - r_lat_pos);
            } else {
                /* During trial */
                inter_trial_trig = 0;
                /* Determine how far along trial */
                if (trial_type[cur_trial_num] == 1) {
                    frac_trial = cur_trial_dist/trial_duration[cur_trial_num];
                } else {
                    frac_trial = cur_trial_time/trial_timeout[cur_trial_num];
                }
                /* Check limits */
                if (frac_trial < 0){
                    frac_trial = 0;
                }
                
                
                /* Get the current corridor width value - check all turn positions and see which one in */
                for (ii = 0; ii < trial_num_cor_widths-1; ii++) {
                    if (frac_trial >= trial_cor_width_positions[cur_trial_num][ii] & frac_trial < trial_cor_width_positions[cur_trial_num][ii+1]){
                        cor_period = ii;
                    }
                }
                
                /* Get the current ol pos value - check all turn positions and see which one in */
                for (ii = 0; ii < trial_num_open_loop-1; ii++) {
                    if (frac_trial >= trial_ol_positions[cur_trial_num][ii] & frac_trial < trial_ol_positions[cur_trial_num][ii+1]){
                        ol_period = ii;
                    }
                }
                
                /* Get the current gain value - check all gain positions and see which one in */
                for (ii = 0; ii < trial_num_gain; ii++) {
                    if (frac_trial >= trial_gain_positions[cur_trial_num][ii] & frac_trial < trial_gain_positions[cur_trial_num][ii+1]){
                        gain_period = ii;
                    }
                }
                /* Get the current turn value - check all turn positions and see which one in */
                for (ii = 0; ii < trial_num_turns; ii++) {
                    if (frac_trial >= trial_turn_positions[cur_trial_num][ii] & frac_trial < trial_turn_positions[cur_trial_num][ii+1]){
                        turn_period = ii;
                    }
                }
                
                
                /* update corridor width */
                cor_width_start = trial_cor_width[cur_trial_num][cor_period];
                cor_width_stop = trial_cor_width[cur_trial_num][cor_period+1];
                cor_width_update = (frac_trial - trial_cor_width_positions[cur_trial_num][cor_period])/(trial_cor_width_positions[cur_trial_num][cor_period+1] - trial_cor_width_positions[cur_trial_num][cor_period])*cor_width_stop + (trial_cor_width_positions[cur_trial_num][cor_period+1] - frac_trial)/(trial_cor_width_positions[cur_trial_num][cor_period+1] - trial_cor_width_positions[cur_trial_num][cor_period])*cor_width_start;
                cor_width_offset = (cor_width_update - cor_width)/2;
                cor_width = cor_width_update;
                cor_pos = cor_pos + cor_width_offset;
                if (cor_width > max_cor_width){
                    cor_width = max_cor_width;
                }
                if (cor_width < 0){
                    cor_width = 0;
                }
                
                /* update open loop wall position */
                cor_pos_target_start = trial_ol_values[cur_trial_num][ol_period];
                cor_pos_target_stop = trial_ol_values[cur_trial_num][ol_period+1];
                /*cor_pos_update = (frac_trial - trial_ol_positions[cur_trial_num][ol_period])/(trial_ol_positions[cur_trial_num][ol_period+1] - trial_ol_positions[cur_trial_num][ol_period])*cor_pos_target_stop + (trial_ol_positions[cur_trial_num][ol_period+1] - frac_trial)/(trial_ol_positions[cur_trial_num][ol_period+1] - trial_ol_positions[cur_trial_num][ol_period])*cor_pos_target_start;*/
                cor_pos_update = (cor_pos_target_stop - cor_pos_target_start)/(trial_ol_positions[cur_trial_num][ol_period+1] - trial_ol_positions[cur_trial_num][ol_period])*(frac_trial - frac_trial_prev);
                frac_trial_prev = frac_trial;
                cor_pos = cor_pos + cor_pos_update;
                
                
                /* update gain value */
                gain_val = trial_gain_values[cur_trial_num][gain_period];
                
                /* update turn value */
                turn_val = trial_turn_values[cur_trial_num][turn_period];
                
                /* update closed loop corridor position */
                cor_pos = cor_pos - 10*wall_ball_gain/sample_freq*gain_val*(for_ball_motion*sin(turn_val*3.141/180) + lat_ball_motion*cos(turn_val*3.141/180));
                
                
                /* Check cor pos bounds */
                if (cor_pos > cor_width) {
                    cor_pos = cor_width;
                }
                if (cor_pos < 0) {
                    cor_pos = 0;
                }
                
                l_lat_pos = cor_width - cor_pos;
                r_lat_pos = cor_pos;
                
                /* Check walls enabled */
                if (trial_left_wall[cur_trial_num] == 0){
                    l_lat_pos = max_wall_pos;
                }
                if (trial_right_wall[cur_trial_num] == 0){
                    r_lat_pos = max_wall_pos;
                }
                
                /* Get the current test period value */
                if (test_val_exit == 0 & frac_trial >= trial_test_period[cur_trial_num][0] & frac_trial < trial_test_period[cur_trial_num][1]){
                    test_val = 1;
                }
                if (frac_trial >= trial_test_period[cur_trial_num][1]){
                    test_val = 0;
                    test_val_exit = 1;
                }
                
                /* determine contingency on how water is being delivered */
                if (trial_water_range_type[cur_trial_num] == 0){
                    water_pos_val = cor_pos;
                } else if (trial_water_range_type[cur_trial_num] == 1) {
                    water_pos_val = cor_pos/cor_width;
                } else {
                    water_pos_val = cur_trial_lat;
                }

                /* Get the current water period value */
                if (water_period < trial_num_water_drops){
                    /* Decide if delivering water */
                    if (trial_water_enabled[cur_trial_num] == 1 & frac_trial >= trial_water_pos[cur_trial_num][water_period] & water_pos_val >= trial_water_range_min[cur_trial_num][water_period] & water_pos_val <= trial_water_range_max[cur_trial_num][water_period]){
                        water_on = 1;
                        valve_open_time = trial_water_drop_size[cur_trial_num][water_period];
                        valve_open_time = round(valve_open_time/2);
                        water_period++;
                    }
                }
                
                
                /* Get the current mf period value */
                if (trial_masking_flash[cur_trial_num] > 0 & mf_val_exit == 0 & frac_trial >= trial_mf_period[cur_trial_num][0] & frac_trial < trial_mf_period[cur_trial_num][1]){
                    mf_val = 1;
                }
                if (frac_trial >= trial_mf_period[cur_trial_num][1]){
                    mf_val = 0;
                    mf_val_exit = 1;
                }
                
                /* Get the current ps period value */
                if (trial_photostim[cur_trial_num] > 0 & ps_val_exit == 0 & frac_trial >= trial_ps_period[cur_trial_num][0] & frac_trial < trial_ps_period[cur_trial_num][1]){
                    ps_val = 1;
                }
                if (frac_trial >= trial_ps_period[cur_trial_num][1]){
                    ps_val = 0;
                    ps_val_exit = 1;
                }
                
                /* Update trial distance and trial time */
                cur_trial_dist = cur_trial_dist + for_ball_motion/sample_freq;
                cur_trial_lat = cur_trial_lat + lat_ball_motion/sample_freq;
                cur_trial_time = cur_trial_time + 1/sample_freq;
            }
            
            /* Check bounds of wall position */
            if (r_lat_pos > max_wall_pos) {
                r_lat_pos = max_wall_pos;
            }
            if (r_lat_pos < 0) {
                r_lat_pos = 0;
            }
            if (l_lat_pos > max_wall_pos) {
                l_lat_pos = max_wall_pos;
            }
            if (l_lat_pos < 0) {
                l_lat_pos = 0;
            }
            r_for_pos = r_for_pos_default;
            l_for_pos = l_for_pos_default;
            /* Send AO for wall position */
            r_for_vlt = wall_mm_to_vlt(r_for_pos);
            l_for_vlt = wall_mm_to_vlt(l_for_pos);
            r_lat_vlt = wall_mm_to_vlt(r_lat_pos);
            l_lat_vlt = wall_mm_to_vlt(l_lat_pos);
            writeAO(r_wall_for_ao_chan, r_wall_for_ao_offset  + r_for_vlt);
            writeAO(r_wall_lat_ao_chan, r_wall_lat_ao_offset + r_lat_vlt);
            writeAO(l_wall_for_ao_chan, l_wall_for_ao_offset  + l_for_vlt);
            writeAO(l_wall_lat_ao_chan, l_wall_lat_ao_offset + l_lat_vlt);
            
            if (ext_valve_trig == 1 || water_dist > dist_thresh & dist_thresh < 200){
                water_on_ext = 1;
            }
            water_dist = water_dist +  for_ball_motion/sample_freq;
            
            /* If delivering water */
            if (water_on == 1) {
                if (valve_time < valve_open_time) {
                } else {
                    valve_time = 0;
                    water_on = 0;
                }
                valve_time++;
            }
            
            if (water_on_ext == 1) {
                if (valve_time_ext < valve_open_time_default) {
                } else {
                    valve_time_ext = 0;
                    water_on_ext = 0;
                    water_dist = 0;
                    ext_valve_trig = 0;
                }
                valve_time_ext++;
            }
            
            if (water_on == 1 || water_on_ext == 1) {
                writeDIO(water_valve_trig, 1);
            } else {
                writeDIO(water_valve_trig, 0);
            }
            
            tick_period = 0;
            
            /* Masking flash */
            if (mf_val == 1){
                if (mf_period_counter >= trial_mf_pulse_dur[cur_trial_num] + trial_mf_pulse_iti[cur_trial_num]){
                    mf_period_counter = 0;
                }
                if (mf_period_counter < trial_mf_pulse_dur[cur_trial_num]){
                    masking_flash_on = 1;
                } else {
                    masking_flash_on = 0;
                }
                mf_period_counter++;
            } else {
                masking_flash_on = 0;
            }
            
            if (trial_masking_flash[cur_trial_num] == 1) {
                writeDIO(mf_dio_blue, masking_flash_on);
                writeDIO(mf_dio_yellow, 0);
            } else if (trial_masking_flash[cur_trial_num] == 2) {
                writeDIO(mf_dio_blue, 0);
                writeDIO(mf_dio_yellow, masking_flash_on);
            } else {
                writeDIO(mf_dio_blue, masking_flash_on);
                writeDIO(mf_dio_yellow, masking_flash_on);
            }
            
            /* Deal with laser and galvos */
            if (ps_val == 1){
                if (ps_period_counter >= trial_ps_num_sites[cur_trial_num]*trial_ps_pulse_dur[cur_trial_num] + trial_ps_pulse_iti[cur_trial_num]){
                    ps_period_counter = 0;
                }
                
                if (ps_period_counter < trial_ps_num_sites[cur_trial_num]*trial_ps_pulse_dur[cur_trial_num]){
                    laser_shutter = 0;
                    cur_site_ind = floor(ps_period_counter/trial_ps_pulse_dur[cur_trial_num]);
                    if (trial_ps_closed_loop[cur_trial_num] == 1) {
                        if (cor_pos < cor_width/2) {
                            laser_power =  trial_ps_peak_power[cur_trial_num]*(cor_width/2 - cor_pos)/(cor_width/2);
                            x_mirror_pos = trial_ps_x_pos[cur_trial_num][cur_site_ind];
                        } else {
                            laser_power =  trial_ps_peak_power[cur_trial_num]*(cor_pos - cor_width/2)/(cor_width/2);
                            x_mirror_pos = -trial_ps_x_pos[cur_trial_num][cur_site_ind];
                        }
                        y_mirror_pos = trial_ps_y_pos[cur_trial_num][cur_site_ind];
                    } else {
                        laser_power =  trial_ps_peak_power[cur_trial_num];
                        x_mirror_pos = trial_ps_x_pos[cur_trial_num][cur_site_ind];
                        y_mirror_pos = trial_ps_y_pos[cur_trial_num][cur_site_ind];
                    }
                } else {
                    laser_power = 0;
                }
                ps_period_counter++;
            } else {
                laser_shutter = 1;
            }
            
            
            if (trial_ps_stop_threshold[cur_trial_num] == 1 & running_ind == 0) {
                laser_power =  0;
            }
            
            if (laser_calibration_mode == 1) {
                if (x_mirror_pos > 10){
                    x_mirror_pos = 10;
                }
                if (x_mirror_pos < -10){
                    x_mirror_pos = -10;
                }
                if (y_mirror_pos > 10){
                    y_mirror_pos = 10;
                }
                if (y_mirror_pos < -10){
                    y_mirror_pos = -10;
                }
                x_mirror_pos_vlt = x_mirror_pos;
                y_mirror_pos_vlt = y_mirror_pos;
                if (laser_power > 5){
                    laser_power = 5;
                }
                if (laser_power < 0){
                    laser_power = 0;
                }
                laser_power_vlt = laser_power;
            } else {
                x_mirror_pos_vlt = galvo_x_mm_to_vlt(x_mirror_pos);
                y_mirror_pos_vlt = galvo_y_mm_to_vlt(y_mirror_pos);
                if (trial_photostim[cur_trial_num] == 1) {
                    laser_power_vlt = blue_laser_mW_to_vlt(laser_power);
                } else if (trial_photostim[cur_trial_num] == 2) {
                    laser_power_vlt = yellow_laser_mW_to_vlt(laser_power);
                } else {
                  laser_power_vlt = blue_laser_mW_to_vlt(laser_power);
                }
            }
            
            if (laser_shutter == 1) {
                laser_power =  0;
                laser_power_vlt = 0;
                x_mirror_pos = - max_galvo_pos;
                y_mirror_pos = - max_galvo_pos;
                x_mirror_pos_vlt = 8;
                y_mirror_pos_vlt = 8;
            }
            
            writeAO(laser_power_ao_chan, laser_power_ao_offset + laser_power_vlt);
            writeAO(x_mirror_ao_chan, x_mirror_ao_offset + x_mirror_pos_vlt);
            writeAO(y_mirror_ao_chan, y_mirror_ao_offset + y_mirror_pos_vlt);
            
            /* Send triggers for behaviour cameras*/
            if (bv_time == 0 && inter_trial_trig == 0) {
                writeDIO(bv_trig, 1);
            } else {
                writeDIO(bv_trig, 0);
            }
            bv_time++;
            if (bv_time == bv_period) {
                bv_time = 0;
            }
            
            /* Send triggers for whisker cameras*/
            if (wv_time == 0 && inter_trial_trig == 0) {
                writeDIO(wv_trig, 1);
                led_pulse_on = 0;
            } else {
                writeDIO(wv_trig, 0);
            }
            wv_time++;
            if (wv_time == wv_period) {
                wv_time = 0;
            }
            
            /* Trial DO Triggers */
            writeDIO(trial_iti_trig, inter_trial_trig);
            writeDIO(trial_on_trig, 1-inter_trial_trig);
            writeDIO(trial_test_trig, test_val);
            writeDIO(trial_ephys_trig, 1-inter_trial_trig);
            writeAO(iti_ao_chan, iti_ao_offset + 5*(inter_trial_trig));
            
            
            /* Sync pulse */
            writeDIO(synch_pulse, 1);
            writeAO(synch_ao_chan, synch_ao_offset + 5);
            led_pulse_on = 0;
            
            scim_logging_ai_vlt = readAI(scim_logging_chan);
            if (scim_logging_ai_vlt >= ai_threshold) {
                scim_logging = 1;
            } else {
                scim_logging = 0;
            }
            
            /* Create Log Vectors */
            log_state_a = water_on + 2*lick_state + 4*inter_trial_trig;
            log_state_b = scim_state + 2*masking_flash_on + 4*running_ind;
            log_state_c = test_val + 2*scim_logging + 4*water_on_ext;
            log_cur_state = 10000*log_state_c+1000*log_state_b+100*log_state_a + cur_trial_num;
            log_ball_motion = cam_vel_steps[0] + 36*cam_vel_steps[1] + 36*36*cam_vel_steps[2]+ 36*36*36*cam_vel_steps[3]; /* convert to cam_motion_vect for logging */
            if (laser_calibration_mode == 1){
                if (scim_ai_vlt < 0 ) {
                    scim_ai_vlt = 0;
                }
                log_cor_pos = 100*scim_ai_vlt;
                log_photo_stim = floor(10*laser_power)*10000 + floor((x_mirror_pos+max_galvo_pos)*10)*100 + floor((y_mirror_pos+max_galvo_pos)*10);
            } else {
                log_cor_pos = floor(10*cor_pos) + 1000*floor(10*(cor_width));
                log_photo_stim = floor(10*laser_power)*10000 + floor((x_mirror_pos+max_galvo_pos)*10)*100 + floor((y_mirror_pos+max_galvo_pos)*10);
            }
            /* log_cor_pos = cam_vel_ai_vlt[0]*1000;*/
            logValue("ps", log_photo_stim);    /* stim code */
            logValue("bm", log_ball_motion); /* ball_motion_vector code */
            logValue("wm", log_cor_pos);       /* wall pos */
            logValue("st", log_cur_state);     /* state_vector code */
            scim_state = 1;
        } else {
            if (ball_tracker_clock_ai_vlt >= ai_threshold && ball_tracker_clock_low_flag == 1) {
                for (ii = 0; ii < 4; ii++) {
                    cam_vel_ai_vlt[ii] = readAI(cam_ai_chan[ii]);
                }
                ball_tracker_clock_low_flag = 0;
                second_ai_read = 1;
                led_pulse_on++;
                if (led_pulse_on > 2){
                    writeDIO(wv_trig, 0);
                    writeDIO(synch_pulse, 0);
                    writeAO(synch_ao_chan, synch_ao_offset);
                }
            } else if (ball_tracker_clock_ai_vlt < ai_threshold) {
                ball_tracker_clock_low_flag = 1;
                led_pulse_on++;
                if (led_pulse_on > 2){
                    writeDIO(wv_trig, 0);
                    writeDIO(synch_pulse, 0);
                }
            }
        }
    } else {
        /* If run is stopping */
        /* send left and right walls to target positions */
        l_lat_pos = l_lat_pos + .0005*(max_wall_pos - l_lat_pos);
        r_lat_pos = r_lat_pos + .0005*(max_wall_pos - r_lat_pos);
        
        if (r_lat_pos > max_wall_pos) {
            r_lat_pos = max_wall_pos;
        }
        if (r_lat_pos < 0) {
            r_lat_pos = 0;
        }
        
        if (l_lat_pos > max_wall_pos) {
            l_lat_pos = max_wall_pos;
        }
        if (l_lat_pos < 0) {
            l_lat_pos = 0;
        }
        r_lat_vlt = wall_mm_to_vlt(r_lat_pos);
        l_lat_vlt = wall_mm_to_vlt(l_lat_pos);
        writeAO(r_wall_lat_ao_chan, r_wall_lat_ao_offset + r_lat_vlt);
        writeAO(l_wall_lat_ao_chan, l_wall_lat_ao_offset + l_lat_vlt);
        writeAO(r_wall_for_ao_chan, r_wall_for_ao_offset  + r_for_vlt);
        writeAO(l_wall_for_ao_chan, l_wall_for_ao_offset  + l_for_vlt);
        writeAO(laser_power_ao_chan , laser_power_ao_offset);
        writeAO(x_mirror_ao_chan , x_mirror_ao_offset);
        writeAO(y_mirror_ao_chan , y_mirror_ao_offset);
        writeAO(iti_ao_chan, iti_ao_offset);
        writeAO(synch_ao_chan, synch_ao_offset);
        writeDIO(water_valve_trig, 0);
        writeDIO(trial_test_trig, 0);
        writeDIO(wv_trig, 0);
        writeDIO(bv_trig, 0);
        writeDIO(sound_trig, 0);
        writeDIO(mf_dio_blue, 0);
        writeDIO(mf_dio_yellow, 0);
        writeDIO(sound_trig_2, 0);
        writeDIO(trial_on_trig, 0);
        writeDIO(trial_iti_trig, 0);
        writeDIO(synch_pulse, 0);
        writeDIO(trial_ephys_trig, 0);
    }
}


void init_func(void) {
    for (jj = 0; jj < speed_time_length; jj++) {
        for_vel_history[jj] = 0;
        lat_vel_history[jj] = 0;
    }
/*    if (trial_random_order == 1) {
        cur_trial_num = 0;
    } else {
        cur_trial_num = trial_num_sequence_length - 1;
    }*/
    
    cor_pos = trial_ol_values[0][0];
            
    l_lat_pos = max_wall_pos;
    r_lat_pos = max_wall_pos;
    
    r_for_vlt = wall_mm_to_vlt(r_for_pos_default);
    l_for_vlt = wall_mm_to_vlt(l_for_pos_default);
    r_lat_vlt = wall_mm_to_vlt(r_lat_pos);
    l_lat_vlt = wall_mm_to_vlt(l_lat_pos);
    
    writeAO(laser_power_ao_chan , laser_power_ao_offset);
    writeAO(r_wall_for_ao_chan, r_wall_for_ao_offset  + r_for_vlt);
    writeAO(r_wall_lat_ao_chan, r_wall_lat_ao_offset + r_lat_vlt);
    writeAO(l_wall_for_ao_chan, l_wall_for_ao_offset  + l_for_vlt);
    writeAO(l_wall_lat_ao_chan, l_wall_lat_ao_offset + l_lat_vlt);
    writeAO(x_mirror_ao_chan , x_mirror_ao_offset);
    writeAO(y_mirror_ao_chan , y_mirror_ao_offset);
    writeAO(iti_ao_chan, iti_ao_offset);
    writeAO(synch_ao_chan, synch_ao_offset);
    writeDIO(water_valve_trig, 0);
    writeDIO(trial_test_trig, 0);
    writeDIO(wv_trig, 0);
    writeDIO(sound_trig, 0);
    writeDIO(bv_trig, 0);
    writeDIO(mf_dio_blue, 0);
    writeDIO(mf_dio_yellow, 0);
    writeDIO(trial_iti_trig, 0);
    writeDIO(trial_on_trig, 0);
    writeDIO(sound_trig_2, 0);
    writeDIO(synch_pulse, 0);
    writeDIO(trial_ephys_trig, 0);
}

void cleanupfunc(void) {
    /* Set all channels to default values */
}

