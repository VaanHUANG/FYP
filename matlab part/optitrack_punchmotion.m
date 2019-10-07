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
name1 = '02_05new'; %initially "02_05new"
[skeleton1,time1] = loadbvh2_same_location(name1);

%%

write_video = false;


% Prepare the new video file.
if write_video, vidObj = VideoWriter(name); open(vidObj); end



%fincr = 10;    
fincr = 10; 
for ff = 1:fincr:length(time) %#ok<FORPF>

  h = figure(1); clf; hold on
  title(sprintf('%1.2f seconds',time(ff)))
  set(h,'color','white')
  
      
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
     
     
     %{
     %walk(02_01new, 02_01_01)
     %skeleton
     %rightfoot
     plot3(skeleton(11).Dxyz(1,113),skeleton(11).Dxyz(3,113),skeleton(11).Dxyz(2,113),'r.','markersize',25)%2nd
     plot3(skeleton(11).Dxyz(1,227),skeleton(11).Dxyz(3,227),skeleton(11).Dxyz(2,227),'r.','markersize',25)%4th
     plot3(skeleton(11).Dxyz(1,341),skeleton(11).Dxyz(3,341),skeleton(11).Dxyz(2,341),'r.','markersize',25)%6th    
     %leftfoot   
     plot3(skeleton(5).Dxyz(1,56),skeleton(5).Dxyz(3,56),skeleton(5).Dxyz(2,56),'r.','markersize',25)%1st
     plot3(skeleton(5).Dxyz(1,170),skeleton(5).Dxyz(3,170),skeleton(5).Dxyz(2,170),'r.','markersize',25)%3rd
     plot3(skeleton(5).Dxyz(1,284),skeleton(5).Dxyz(3,284),skeleton(5).Dxyz(2,284),'r.','markersize',25)%5th
     
     %skeleton 1
     %rightfoot
     plot3(skeleton1(11).Dxyz(1,113),skeleton1(11).Dxyz(3,113),skeleton1(11).Dxyz(2,113),'r.','markersize',25)%2nd
     plot3(skeleton1(11).Dxyz(1,227),skeleton1(11).Dxyz(3,227),skeleton1(11).Dxyz(2,227),'r.','markersize',25)%4th
     plot3(skeleton1(11).Dxyz(1,341),skeleton1(11).Dxyz(3,341),skeleton1(11).Dxyz(2,341),'r.','markersize',25)%6th    
     %leftfoot   
     plot3(skeleton1(5).Dxyz(1,56),skeleton1(5).Dxyz(3,56),skeleton1(5).Dxyz(2,56),'r.','markersize',25)%1st
     plot3(skeleton1(5).Dxyz(1,170),skeleton1(5).Dxyz(3,170),skeleton1(5).Dxyz(2,170),'r.','markersize',25)%3rd
     plot3(skeleton1(5).Dxyz(1,284),skeleton1(5).Dxyz(3,284),skeleton1(5).Dxyz(2,284),'r.','markersize',25)%5th
     
    %blue dots
     if ff>=56
     plot3(skeleton(5).Dxyz(1,56),skeleton(5).Dxyz(3,56),skeleton(5).Dxyz(2,56),'b.','markersize',25)%1st
     plot3(skeleton1(5).Dxyz(1,56),skeleton1(5).Dxyz(3,56),skeleton1(5).Dxyz(2,56),'b.','markersize',25)%1st
     end
     if ff>=113
     plot3(skeleton(11).Dxyz(1,113),skeleton(11).Dxyz(3,113),skeleton(11).Dxyz(2,113),'b.','markersize',25)%2nd 
     plot3(skeleton1(11).Dxyz(1,113),skeleton1(11).Dxyz(3,113),skeleton1(11).Dxyz(2,113),'b.','markersize',25)%2nd
     end
     if ff>=170
     plot3(skeleton(5).Dxyz(1,170),skeleton(5).Dxyz(3,170),skeleton(5).Dxyz(2,170),'b.','markersize',25)%3rd
     plot3(skeleton1(5).Dxyz(1,170),skeleton1(5).Dxyz(3,170),skeleton1(5).Dxyz(2,170),'b.','markersize',25)%3rd
     end
     if ff>=227
     plot3(skeleton(11).Dxyz(1,227),skeleton(11).Dxyz(3,227),skeleton(11).Dxyz(2,227),'b.','markersize',25)%4th
     plot3(skeleton1(11).Dxyz(1,227),skeleton1(11).Dxyz(3,227),skeleton1(11).Dxyz(2,227),'b.','markersize',25)%4th
     end
     if ff>=284
     plot3(skeleton(5).Dxyz(1,284),skeleton(5).Dxyz(3,284),skeleton(5).Dxyz(2,284),'b.','markersize',25)%5th
     plot3(skeleton1(5).Dxyz(1,284),skeleton1(5).Dxyz(3,284),skeleton1(5).Dxyz(2,284),'b.','markersize',25)%5th
     end
     if ff>=341
     plot3(skeleton(11).Dxyz(1,341),skeleton(11).Dxyz(3,341),skeleton(11).Dxyz(2,341),'b.','markersize',25)%6th  
     plot3(skeleton1(11).Dxyz(1,341),skeleton1(11).Dxyz(3,341),skeleton1(11).Dxyz(2,341),'b.','markersize',25)%6th
     end
     
     %}
     
     
     %{
     
      %run(02_03left, 02_03new)
     %skeleton
     %leftfoot
     plot3(skeleton(5).Dxyz(1,60),skeleton(5).Dxyz(3,60),skeleton(5).Dxyz(2,60),'r.','markersize',25)%2nd
     plot3(skeleton(5).Dxyz(1,150),skeleton(5).Dxyz(3,150),skeleton(5).Dxyz(2,150),'r.','markersize',25)%4th
         
     %rightfoot   
     plot3(skeleton(11).Dxyz(1,20),skeleton(11).Dxyz(3,20),skeleton(11).Dxyz(2,20),'r.','markersize',25)%1st
     plot3(skeleton(11).Dxyz(1,110),skeleton(11).Dxyz(3,110),skeleton(11).Dxyz(2,110),'r.','markersize',25)%3rd
     
     
     %skeleton 1
     %leftfoot
     plot3(skeleton1(5).Dxyz(1,60),skeleton1(5).Dxyz(3,60),skeleton1(5).Dxyz(2,60),'r.','markersize',25)%2nd
     plot3(skeleton1(5).Dxyz(1,150),skeleton1(5).Dxyz(3,150),skeleton1(5).Dxyz(2,150),'r.','markersize',25)%4th
        
     %rightfoot   
     plot3(skeleton1(11).Dxyz(1,20),skeleton1(11).Dxyz(3,20),skeleton1(11).Dxyz(2,20),'r.','markersize',25)%1st
     plot3(skeleton1(11).Dxyz(1,110),skeleton1(11).Dxyz(3,110),skeleton1(11).Dxyz(2,110),'r.','markersize',25)%3rd
     
   
    %blue dots
     if ff>=20
     plot3(skeleton(11).Dxyz(1,20),skeleton(11).Dxyz(3,20),skeleton(11).Dxyz(2,20),'b.','markersize',25)%1st
     plot3(skeleton1(11).Dxyz(1,20),skeleton1(11).Dxyz(3,20),skeleton1(11).Dxyz(2,20),'b.','markersize',25)%1st
     end
     if ff>=60
     plot3(skeleton(5).Dxyz(1,60),skeleton(5).Dxyz(3,60),skeleton(5).Dxyz(2,60),'b.','markersize',25)%2nd 
     plot3(skeleton1(5).Dxyz(1,60),skeleton1(5).Dxyz(3,60),skeleton1(5).Dxyz(2,60),'b.','markersize',25)%2nd
     end
     if ff>=109
     plot3(skeleton(11).Dxyz(1,110),skeleton(11).Dxyz(3,110),skeleton(11).Dxyz(2,110),'b.','markersize',25)%3rd
     plot3(skeleton1(11).Dxyz(1,110),skeleton1(11).Dxyz(3,110),skeleton1(11).Dxyz(2,110),'b.','markersize',25)%3rd
     end

     if ff>=150
     plot3(skeleton(5).Dxyz(1,150),skeleton(5).Dxyz(3,150),skeleton(5).Dxyz(2,150),'b.','markersize',25)%4th  
     plot3(skeleton1(5).Dxyz(1,150),skeleton1(5).Dxyz(3,150),skeleton1(5).Dxyz(2,150),'b.','markersize',25)%4th
     end
     
     %}
     
     
   
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
     plot3(skeleton1(35).Dxyz(1,175),skeleton1(35).Dxyz(3,175),skeleton1(35).Dxyz(2,175),'r.','markersize',25)%1st
     plot3(skeleton1(35).Dxyz(1,350),skeleton1(35).Dxyz(3,350),skeleton1(35).Dxyz(2,350),'r.','markersize',25)%2nd
     plot3(skeleton1(35).Dxyz(1,526),skeleton1(35).Dxyz(3,526),skeleton1(35).Dxyz(2,526),'r.','markersize',25)%3rd
     plot3(skeleton1(35).Dxyz(1,695),skeleton1(35).Dxyz(3,695),skeleton1(35).Dxyz(2,695),'r.','markersize',25)%4th
     plot3(skeleton1(35).Dxyz(1,867),skeleton1(35).Dxyz(3,867),skeleton1(35).Dxyz(2,867),'r.','markersize',25)%5th
     plot3(skeleton1(35).Dxyz(1,1041),skeleton1(35).Dxyz(3,1041),skeleton1(35).Dxyz(2,1041),'r.','markersize',25)%6th
     
    %blue dots
     if ff>=175
     plot3(skeleton(35).Dxyz(1,175),skeleton(35).Dxyz(3,175),skeleton(35).Dxyz(2,175),'b.','markersize',25)%1st
     plot3(skeleton1(35).Dxyz(1,175),skeleton1(35).Dxyz(3,175),skeleton1(35).Dxyz(2,175),'b.','markersize',25)%1st
     end
      if ff>=350
      plot3(skeleton(35).Dxyz(1,350),skeleton(35).Dxyz(3,350),skeleton(35).Dxyz(2,350),'b.','markersize',25)%2nd
      plot3(skeleton1(35).Dxyz(1,350),skeleton1(35).Dxyz(3,350),skeleton1(35).Dxyz(2,350),'b.','markersize',25)%2nd
      plot3(skeleton(35).Dxyz(1,175),skeleton(35).Dxyz(3,175),skeleton(35).Dxyz(2,175),'c.','markersize',25)%1st
      plot3(skeleton1(35).Dxyz(1,175),skeleton1(35).Dxyz(3,175),skeleton1(35).Dxyz(2,175),'c.','markersize',25)%1st
      end
      if ff>=526
      plot3(skeleton(35).Dxyz(1,526),skeleton(35).Dxyz(3,526),skeleton(35).Dxyz(2,526),'b.','markersize',25)%3rd
      plot3(skeleton1(35).Dxyz(1,526),skeleton1(35).Dxyz(3,526),skeleton1(35).Dxyz(2,526),'b.','markersize',25)%3rd
      plot3(skeleton(35).Dxyz(1,350),skeleton(35).Dxyz(3,350),skeleton(35).Dxyz(2,350),'c.','markersize',25)%2nd
      plot3(skeleton1(35).Dxyz(1,350),skeleton1(35).Dxyz(3,350),skeleton1(35).Dxyz(2,350),'c.','markersize',25)%2nd
      end 
      if ff>=695
      plot3(skeleton(35).Dxyz(1,695),skeleton(35).Dxyz(3,695),skeleton(35).Dxyz(2,695),'b.','markersize',25)%4th
      plot3(skeleton1(35).Dxyz(1,695),skeleton1(35).Dxyz(3,695),skeleton1(35).Dxyz(2,695),'b.','markersize',25)%4th
      plot3(skeleton(35).Dxyz(1,526),skeleton(35).Dxyz(3,526),skeleton(35).Dxyz(2,526),'c.','markersize',25)%3rd
      plot3(skeleton1(35).Dxyz(1,526),skeleton1(35).Dxyz(3,526),skeleton1(35).Dxyz(2,526),'c.','markersize',25)%3rd
      end    
      if ff>=867
      plot3(skeleton(35).Dxyz(1,867),skeleton(35).Dxyz(3,867),skeleton(35).Dxyz(2,867),'b.','markersize',25)%5th
      plot3(skeleton1(35).Dxyz(1,867),skeleton1(35).Dxyz(3,867),skeleton1(35).Dxyz(2,867),'b.','markersize',25)%5th
      plot3(skeleton(35).Dxyz(1,695),skeleton(35).Dxyz(3,695),skeleton(35).Dxyz(2,695),'c.','markersize',25)%4th
      plot3(skeleton1(35).Dxyz(1,695),skeleton1(35).Dxyz(3,695),skeleton1(35).Dxyz(2,695),'c.','markersize',25)%4th
      end
     if ff>=1041
      plot3(skeleton(35).Dxyz(1,1041),skeleton(35).Dxyz(3,1041),skeleton(35).Dxyz(2,1041),'b.','markersize',25)%6th
      plot3(skeleton1(35).Dxyz(1,1041),skeleton1(35).Dxyz(3,1041),skeleton1(35).Dxyz(2,1041),'b.','markersize',25)%6th
      plot3(skeleton(35).Dxyz(1,867),skeleton(35).Dxyz(3,867),skeleton(35).Dxyz(2,867),'c.','markersize',25)%5th
      plot3(skeleton1(35).Dxyz(1,867),skeleton1(35).Dxyz(3,867),skeleton1(35).Dxyz(2,867),'c.','markersize',25)%5th
      end
     
% From the BVH model exported by arena, it's clear that "y" is vertical
% and "z" is medial-lateral. (From the "offsets" between the joints.)
% Therefore, flip Y and Z when plotting to have Matlab's "vertical" z-axis
% match up.
 
%}

  for nn = 1:length(skeleton) %38
      
   % %joint% %joint
    plot3(skeleton(nn).Dxyz(1,ff),skeleton(nn).Dxyz(3,ff),skeleton(nn).Dxyz(2,ff),'g.','markersize',20)
    plot3(skeleton1(nn).Dxyz(1,ff),skeleton1(nn).Dxyz(3,ff),skeleton1(nn).Dxyz(2,ff),'k.','markersize',20)
    grid minor
    parent = skeleton(nn).parent;
    parent1 = skeleton1(nn).parent;
    
   
   
    
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
      plot3([skeleton1(parent1).Dxyz(1,ff) skeleton1(nn).Dxyz(1,ff)],...
            [skeleton1(parent1).Dxyz(3,ff) skeleton1(nn).Dxyz(3,ff)],...
            [skeleton1(parent1).Dxyz(2,ff) skeleton1(nn).Dxyz(2,ff)],'k-','LineWidth',2.5)
        grid minor
       %  if parent1 == 3
        % disp(skeleton1(nn).Dxyz)
       %  end
    
   if parent1 >=20
      plot3([skeleton1(parent1).Dxyz(1,ff) skeleton1(nn).Dxyz(1,ff)],...
            [skeleton1(parent1).Dxyz(3,ff) skeleton1(nn).Dxyz(3,ff)],...
            [skeleton1(parent1).Dxyz(2,ff) skeleton1(nn).Dxyz(2,ff)],'m-','LineWidth',2.5) %change line colour 
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

