@echo off
set xv_path=C:\\Xilinx-Vivado\\Vivado\\2016.2\\bin
call %xv_path%/xelab  -wto df9b108d6e714696b7953cc016266206 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot topmodule_behav xil_defaultlib.topmodule xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
