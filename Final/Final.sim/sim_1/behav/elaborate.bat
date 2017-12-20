@echo off
set xv_path=C:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xelab  -wto 883feeae0ec24ae0a3fcef6c3634941c -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot robotsim_behav xil_defaultlib.robotsim -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
