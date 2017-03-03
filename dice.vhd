-- Preliminary finish project: 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity dice is
    Port ( CLK : in STD_LOGIC;
           R : in STD_LOGIC_VECTOR(2 downto 0); -- R0,R1,R2 to select number 
           S : in STD_LOGIC;    -- S is the button that "stops" the sequence and display result. 
           reset : in STD_LOGIC; -- Reset function sets it to default state. 
           M : in STD_LOGIC_VECTOR(1 downto 0); -- M0, M1 to select mode of cheating. 
           an : out STD_LOGIC_VECTOR(3 downto 0); -- Uses this to select which 7-seg to display our result (default for us: 1110)
           led : out STD_LOGIC_VECTOR (6 downto 0); -- LED values. 
           seg : out STD_LOGIC_VECTOR (6 downto 0); -- 7-Segment display values
           dp : out STD_LOGIC);
end dice;
 
architecture Behavioral of dice is
type eg_state_type is (s0, s1, s2, s3, s4, s5, s6, s7);
signal state_reg, state_next: eg_state_type;
signal s_value, l_value : std_logic_vector(6 downto 0);

begin

    process (CLK, reset)
     begin
        if (reset = '1') then   -- if reset is "pressed"/active, reset sequence and set state_reg to s0;
           state_reg <= s0;
        end if;
        
        if(CLK'event and CLK = '1') then -- Says that on Clock event and clock high, set state_reg to be state_next
            state_reg <= state_next;
        end if;
    end process;
    
process(state_reg, s, m, r)
  
     begin
        an <= "1110"; -- Select that the rightmost 7-seg is the on displaying our result.
        dp <='1'; -- Removes light from  "DOT" in the 7-seg display
        if(s = '0') then -- Says that if Button S is not pressed, the 7-seg will be turned off.
            led <= "0000000"; -- Set it to be blank or turned off.
            seg <= "1111111";
        end if;
        
    case state_reg is
        when s0 => -- Value on dice : 1
            if(s = '1') then 
                led <= "0001000"; -- If button Stop is pressed: show values for s0 = 1 on 7-seg and LEDs.
                seg <= "1111001";     -- Loops back and display s0 until button is released.  
                state_next <= s0;       
                
            elsif (m="01") and (r = "001")then -- Predefined: If predefined is active: repeat s0
                state_next <= s0;    -- repeats and loops s0 so predefined works. 
                
            elsif (m="10") and (r = "010")then -- Forbidden: if "S1" is forbidden:
                state_next <= s2;              -- This "Skips" the S1-state and jumps straight to S2 if R = '010' (2)
                
            elsif (m="11") and (r = "001")then  -- Tripple probability: Activates l_value and s_value  
                l_value <= "0001000";           -- These are used in s6 and s7 to show the value chosen by R.   
                s_value <= "1111001";           -- s6 and s7 is activated in a statement in s5 IF M="11".
                state_next <= s1;                   
            else
                state_next <= s1;       -- This is to go to next state in process, if non of the IFs is activated.
            end if;
-- The same goes for s1-s4, s5 is a little bit different. See comments
                --
        when s1 => -- Value on dice : 2
            if(s = '1') then
                led <= "0010100";
                seg <= "0100100";
                state_next <= s1;
            elsif (m="01") and (r = "010")then -- Predefined
                state_next <= s1;
            elsif (m="10") and (r = "011")then -- Forbidden
                state_next <= s3;                   -- Forbidden
            elsif (m="11") and (r = "010")then  -- 3x 
                 l_value <= "0010100";
                 s_value <= "0100100";
                 state_next <= s2;
            else
                state_next <= s2;
            end if;
            
            --
                
        when s2 => -- Value on dice : 3
            if(s = '1') then
                led <= "0011100";
                seg <= "0110000";
                state_next <= s2;
            elsif (m="01") and (r = "011")then
                state_next <= s2;   
            elsif (m="10") and (r = "100")then 
                state_next <= s4;
            elsif (m="11") and (r = "011")then
                 l_value <= "0011100";
                 s_value <= "0110000";
                 state_next <= s3;
            else
                state_next <= s3;
            end if;
            
            --
                
        when s3 => -- Value on dice : 4 
            if(s = '1') then
                led <= "1010101";
                seg <= "0011001";
                state_next <= s3;
            elsif (m="01") and (r = "100")then
                 state_next <= s3;   
            elsif (m="10") and (r = "101")then 
                 state_next <= s5;
            elsif (m="11") and (r = "100")then
                 l_value <= "1010101";
                 s_value <= "0011001";
                 state_next <= s4;
            else
                state_next <= s4;
            end if;
            
            --
                
        when s4 => -- Value on dice : 5
            if(s = '1') then
                led <= "1011101";
                seg <= "0010010";
                state_next <= s4;
            elsif (m="01") and (r = "101")then
                state_next <= s4;   
            elsif (m="10") and (r = "110")then 
                state_next <= s0;
            elsif (m="11") and (r = "101")then
                l_value <= "1011101";
                s_value <= "0010010";
                state_next <= s5;
                        
             else
                state_next <= s5;
             end if;
             
                --
                
        when s5 => -- Value on dice : 6
             if(s = '1') then -- if stop is pressed, show values for s5 = number 6
                led <= "1110111";
                seg <= "0000010";
                state_next <= s5; -- loop back and show result until button released. 
                
             elsif (m="01") and (r = "110")then -- if predefined is 6: loop state s5
                state_next <= s5;   -- loops if predefined.
                
             elsif (m="10") and (r = "001")then -- If number 1 is forbidden, skip s0 and go directly to s1;
                state_next <= s1; -- Skips s0.
                
             elsif(M = "11") then -- If true, this makes state_next to s6 and therefor increases the probability.
                if (r="110") then -- This is to ensure that s5 gets tripple probability if it is the one chosen.
                    l_value <= "1110111"; -- sets values if s5(number 6) should have tripple probability.
                    s_value <= "0000010";
                end if;
                state_next <= s6; -- Include two extra states to increase probability: It becomes 3/8 to 1/8 for the others.
                
                if ( r="000" or r = "111") then -- In case someone tries to use 3x. prob when no R-value is chosen. 
                    state_next <= s0; -- Run as normal. 
                end if;
                
             else
                state_next <= s0; -- This make the sequence go back to s0 if nothing else is happening. 
             end if;
             
            --
               
        when s6 =>
                    
             if(s = '1') then
                 led <= l_value; -- Declared by the number of which is chose to have tripple probability. 
                 seg <= s_value;
                 state_next <= s6; -- If stop is pressed: loop and show values for s6, which would be declared by r"xxx".
             else
                 state_next <= s7; -- If not pressed, go to s7; 
             end if;
            
            --
            
        when s7 =>
                    
             if(s = '1') then
                 led <= l_value;
                 seg <= s_value;
                 state_next <= s7; -- If stop is pressed: loop and show walues for s7, which would be declared by r"xxx".
             else
                 state_next <= s0; -- If button is not pressed, go back to s0
             end if;
             
        when others => 
                led <= "0000000"; -- Blank
                seg <= "1111111";
    end case;
         
end process;
     
end Behavioral;