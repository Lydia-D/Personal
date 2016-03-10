%% Test Conversions and Preliminary Questions
%
% Author: Kelvin Hsu
% AERO4701, 2016

% Clear everything
clc;
clear;
close all;

% Organise your files into meaningful folders
% Each assignment can get very big: Avoid cluttering your folder and hence
% your thoughts. Spend some time modularising your code base as clearly and
% simply as possible.
addpath('./scripts_general', './scripts_prelim', ...
        './module_conversion', './module_testing');

% Obtain the constants we need
% Avoid re-defining constants that will always stay the same
constants();
global r_earth;


%% Basic Conversions regarding Satellite Positions

% Initialise a position in ECI and the times
pos_eci = r_earth + 1e4 * rand(3, 1);
t = 12 * 60 * 60;

% Convert it to a position in ECEF
pos_ecef = eci2ecef(pos_eci, t);

% Test: ECEF to ECI
assert_allclose(pos_eci, ecef2eci(pos_ecef, t), 'quantity1 = ''ECI''', 'quantity2 = ''ECI from ECEF''');

% Test: ECEF to LLHGC
pos_llhgc = ecef2llhgc(pos_ecef);
assert_allclose(pos_ecef, llhgc2ecef(pos_llhgc), 'quantity1 = ''ECEF''', 'quantity2 = ''ECEF from LLHGC''');

% Test: ECEF to LLHGD
pos_llhgd = ecef2llhgd(pos_ecef);
assert_allclose(pos_ecef, llhgd2ecef(pos_llhgd), 'quantity1 = ''ECEF''', 'quantity2 = ''ECEF from LLHGD''');

%% Conversions regarding Satellite Positions relative to a Ground Station

% Initialise ground station coordinates in LLHGD
pos_llhgd_ground = [rand * pi/4; rand * pi/4; 0];

% Convert the ground station coordinates to ECEF
pos_ecef_ground = llhgd2ecef(pos_llhgd_ground);

% Obtain the position of the satellite relative to the ground in ECEF
pos_ecef_obs = pos_ecef - pos_ecef_ground;

% Convert it to LLHGD
pos_lgdv_obs = ecef2lg(pos_ecef_obs, pos_llhgd_ground);

% Test: ECEF to LGDV
assert_allclose(pos_ecef_obs, lg2ecef(pos_lgdv_obs, pos_llhgd_ground), 'quantity1 = ''ECEF''', 'quantity2 = ''ECEF from LGDV''');

% Convert the ground station coordinates to LLHGC
pos_llhgc_ground = ecef2llhgc(pos_ecef_ground);

% Convert the relative satellite position to LGCV
pos_lgcv_obs = ecef2lg(pos_ecef_obs, pos_llhgc_ground);

% Test: ECEF to LGCV
assert_allclose(pos_ecef_obs, lg2ecef(pos_lgcv_obs, pos_llhgc_ground), 'quantity1 = ''ECEF''', 'quantity2 = ''ECEF from LGCV''');

% Convert the relative satellite position to polar coordinates
pos_lgcv_obs_polar = cartesian2polar(pos_lgcv_obs);

% Test: Cartesian to Polar
assert_allclose(pos_lgcv_obs, polar2cartesian(pos_lgcv_obs_polar), 'tol = 1e-5', 'quantity1 = ''Cartesian''', 'quantity2 = ''Polar''');

%% Preliminary Questions

% Preliminaries Question 1.1
pos_ecef_true = [-6402560; 3199449; -4152797];
assert_allclose(prelim_q1_1(), pos_ecef_true, 'tol = 1e3', 'pass_msg = ''Q1.1 passed''', 'fail_msg = ''Answer to Preliminary Question 1.1 is incorrect''');

% Preliminaries Question 1.2
pos_eci_true = [-6403959; 3196647; -4152797];
assert_allclose(prelim_q1_2(), pos_eci_true, 'tol = 1e3', 'pass_msg = ''Q1.2 passed''', 'fail_msg = ''Answer to Preliminary Question 1.2 is incorrect''');

% Preliminaries Question 2.1
% UPDATE: Use the following in 'prelim_q2_1()'
%     sat.pos_ecef = [-6763200; 3940900; 5387700];
%     station.pos_lgcvp_wrt_sat = [3852736; deg2rad(-65.6); deg2rad(-61.86)];
pos_llhgc_true = [deg2rad(39.8280); deg2rad(129.9995); -8237];
pos_llhgc_computed = prelim_q2_1();
assert_allclose(pos_llhgc_computed(1:2), pos_llhgc_true(1:2), 'tol = 1e-2', 'pass_msg = ''Q2.1.1 passed''', 'fail_msg = ''Answer to Preliminary Question 2.1.1 is incorrect''');
assert_allclose(pos_llhgc_computed(3), pos_llhgc_true(3), 'tol = 1e+2', 'pass_msg = ''Q2.1.2 passed''', 'fail_msg = ''Answer to Preliminary Question 2.1.2 is incorrect''');

% Preliminaries Question 2.2
% UPDATE: Use the following in 'prelim_q2_2()'
%     sat.pos_ecef = [-6763200; 3940900; 5387700];
%     station.pos_lgcvp_wrt_sat = [3852736; deg2rad(-65.6); deg2rad(-61.86)];
pos_llhgd_true = [deg2rad(40.0174); deg2rad(129.9995); 562];
pos_llhgd_computed = prelim_q2_2();
assert_allclose(pos_llhgd_computed(1:2), pos_llhgd_true(1:2), 'tol = 1e-2', 'pass_msg = ''Q2.2.1 passed''', 'fail_msg = ''Answer to Preliminary Question 2.2.1 is incorrect''');
assert_allclose(pos_llhgd_computed(3), pos_llhgd_true(3), 'tol = 1e+2', 'pass_msg = ''Q2.2.2 passed''', 'fail_msg = ''Answer to Preliminary Question 2.2.2 is incorrect''');

% Preliminaries Question 3.1
% UPDATE: Use the same values from Question 2, except you do not have the 
% range observation anymore, so that you only have
% [deg2rad(-65.6); deg2rad(-61.86)]
pos_llhgc_sea_level_true = deg2rad([39.8123; 130.0926;]);
pos_llhgc_sea_level_computed = prelim_q3_1();
assert_allclose(pos_llhgc_sea_level_computed(1:2), pos_llhgc_sea_level_true, 'tol = 1e-2', 'pass_msg = ''Q3.1 passed''', 'fail_msg = ''Answer to Preliminary Question 3.1 is incorrect''');

% Preliminaries Question 3.2
% UPDATE: Use the same values from Question 2, except you do not have the 
% range observation anymore, so that you only have
% [deg2rad(-65.6); deg2rad(-61.86)]
pos_llhgd_sea_level_true = deg2rad([40.0185; 129.9931]);
pos_llhgd_sea_level_computed = prelim_q3_2();
assert_allclose(pos_llhgd_sea_level_computed(1:2), pos_llhgd_sea_level_true, 'tol = 1e-2', 'pass_msg = ''Q3.2 passed''', 'fail_msg = ''Answer to Preliminary Question 3.2 is incorrect''');
