
%% Function for engine start stop condition
function state_CE = Engine_start_stop_GGP(input)

w_MGB = input(1); % Gearbox angular velocity as an input
u = input(2);     % Torque split ration as an input

if (w_MGB == 0)   
   
   state_CE = 0;  % Engine off
   
elseif u==1
   
   state_CE = 0;
  
else 
    
   state_CE = 1;  % Engine on
   
end
