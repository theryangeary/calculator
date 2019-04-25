GHDL=ghdl
FLAGS= --ieee=standard

all: mux full_adder add_sub regfile clockfile calc

%: %.vhdl %_tb.vhdl
	$(GHDL) -a $(FLAGS) $@.vhdl $@_tb.vhdl
	$(GHDL) -e $(FLAGS) $@
	$(GHDL) -e $(FLAGS) $@_tb
	$(GHDL) -r $@_tb --vcd=$@.vcd

