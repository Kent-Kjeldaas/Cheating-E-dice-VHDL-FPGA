library ieee;
use ieee.std_logic_1164.all;
 
entity dice_tb is
end dice_tb;
 
architecture tb of dice_tb is
 
    component dice
        port (  CLK : in std_logic;
                R     : in std_logic_vector(2 downto 0);
                S     : in std_logic;
                M     : in std_logic_vector(1 downto 0);
                reset : in std_logic;
                led  : out std_logic_vector(6 downto 0);
                seg   : out std_logic_vector(6 downto 0)
            );
    end component;
 
    --Inputs
    signal clk  : std_logic := '0';
    signal S    : std_logic := '0' ;
    signal R    : std_logic_vector(2 downto 0);
    signal M    : std_logic_vector(1 downto 0);
    signal reset : std_logic := '0';
    --Outputs
    signal led  : std_logic_vector(6 downto 0);
    signal seg  : std_logic_vector(6 downto 0);
    
    
    constant clk_period : time := 10 ns;
 
begin
 
    uut : dice port map (clk => clk, 
                         led=> led,
                         seg => seg,
                         r => r,
                         m => m,
                         reset => reset,
                         s => s);
 
 -- Clock Process:
clk_process : process
   begin
      clk <= '0';
      wait for clk_period/2;
      clk <= '1';
     wait for clk_period/2;
     
   end process;
 
-- Stimuli process

   stim_proc: process
      begin                
        s <= '1';      
            wait for clk_period*2;
        s <= '0';      
            wait for clk_period*5; 
        
    end process ;
       
    stim_procM: process
       begin
              m <= "00";
                wait for 500 ns;
              m <= "01";
                wait for 500 ns;
              m <= "10";
                wait for 500 ns;
              m <= "11";
                wait for 500 ns;
              
    end process;
       
    stim_proc_R: process
       begin
            r <= "000";
                wait for 83 ns;
            r <= "001";
                wait for 83 ns;
            r <= "010";
                wait for 83 ns;
            r <= "011";
                wait for 83 ns;
            r <= "100";
                wait for 83 ns;
            r <= "101";
                wait for 83 ns;
            r <= "110";
                wait for 83 ns;
            r <= "111";
                wait for 83 ns;
                
    end process;
      
end tb;