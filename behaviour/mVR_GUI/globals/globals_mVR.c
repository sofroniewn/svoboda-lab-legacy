/* Whisker Guided Navigation Rig
 *
 * NJS JFRC 10/10/13
 * NJS JFRC 01/26/14 revision */

/******************************************/
/* TRIAL PARAMETERS SET FROM MATLAB */
const unsigned Xnum_mazes = 0; /* Number of mazes */
const unsigned Xmax_num_branches = 0; /* Max number of branches */

const unsigned Xtrial_random_order = 0; /* 1 if in random order, 0 if in sequence, 2 if repeat till correct */
const unsigned Xtrial_num_sequence_length = 0; /* 0 if random, otherwise length of sequence */
const unsigned Xtrial_num_sequence[] = {}; /* 1 if random, sequence */
const unsigned Xtrial_num_repeats[] = {}; /* 1 if random, num repeats */

/* params - one per session */
const double Xsession_timeout = 0; /* time for trial to time out */
const double Xsession_iti = 0; /* inter trial interal time */
const double Xsession_drink_time = 0; /* time to drink water before trial ends */
const unsigned Xsession_continuous_world = 0; /* whether to have a continuous world or not */

/* params - one per maze */
const unsigned Xmaze_num_branches[] = {}; /* Number of branches for each maze */
const double Xmaze_reward_patch[][] = {{}}; /* Size of reward patches in this maze, l_frac, r_frac, back_dist_frac for_dist_frac */
const double Xmaze_reward_size[] = {}; /* Multiplier on reward size */
const double Xmaze_wall_gain[] = {}; /* ball wall gain */
const double Xmaze_center_width[] = {}; /* width of center */
const double Xmaze_screen_on_time[] = {}; /* Duration screen on - if 0 then never on */
const unsigned Xmaze_initial_branch[] = {}; /* Starting branch num */
const double Xmaze_initial_branch_for_fraction[] = {}; /* Starting branch forward fraction */
const double Xmaze_initial_branch_lat_fraction[] = {}; /* Starting lateral fraction */

/* params - one per branch */
const double Xbranch_length[][] = {{}}; /* Length of branch */
const double Xbranch_left_angle[][] = {{}}; /* Angle of left wall */
const double Xbranch_right_angle[][] = {{}}; /* Angle of right wall */
const double Xbranch_for_start[][] = {{}}; /* forward start position branch, cm */
const double Xbranch_l_lat_start[][] = {{}}; /* lateral left wall start mm */
const double Xbranch_r_lat_start[][] = {{}}; /* lateral right wall start mm */
const signed Xbranch_left_end[][] = {{}}; /* Left maze end condition */
const signed Xbranch_right_end[][] = {{}}; /* Right maze end condition */
const unsigned Xbranch_split[][] = {{}}; /* If split branch or not */
const unsigned Xbranch_reward[][] = {{}}; /* If reward branch or not */
const signed Xbranch_parent[][] = {{}}; /* Parent branch id */

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
extern double tan(double);
extern double sin(double);
extern double cos(double);
extern double powi(double d, int i);
extern double sqrt(double);

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
const unsigned maze_num_ao_chan = 0; /* maze number */
const unsigned synch_ao_chan = 0; /* synch channel at 500 Hz */
const unsigned iti_ao_chan = 0; /* AO intertrial trig  */
const unsigned l_wall_lat_ao_chan = 0; /* left wall lateral position */
const unsigned c_wall_for_ao_chan = 0; /* left wall forward position */
const unsigned c_wall_lat_ao_chan = 0; /* right wall lateral position */
const unsigned r_wall_lat_ao_chan = 0; /* right wall lateral position */
const unsigned maze_for_ao_chan = 0; /* forward position of mouse */
const unsigned maze_lat_ao_chan = 0; /* lateral position of mouse */

/* Analog output channel offsets */
const double maze_num_ao_offset = 0;
const double synch_ao_offset = 0;
const double iti_ao_offset = 0;
const double l_wall_lat_ao_offset = 0;
const double c_wall_for_ao_offset = 0;
const double c_wall_lat_ao_offset = 0;
const double r_wall_lat_ao_offset = 0;
const double maze_for_ao_offset = 0;
const double maze_lat_ao_offset = 0;

/* Digital output channels */
const unsigned water_valve_trig = 0; /* Water valve trigger */
const unsigned trial_iti_trig = 0;
const unsigned trial_on_trig = 0;
const unsigned wv_trig = 0;
const unsigned bv_trig = 0;
const unsigned synch_pulse = 0;
const unsigned trial_ephys_trig = 0;
const unsigned screen_on_trig = 0;
const unsigned sound_cue_trig = 0;

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

const double max_wall_pos = 0;
const double max_wall_for_pos = 0; /* forward default position 20 mm from face */

const unsigned bv_period = 0; /* behavioural video frame period / 2 in ms */
const unsigned wv_period = 0; /* whisker video frame period / 2 in ms */

const double valve_open_time_default = 0; /* Time water valve open for at 500 Hz */

const double max_galvo_pos = 0;

const unsigned ao_trial_trig_on = 0;

const double update_scale = 2;

const double sound_on_length = 0;

const double branch_compensate_dist = 7; /* split_child >= 9, split >=31, split ~= dead_end ~= split_child */
const double offset_dist = 3;

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
unsigned cur_branch = 0;
double cur_trial_time = 0;
double cur_branch_dist = 0;
double cur_drink_time = 0;
double cur_branch_lat_frac = 0;
double cur_trial_lat = 0;
unsigned cur_trial_num = 0;
unsigned left_side;
unsigned c_dead_end;
unsigned screen_on;
unsigned dead_end = 0;
double gain_val;
unsigned wv_time;
unsigned bv_time;
unsigned cur_trial_block = 0;
unsigned cur_trial_repeat = 0;
unsigned led_pulse_on = 0;
unsigned correct = 1;
unsigned sound_on = 0;
signed parent_branch;
signed child_branch;
unsigned split_child; /* 0 if not a child of y branch, 1 if left child, 2 if right child */
unsigned first_trial = 1;
unsigned maze_end_reached = 0;
unsigned iti_reset;

/* Define Wall Motion Variables and maze cords*/
double left_angle;
double right_angle;
double l_lat_pos_target;
double r_lat_pos_target;
double c_for_pos_target;
double c_lat_pos_target;
double c_ang_pos_target;
double l_lat_pos_current;
double r_lat_pos_current;
double c_for_pos_current;
double c_lat_pos_current;
double c_ang_pos_current;
double c_for_pos;
double c_lat_pos;
double c_ang_pos;
double r_lat_pos;
double l_lat_pos;
double cor_pos;
double cor_width;
double maze_for_cord;
double maze_lat_cord;
double update_dist = 0;
double time_frac = 0;
double c_lat_dist;
double c_lat_pos_mid;
double c_lat_pos_top;
double maze_start_dist = 0;



/* vars for water delivery*/
unsigned water_on = 0;
unsigned water_on_ext = 0;
unsigned valve_time = 0;
unsigned valve_time_ext = 0;
unsigned ext_valve_trig = 0;
double water_dist = 0;
unsigned water_trig_on[];

/* vars for scim sync*/
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
double log_wall_pos;
double log_maze_cord;

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

double wall_ang_to_vlt(double x) {
    if (x<-90) {
        x = -90;
    }
    if (x>90) {
        x = 90;
    }
    return (x+90)/180*5;
}

/***********************************/
/* Maze AO output Function*/
/* scale 0 to 999 to 0 to 5V */
double maze_for_to_vlt(double x) {
    if (x<0) {
        x = 0;
    }
    if (x>200) {
        x = 200;
    }
    x = x/40;
    
    return x;
}
/* scale -499 to 499 to 0 to 5V*/
double maze_lat_to_vlt(double x) {
    if (x<-100) {
        x = -100;
    }
    if (x>100) {
        x = 100;
    }
    
    x = (x+100)/40;
    return x;
}
/* scale 0 to 99 to 0 to 5V*/
double maze_num_to_vlt(double x) {
    if (x<0) {
        x = 0;
    }
    if (x>20) {
        x = 20;
    }
    return x/4;
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
            
            /***********************************************************************************/
            /***********************************************************************************/
            /***********************************************************************************/
            /**************** INITIALIZE NEW TRIAL *********************************************/
            /* Check if trial has ended, and if so make a new one */
            if ((cur_drink_time-1)/sample_freq >= session_drink_time || cur_trial_time >= session_timeout || (maze_end_reached == 1 && session_continuous_world == 1)) {
                /* Pick new trial number */
                if (trial_random_order == 1) {
                    cur_trial_num = (unsigned int) (num_mazes)*rand();
                } else if (trial_random_order == 2) {
                    if (correct) {
                        cur_trial_num = (unsigned int) (num_mazes)*rand();
                    } else {
                        cur_trial_num = cur_trial_num;
                    }
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
                
                l_lat_pos_current = l_lat_pos;
                r_lat_pos_current = r_lat_pos;
                c_for_pos_current = c_for_pos;
                c_lat_pos_current = c_lat_pos;
                c_ang_pos_current = c_ang_pos;
                
                /* reset variables */
                inter_trial_time = 0;
                cur_trial_time = 0;
                cur_drink_time = 0;
                for (ii = 0; ii < max_num_branches; ii++) {
                    water_trig_on[ii] = 0;
                }
                correct = 0;
                dead_end = 0;
                gain_val = maze_wall_gain[cur_trial_num];
                
                if (maze_end_reached == 1 && session_continuous_world == 1) {
                    cur_branch = 0;
                    cur_branch_lat_frac = cor_pos/cor_width;
                    cur_branch_dist = 0; /* maze_start_dist */
                    iti_reset = 0;
                    
                } else {
                    cur_branch = maze_initial_branch[cur_trial_num];
                    cur_branch_lat_frac = maze_initial_branch_lat_fraction[cur_trial_num];
                    cur_branch_dist = maze_initial_branch_for_fraction[cur_trial_num]*branch_length[cur_trial_num][cur_branch];
                    iti_reset = 1;
                }
                
                left_angle = branch_left_angle[cur_trial_num][cur_branch];
                right_angle = branch_right_angle[cur_trial_num][cur_branch];
                
                cor_width = (branch_r_lat_start[cur_trial_num][cur_branch] + cur_branch_dist*gain_val*tan(right_angle*3.141/180))-(branch_l_lat_start[cur_trial_num][cur_branch] + cur_branch_dist*gain_val*tan(left_angle*3.141/180));
                cor_pos = cur_branch_lat_frac*cor_width;
                
                /* Check if new branch is a split child branch, and if so change update_dist */
                split_child = 0;
                update_dist = 0;
                parent_branch = branch_parent[cur_trial_num][cur_branch];
                if (parent_branch >=0) {
                    if (branch_split[cur_trial_num][parent_branch] == 1){
                        if (cur_branch == branch_left_end[cur_trial_num][parent_branch]) {
                            split_child = 1;
                        } else {
                            split_child = 2;
                        }
                        update_dist = branch_r_lat_start[cur_trial_num][parent_branch] - branch_l_lat_start[cur_trial_num][parent_branch] + maze_center_width[cur_trial_num];
                    }
                }
                
                /* update wall positions */
                if (split_child == 1 && (branch_left_end[cur_trial_num][cur_branch] == -1 ||  branch_right_end[cur_trial_num][cur_branch] == -1)) {
                    /* if in left child of split branch */
                    if (cur_branch_dist < branch_compensate_dist) {
                        /* move far lateral wall in behind rotated center wall */
                        c_ang_pos_target = -90;
                        r_lat_pos_target = cor_pos + update_dist*(1-cur_branch_dist/branch_compensate_dist)+offset_dist*cur_branch_dist/branch_compensate_dist;
                        c_lat_pos_target = cor_pos - cor_width/2 + update_dist/2;
                        l_lat_pos_target = cor_width - cor_pos;
                        c_for_pos_target = 0;
                        c_dead_end = 0;
                    } else if (cur_branch_dist >= branch_compensate_dist && cur_branch_dist < branch_compensate_dist*2) {
                        /* move center wall back to center, rotate center wall back to straight and move in lateral wall*/
                        c_ang_pos_target = -90*(2 - cur_branch_dist/branch_compensate_dist);
                        r_lat_pos_target = cor_pos + offset_dist*(2 - cur_branch_dist/branch_compensate_dist);
                        c_lat_pos_target = cor_pos - cor_width/2 + update_dist/2*(2 - cur_branch_dist/branch_compensate_dist);
                        l_lat_pos_target = cor_width - cor_pos;
                        c_for_pos_target = 0;
                        c_dead_end = 1;
                    } else {
                        c_ang_pos_target = 0;
                        r_lat_pos_target = cor_pos;
                        l_lat_pos_target = cor_width - cor_pos;
                        c_lat_pos_target = cor_pos - cor_width/2;
                        c_for_pos_target = 0;
                        c_dead_end = 1;
                    }
                } else if (split_child == 1) {
                    /* if in left child of split branch */
                    if (cur_branch_dist < branch_compensate_dist) {
                        /* move far lateral wall in behind rotated center wall */
                        c_ang_pos_target = -90;
                        r_lat_pos_target = cor_pos + update_dist*(1-cur_branch_dist/branch_compensate_dist)+offset_dist*cur_branch_dist/branch_compensate_dist;
                        c_lat_pos_target = cor_pos - cor_width/2 + update_dist/2;
                        l_lat_pos_target = cor_width - cor_pos;
                        c_for_pos_target = 0;
                    } else if (cur_branch_dist >= branch_compensate_dist && cur_branch_dist < branch_compensate_dist*2) {
                        /* move rotated center wall away from mouse */
                        c_ang_pos_target = -90;
                        r_lat_pos_target = cor_pos + offset_dist;
                        c_lat_pos_target = cor_pos - cor_width/2 + update_dist/2;
                        l_lat_pos_target = cor_width - cor_pos;
                        c_for_pos_target = max_wall_for_pos*(cur_branch_dist/branch_compensate_dist - 1);
                    } else if (cur_branch_dist >= branch_compensate_dist*2 && cur_branch_dist < branch_compensate_dist*3) {
                        /* move center wall back to center, rotate center wall back to straight and move in lateral wall*/
                        c_ang_pos_target = -90*(3 - cur_branch_dist/branch_compensate_dist);
                        r_lat_pos_target = cor_pos + offset_dist*(3 - cur_branch_dist/branch_compensate_dist);
                        c_lat_pos_target = cor_pos - cor_width/2 + update_dist/2*(3 - cur_branch_dist/branch_compensate_dist);
                        l_lat_pos_target = cor_width - cor_pos;
                        c_for_pos_target = max_wall_for_pos;
                    } else {
                        c_ang_pos_target = 0;
                        r_lat_pos_target = cor_pos;
                        l_lat_pos_target = cor_width - cor_pos;
                        c_lat_pos_target = cor_pos - cor_width/2;
                        c_for_pos_target = max_wall_for_pos;
                    }
                }  else if (split_child == 2 && (branch_left_end[cur_trial_num][cur_branch] == -1 ||  branch_right_end[cur_trial_num][cur_branch] == -1)) {
                    /* if in right child of split branch */
                    if (cur_branch_dist < branch_compensate_dist) {
                        /* move far lateral wall in behind rotated center wall */
                        c_ang_pos_target = 90;
                        r_lat_pos_target = cor_pos;
                        c_lat_pos_target = cor_pos - cor_width/2 - update_dist/2;
                        l_lat_pos_target = cor_width - cor_pos + update_dist*(1-cur_branch_dist/branch_compensate_dist)+offset_dist*cur_branch_dist/branch_compensate_dist;
                        c_for_pos_target = 0;
                        c_dead_end = 0;
                    } else if (cur_branch_dist >= branch_compensate_dist && cur_branch_dist < branch_compensate_dist*2) {
                        /* move center wall back to center, rotate center wall back to straight and move in lateral wall*/
                        c_ang_pos_target = 90*(2 - cur_branch_dist/branch_compensate_dist);
                        r_lat_pos_target = cor_pos;
                        c_lat_pos_target = cor_pos - cor_width/2 - update_dist/2*(2 - cur_branch_dist/branch_compensate_dist);
                        l_lat_pos_target = cor_width - cor_pos + offset_dist*(2 - cur_branch_dist/branch_compensate_dist);
                        c_for_pos_target = 0;
                        c_dead_end = 1;
                    } else {
                        c_ang_pos_target = 0;
                        r_lat_pos_target = cor_pos;
                        l_lat_pos_target = cor_width - cor_pos;
                        c_lat_pos_target = cor_pos - cor_width/2;
                        c_for_pos_target = 0;
                        c_dead_end = 1;
                    }
                } else if (split_child == 2) {
                    /* if in right child of split branch */
                    if (cur_branch_dist < branch_compensate_dist) {
                        /* move far lateral wall in behind rotated center wall */
                        c_ang_pos_target = 90;
                        r_lat_pos_target = cor_pos;
                        c_lat_pos_target = cor_pos - cor_width/2 - update_dist/2;
                        l_lat_pos_target = cor_width - cor_pos + update_dist*(1-cur_branch_dist/branch_compensate_dist)+offset_dist*cur_branch_dist/branch_compensate_dist;
                        c_for_pos_target = 0;
                    } else if (cur_branch_dist >= branch_compensate_dist && cur_branch_dist < branch_compensate_dist*2) {
                        /* move rotated center wall away from mouse */
                        c_ang_pos_target = 90;
                        r_lat_pos_target = cor_pos;
                        c_lat_pos_target = cor_pos - cor_width/2 - update_dist/2;
                        l_lat_pos_target = cor_width - cor_pos + offset_dist;
                        c_for_pos_target = max_wall_for_pos*(cur_branch_dist/branch_compensate_dist - 1);
                    } else if (cur_branch_dist >= branch_compensate_dist*2 && cur_branch_dist < branch_compensate_dist*3) {
                        /* move center wall back to center, rotate center wall back to straight and move in lateral wall*/
                        c_ang_pos_target = 90*(3 - cur_branch_dist/branch_compensate_dist);
                        r_lat_pos_target = cor_pos;
                        c_lat_pos_target = cor_pos - cor_width/2 - update_dist/2*(3 - cur_branch_dist/branch_compensate_dist);
                        l_lat_pos_target = cor_width - cor_pos + offset_dist*(3 - cur_branch_dist/branch_compensate_dist);
                        c_for_pos_target = max_wall_for_pos;
                    } else {
                        c_ang_pos_target = 0;
                        r_lat_pos_target = cor_pos;
                        l_lat_pos_target = cor_width - cor_pos;
                        c_lat_pos_target = cor_pos - cor_width/2;
                        c_for_pos_target = max_wall_for_pos;
                    }
                } else if (branch_split[cur_trial_num][cur_branch] == 1) {
                    /* if in split branch */
                    r_lat_pos_target = cor_pos;
                    l_lat_pos_target = cor_width - cor_pos;
                    c_lat_pos_target = cor_pos - cor_width/2;
                    c_ang_pos_target = -180*c_lat_pos_target/maze_center_width[cur_trial_num];
                    if (c_ang_pos_target > 90) {
                        c_ang_pos_target = 90;
                    } else if (c_ang_pos_target < -90){
                        c_ang_pos_target = -90;
                    }
                    if (cur_branch_dist < branch_compensate_dist) {
                        /* if close to start of branch */
                        c_ang_pos_target = cur_branch_dist/branch_compensate_dist*c_ang_pos;
                    }
                    if (gain_val*(branch_length[cur_trial_num][cur_branch] - cur_branch_dist) < max_wall_for_pos) {
                        /* if near end of branch */
                        c_for_pos_target = gain_val*(branch_length[cur_trial_num][cur_branch] - cur_branch_dist);
                    } else {
                        c_for_pos_target = max_wall_for_pos;
                    }
                } else if (branch_left_end[cur_trial_num][cur_branch] == -1 ||  branch_right_end[cur_trial_num][cur_branch] == -1) {
                    /* if in dead end branch */
                    c_ang_pos_target = 0;
                    r_lat_pos_target = cor_pos;
                    l_lat_pos_target = cor_width - cor_pos;
                    c_lat_pos_target = cor_pos - cor_width/2;
                    if (gain_val*(branch_length[cur_trial_num][cur_branch] - cur_branch_dist) < max_wall_for_pos) {
                        /* if near end of branch */
                        c_for_pos_target = gain_val*(branch_length[cur_trial_num][cur_branch] - cur_branch_dist);
                        c_dead_end = 1;
                    } else {
                        c_for_pos_target = max_wall_for_pos;
                        c_dead_end = 0;
                    }
                } else {
                    /* if in normal branch */
                    c_ang_pos_target = 0;
                    r_lat_pos_target = cor_pos;
                    l_lat_pos_target = cor_width - cor_pos;
                    c_lat_pos_target = cor_pos - cor_width/2;
                    c_for_pos_target = max_wall_for_pos;
                }
                
                /* initialize maze coords */
                maze_for_cord = branch_for_start[cur_trial_num][cur_branch] + cur_branch_dist;
                maze_lat_cord = (branch_r_lat_start[cur_trial_num][cur_branch] + cur_branch_dist*gain_val*tan(right_angle*3.141/180)) - cor_pos;
                wv_time = 0;
                bv_time = 0;
                water_on = 0;
                screen_on = 0;
                maze_end_reached = 0;
            }
            
            
            /***********************************************************************************/
            /***********************************************************************************/
            /***********************************************************************************/
            /**************** Execute main trial loop ******************************************/
            /* Check if in iti */
            if (inter_trial_time < session_iti && (session_continuous_world == 0 || (iti_reset == 1 && session_continuous_world == 1) || first_trial == 1)) {
                inter_trial_trig = 1;
                inter_trial_time = inter_trial_time + 1/sample_freq;
                /* send left and right walls to target positions */
                l_lat_pos = l_lat_pos_current*(1-inter_trial_time/session_iti) + l_lat_pos_target*(inter_trial_time/session_iti);
                r_lat_pos = r_lat_pos_current*(1-inter_trial_time/session_iti) + r_lat_pos_target*(inter_trial_time/session_iti);
                c_lat_pos = c_lat_pos_current*(1-inter_trial_time/session_iti) + c_lat_pos_target*(inter_trial_time/session_iti);
                c_for_pos = c_for_pos_current*(1-inter_trial_time/session_iti) + c_for_pos_target*(inter_trial_time/session_iti);
                c_ang_pos = c_ang_pos_current*(1-inter_trial_time/session_iti) + c_ang_pos_target*(inter_trial_time/session_iti);
                
                screen_on = 0;
            } else {
                first_trial = 0;
                iti_reset = 0;
                /* During trial set inter trial trig to 0 */
                if (inter_trial_time == 0) {
                    inter_trial_trig = 1;
                    inter_trial_time = session_iti;
                } else {
                    inter_trial_trig = 0;
                }

                
                /* update trial time */
                cur_trial_time = cur_trial_time + 1/sample_freq;
                
                /* update forward position along branch */
                /*for_ball_motion = 10; lat_ball_motion = -1;*/
                cur_branch_dist = cur_branch_dist + for_ball_motion/sample_freq;
                
                /* Check limits and make branch transition forwards */
                if (cur_branch_dist > branch_length[cur_trial_num][cur_branch]){
                    /* Transition to child branch */
                    if (branch_left_end[cur_trial_num][cur_branch] == -1 || branch_right_end[cur_trial_num][cur_branch] == -1) {
                        /* if no child stay */
                        cur_branch_dist = branch_length[cur_trial_num][cur_branch];
                    } else if (branch_left_end[cur_trial_num][cur_branch] == 0 && session_continuous_world) {
                        maze_end_reached = 1;
                        maze_start_dist = cur_branch_dist - branch_length[cur_trial_num][cur_branch];
                        cur_branch_dist = branch_length[cur_trial_num][cur_branch];                        
                    } else {
                        if (branch_split[cur_trial_num][cur_branch] == 1) {
                            if (cur_branch_lat_frac > (branch_r_lat_start[cur_trial_num][cur_branch] - branch_l_lat_start[cur_trial_num][cur_branch] + maze_center_width[cur_trial_num])/(2*branch_r_lat_start[cur_trial_num][cur_branch] - 2*branch_l_lat_start[cur_trial_num][cur_branch] + maze_center_width[cur_trial_num])) {
                                update_dist = branch_r_lat_start[cur_trial_num][cur_branch] - branch_l_lat_start[cur_trial_num][cur_branch] + maze_center_width[cur_trial_num];
                                cor_pos = cor_pos - update_dist;
                                split_child = 1;
                                cur_branch_dist = cur_branch_dist - branch_length[cur_trial_num][cur_branch];
                                cur_branch = branch_left_end[cur_trial_num][cur_branch];
                            } else if (cur_branch_lat_frac < (branch_r_lat_start[cur_trial_num][cur_branch] - branch_l_lat_start[cur_trial_num][cur_branch])/(2*branch_r_lat_start[cur_trial_num][cur_branch] - 2*branch_l_lat_start[cur_trial_num][cur_branch] + maze_center_width[cur_trial_num])) {
                                update_dist = branch_r_lat_start[cur_trial_num][cur_branch] - branch_l_lat_start[cur_trial_num][cur_branch] + maze_center_width[cur_trial_num];
                                split_child = 2;
                                cur_branch_dist = cur_branch_dist - branch_length[cur_trial_num][cur_branch];
                                cur_branch = branch_right_end[cur_trial_num][cur_branch];
                            } else {
                                cur_branch_dist = branch_length[cur_trial_num][cur_branch];
                            }
                        } else {
                            cur_branch_dist = cur_branch_dist - branch_length[cur_trial_num][cur_branch];
                            cur_branch = branch_left_end[cur_trial_num][cur_branch];
                            split_child = 0;
                        }
                    }
                }
                
                /* Check limits and make branch transition backwards */
                if (cur_branch_dist < 0){
                    /* Transition to parent branch */
                    if (branch_parent[cur_trial_num][cur_branch] == -1) {
                        /* if no partent stay */
                        cur_branch_dist = 0;
                    } else {
                        /* update branch id */
                        parent_branch = branch_parent[cur_trial_num][cur_branch];
                        if (branch_split[cur_trial_num][parent_branch] == 1) {
                            /* if split branch - check which side to go */
                            if (branch_left_end[cur_trial_num][parent_branch] == cur_branch){
                                cor_pos = cor_pos + branch_r_lat_start[cur_trial_num][cur_branch] - branch_l_lat_start[cur_trial_num][cur_branch] + maze_center_width[cur_trial_num];
                            }
                        }
                        cur_branch_dist = cur_branch_dist + branch_length[cur_trial_num][parent_branch];
                        cur_branch = parent_branch;
                        split_child = 0;
                        /* Check if new branch is a split child branch, and if so change update_dist */
                        parent_branch = branch_parent[cur_trial_num][cur_branch];
                        if (parent_branch >=0) {
                            if (branch_split[cur_trial_num][parent_branch] == 1){
                                if (cur_branch == branch_left_end[cur_trial_num][parent_branch]) {
                                    split_child = 1;
                                } else {
                                    split_child = 2;
                                }
                                update_dist = branch_r_lat_start[cur_trial_num][parent_branch] - branch_l_lat_start[cur_trial_num][parent_branch] + maze_center_width[cur_trial_num];
                            }
                        }
                    }
                }
                
                /* set angles */
                left_angle = branch_left_angle[cur_trial_num][cur_branch];
                right_angle = branch_right_angle[cur_trial_num][cur_branch];
                
                /* update corridor width */
                cor_width = (branch_r_lat_start[cur_trial_num][cur_branch] + cur_branch_dist*gain_val*tan(right_angle*3.141/180))-(branch_l_lat_start[cur_trial_num][cur_branch] + cur_branch_dist*gain_val*tan(left_angle*3.141/180));
                
                /* update corridor position */
                cor_pos = cor_pos + gain_val/sample_freq*(for_ball_motion*tan(right_angle*3.141/180) + lat_ball_motion);
                if (cor_pos < 0) {
                    cor_pos = 0;
                }
                if (cor_pos > cor_width) {
                    cor_pos = cor_width;
                }
                
                cur_branch_lat_frac = cor_pos/cor_width;
                
                /* update wall positions */
                if (split_child == 1 && (branch_left_end[cur_trial_num][cur_branch] == -1 ||  branch_right_end[cur_trial_num][cur_branch] == -1)) {
                    /* if in left child of split branch */
                    if (cur_branch_dist < branch_compensate_dist) {
                        /* move far lateral wall in behind rotated center wall */
                        c_ang_pos = -90;
                        r_lat_pos = cor_pos + update_dist*(1-cur_branch_dist/branch_compensate_dist)+offset_dist*cur_branch_dist/branch_compensate_dist;
                        c_lat_pos = cor_pos - cor_width/2 + update_dist/2;
                        l_lat_pos = cor_width - cor_pos;
                        c_for_pos = 0;
                        c_dead_end = 0;
                    } else if (cur_branch_dist >= branch_compensate_dist && cur_branch_dist < branch_compensate_dist*2) {
                        /* move center wall back to center, rotate center wall back to straight and move in lateral wall*/
                        c_ang_pos = -90*(2 - cur_branch_dist/branch_compensate_dist);
                        r_lat_pos = cor_pos + offset_dist*(2 - cur_branch_dist/branch_compensate_dist);
                        c_lat_pos = cor_pos - cor_width/2 + update_dist/2*(2 - cur_branch_dist/branch_compensate_dist);
                        l_lat_pos = cor_width - cor_pos;
                        c_for_pos = 0;
                        c_dead_end = 1;
                    } else {
                        c_ang_pos = 0;
                        r_lat_pos = cor_pos;
                        l_lat_pos = cor_width - cor_pos;
                        c_lat_pos = cor_pos - cor_width/2;
                        c_for_pos = 0;
                        c_dead_end = 1;
                    }
                } else if (split_child == 1) {
                    /* if in left child of split branch */
                    if (cur_branch_dist < branch_compensate_dist) {
                        /* move far lateral wall in behind rotated center wall */
                        c_ang_pos = -90;
                        r_lat_pos = cor_pos + update_dist*(1-cur_branch_dist/branch_compensate_dist)+offset_dist*cur_branch_dist/branch_compensate_dist;
                        c_lat_pos = cor_pos - cor_width/2 + update_dist/2;
                        l_lat_pos = cor_width - cor_pos;
                        c_for_pos = 0;
                    } else if (cur_branch_dist >= branch_compensate_dist && cur_branch_dist < branch_compensate_dist*2) {
                        /* move rotated center wall away from mouse */
                        c_ang_pos = -90;
                        r_lat_pos = cor_pos + offset_dist;
                        c_lat_pos = cor_pos - cor_width/2 + update_dist/2;
                        l_lat_pos = cor_width - cor_pos;
                        c_for_pos = max_wall_for_pos*(cur_branch_dist/branch_compensate_dist - 1);
                    } else if (cur_branch_dist >= branch_compensate_dist*2 && cur_branch_dist < branch_compensate_dist*3) {
                        /* move center wall back to center, rotate center wall back to straight and move in lateral wall*/
                        c_ang_pos = -90*(3 - cur_branch_dist/branch_compensate_dist);
                        r_lat_pos = cor_pos + offset_dist*(3 - cur_branch_dist/branch_compensate_dist);
                        c_lat_pos = cor_pos - cor_width/2 + update_dist/2*(3 - cur_branch_dist/branch_compensate_dist);
                        l_lat_pos = cor_width - cor_pos;
                        c_for_pos = max_wall_for_pos;
                    } else {
                        c_ang_pos = 0;
                        r_lat_pos = cor_pos;
                        l_lat_pos = cor_width - cor_pos;
                        c_lat_pos = cor_pos - cor_width/2;
                        c_for_pos = max_wall_for_pos;
                    }
                } else if (split_child == 2 && (branch_left_end[cur_trial_num][cur_branch] == -1 ||  branch_right_end[cur_trial_num][cur_branch] == -1)) {
                    /* if in right child of split branch */
                    if (cur_branch_dist < branch_compensate_dist) {
                        /* move far lateral wall in behind rotated center wall */
                        c_ang_pos = 90;
                        r_lat_pos = cor_pos;
                        c_lat_pos = cor_pos - cor_width/2 - update_dist/2;
                        l_lat_pos = cor_width - cor_pos + update_dist*(1-cur_branch_dist/branch_compensate_dist)+offset_dist*cur_branch_dist/branch_compensate_dist;
                        c_for_pos = 0;
                    } else if (cur_branch_dist >= branch_compensate_dist && cur_branch_dist < branch_compensate_dist*2) {
                        /* move center wall back to center, rotate center wall back to straight and move in lateral wall*/
                        c_ang_pos = 90*(2 - cur_branch_dist/branch_compensate_dist);
                        r_lat_pos = cor_pos;
                        c_lat_pos = cor_pos - cor_width/2 - update_dist/2*(2 - cur_branch_dist/branch_compensate_dist);
                        l_lat_pos = cor_width - cor_pos + offset_dist*(2 - cur_branch_dist/branch_compensate_dist);
                        c_for_pos = 0;
                    } else {
                        c_ang_pos = 0;
                        r_lat_pos = cor_pos;
                        l_lat_pos = cor_width - cor_pos;
                        c_lat_pos = cor_pos - cor_width/2;
                        c_for_pos = 0;
                    }
                } else if (split_child == 2) {
                    /* if in right child of split branch */
                    if (cur_branch_dist < branch_compensate_dist) {
                        /* move far lateral wall in behind rotated center wall */
                        c_ang_pos = 90;
                        r_lat_pos = cor_pos;
                        c_lat_pos = cor_pos - cor_width/2 - update_dist/2;
                        l_lat_pos = cor_width - cor_pos + update_dist*(1-cur_branch_dist/branch_compensate_dist)+offset_dist*cur_branch_dist/branch_compensate_dist;
                        c_for_pos = 0;
                        c_dead_end = 0;
                    } else if (cur_branch_dist >= branch_compensate_dist && cur_branch_dist < branch_compensate_dist*2) {
                        /* move rotated center wall away from mouse */
                        c_ang_pos = 90;
                        r_lat_pos = cor_pos;
                        c_lat_pos = cor_pos - cor_width/2 - update_dist/2;
                        l_lat_pos = cor_width - cor_pos + offset_dist;
                        c_for_pos = max_wall_for_pos*(cur_branch_dist/branch_compensate_dist - 1);
                        c_dead_end = 1;
                    } else if (cur_branch_dist >= branch_compensate_dist*2 && cur_branch_dist < branch_compensate_dist*3) {
                        /* move center wall back to center, rotate center wall back to straight and move in lateral wall*/
                        c_ang_pos = 90*(3 - cur_branch_dist/branch_compensate_dist);
                        r_lat_pos = cor_pos;
                        c_lat_pos = cor_pos - cor_width/2 - update_dist/2*(3 - cur_branch_dist/branch_compensate_dist);
                        l_lat_pos = cor_width - cor_pos + offset_dist*(3 - cur_branch_dist/branch_compensate_dist);
                        c_for_pos = max_wall_for_pos;
                        c_dead_end = 1;
                    } else {
                        c_ang_pos = 0;
                        r_lat_pos = cor_pos;
                        l_lat_pos = cor_width - cor_pos;
                        c_lat_pos = cor_pos - cor_width/2;
                        c_for_pos = max_wall_for_pos;
                    }
                } else if (branch_split[cur_trial_num][cur_branch] == 1) {
                    /* if in split branch */
                    r_lat_pos = cor_pos;
                    l_lat_pos = cor_width - cor_pos;
                    c_lat_pos = cor_pos - cor_width/2;
                    c_ang_pos = -180*c_lat_pos/maze_center_width[cur_trial_num];
                    if (c_ang_pos > 90) {
                        c_ang_pos = 90;
                    } else if (c_ang_pos < -90){
                        c_ang_pos = -90;
                    }
                    if (cur_branch_dist < branch_compensate_dist) {
                        /* if close to start of branch */
                        c_ang_pos = cur_branch_dist/branch_compensate_dist*c_ang_pos;
                    }
                    if (gain_val*(branch_length[cur_trial_num][cur_branch] - cur_branch_dist) < max_wall_for_pos) {
                        /* if near end of branch */
                        c_for_pos = gain_val*(branch_length[cur_trial_num][cur_branch] - cur_branch_dist);
                    } else {
                        c_for_pos = max_wall_for_pos;
                    }
                } else if (branch_left_end[cur_trial_num][cur_branch] == -1 ||  branch_right_end[cur_trial_num][cur_branch] == -1) {
                    /* if in dead end branch */
                    c_ang_pos = 0;
                    r_lat_pos = cor_pos;
                    l_lat_pos = cor_width - cor_pos;
                    c_lat_pos = cor_pos - cor_width/2;
                    if (gain_val*(branch_length[cur_trial_num][cur_branch] - cur_branch_dist) < max_wall_for_pos) {
                        /* if near end of branch */
                        c_for_pos = gain_val*(branch_length[cur_trial_num][cur_branch] - cur_branch_dist);
                        c_dead_end = 1;
                    } else {
                        c_for_pos = max_wall_for_pos;
                        c_dead_end = 0;
                    }
                } else {
                    /* if in normal branch */
                    c_ang_pos = 0;
                    r_lat_pos = cor_pos;
                    l_lat_pos = cor_width - cor_pos;
                    c_lat_pos = cor_pos - cor_width/2;
                    c_for_pos = max_wall_for_pos;
                }
                
                /* maze forward and lateral cordinates for display */
                maze_for_cord = branch_for_start[cur_trial_num][cur_branch] + cur_branch_dist;
                maze_lat_cord = (branch_r_lat_start[cur_trial_num][cur_branch] + cur_branch_dist*gain_val*tan(right_angle*3.141/180)) - cor_pos;
                
                /* turn screen off if appropriate */
                if (cur_trial_time <= maze_screen_on_time[cur_trial_num]) {
                    screen_on = 1;
                } else{
                    screen_on = 0;
                }
                
                /* determine if in reward patch and deliver water / update drinking timer*/
                /* Decide if delivering water */
                if (water_trig_on[cur_branch] == 0 && branch_reward[cur_trial_num][cur_branch] == 1){
                    if ((cur_branch_lat_frac >= maze_reward_patch[cur_trial_num][0]) && (cur_branch_lat_frac <= maze_reward_patch[cur_trial_num][1]) && (cur_branch_dist/branch_length[cur_trial_num][cur_branch] >= maze_reward_patch[cur_trial_num][2]) && (cur_branch_dist/branch_length[cur_trial_num][cur_branch] <= maze_reward_patch[cur_trial_num][3])) {
                        water_on = 1;
                        valve_open_time = round(valve_open_time_default*maze_reward_size[cur_trial_num]);
                        cur_drink_time = 1;
                        water_trig_on[cur_branch] = 1;
                    }
                }
            }
            
            /***********************************************************************************/
            /***********************************************************************************/
            /***********************************************************************************/
            /**************** SEND AO/DIO ******************************************************/
            /* Check bounds of wall positions and send aO */
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
            if (c_for_pos > max_wall_for_pos) {
                c_for_pos = max_wall_for_pos;
            }
            if (c_for_pos < 0) {
                c_for_pos = 0;
            }
            if (c_lat_pos > max_wall_pos) {
                c_lat_pos = max_wall_pos;
            }
            if (c_lat_pos < -max_wall_pos) {
                c_lat_pos = -max_wall_pos;
            }
            
            if (c_lat_pos > max_wall_pos/2) {
                c_lat_pos_mid = max_wall_pos/2;
                c_lat_pos_top = c_lat_pos - max_wall_pos/2;
            } else if (c_lat_pos <= max_wall_pos/2 && c_lat_pos > -max_wall_pos/2){
                c_lat_pos_mid = c_lat_pos;
                c_lat_pos_top = 0;
            } else {
                c_lat_pos_mid = -max_wall_pos/2;
                c_lat_pos_top = c_lat_pos + max_wall_pos/2;
            }
            
            /* Send AO for wall position */
            writeAO(c_wall_lat_ao_chan, c_wall_lat_ao_offset  + wall_mm_to_vlt(max_wall_pos/2 + c_lat_pos_mid));
            writeAO(maze_num_ao_chan, maze_num_ao_offset + wall_mm_to_vlt(max_wall_pos/2 + c_lat_pos_top));
            writeAO(r_wall_lat_ao_chan, r_wall_lat_ao_offset + wall_mm_to_vlt(r_lat_pos));
            writeAO(c_wall_for_ao_chan, c_wall_for_ao_offset  + wall_mm_to_vlt(c_for_pos));
            writeAO(l_wall_lat_ao_chan, l_wall_lat_ao_offset + wall_mm_to_vlt(l_lat_pos));
            writeAO(maze_for_ao_chan, maze_for_ao_offset  + wall_ang_to_vlt(c_ang_pos));
            
            /* Check bounds and output AO for forward, lateral maze cords */
            if (maze_for_cord > 199) {
                maze_for_cord = 199;
            }
            if (maze_for_cord < 0) {
                maze_for_cord = 0;
            }
            if (maze_lat_cord > 99) {
                maze_lat_cord = 99;
            }
            if (maze_lat_cord < -100) {
                maze_lat_cord = -100;
            }
            /*writeAO(maze_for_ao_chan, maze_for_ao_offset  + maze_for_to_vlt(maze_for_cord));*/
            writeAO(maze_lat_ao_chan, maze_lat_ao_offset + maze_lat_to_vlt(maze_lat_cord));
            
            if (c_dead_end){
                dead_end = 1;
            }
            
            if (water_on && dead_end == 0){
                correct = 1;
            }
            
            /* Check bounds and output AO for maze number */
            /* check in matlab not more than 100 mazes */
            /*writeAO(maze_num_ao_chan, maze_num_ao_offset  + maze_num_to_vlt(cur_trial_num));*/
            
            /* Check water */
            if (ext_valve_trig == 1 || ((water_dist > dist_thresh) && (dist_thresh < 200))){
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
            
            /* if drinking initiate increment */
            if (cur_drink_time > 0){
                cur_drink_time++;
            }
            
            if (water_on == 1 || water_on_ext == 1) {
                writeDIO(water_valve_trig, 1);
            } else {
                writeDIO(water_valve_trig, 0);
            }
            
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
            
            
            if (cur_trial_time < sound_on_length){
                sound_on = 1;
            } else {
                sound_on = 0;
            }
            
            /* Trial DO Triggers */
            writeDIO(sound_cue_trig, sound_on);
            writeDIO(screen_on_trig, screen_on);
            writeDIO(trial_iti_trig, inter_trial_trig);
            writeDIO(trial_on_trig, 1-inter_trial_trig);
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
            log_state_b = scim_state + 2*c_dead_end + 4*screen_on;
            log_state_c = 0 + 2*scim_logging + 4*water_on_ext;
            log_cur_state = 10000*log_state_c+1000*log_state_b+100*log_state_a + cur_trial_num;
            log_ball_motion = cam_vel_steps[0] + 36*cam_vel_steps[1] + 36*36*cam_vel_steps[2]+ 36*36*36*cam_vel_steps[3]; /* convert to cam_motion_vect for logging */
            log_wall_pos = round(10*cor_pos) + 1000*round(10*cor_width);
            /*log_maze_cord = floor(5*maze_for_cord) + 1000*floor(5*maze_lat_cord+500);*/
            log_maze_cord = round(20*cur_branch_dist) + 1000*cur_branch + 100000*0;
            
            /* log_cor_pos = cam_vel_ai_vlt[0]*1000;*/
            logValue("m", log_maze_cord);    /* stim code */
            logValue("b", log_ball_motion); /* ball_motion_vector code */
            logValue("w", log_wall_pos);       /* wall pos */
            logValue("s", log_cur_state);     /* state_vector code */
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
        c_for_pos = c_for_pos + .0005*(max_wall_for_pos - c_for_pos);
        c_lat_pos = c_lat_pos + .0005*(0 - c_lat_pos);
        c_ang_pos = c_ang_pos + .0005*(0 - c_ang_pos);
        
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
        if (c_for_pos > max_wall_for_pos) {
            c_for_pos = max_wall_for_pos;
        }
        if (c_for_pos < 0) {
            c_for_pos = 0;
        }
        if (c_lat_pos > max_wall_pos/2) {
            c_lat_pos = max_wall_pos/2;
        }
        if (c_lat_pos <  -max_wall_pos/2) {
            c_lat_pos =  -max_wall_pos/2;
        }
        
        writeAO(c_wall_lat_ao_chan, c_wall_lat_ao_offset  + wall_mm_to_vlt(max_wall_pos/2 + c_lat_pos));
        writeAO(r_wall_lat_ao_chan, r_wall_lat_ao_offset + wall_mm_to_vlt(r_lat_pos));
        writeAO(c_wall_for_ao_chan, c_wall_for_ao_offset  + wall_mm_to_vlt(c_for_pos));
        writeAO(l_wall_lat_ao_chan, l_wall_lat_ao_offset + wall_mm_to_vlt(l_lat_pos));
        
        writeAO(maze_num_ao_chan, maze_num_ao_offset);
        writeAO(maze_for_ao_chan,  maze_for_ao_offset  + wall_ang_to_vlt(c_ang_pos));
        writeAO(maze_lat_ao_chan, maze_lat_ao_offset);
        
        writeAO(iti_ao_chan, iti_ao_offset);
        writeAO(synch_ao_chan, synch_ao_offset);
        
        writeDIO(water_valve_trig, 0);
        writeDIO(wv_trig, 0);
        writeDIO(bv_trig, 0);
        writeDIO(trial_on_trig, 0);
        writeDIO(screen_on_trig, 0);
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
     * cur_trial_num = 0;
     * } else {
     * cur_trial_num = trial_num_sequence_length - 1;
     * }*/
    
    cur_trial_time = session_timeout + 1;
    first_trial = 1;

    l_lat_pos = max_wall_pos;
    r_lat_pos = max_wall_pos;
    c_lat_pos = 0;
    c_for_pos = max_wall_for_pos;
    c_ang_pos = 0;
    
    cor_width = (branch_r_lat_start[0][0])-(branch_l_lat_start[0][0]);
    cor_pos = cor_width/2;
    maze_start_dist = 0;
    maze_end_reached = 1;
    iti_reset = 1;

    for (ii = 0; ii < max_num_branches; ii++) {
        water_trig_on[ii] = 0;
    }

    writeAO(c_wall_lat_ao_chan, c_wall_lat_ao_offset  + wall_mm_to_vlt(max_wall_pos/2 + c_lat_pos));
    writeAO(r_wall_lat_ao_chan, r_wall_lat_ao_offset + wall_mm_to_vlt(r_lat_pos));
    writeAO(c_wall_for_ao_chan, c_wall_for_ao_offset  + wall_mm_to_vlt(c_for_pos));
    writeAO(l_wall_lat_ao_chan, l_wall_lat_ao_offset + wall_mm_to_vlt(l_lat_pos));
    
    writeAO(maze_num_ao_chan, maze_num_ao_offset);
    writeAO(maze_for_ao_chan, maze_for_ao_offset  + wall_ang_to_vlt(c_ang_pos));
    writeAO(maze_lat_ao_chan, maze_lat_ao_offset);
    
    writeAO(iti_ao_chan, iti_ao_offset);
    writeAO(synch_ao_chan, synch_ao_offset);
    
    writeDIO(water_valve_trig, 0);
    writeDIO(wv_trig, 0);
    writeDIO(bv_trig, 0);
    writeDIO(trial_iti_trig, 0);
    writeDIO(trial_on_trig, 0);
    writeDIO(synch_pulse, 0);
    writeDIO(trial_ephys_trig, 0);
    writeDIO(screen_on_trig, 0);
}

void cleanupfunc(void) {
    /* Set all channels to default values */
}

