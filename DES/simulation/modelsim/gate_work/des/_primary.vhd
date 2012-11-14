library verilog;
use verilog.vl_types.all;
entity des is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        mode            : in     vl_logic;
        din             : in     vl_logic_vector(1 to 64);
        key             : in     vl_logic_vector(1 to 64);
        dout            : out    vl_logic_vector(1 to 64);
        oflag           : out    vl_logic
    );
end des;
