stop=0
echo "------------------------------------------"
echo " > Select Command:"
echo "1.Compile Software."
echo "2.HDL Simulate SoC."
echo "3.HDL Simulate RISCV Core."
echo "4.Python Simulate and Compile RISCV program."
echo "------------------------------------------"
echo " Enter Number to Run. Enter Any Key Else to Quit."
read -p "Enter: " choice

if [ "$choice" = "1" ]; then
    echo -e "\n Use python ./compiler/dust ./filename +debug +comment"
elif [ "$choice" = "2" ]; then
    cd ./simulate
    xmverilog ../soc/bus.sv \
    ../soc/buttom.sv \
    ../soc/clock.sv \
    ../soc/core.sv \
    ../soc/dualram.sv \
    ../soc/ram.sv \
    ../soc/rom.sv \
    ../soc/soc.sv \
    ../soc/tb_soc.sv \
    ../soc/uart.sv \
    +access+r +xmtimescale+1ns/10ps
    cd ..
elif [ "$choice" = "3" ]; then
    cd ./simulate
    xmverilog ../riscv/alu.sv \
    ../riscv/alucontrol.sv \
    ../riscv/control.sv \
    ../riscv/core.sv \
    ../riscv/immextend.sv \
    ../riscv/mux.sv \
    ../riscv/pc.sv \
    ../riscv/pccontrol.sv \
    ../riscv/ram.sv \
    ../riscv/regfile.sv \
    ../riscv/riscv32s.sv \
    ../riscv/rom.sv \
    ../riscv/stim.sv \
    +access+r +xmtimescale+1ns/10ps
    cd ..
elif [ "$choice" = "4" ]; then
    python ./compiler/dust.py
fi

if [ $stop -eq 0 ]; then
	echo -e "\n\n *********** Process Finished ************\n"
	echo -e "------------------------------------------\n"
else
	echo -e "\n Process Stopped.\n"
	echo -e "------------------------------------------\n"
fi
