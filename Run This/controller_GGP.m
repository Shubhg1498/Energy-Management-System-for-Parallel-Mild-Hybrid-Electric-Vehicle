%%
% Group 14 - Seminar Electromobility
% Names:
% Member 1 : Shubham Gorade
% Member 2 : Shubham Ghogare
% Member 3 : Indrajit Patil
%%
function u = controller_GGP(input)

w_MGB = input(1);            % get flywheel angular velocity
dw_MGB = input(2);           % get flywheel angular acceleration
T_MGB = input(3);            % get flywheel torque
Q_BT  = input(4);            % get battery SOC 
theta_EM = 0.1;              % define motor inertia

global w_EM_max;             % define maximum motor angular velocity (global) 
global T_EM_max;             % define maximum motor torque (global)
global stoptime;             % define global variable for cycle selection  

if stoptime == 1877 % Select Parameters for FTP75
T_MGB_th = 88;        %Upper limit thresold   
T_MGB_th1 = 31.5;         %Lower limit thresold
u_LPS_min = -0.212;     %Minimum Torque split ratio for generator mode LPS

elseif stoptime == 1220  % Select Parameters for NEDC
T_MGB_th = 59.6;     %Upper limit thresold
T_MGB_th1 = 31;      %Lower limit thresold
u_LPS_min = -0.601;  %Minimum Torque split ratio for generator mode LPS

else                    %Gives a warning if selected cycle is other than FTP75 & NEDC
     warning('Unexpected Cycle Type Selected.')
end

Q_BT_max = 24500;       %SOC upper limit
Q_BT_min = 6000;        %SOC upper limit

epsilon = 0.01;              % define epsilon 
u_LPS_max = 0.3;             % define maximum torque-split factor for LPS (cf. Slide 3-8)

if T_MGB<0   % Regeneration 
   u= min((interp1(w_EM_max,-T_EM_max,w_MGB)+abs(theta_EM*dw_MGB)+epsilon)/T_MGB,1);                  % Torque- Split Ratio calculation

elseif ((T_MGB>=T_MGB_th) && (Q_BT > Q_BT_max))  % Motor mode 
   u= min((interp1(w_EM_max,T_EM_max,w_MGB)-abs(theta_EM*dw_MGB)-epsilon)/T_MGB,u_LPS_max);          % Torque-split ratio calculation     

elseif ((T_MGB >=T_MGB_th1) && (T_MGB<T_MGB_th)&&(Q_BT < Q_BT_max))   % Generator mode
   u = max((interp1(w_EM_max,-T_EM_max,w_MGB)+abs(theta_EM*dw_MGB)+epsilon)/T_MGB,u_LPS_min);            % Torque- Split Ratio calculation

elseif ((T_MGB < T_MGB_th1)&&( Q_BT > Q_BT_min))  % Electric driving mode                                        % Electric Drive Mode                                                                
   u = 1;  
  
else  % Conventional driving mode
   u = 0;
   
end

    
