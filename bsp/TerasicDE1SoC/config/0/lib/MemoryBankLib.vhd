LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

package TerasicDE1SoCMem is

    COMPONENT MemBank32Kx32 IS
      	PORT
      	(
      		address_a		: IN STD_LOGIC_VECTOR (14 DOWNTO 0);
      		address_b		: IN STD_LOGIC_VECTOR (14 DOWNTO 0);
      		clock		: IN STD_LOGIC  := '1';
      		data_a		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      		data_b		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      		rden_a		: IN STD_LOGIC  := '1';
      		rden_b		: IN STD_LOGIC  := '1';
      		wren_a		: IN STD_LOGIC  := '0';
      		wren_b		: IN STD_LOGIC  := '0';
      		q_a		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      		q_b		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
      	);
    END COMPONENT;

    COMPONENT MemBank64Kx16 IS
      	PORT
      	(
      		address_a		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
      		address_b		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
      		clock		: IN STD_LOGIC  := '1';
      		data_a		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
      		data_b		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
      		rden_a		: IN STD_LOGIC  := '1';
      		rden_b		: IN STD_LOGIC  := '1';
      		wren_a		: IN STD_LOGIC  := '0';
      		wren_b		: IN STD_LOGIC  := '0';
      		q_a		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
      		q_b		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
      	);
    END COMPONENT;

    COMPONENT MemBank64Kx8 IS
      	PORT
      	(
      		address_a		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
      		address_b		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
      		clock		: IN STD_LOGIC  := '1';
      		data_a		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      		data_b		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      		rden_a		: IN STD_LOGIC  := '1';
      		rden_b		: IN STD_LOGIC  := '1';
      		wren_a		: IN STD_LOGIC  := '0';
      		wren_b		: IN STD_LOGIC  := '0';
      		q_a		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      		q_b		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
      	);
    END COMPONENT;

    COMPONENT MemBank16Kx4 IS
      	PORT
      	(
      		address_a		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
      		address_b		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
      		clock		: IN STD_LOGIC  := '1';
      		data_a		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      		data_b		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      		rden_a		: IN STD_LOGIC  := '1';
      		rden_b		: IN STD_LOGIC  := '1';
      		wren_a		: IN STD_LOGIC  := '0';
      		wren_b		: IN STD_LOGIC  := '0';
      		q_a		: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
      		q_b		: OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
      	);
    END COMPONENT;

    COMPONENT MemBank32Kx1 IS
      	PORT
      	(
      		address_a		: IN STD_LOGIC_VECTOR (14 DOWNTO 0);
      		address_b		: IN STD_LOGIC_VECTOR (14 DOWNTO 0);
      		clock		: IN STD_LOGIC  := '1';
      		data_a		: IN STD_LOGIC_VECTOR (0 DOWNTO 0);
      		data_b		: IN STD_LOGIC_VECTOR (0 DOWNTO 0);
      		rden_a		: IN STD_LOGIC  := '1';
      		rden_b		: IN STD_LOGIC  := '1';
      		wren_a		: IN STD_LOGIC  := '0';
      		wren_b		: IN STD_LOGIC  := '0';
      		q_a		: OUT STD_LOGIC_VECTOR (0 DOWNTO 0);
      		q_b		: OUT STD_LOGIC_VECTOR (0 DOWNTO 0)
      	);
    END COMPONENT;
  
end TerasicDE1SoCMem;

--------------------------------------
-- Memory bank AL and AH: 32K x 32bits
--------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY MemBank32Kx32 IS
	PORT
	(
		address_a		: IN STD_LOGIC_VECTOR (14 DOWNTO 0);
		address_b		: IN STD_LOGIC_VECTOR (14 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data_a		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		data_b		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		rden_a		: IN STD_LOGIC  := '1';
		rden_b		: IN STD_LOGIC  := '1';
		wren_a		: IN STD_LOGIC  := '0';
		wren_b		: IN STD_LOGIC  := '0';
		q_a		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		q_b		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END MemBank32Kx32;


ARCHITECTURE SYN OF membank32kx32 IS

	SIGNAL sub_wire0	: STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL sub_wire1	: STD_LOGIC_VECTOR (31 DOWNTO 0);

BEGIN
	q_a    <= sub_wire0(31 DOWNTO 0);
	q_b    <= sub_wire1(31 DOWNTO 0);

	altsyncram_component : altsyncram
	GENERIC MAP (
		address_reg_b => "CLOCK0",
		clock_enable_input_a => "BYPASS",
		clock_enable_input_b => "BYPASS",
		clock_enable_output_a => "BYPASS",
		clock_enable_output_b => "BYPASS",
		indata_reg_b => "CLOCK0",
		intended_device_family => "Cyclone V",
		lpm_type => "altsyncram",
		numwords_a => 32768,
		numwords_b => 32768,
		operation_mode => "BIDIR_DUAL_PORT",
		outdata_aclr_a => "NONE",
		outdata_aclr_b => "NONE",
		outdata_reg_a => "UNREGISTERED",
		outdata_reg_b => "UNREGISTERED",
		power_up_uninitialized => "FALSE",
		ram_block_type => "M10K",
		read_during_write_mode_mixed_ports => "OLD_DATA",
		read_during_write_mode_port_a => "NEW_DATA_NO_NBE_READ",
		read_during_write_mode_port_b => "NEW_DATA_NO_NBE_READ",
		widthad_a => 15,
		widthad_b => 15,
		width_a => 32,
		width_b => 32,
		width_byteena_a => 1,
		width_byteena_b => 1,
		wrcontrol_wraddress_reg_b => "CLOCK0"
	)
	PORT MAP (
		address_a => address_a,
		address_b => address_b,
		clock0 => clock,
		data_a => data_a,
		data_b => data_b,
		rden_a => rden_a,
		rden_b => rden_b,
		wren_a => wren_a,
		wren_b => wren_b,
		q_a => sub_wire0,
		q_b => sub_wire1
	);

END SYN;

--------------------------------------
-- Memory bank BL and BH: 64K x 16bits
--------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY MemBank64Kx16 IS
	PORT
	(
		address_a		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		address_b		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data_a		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		data_b		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		rden_a		: IN STD_LOGIC  := '1';
		rden_b		: IN STD_LOGIC  := '1';
		wren_a		: IN STD_LOGIC  := '0';
		wren_b		: IN STD_LOGIC  := '0';
		q_a		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		q_b		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END MemBank64Kx16;


ARCHITECTURE SYN OF membank64kx16 IS

	SIGNAL sub_wire0	: STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL sub_wire1	: STD_LOGIC_VECTOR (15 DOWNTO 0);

BEGIN
	q_a    <= sub_wire0(15 DOWNTO 0);
	q_b    <= sub_wire1(15 DOWNTO 0);

	altsyncram_component : altsyncram
	GENERIC MAP (
		address_reg_b => "CLOCK0",
		clock_enable_input_a => "BYPASS",
		clock_enable_input_b => "BYPASS",
		clock_enable_output_a => "BYPASS",
		clock_enable_output_b => "BYPASS",
		indata_reg_b => "CLOCK0",
		intended_device_family => "Cyclone V",
		lpm_type => "altsyncram",
		numwords_a => 65536,
		numwords_b => 65536,
		operation_mode => "BIDIR_DUAL_PORT",
		outdata_aclr_a => "NONE",
		outdata_aclr_b => "NONE",
		outdata_reg_a => "UNREGISTERED",
		outdata_reg_b => "UNREGISTERED",
		power_up_uninitialized => "FALSE",
		ram_block_type => "M10K",
		read_during_write_mode_mixed_ports => "OLD_DATA",
		read_during_write_mode_port_a => "NEW_DATA_NO_NBE_READ",
		read_during_write_mode_port_b => "NEW_DATA_NO_NBE_READ",
		widthad_a => 16,
		widthad_b => 16,
		width_a => 16,
		width_b => 16,
		width_byteena_a => 1,
		width_byteena_b => 1,
		wrcontrol_wraddress_reg_b => "CLOCK0"
	)
	PORT MAP (
		address_a => address_a,
		address_b => address_b,
		clock0 => clock,
		data_a => data_a,
		data_b => data_b,
		rden_a => rden_a,
		rden_b => rden_b,
		wren_a => wren_a,
		wren_b => wren_b,
		q_a => sub_wire0,
		q_b => sub_wire1
	);

END SYN;

--------------------------------------
-- Memory bank CL and CH: 64K x 8bits
-- Memory bank DL and DH: 64K x 8bits
--------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY MemBank64Kx8 IS
	PORT
	(
		address_a		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		address_b		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data_a		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		data_b		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		rden_a		: IN STD_LOGIC  := '1';
		rden_b		: IN STD_LOGIC  := '1';
		wren_a		: IN STD_LOGIC  := '0';
		wren_b		: IN STD_LOGIC  := '0';
		q_a		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		q_b		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END MemBank64Kx8;


ARCHITECTURE SYN OF membank64kx8 IS

	SIGNAL sub_wire0	: STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL sub_wire1	: STD_LOGIC_VECTOR (7 DOWNTO 0);

BEGIN
	q_a    <= sub_wire0(7 DOWNTO 0);
	q_b    <= sub_wire1(7 DOWNTO 0);

	altsyncram_component : altsyncram
	GENERIC MAP (
		address_reg_b => "CLOCK0",
		clock_enable_input_a => "BYPASS",
		clock_enable_input_b => "BYPASS",
		clock_enable_output_a => "BYPASS",
		clock_enable_output_b => "BYPASS",
		indata_reg_b => "CLOCK0",
		intended_device_family => "Cyclone V",
		lpm_type => "altsyncram",
		numwords_a => 65536,
		numwords_b => 65536,
		operation_mode => "BIDIR_DUAL_PORT",
		outdata_aclr_a => "NONE",
		outdata_aclr_b => "NONE",
		outdata_reg_a => "UNREGISTERED",
		outdata_reg_b => "UNREGISTERED",
		power_up_uninitialized => "FALSE",
		read_during_write_mode_mixed_ports => "OLD_DATA",
		read_during_write_mode_port_a => "NEW_DATA_NO_NBE_READ",
		read_during_write_mode_port_b => "NEW_DATA_NO_NBE_READ",
		widthad_a => 16,
		widthad_b => 16,
		width_a => 8,
		width_b => 8,
		width_byteena_a => 1,
		width_byteena_b => 1,
		wrcontrol_wraddress_reg_b => "CLOCK0"
	)
	PORT MAP (
		address_a => address_a,
		address_b => address_b,
		clock0 => clock,
		data_a => data_a,
		data_b => data_b,
		rden_a => rden_a,
		rden_b => rden_b,
		wren_a => wren_a,
		wren_b => wren_b,
		q_a => sub_wire0,
		q_b => sub_wire1
	);

END SYN;

--------------------------------------
-- Memory bank EL and EH: 16K x 4bits
--------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY MemBank16Kx4 IS
	PORT
	(
		address_a		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		address_b		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data_a		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		data_b		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		rden_a		: IN STD_LOGIC  := '1';
		rden_b		: IN STD_LOGIC  := '1';
		wren_a		: IN STD_LOGIC  := '0';
		wren_b		: IN STD_LOGIC  := '0';
		q_a		: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		q_b		: OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
	);
END MemBank16Kx4;


ARCHITECTURE SYN OF membank16kx4 IS

	SIGNAL sub_wire0	: STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL sub_wire1	: STD_LOGIC_VECTOR (3 DOWNTO 0);

BEGIN
	q_a    <= sub_wire0(3 DOWNTO 0);
	q_b    <= sub_wire1(3 DOWNTO 0);

	altsyncram_component : altsyncram
	GENERIC MAP (
		address_reg_b => "CLOCK0",
		clock_enable_input_a => "BYPASS",
		clock_enable_input_b => "BYPASS",
		clock_enable_output_a => "BYPASS",
		clock_enable_output_b => "BYPASS",
		indata_reg_b => "CLOCK0",
		intended_device_family => "Cyclone V",
		lpm_type => "altsyncram",
		numwords_a => 16384,
		numwords_b => 16384,
		operation_mode => "BIDIR_DUAL_PORT",
		outdata_aclr_a => "NONE",
		outdata_aclr_b => "NONE",
		outdata_reg_a => "UNREGISTERED",
		outdata_reg_b => "UNREGISTERED",
		power_up_uninitialized => "FALSE",
		ram_block_type => "M10K",
		read_during_write_mode_mixed_ports => "OLD_DATA",
		read_during_write_mode_port_a => "NEW_DATA_NO_NBE_READ",
		read_during_write_mode_port_b => "NEW_DATA_NO_NBE_READ",
		widthad_a => 14,
		widthad_b => 14,
		width_a => 4,
		width_b => 4,
		width_byteena_a => 1,
		width_byteena_b => 1,
		wrcontrol_wraddress_reg_b => "CLOCK0"
	)
	PORT MAP (
		address_a => address_a,
		address_b => address_b,
		clock0 => clock,
		data_a => data_a,
		data_b => data_b,
		rden_a => rden_a,
		rden_b => rden_b,
		wren_a => wren_a,
		wren_b => wren_b,
		q_a => sub_wire0,
		q_b => sub_wire1
	);

END SYN;

--------------------------------------
-- Memory bank FL and FH: 32K x 1bits
-- Initialize with a character map
--------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY MemBank32Kx1 IS
	PORT
	(
		address_a		: IN STD_LOGIC_VECTOR (14 DOWNTO 0);
		address_b		: IN STD_LOGIC_VECTOR (14 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data_a		: IN STD_LOGIC_VECTOR (0 DOWNTO 0);
		data_b		: IN STD_LOGIC_VECTOR (0 DOWNTO 0);
		rden_a		: IN STD_LOGIC  := '1';
		rden_b		: IN STD_LOGIC  := '1';
		wren_a		: IN STD_LOGIC  := '0';
		wren_b		: IN STD_LOGIC  := '0';
		q_a		: OUT STD_LOGIC_VECTOR (0 DOWNTO 0);
		q_b		: OUT STD_LOGIC_VECTOR (0 DOWNTO 0)
	);
END MemBank32Kx1;


ARCHITECTURE SYN OF membank32kx1 IS

	SIGNAL sub_wire0	: STD_LOGIC_VECTOR (0 DOWNTO 0);
	SIGNAL sub_wire1	: STD_LOGIC_VECTOR (0 DOWNTO 0);

BEGIN
	q_a    <= sub_wire0(0 DOWNTO 0);
	q_b    <= sub_wire1(0 DOWNTO 0);

	altsyncram_component : altsyncram
	GENERIC MAP (
		address_reg_b => "CLOCK0",
		clock_enable_input_a => "BYPASS",
		clock_enable_input_b => "BYPASS",
		clock_enable_output_a => "BYPASS",
		clock_enable_output_b => "BYPASS",
		indata_reg_b => "CLOCK0",
		init_file => "CharTable.hex",
		intended_device_family => "Cyclone V",
		lpm_type => "altsyncram",
		numwords_a => 32768,
		numwords_b => 32768,
		operation_mode => "BIDIR_DUAL_PORT",
		outdata_aclr_a => "NONE",
		outdata_aclr_b => "NONE",
		outdata_reg_a => "UNREGISTERED",
		outdata_reg_b => "UNREGISTERED",
		power_up_uninitialized => "FALSE",
		ram_block_type => "M10K",
		read_during_write_mode_mixed_ports => "OLD_DATA",
		read_during_write_mode_port_a => "NEW_DATA_NO_NBE_READ",
		read_during_write_mode_port_b => "NEW_DATA_NO_NBE_READ",
		widthad_a => 15,
		widthad_b => 15,
		width_a => 1,
		width_b => 1,
		width_byteena_a => 1,
		width_byteena_b => 1,
		wrcontrol_wraddress_reg_b => "CLOCK0"
	)
	PORT MAP (
		address_a => address_a,
		address_b => address_b,
		clock0 => clock,
		data_a => data_a,
		data_b => data_b,
		rden_a => rden_a,
		rden_b => rden_b,
		wren_a => wren_a,
		wren_b => wren_b,
		q_a => sub_wire0,
		q_b => sub_wire1
	);

END SYN;


