%% Taking data from Arena
%
% BVH is a text file which contains skeletal data, but its contents needs
% additional processing to draw the wireframe and create the animation.
%02_01	walk     %02_02	walk     %02_03	run/jog
%02_04	jump, balance %02_05 punch/strike %02_06	bend over, scoop up, rise, lift arm
%02_07	swordplay %02_08 swordplay %02_09	swordplay %02_10	wash self

%hand x2, leg x1
%name = '02_01new';
%name = '02_03left'; 
name = '02_05'; 
[skeleton,time] = loadbvh(name); 

%name1 = '02_01_01';
%name1 = '02_03new';
name1 = '02_05new'; %initially 02_05new
[skeleton_1,time1] = loadbvh2_same_location(name1);

%%
global all_pt;    
global p1;
global p2;
global p3;
write_video = false;
all_angle=[45 45 45];
xXx = [0 0 0;];
% Prepare the new video file.
if write_video, vidObj = VideoWriter(name); open(vidObj); end



%fincr = 10;    
fincr = 10; 
for ff = 1:fincr:length(time) %#ok<FORPF>

  h = figure(1); clf; hold on
  title(sprintf('%1.2f seconds',time(ff)))
  set(h,'color','white')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        %RETARGET
                        
%%################################ RIGHT ARM #########################%%%%%%%%%%
p1=[skeleton_1(33).Dxyz(3,ff);skeleton_1(33).Dxyz(1,ff);skeleton_1(33).Dxyz(2,ff)]; 
p2=[skeleton_1(32).Dxyz(3,ff);skeleton_1(32).Dxyz(1,ff);skeleton_1(32).Dxyz(2,ff)]; 
p3=[skeleton_1(31).Dxyz(3,ff);skeleton_1(31).Dxyz(1,ff);skeleton_1(31).Dxyz(2,ff)]; 
all_angle(1) = xXx(1, 1);
all_angle(2) = xXx(1, 2);

%all_angle = [0 0;];
all_pt = [skeleton(33).Dxyz(3,ff) skeleton(33).Dxyz(1,ff) skeleton(33).Dxyz(2,ff)];
displace_33_to_35=[skeleton_1(35).Dxyz(1,ff)-skeleton_1(33).Dxyz(1,ff) skeleton_1(35).Dxyz(2,ff)-skeleton_1(33).Dxyz(2,ff) skeleton_1(35).Dxyz(3,ff)-skeleton_1(33).Dxyz(3,ff)];
displace_33_to_38=[skeleton_1(38).Dxyz(1,ff)-skeleton_1(33).Dxyz(1,ff) skeleton_1(38).Dxyz(2,ff)-skeleton_1(33).Dxyz(2,ff) skeleton_1(38).Dxyz(3,ff)-skeleton_1(33).Dxyz(3,ff)];
displace_35_to_36=[skeleton_1(36).Dxyz(1,ff)-skeleton_1(35).Dxyz(1,ff) skeleton_1(36).Dxyz(2,ff)-skeleton_1(35).Dxyz(2,ff) skeleton_1(36).Dxyz(3,ff)-skeleton_1(35).Dxyz(3,ff)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%#####################################################################################%%%%%%%%%
A=[];    
b=[];
Aeq=[];beq=[];lb=[-Inf -Inf -Inf];ub=[pi/4 pi/4 Inf];nonlcon=[];
options = optimset('MaxFunEvals',1000000000000000000000000,'MaxIter',100000000000000000000); %initially 1000000000000000000000000 & 100000000000000000000
xXx = fmincon(@angle_find_function_4_3debug,all_angle,A,b,Aeq,beq,lb,ub,nonlcon,options);


% This is exactly the same code as in angle_find_function_4_3debug
%%%%%%% Calculate transform matrix%%%%%%%%%%%%%%%%%%%%%%%%
    for i=1:1
        pt=[0;0;0];
        pt(1) = all_pt(i,1);
        pt(2) = all_pt(i,2);
        pt(3) = all_pt(i,3);
      if (((p1(1)-p2(1)==0)&&(p2(1)-p3(1)==0)&&(p1(1)-p3(1)==0)&&(pt(1)-p1(1)==0))||((p1(2)-p2(2)==0)&&(p2(2)-p3(2)==0)&&(p1(2)-p3(2)==0)&&(pt(2)-p1(2)==0))||((p1(3)-p2(3)==0)&&(p2(3)-p3(3)==0)&&(p1(3)-p3(3)==0)&&(pt(3)-p1(3)==0)))
        pts = [ p1' 1; p2' ,1; p3' 1]';
         ptspi =pts;
      else
           p3v = p3 + [0; 0; 5];
           % now p3v-p3-p2 form the original plane
           

           %normal=cross(p3v-p3,p2-p3);  normal2=cross(p3v-p3,pt-p3);
           %up=abs(normal(1).*normal2(1)+normal(2).*normal2(2)+normal(3).*normal2(3)  );
           %down=sqrt( normal(1).*normal(1)+normal(2).*normal(2)+normal(3).*normal(3) )*sqrt( normal2(1).*normal2(1)+normal2(2).*normal2(2)+normal2(3).*normal2(3) );
            normal=cross(p3v-p3,p1-p3);  normal2=cross(p3v-p3,pt-p3);
           up=abs(normal(1).*normal2(1)+normal(2).*normal2(2)+normal(3).*normal2(3)  );
           down=sqrt( normal(1).*normal(1)+normal(2).*normal(2)+normal(3).*normal(3) )*sqrt( normal2(1).*normal2(1)+normal2(2).*normal2(2)+normal2(3).*normal2(3) );
           % we want to rotate about Z-axis first
           radi= acos (up/down);
            %axi=[normal(1);normal(2);normal(3)];
           axi=[p3(1)-p2(1);p3(2)-p2(2);p3(3)-p2(3)];
           ax2=axi/ sqrt(sum(axi.^2));
     
           % rotate about vertical axis at pt3
           
            if(pt(2)<p2(2))
                 M = AxelRot((radi) / pi * 180, [0; 0; 1], p3);
            elseif(pt(2)>p2(2))
                 M = AxelRot((radi) / pi * 180, [0; 0; -1], p3);
            elseif(p3(2)<p2(2))
                 M = AxelRot((radi) / pi * 180, [0; 0; -1], p3);
            else
                M = AxelRot((radi) / pi * 180, [0; 0; 1], p3);
            end
          % M = AxelRot(80, ax2, p2);
          %M = makehgtform('axisrotate',axi,radi);
          
        Mx=sum(M([1 2 3 ],1)); My=sum(M([1 2 3],2));Mz=sum(M([1 2 3],3));

        % construct points matrix
         pts = [ p1' 1; p2' ,1; p3' 1]';
         % transform points with M
         ptspi = M * pts;
         %ptspi =pts;
      end
     % h = plot3( ptspi(1,1:3), ptspi(2,1:3), ptspi(3,1:3), 'r-');set(h,'linewidth',6);
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
      p1x=ptspi(1,1);p1y=ptspi(2,1); p1z=ptspi(3,1);p11=[p1x;p1y;p1z];
      p2x=ptspi(1,2);p2y=ptspi(2,2); p2z=ptspi(3,2);p22=[p2x;p2y;p2z];
      p3x=ptspi(1,3);p3y=ptspi(2,3); p3z=ptspi(3,3);p33=[p3x;p3y;p3z];
      normp=cross(p33-p22,p11-p22);%plane equation
      uninormp =normp/norm(normp);%unit vector
        
      %pppl = AxelRot((xXx(i,1))/ pi * 180, uninormp, p11);
      ppp1 = AxelRot((xXx(i,1))/ pi * 180, uninormp, p22);
      pt1pii = ppp1*[p11;1];
    
      % now rotate first joint (controlling p2-p1)
      xformPts = [ pt1pii(1:3) p22 p33];
      % now rotate wholr joint (controlling p3-p1)
      ppp1=AxelRot((xXx(i,2)) / pi * 180, uninormp, p33);
      ptspii = ppp1 * [xformPts [1; 1; 1]; 1 1 1 1 ];

% aaply changes to joints

%skeleton_1(33).Dxyz(3,ff)=ptspii(1,1);
%skeleton_1(33).Dxyz(1,ff)=ptspii(2,1);
%skeleton_1(33).Dxyz(2,ff)=ptspii(3,1);

skeleton_1(32).Dxyz(3,ff)=ptspii(1,2);
skeleton_1(32).Dxyz(1,ff)=ptspii(2,2);
skeleton_1(32).Dxyz(2,ff)=ptspii(3,2);

%skeleton_1(31).Dxyz(3,ff)=ptspii(1,3);
%skeleton_1(31).Dxyz(1,ff)=ptspii(2,3);
%skeleton_1(31).Dxyz(2,ff)=ptspii(3,3);

skeleton_1(35).Dxyz(1,ff)=skeleton_1(33).Dxyz(1,ff)+displace_33_to_35(1);
skeleton_1(35).Dxyz(2,ff)=skeleton_1(33).Dxyz(2,ff)+displace_33_to_35(2);
skeleton_1(35).Dxyz(3,ff)=skeleton_1(33).Dxyz(3,ff)+displace_33_to_35(3);
skeleton_1(36).Dxyz(1,ff)=skeleton_1(35).Dxyz(1,ff)+displace_35_to_36(1);
skeleton_1(36).Dxyz(2,ff)=skeleton_1(35).Dxyz(2,ff)+displace_35_to_36(2);
skeleton_1(36).Dxyz(3,ff)=skeleton_1(35).Dxyz(3,ff)+displace_35_to_36(3);
skeleton_1(38).Dxyz(1,ff)=skeleton_1(33).Dxyz(1,ff)+displace_33_to_38(1);
skeleton_1(38).Dxyz(2,ff)=skeleton_1(33).Dxyz(2,ff)+displace_33_to_38(2);
skeleton_1(38).Dxyz(3,ff)=skeleton_1(33).Dxyz(3,ff)+displace_33_to_38(3);

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LEFT ARM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p1=[skeleton_1(24).Dxyz(3,ff);skeleton_1(24).Dxyz(1,ff);skeleton_1(24).Dxyz(2,ff)]; 
p2=[skeleton_1(23).Dxyz(3,ff);skeleton_1(23).Dxyz(1,ff);skeleton_1(23).Dxyz(2,ff)]; 
p3=[skeleton_1(22).Dxyz(3,ff);skeleton_1(22).Dxyz(1,ff);skeleton_1(22).Dxyz(2,ff)]; 
displace_24_to_26=[skeleton_1(26).Dxyz(1,ff)-skeleton_1(24).Dxyz(1,ff) skeleton_1(26).Dxyz(2,ff)-skeleton_1(24).Dxyz(2,ff) skeleton_1(26).Dxyz(3,ff)-skeleton_1(24).Dxyz(3,ff)];
displace_26_to_27=[skeleton_1(27).Dxyz(1,ff)-skeleton_1(26).Dxyz(1,ff) skeleton_1(27).Dxyz(2,ff)-skeleton_1(26).Dxyz(2,ff) skeleton_1(27).Dxyz(3,ff)-skeleton_1(26).Dxyz(3,ff)];
displace_24_to_29=[skeleton_1(29).Dxyz(1,ff)-skeleton_1(24).Dxyz(1,ff) skeleton_1(29).Dxyz(2,ff)-skeleton_1(24).Dxyz(2,ff) skeleton_1(29).Dxyz(3,ff)-skeleton_1(24).Dxyz(3,ff)];
all_pt=[skeleton(24).Dxyz(3,ff) skeleton(24).Dxyz(1,ff) skeleton(24).Dxyz(2,ff);];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%options = optimset('MaxFunEvals',1000000000000000000000000,'MaxIter',100000000000000000000);
xXx = fminsearch(@angle_find_function_4_3debug,all_angle,options);


  
      for x=-40:40:40 %(represents x)
          for y=-40:40:40
              plot3([x x],[y y] ,[-40 40],'r-','LineWidth',0.1);
             
          end 
      end
      for y=-40:40:40 %(represents z)
          for z=-40:40:40
              plot3([-40 40],[y y] ,[z z],'r-','LineWidth',0.1);
          end
      end
      for z=-40:40:40 %(represents y)
          for x=-40:40:40
              plot3([x x],[-40 40] ,[z z],'r-','LineWidth',0.1);
          end
      end
     
     
   
     %punch(02_05, 02_05new)
     %skeleton
     %righthand   
     plot3(skeleton(35).Dxyz(1,175),skeleton(35).Dxyz(3,175),skeleton(35).Dxyz(2,175),'r.','markersize',25)%1st
     plot3(skeleton(35).Dxyz(1,350),skeleton(35).Dxyz(3,350),skeleton(35).Dxyz(2,350),'r.','markersize',25)%2nd
     plot3(skeleton(35).Dxyz(1,526),skeleton(35).Dxyz(3,526),skeleton(35).Dxyz(2,526),'r.','markersize',25)%3rd
     plot3(skeleton(35).Dxyz(1,695),skeleton(35).Dxyz(3,695),skeleton(35).Dxyz(2,695),'r.','markersize',25)%4th
     plot3(skeleton(35).Dxyz(1,867),skeleton(35).Dxyz(3,867),skeleton(35).Dxyz(2,867),'r.','markersize',25)%5th
     plot3(skeleton(35).Dxyz(1,1041),skeleton(35).Dxyz(3,1041),skeleton(35).Dxyz(2,1041),'r.','markersize',25)%6th
     
     
%%%%%%%the part of code that may have something to do with the position of
%%%%%%%the dots
%%%%%%%UPDATE: after scrutinization, they are actually the same. That means
%%%%%%%the difference arises from the additional part in loadbvh2.m 
     %skeleton 1
     %righthand   
     plot3(skeleton_1(35).Dxyz(1,175),skeleton_1(35).Dxyz(3,175),skeleton_1(35).Dxyz(2,175),'r.','markersize',25)%1st
     plot3(skeleton_1(35).Dxyz(1,350),skeleton_1(35).Dxyz(3,350),skeleton_1(35).Dxyz(2,350),'r.','markersize',25)%2nd
     plot3(skeleton_1(35).Dxyz(1,526),skeleton_1(35).Dxyz(3,526),skeleton_1(35).Dxyz(2,526),'r.','markersize',25)%3rd
     plot3(skeleton_1(35).Dxyz(1,695),skeleton_1(35).Dxyz(3,695),skeleton_1(35).Dxyz(2,695),'r.','markersize',25)%4th
     plot3(skeleton_1(35).Dxyz(1,867),skeleton_1(35).Dxyz(3,867),skeleton_1(35).Dxyz(2,867),'r.','markersize',25)%5th
     plot3(skeleton_1(35).Dxyz(1,1041),skeleton_1(35).Dxyz(3,1041),skeleton_1(35).Dxyz(2,1041),'r.','markersize',25)%6th
     
    %blue dots
     if ff>=175
     plot3(skeleton(35).Dxyz(1,175),skeleton(35).Dxyz(3,175),skeleton(35).Dxyz(2,175),'b.','markersize',25)%1st
     plot3(skeleton_1(35).Dxyz(1,175),skeleton_1(35).Dxyz(3,175),skeleton_1(35).Dxyz(2,175),'b.','markersize',25)%1st
     end
      if ff>=350
      plot3(skeleton(35).Dxyz(1,350),skeleton(35).Dxyz(3,350),skeleton(35).Dxyz(2,350),'b.','markersize',25)%2nd
      plot3(skeleton_1(35).Dxyz(1,350),skeleton_1(35).Dxyz(3,350),skeleton_1(35).Dxyz(2,350),'b.','markersize',25)%2nd
      plot3(skeleton(35).Dxyz(1,175),skeleton(35).Dxyz(3,175),skeleton(35).Dxyz(2,175),'c.','markersize',25)%1st
      plot3(skeleton_1(35).Dxyz(1,175),skeleton_1(35).Dxyz(3,175),skeleton_1(35).Dxyz(2,175),'c.','markersize',25)%1st
      end
      if ff>=526
      plot3(skeleton(35).Dxyz(1,526),skeleton(35).Dxyz(3,526),skeleton(35).Dxyz(2,526),'b.','markersize',25)%3rd
      plot3(skeleton_1(35).Dxyz(1,526),skeleton_1(35).Dxyz(3,526),skeleton_1(35).Dxyz(2,526),'b.','markersize',25)%3rd
      plot3(skeleton(35).Dxyz(1,350),skeleton(35).Dxyz(3,350),skeleton(35).Dxyz(2,350),'c.','markersize',25)%2nd
      plot3(skeleton_1(35).Dxyz(1,350),skeleton_1(35).Dxyz(3,350),skeleton_1(35).Dxyz(2,350),'c.','markersize',25)%2nd
      end 
      if ff>=695
      plot3(skeleton(35).Dxyz(1,695),skeleton(35).Dxyz(3,695),skeleton(35).Dxyz(2,695),'b.','markersize',25)%4th
      plot3(skeleton_1(35).Dxyz(1,695),skeleton_1(35).Dxyz(3,695),skeleton_1(35).Dxyz(2,695),'b.','markersize',25)%4th
      plot3(skeleton(35).Dxyz(1,526),skeleton(35).Dxyz(3,526),skeleton(35).Dxyz(2,526),'c.','markersize',25)%3rd
      plot3(skeleton_1(35).Dxyz(1,526),skeleton_1(35).Dxyz(3,526),skeleton_1(35).Dxyz(2,526),'c.','markersize',25)%3rd
      end    
      if ff>=867
      plot3(skeleton(35).Dxyz(1,867),skeleton(35).Dxyz(3,867),skeleton(35).Dxyz(2,867),'b.','markersize',25)%5th
      plot3(skeleton_1(35).Dxyz(1,867),skeleton_1(35).Dxyz(3,867),skeleton_1(35).Dxyz(2,867),'b.','markersize',25)%5th
      plot3(skeleton(35).Dxyz(1,695),skeleton(35).Dxyz(3,695),skeleton(35).Dxyz(2,695),'c.','markersize',25)%4th
      plot3(skeleton_1(35).Dxyz(1,695),skeleton_1(35).Dxyz(3,695),skeleton_1(35).Dxyz(2,695),'c.','markersize',25)%4th
      end
     if ff>=1041
      plot3(skeleton(35).Dxyz(1,1041),skeleton(35).Dxyz(3,1041),skeleton(35).Dxyz(2,1041),'b.','markersize',25)%6th
      plot3(skeleton_1(35).Dxyz(1,1041),skeleton_1(35).Dxyz(3,1041),skeleton_1(35).Dxyz(2,1041),'b.','markersize',25)%6th
      plot3(skeleton(35).Dxyz(1,867),skeleton(35).Dxyz(3,867),skeleton(35).Dxyz(2,867),'c.','markersize',25)%5th
      plot3(skeleton_1(35).Dxyz(1,867),skeleton_1(35).Dxyz(3,867),skeleton_1(35).Dxyz(2,867),'c.','markersize',25)%5th
      end
     
% From the BVH model exported by arena, it's clear that "y" is vertical
% and "z" is medial-lateral. (From the "offsets" between the joints.)
% Therefore, flip Y and Z when plotting to have Matlab's "vertical" z-axis
% match up.
 
%}

  for nn = 1:length(skeleton) %38
      
   % %joint% %joint
    plot3(skeleton(nn).Dxyz(1,ff),skeleton(nn).Dxyz(3,ff),skeleton(nn).Dxyz(2,ff),'g.','markersize',20)
    plot3(skeleton_1(nn).Dxyz(1,ff),skeleton_1(nn).Dxyz(3,ff),skeleton_1(nn).Dxyz(2,ff),'k.','markersize',20)
    grid minor
    parent = skeleton(nn).parent;
    parent1 = skeleton_1(nn).parent;
    
   
   
    
   %lines, dxyz is point position
    if parent > 0
        
      plot3([skeleton(parent).Dxyz(1,ff) skeleton(nn).Dxyz(1,ff)],...
            [skeleton(parent).Dxyz(3,ff) skeleton(nn).Dxyz(3,ff)],...
            [skeleton(parent).Dxyz(2,ff) skeleton(nn).Dxyz(2,ff)],'g-','LineWidth',2.5) %change line colour
        

    %  plot3([4 4],[0 0] ,[-2 2],'b-');
     % plot3([6 6],[0 0] ,[-2 2],'b-');
    %  plot3([8 8],[0 0] ,[-2 2],'b-');
    %  plot3([10 10],[0 0] ,[-2 2],'b-');
      
      %title(['Dxyz is ',skeleton(nn-1).Dxyz,' none'])
     %if parent == 3
       %  disp(skeleton(nn).Dxyz)
     
    % end
    end
   
    
    if parent >=10 %20
      plot3([skeleton(parent).Dxyz(1,ff) skeleton(nn).Dxyz(1,ff)],...
            [skeleton(parent).Dxyz(3,ff) skeleton(nn).Dxyz(3,ff)],...
            [skeleton(parent).Dxyz(2,ff) skeleton(nn).Dxyz(2,ff)],'m-','LineWidth',2.5) %change line colour 
    end
         
            %plot3(-5,skeleton(31).Dxyz(3,ff)+7,20,'bl.','markersize',50);
            %plot3([-21 -21],[25 40],[21 21],'r-') ;
    if parent1 > 0
      plot3([skeleton_1(parent1).Dxyz(1,ff) skeleton_1(nn).Dxyz(1,ff)],...
            [skeleton_1(parent1).Dxyz(3,ff) skeleton_1(nn).Dxyz(3,ff)],...
            [skeleton_1(parent1).Dxyz(2,ff) skeleton_1(nn).Dxyz(2,ff)],'k-','LineWidth',2.5)
        grid minor
       %  if parent1 == 3
        % disp(skeleton_1(nn).Dxyz)
       %  end
    
   if parent1 >=20
      plot3([skeleton_1(parent1).Dxyz(1,ff) skeleton_1(nn).Dxyz(1,ff)],...
            [skeleton_1(parent1).Dxyz(3,ff) skeleton_1(nn).Dxyz(3,ff)],...
            [skeleton_1(parent1).Dxyz(2,ff) skeleton_1(nn).Dxyz(2,ff)],'m-','LineWidth',2.5) %change line colour 
    end
  end
  end
  
  
  view(-150,25)%change view perspective
  %view(-290,25)
  %view(-135,30)
  axis equal on % show axis meter
  
  drawnow
  
  
  
  if write_video, writeVideo(vidObj,getframe); end
    
end

if write_video, close(vidObj); end

