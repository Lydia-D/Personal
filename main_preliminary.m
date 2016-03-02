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

% Preliminaries Question 1
% (1) ECEF = [-6.4061e6 ; 3.2042e6; -4.1331e6]
pos_ecef_true = [-6.4061e6 ; 3.2042e6; -4.1331e6];
assert_allclose(prelim_q1_1(), pos_ecef_true, 'tol = 1e-5', 'pass_msg = ''Q1.1 passed''', 'fail_msg = ''Answer to Preliminary Question 1.1 is incorrect''');

% (2) ECI = [-3.1766e6; -6.4199e6; -4.1331e6]
pos_eci_true = [-3.1766e6; -6.4199e6; -4.1331e6];
assert_allclose(prelim_q1_2(), pos_eci_true, 'tol = 1e-5', 'pass_msg = ''Q1.2 passed''', 'fail_msg = ''Answer to Preliminary Question 1.2 is incorrect''');

% Preliminaries Question 2
% (1) LLH_geocentric = [16.7695; 130.8204; 1.8608e6]
pos_llhgc_true = [16.7695; 130.8204; 1.8608e6];
assert_allclose(prelim_q2_1(), pos_llhgc_true, 'tol = 1e-5', 'pass_msg = ''Q1.3 passed''', 'fail_msg = ''Answer to Preliminary Question 2.1 is incorrect''');

% (2) LLH_geodetic = [16.8519; 130.8204; 1.8625e6]
pos_llhgd_true = [16.8519; 130.8204; 1.8625e6];
assert_allclose(prelim_q2_2(), pos_llhgd_true, 'tol = 1e-5', 'pass_msg = ''Q1.4 passed''', 'fail_msg = ''Answer to Preliminary Question 2.2 is incorrect''');
