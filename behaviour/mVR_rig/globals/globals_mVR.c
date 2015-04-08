/* Whisker Guided Navigation Rig
 *
 * NJS JFRC 10/10/13 
 * NJS JFRC 01/26/14 revision */

/******************************************/
/* TRIAL PARAMETERS SET FROM MATLAB */
const unsigned num_mazes = 0; /* Number of mazes */
const unsigned max_num_branches = 0; /* Max number of branches */

const unsigned trial_random_order = 1; /* 1 if in random order, 0 if in sequence */
const unsigned trial_num_sequence_length = 0; /* 0 if random, otherwise length of sequence */
const unsigned trial_num_sequence[1] = {0}; /* 1 if random, sequence */
const unsigned trial_num_repeats[1] = {0}; /* 1 if random, num repeats */

const unsigned trial_timeout = 0; /* 1 if in random order, 0 if in sequence */
const unsigned trial_iti = 0; /* 1 if in random order, 0 if in sequence */
const unsigned trial_drink_time = 0; /* 1 if in random order, 0 if in sequence */
const unsigned trial_reward_size = 0; /* 1 if in random order, 0 if in sequence */

const unsigned maze_num_branches[] = {}; /* Number of branches for each maze */
const double maze_reward_patch[][8] = {{}}; /* If parent branch or not */
const double maze_wall_gain[] = {}; /* If parent branch or not */
const unsigned maze_initial_branch[] = {}; /* If parent branch or not */
const double maze_initial_branch_frac[] = {}; /* If parent branch or not */
const double maze_initial_left_wall[] = {}; /* If parent branch or not */
const double maze_initial_right_wall[] = {}; /* If parent branch or not */


const double branch_length[][] = {{}}; /* Length of branch */
const double branch_left_angle[][] = {{}}; /* Angle of left wall */
const double branch_right_angle[][] = {{}}; /* Angle of right wall */
const unsigned branch_left_end[][] = {{}}; /* Left maze end condition */
const unsigned branch_right_end[][] = {{}}; /* Right maze end condition */
const unsigned branch_split[][] = {{}}; /* If split branch or not */
const unsigned branch_reward[][] = {{}}; /* If reward branch or not */
const unsigned branch_parent[][] = {{}}; /* If parent branch or not */

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
const unsigned cam_ai_chan[4] = 0; /* AI channels from camerea, x0, y0, x1, y1 */
const unsigned scan_image_frame_clock_chan = 0; /* Frame clock from scan image */
const unsigned lick_in_chan = 0; /* Lick signal*/
const unsigned scim_logging_chan = 0; /* Lick signal*/

/* Analog output channels */
const unsigned undef_ao_chan = 0; /* undefined */
const unsigned synch_ao_chan = 0; /* synch channel at 500 Hz */
const unsigned iti_ao_chan = 0; /* AO intertrial trig  */
const unsigned l_wall_lat_ao_chan = 0; /* left wall lateral position */
const unsigned l_wall_for_ao_chan = 0; /* left wall forward position */
const unsigned r_wall_lat_ao_chan = 0; /* right wall lateral position */
const unsigned r_wall_for_ao_chan = 0; /* right wall lateral position */
const unsigned for_pos_ao_chan = 0; /* forward position of mouse */
const unsigned lat_pos_ao_chan = 0; /* lateral position of mouse */

/* Analog output channel offsets */
const double undef_ao_offset = 0;
const double synch_ao_offset = 0;
const double iti_ao_offset = 0;
const double l_wall_lat_ao_offset = 0;
const double l_wall_for_ao_offset = 0;
const double r_wall_lat_ao_offset = 0;
const double r_wall_for_ao_offset = 0;
const double for_pos_ao_offset = 0;
const double lat_pos_ao_offset = 0;

/* Digital output channels */
const unsigned water_valve_trig = 0; /* Water valve trigger */
const unsigned trial_iti_trig = 0;
const unsigned wv_trig = 0;
const unsigned bv_trig = 0;
const unsigned sound_trig = 0;
const unsigned synch_pulse = 0;
const unsigned sound_trig_2 = 0;
const unsigned trial_on_trig = 0;
const unsigned trial_ephys_trig = 0;
const unsigned trial_test_trig = 0;
const unsigned mf_dio_yellow = 0;
const unsigned mf_dio_blue = 0;


/***************************************/
/***************************************/
/* DEFINE CONSTANTS */
/* Convert to steps params */
const double zero_V[4] = 0;
const double step_V = 0;
const double A_calib[3][4] = 0;

const double sample_freq = 0;
const unsigned ai_threshold = 0; /* Threshold ai signal needs to pass to be considered high */
const double run_speed_thresh = 0;
const unsigned speed_time_length = 0;
const double wall_ball_gain = 0;

const double max_wall_pos = 0;
const double max_cor_width = 0;
const double l_for_pos_default = 0;
const double r_for_pos_default = 0;

const unsigned bv_period = 0; /* behavioural video frame period / 2 in ms */
const unsigned wv_period = 0; /* whisker video frame period / 2 in ms */

const double valve_open_time_default = 0; /* Time water valve open for at 500 Hz */

const double max_galvo_pos = 0;

const unsigned ao_trial_trig_on = 0;

double dist_thresh = 0;

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
double cur_drink_time = 0;
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

/*************************************************************************/
/*************************************************************************/
/*************************************************************************/


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
            if (cur_drink_time >= trial_drink_time || cur_trial_time >= trial_timeout) {
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
                l_lat_pos_target = maze_initial_left_wall[cur_trial_num];
                r_lat_pos_target = maze_initial_right_wall[cur_trial_num];
                l_for_pos_target = l_for_pos_default;
                r_for_pos_target = r_for_pos_default;

                /* reset variables */                
                inter_trial_time = 0;
                cur_trial_time = 0;
                cur_drink_time = 0;
                cur_branch = maze_initial_branch[cur_trial_num];
                cur_branch_frac = maze_initial_branch_frac[cur_trial_num];
                wv_time = 0;
                bv_time = 0;
            }
            
            /* Check if in iti */
            if (inter_trial_time <= trial_iti) {
                inter_trial_trig = 1;
                inter_trial_time = inter_trial_time + 1/sample_freq;
                /* send left and right walls to target positions */
                l_lat_pos = l_lat_pos + .03*(l_lat_pos_target - l_lat_pos);
                r_lat_pos = r_lat_pos + .03*(r_lat_pos_target - r_lat_pos);
            } else {
                /* During trial */
                inter_trial_trig = 0;
                
                /* Determine how far along trial */
                /* Determine how far along trial */
                /* Determine how far along trial */
                /* Determine how far along trial */
                /* Determine how far along trial */
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
    
    cur_trial_time = trial_timeout + 1;
            
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

