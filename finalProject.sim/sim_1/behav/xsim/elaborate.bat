@echo off
REM ****************************************************************************
REM Vivado (TM) v2020.1 (64-bit)
REM
REM Filename    : elaborate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for elaborating the compiled design
REM
REM Generated by Vivado on Wed Dec 30 14:10:27 +0200 2020
REM SW Build 2902540 on Wed May 27 19:54:49 MDT 2020
REM
REM Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
REM
REM usage: elaborate.bat
REM
REM ****************************************************************************
echo "xelab -wto b92c5e164e354985a96b484d88825507 --incr --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot MainTB_behav xil_defaultlib.MainTB -log elaborate.log"
call xelab  -wto b92c5e164e354985a96b484d88825507 --incr --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot MainTB_behav xil_defaultlib.MainTB -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
