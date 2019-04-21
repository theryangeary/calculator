GHDL=ghdl
FLAGS=""

all: mux regfile calc

%: %.vhdl %_tb.vhdl
	$(GHDL) -a $@.vhdl $@_tb.vhdl
	$(GHDL) -e $@
	$(GHDL) -e $@_tb
	$(GHDL) -r $@_tb --vcd=$@.vcd
