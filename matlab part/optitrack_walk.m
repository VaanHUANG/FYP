%% Taking data from Arena
%
% BVH is a text file which contains skeletal data, but its contents needs
% additional processing to draw the wireframe and create the animation.

name = '02_01_01';
[skeleton,time] = loadbvh(name);
[skeleton_4,time4] = loadbvh(name);
name1 = '02_01_01';
[skeleton_1,time1] = loadbvh_2(name1);

name2 = '02_01_01';
[skeleton_2,time2] = loadbvh(name2);

name3 = '02_01_01';
[skeleton_3,time3] = loadbvh_2(name2);

%%
 global all_pt;
    
    global p1;
    global p2;
    global p3;
    
xXx = [0 0 0;];
write_video = false;
all_angle=[0 0;];

% Prepare the new video file.
if write_video, vidObj = VideoWriter(name); open(vidObj); end



       
fincr = 10; 
for ff = 1:fincr:length(time) %#ok<FORPF>
%for ff = 1:fincr:200  
      h = figure(1); clf; hold on
        title(sprintf('%1.2f seconds',time(ff)))
         set(h,'color','white')
    %MAKE TWO FIGURE ON SAME LEVEL
    for nn = 1:length(skeleton) %38
       skeleton_1(nn).Dxyz(2,ff)=skeleton_1(nn).Dxyz(2,ff)+15; 
    end  
    for nn = 1:length(skeleton) %38
       skeleton_1(nn).Dxyz(2,ff)=skeleton_1(nn).Dxyz(2,ff)+2; 
    end
    for nn = 1:length(skeleton) %38
       skeleton_2(nn).Dxyz(1,ff)=skeleton_2(nn).Dxyz(1,ff)+60; 
    end
    for nn = 1:length(skeleton) %38
       skeleton_3(nn).Dxyz(2,ff)=skeleton_3(nn).Dxyz(2,ff)+15; 
    end
    for nn = 1:length(skeleton) %38
       skeleton_3(nn).Dxyz(1,ff)=skeleton_3(nn).Dxyz(1,ff)+30; 
    end
    for nn = 1:length(skeleton) %38
       skeleton_4(nn).Dxyz(1,ff)=skeleton_4(nn).Dxyz(1,ff)+30; 
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %RETARGET
%left leg
p1=[skeleton_1(11).Dxyz(3,ff);skeleton_1(11).Dxyz(1,ff);skeleton_1(11).Dxyz(2,ff)]; 
p2=[skeleton_1(10).Dxyz(3,ff);skeleton_1(10).Dxyz(1,ff);skeleton_1(10).Dxyz(2,ff)]; 
p3=[skeleton_1(9).Dxyz(3,ff);skeleton_1(9).Dxyz(1,ff);skeleton_1(9).Dxyz(2,ff)]; 
%all_angle=[0 0 0;];
all_angle(1) = xXx(1, 1);
all_angle(2) = xXx(1, 2);
all_angle(3) = xXx(1, 3);
all_pt=[skeleton(11).Dxyz(3,ff) skeleton(11).Dxyz(1,ff) skeleton(11).Dxyz(2,ff);];
displace_11_to_12=[skeleton_1(12).Dxyz(1,ff)-skeleton_1(11).Dxyz(1,ff) skeleton_1(12).Dxyz(2,ff)-skeleton_1(11).Dxyz(2,ff) skeleton_1(12).Dxyz(3,ff)-skeleton_1(11).Dxyz(3,ff)];
displace_12_to_13=[skeleton_1(13).Dxyz(1,ff)-skeleton_1(12).Dxyz(1,ff) skeleton_1(13).Dxyz(2,ff)-skeleton_1(12).Dxyz(2,ff) skeleton_1(13).Dxyz(3,ff)-skeleton_1(12).Dxyz(3,ff)];
%p1=[skeleton_1(10).Dxyz(1,ff);skeleton_1(10).Dxyz(2,ff);skeleton_1(10).Dxyz(3,ff)]; 
%p2=[skeleton_1(9).Dxyz(1,ff);skeleton_1(9).Dxyz(2,ff);skeleton_1(9).Dxyz(3,ff)];
%p3=[skeleton_1(8).Dxyz(1,ff);skeleton_1(8).Dxyz(2,ff);skeleton_1(8).Dxyz(3,ff)]; 
%all_angle=[0 0;];
%all_pt=[skeleton(10).Dxyz(1,ff) skeleton(10).Dxyz(2,ff) skeleton(10).Dxyz(3,ff);];
%options = optimset('MaxFunEvals',1000000000000000000000000,'MaxIter',100000000000000000000);
A=[];    
b=[];
Aeq=[];beq=[];lb=[0 -pi/4];ub=[pi/4 pi/4];nonlcon=[];
%Aeq=[];beq=[];lb=[];ub=[];nonlcon=[];
options = optimset('MaxFunEvals',1000000000000000000000000,'MaxIter',100000000000000000000);
%options = optimoptions(@fmincon,'Algorithm','active-set','MaxIter',1500);
%xXx = fmincon(@angle_find_function_4,all_angle,A,b,options);
%xXx = fmincon(@angle_find_function_4_3debug,all_angle,A,b,Aeq,beq,lb,ub,nonlcon,options);
xXx = fminsearch(@angle_find_function_4_3debug,all_angle,options);
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
           end;
          % M = AxelRot(80, ax2, p2);
          %M = makehgtform('axisrotate',axi,radi);
          
        Mx=sum(M([1 2 3 ],1)); My=sum(M([1 2 3],2));Mz=sum(M([1 2 3],3));

        % construct points matrix
         pts = [ p1' 1; p2' ,1; p3' 1]';
         % transform points with M
         ptspi = M * pts;
         %ptspi =pts;
      end;
     % h = plot3( ptspi(1,1:3), ptspi(2,1:3), ptspi(3,1:3), 'r-');set(h,'linewidth',6);
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
      p1x=ptspi(1,1);p1y=ptspi(2,1); p1z=ptspi(3,1);p11=[p1x;p1y;p1z];
      p2x=ptspi(1,2);p2y=ptspi(2,2); p2z=ptspi(3,2);p22=[p2x;p2y;p2z];
      p3x=ptspi(1,3);p3y=ptspi(2,3); p3z=ptspi(3,3);p33=[p3x;p3y;p3z];
      normp=cross(p33-p22,p11-p22);%plane equation
      uninormp =normp/norm(normp);%unit vector

      ppp1=AxelRot((xXx(i,1))/ pi * 180, uninormp, p22);
      pt1pii = ppp1*[p11;1];
    
     % now rotate first joint (controlling p2-p1)
     xformPts = [ pt1pii(1:3) p22 p33];
     % now rotate wholr joint (controlling p3-p1)
    ppp1=AxelRot((xXx(i,2)) / pi * 180, uninormp, p33);
    ptspii = ppp1 * [xformPts [1; 1; 1]; 1 1 1 1 ];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Show the change of the arm after before CCD
%h = plot3( ptspii(1,1:3), ptspii(2,1:3), ptspii(3,1:3), 'b-');
%set(h,'linewidth',20);
%h = plot3( ptspi(1,1:3), ptspi(2,1:3), ptspi(3,1:3), 'b-'); set(h,'linewidth',1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
skeleton_1(11).Dxyz(3,ff)=ptspii(1,1);skeleton_1(11).Dxyz(1,ff)=ptspii(2,1);skeleton_1(11).Dxyz(2,ff)=ptspii(3,1);     
skeleton_1(10).Dxyz(3,ff)=ptspii(1,2);skeleton_1(10).Dxyz(1,ff)=ptspii(2,2);skeleton_1(10).Dxyz(2,ff)=ptspii(3,2);
skeleton_1(9).Dxyz(3,ff)=ptspii(1,3); skeleton_1(9).Dxyz(1,ff)=ptspii(2,3); skeleton_1(9).Dxyz(2,ff)=ptspii(3,3);
%skeleton_1(11).Dxyz(1,ff)=skeleton(11).Dxyz(1,ff);skeleton_1(11).Dxyz(2,ff)=skeleton(11).Dxyz(2,ff);skeleton_1(11).Dxyz(3,ff)=skeleton(11).Dxyz(3,ff);
%skeleton_1(12).Dxyz(1,ff)=skeleton(12).Dxyz(1,ff);skeleton_1(12).Dxyz(2,ff)=skeleton(12).Dxyz(2,ff);skeleton_1(12).Dxyz(3,ff)=skeleton(12).Dxyz(3,ff);
%skeleton_1(13).Dxyz(1,ff)=skeleton(13).Dxyz(1,ff);skeleton_1(13).Dxyz(2,ff)=skeleton(13).Dxyz(2,ff);skeleton_1(13).Dxyz(3,ff)=skeleton(13).Dxyz(3,ff);
skeleton_1(12).Dxyz(1,ff)=skeleton_1(11).Dxyz(1,ff)+displace_11_to_12(1);skeleton_1(12).Dxyz(2,ff)=skeleton_1(11).Dxyz(2,ff)+displace_11_to_12(2);skeleton_1(12).Dxyz(3,ff)=skeleton_1(11).Dxyz(3,ff)+displace_11_to_12(3);
skeleton_1(13).Dxyz(1,ff)=skeleton_1(12).Dxyz(1,ff)+displace_12_to_13(1);skeleton_1(13).Dxyz(2,ff)=skeleton_1(12).Dxyz(2,ff)+displace_12_to_13(2);skeleton_1(13).Dxyz(3,ff)=skeleton_1(12).Dxyz(3,ff)+displace_12_to_13(3);
%cal=[pt(1)-ptspii(1,1) pt(2)-ptspii(2,1) pt(3)-ptspii(3,1)];
%cal2=[ptspii(1,1)-ptspii(1,2) ptspii(2,1)-ptspii(2,2) ptspii(3,1)-ptspii(3,2)];
%cal3=cross(cal,cal2);
    
%skeleton_1(10).Dxyz(1,ff)=ptspii(1,1);skeleton_1(10).Dxyz(2,ff)=ptspii(2,1);skeleton_1(10).Dxyz(3,ff)=ptspii(3,1);
%skeleton_1(9).Dxyz(1,ff)=ptspii(1,2);skeleton_1(9).Dxyz(2,ff)=ptspii(2,2);skeleton_1(9).Dxyz(3,ff)=ptspii(3,2);
%skeleton_1(8).Dxyz(1,ff)=ptspii(1,3);skeleton_1(8).Dxyz(2,ff)=ptspii(2,3);skeleton_1(8).Dxyz(3,ff)=ptspii(3,3);
%skeleton_1(11).Dxyz(1,ff)=skeleton(11).Dxyz(1,ff);skeleton_1(11).Dxyz(2,ff)=skeleton(11).Dxyz(2,ff);skeleton_1(11).Dxyz(3,ff)=skeleton(11).Dxyz(3,ff); 
%skeleton_1(12).Dxyz(1,ff)=skeleton(12).Dxyz(1,ff);skeleton_1(12).Dxyz(2,ff)=skeleton(12).Dxyz(2,ff);skeleton_1(12).Dxyz(3,ff)=skeleton(12).Dxyz(3,ff);
%skeleton_1(13).Dxyz(1,ff)=skeleton(13).Dxyz(1,ff);skeleton_1(13).Dxyz(2,ff)=skeleton(13).Dxyz(2,ff);skeleton_1(13).Dxyz(3,ff)=skeleton(13).Dxyz(3,ff);
%cal=[pt(1)-ptspii(1,1) pt(2)-ptspii(2,1) pt(3)-ptspii(3,1)];
%cal2=[ptspii(1,1)-ptspii(1,2) ptspii(2,1)-ptspii(2,2) ptspii(3,1)-ptspii(3,2)];
%cal3=cross(cal,cal2);
%length(1,i) = sqrt(sum(cal.^2));
end

%right leg

p1=[skeleton_1(5).Dxyz(3,ff);skeleton_1(5).Dxyz(1,ff);skeleton_1(5).Dxyz(2,ff)]; 
p2=[skeleton_1(4).Dxyz(3,ff);skeleton_1(4).Dxyz(1,ff);skeleton_1(4).Dxyz(2,ff)]; 
p3=[skeleton_1(3).Dxyz(3,ff);skeleton_1(3).Dxyz(1,ff);skeleton_1(3).Dxyz(2,ff)]; 
displace_5_to_6=[skeleton_1(6).Dxyz(1,ff)-skeleton_1(5).Dxyz(1,ff) skeleton_1(6).Dxyz(2,ff)-skeleton_1(5).Dxyz(2,ff) skeleton_1(6).Dxyz(3,ff)-skeleton_1(5).Dxyz(3,ff)];
displace_6_to_7=[skeleton_1(7).Dxyz(1,ff)-skeleton_1(6).Dxyz(1,ff) skeleton_1(7).Dxyz(2,ff)-skeleton_1(6).Dxyz(2,ff) skeleton_1(7).Dxyz(3,ff)-skeleton_1(6).Dxyz(3,ff)];
all_pt=[skeleton(5).Dxyz(3,ff) skeleton(5).Dxyz(1,ff) skeleton(5).Dxyz(2,ff);];
%options = optimset('MaxFunEvals',1000000000000000000000000,'MaxIter',100000000000000000000);
%A=[];    
%b=[];
%Aeq=[];beq=[];lb=[0 0];ub=[pi/2 2*pi];nonlcon=[];
options = optimset('MaxFunEvals',1000000000000000000000000,'MaxIter',100000000000000000000);
%options = optimoptions(@fmincon,'Algorithm','active-set','MaxIter',1500);
%xXx = fmincon(@angle_find_function_4,all_angle,A,b,options);
%xXx = fmincon(@angle_find_function_4_3debug,all_angle,A,b,Aeq,beq,lb,ub,nonlcon,options);
xXx = fminsearch(@angle_find_function_4_3debug,all_angle,options);

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
           end;
          % M = AxelRot(80, ax2, p2);
          %M = makehgtform('axisrotate',axi,radi);
          
        Mx=sum(M([1 2 3 ],1)); My=sum(M([1 2 3],2));Mz=sum(M([1 2 3],3));

        % construct points matrix
         pts = [ p1' 1; p2' ,1; p3' 1]';
         % transform points with M
         ptspi = M * pts;
         %ptspi =pts;
      end;
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %h = plot3( ptspi(1,1:3), ptspi(2,1:3), ptspi(3,1:3), 'r-');set(h,'linewidth',6);  
      p1x=ptspi(1,1);p1y=ptspi(2,1); p1z=ptspi(3,1);p11=[p1x;p1y;p1z];
      p2x=ptspi(1,2);p2y=ptspi(2,2); p2z=ptspi(3,2);p22=[p2x;p2y;p2z];
      p3x=ptspi(1,3);p3y=ptspi(2,3); p3z=ptspi(3,3);p33=[p3x;p3y;p3z];
      normp=cross(p33-p22,p11-p22);%plane equation
      uninormp =normp/norm(normp);%unit vector

      ppp1=AxelRot((xXx(i,1))/ pi * 180, uninormp, p22);
      pt1pii = ppp1*[p11;1];
    
     % now rotate first joint (controlling p2-p1)
     xformPts = [ pt1pii(1:3) p22 p33];
     % now rotate wholr joint (controlling p3-p1)
    ppp1=AxelRot((xXx(i,2)) / pi * 180, uninormp, p33);
    ptspii = ppp1 * [xformPts [1; 1; 1]; 1 1 1 1 ];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Show the change of the arm after before CCD
%h = plot3( ptspi(1,1:3), ptspi(2,1:3), ptspi(3,1:3), 'b-');
%set(h,'linewidth',2);
%h = plot3( ptspi(1,1:3), ptspi(2,1:3), ptspi(3,1:3), 'b-'); set(h,'linewidth',1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%skeleton_1(5).Dxyz(3,ff)=ptspii(1,1);skeleton_1(5).Dxyz(1,ff)=ptspii(2,1);skeleton_1(5).Dxyz(2,ff)=ptspii(3,1);     
%skeleton_1(4).Dxyz(3,ff)=ptspii(1,2);skeleton_1(4).Dxyz(1,ff)=ptspii(2,2);skeleton_1(4).Dxyz(2,ff)=ptspii(3,2);
%skeleton_1(3).Dxyz(3,ff)=ptspii(1,3);skeleton_1(3).Dxyz(1,ff)=ptspii(2,3);skeleton_1(3).Dxyz(2,ff)=ptspii(3,3);

%skeleton_1(5).Dxyz(1,ff)=skeleton(5).Dxyz(1,ff);skeleton_1(5).Dxyz(2,ff)=skeleton(5).Dxyz(2,ff);skeleton_1(5).Dxyz(3,ff)=skeleton(5).Dxyz(3,ff);
%skeleton_1(6).Dxyz(1,ff)=skeleton(6).Dxyz(1,ff);skeleton_1(6).Dxyz(2,ff)=skeleton(6).Dxyz(2,ff);skeleton_1(6).Dxyz(3,ff)=skeleton(6).Dxyz(3,ff);
%skeleton_1(7).Dxyz(1,ff)=skeleton(7).Dxyz(1,ff);skeleton_1(7).Dxyz(2,ff)=skeleton(7).Dxyz(2,ff);skeleton_1(7).Dxyz(3,ff)=skeleton(7).Dxyz(3,ff);
skeleton_1(6).Dxyz(1,ff)=skeleton_1(5).Dxyz(1,ff)+displace_5_to_6(1);skeleton_1(6).Dxyz(2,ff)=skeleton_1(5).Dxyz(2,ff)+displace_5_to_6(2);skeleton_1(6).Dxyz(3,ff)=skeleton_1(5).Dxyz(3,ff)+displace_5_to_6(3);
skeleton_1(7).Dxyz(1,ff)=skeleton_1(6).Dxyz(1,ff)+displace_6_to_7(1);skeleton_1(7).Dxyz(2,ff)=skeleton_1(6).Dxyz(2,ff)+displace_6_to_7(2);skeleton_1(7).Dxyz(3,ff)=skeleton_1(6).Dxyz(3,ff)+displace_6_to_7(3);
%cal=[pt(1)-ptspii(1,1) pt(2)-ptspii(2,1) pt(3)-ptspii(3,1)];
%cal2=[ptspii(1,1)-ptspii(1,2) ptspii(2,1)-ptspii(2,2) ptspii(3,1)-ptspii(3,2)];
%cal3=cross(cal,cal2);
%length(1,i) = sqrt(sum(cal.^2));
end
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    

  
  %[X,Y,Z] = meshgrid(-40:5:40, -40:5:45, -40:5:40);    %# they can be different
%points = [X(:) Y(:) Z(:)];

%plot3(points(:,1),points(:,2),points(:,3),'ro')
     % plot3([-40 40],[0 0] ,[0 0],'r-');
     % plot3([0 0],[-40 40] ,[0 0],'r-');
     % plot3([0 0],[0 0] ,[-40 40],'r-');
      
      for x=-40:40:40 %(represents x)
          for y=-40:40:40
              plot3([x x],[y y] ,[-40 40],'r-','LineWidth',0.1);
             
      %plot3([x x],[0 0] ,[-40 40],'r-');
     % plot3([x x],[-40 -40] ,[-40 40],'r-');
     % plot3([x x],[-32 -32] ,[-40 40],'r-');
     % plot3([x x],[-24 -24] ,[-40 40],'r-');
     % plot3([x x],[-16 -16] ,[-40 40],'r-');
     % plot3([x x],[-8 -8] ,[-40 40],'r-');
     % plot3([x x],[0 0] ,[-40 40],'r-');
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
      %plot3([-40 40],[z z] ,[0 0],'r-');
          end
      end
      
      
% From the BVH model exported by arena, it's clear that "y" is vertical
% and "z" is medial-lateral. (From the "offsets" between the joints.)
% Therefore, flip Y and Z when plotting to have Matlab's "vertical" z-axis
% match up.
 


  for nn = 1:length(skeleton) %38
    left_colour_change_begin=5;
    right_colour_change_begin=11;
    hold on
   % %joint% %joint
   if((nn==11)||(nn==12)||(nn==13)||(nn==5)||(nn==6)||(nn==7))
       plot3(skeleton(nn).Dxyz(1,ff),skeleton(nn).Dxyz(3,ff),skeleton(nn).Dxyz(2,ff),'g.','markersize',10)
    plot3(skeleton_1(nn).Dxyz(1,ff),skeleton_1(nn).Dxyz(3,ff),skeleton_1(nn).Dxyz(2,ff),'g.','markersize',10)
    plot3(skeleton_2(nn).Dxyz(1,ff),skeleton_2(nn).Dxyz(3,ff),skeleton_2(nn).Dxyz(2,ff),'g.','markersize',10)
    plot3(skeleton_3(nn).Dxyz(1,ff),skeleton_3(nn).Dxyz(3,ff),skeleton_3(nn).Dxyz(2,ff),'g.','markersize',10)
    plot3(skeleton_4(nn).Dxyz(1,ff),skeleton_4(nn).Dxyz(3,ff),skeleton_4(nn).Dxyz(2,ff),'g.','markersize',10)
   else
    plot3(skeleton(nn).Dxyz(1,ff),skeleton(nn).Dxyz(3,ff),skeleton(nn).Dxyz(2,ff),'y.','markersize',20)
    plot3(skeleton_1(nn).Dxyz(1,ff),skeleton_1(nn).Dxyz(3,ff),skeleton_1(nn).Dxyz(2,ff),'y.','markersize',20)
    plot3(skeleton_2(nn).Dxyz(1,ff),skeleton_2(nn).Dxyz(3,ff),skeleton_2(nn).Dxyz(2,ff),'y.','markersize',20)
    plot3(skeleton_3(nn).Dxyz(1,ff),skeleton_3(nn).Dxyz(3,ff),skeleton_3(nn).Dxyz(2,ff),'y.','markersize',20)
    plot3(skeleton_4(nn).Dxyz(1,ff),skeleton_4(nn).Dxyz(3,ff),skeleton_4(nn).Dxyz(2,ff),'y.','markersize',20)
   end;
    grid minor
    parent = skeleton(nn).parent;
    parent1 = skeleton_1(nn).parent;
    parent2 = skeleton_2(nn).parent;
    parent3 = skeleton_3(nn).parent;
    parent4 = skeleton_4(nn).parent;
    
   %lines, dxyz is point position
    if parent > 0
        
      plot3([skeleton(parent).Dxyz(1,ff) skeleton(nn).Dxyz(1,ff)],...
            [skeleton(parent).Dxyz(3,ff) skeleton(nn).Dxyz(3,ff)],...
            [skeleton(parent).Dxyz(2,ff) skeleton(nn).Dxyz(2,ff)],'k-','LineWidth',3) %change line colour   
    end
    plot3([skeleton(right_colour_change_begin).Dxyz(1,ff) skeleton(13).Dxyz(1,ff)],...
            [skeleton(right_colour_change_begin).Dxyz(3,ff) skeleton(13).Dxyz(3,ff)],...
            [skeleton(right_colour_change_begin).Dxyz(2,ff) skeleton(13).Dxyz(2,ff)],'r-','LineWidth',3)
    plot3([skeleton(left_colour_change_begin).Dxyz(1,ff) skeleton(7).Dxyz(1,ff)],...
          [skeleton(left_colour_change_begin).Dxyz(3,ff) skeleton(7).Dxyz(3,ff)],...
          [skeleton(left_colour_change_begin).Dxyz(2,ff) skeleton(7).Dxyz(2,ff)],'r-','LineWidth',3)
    if parent1 > 0
      plot3([skeleton_1(parent1).Dxyz(1,ff) skeleton_1(nn).Dxyz(1,ff)],...
            [skeleton_1(parent1).Dxyz(3,ff) skeleton_1(nn).Dxyz(3,ff)],...
            [skeleton_1(parent1).Dxyz(2,ff) skeleton_1(nn).Dxyz(2,ff)],'g-','LineWidth',3)
        grid minor

    end
    plot3([skeleton_1(right_colour_change_begin).Dxyz(1,ff) skeleton_1(13).Dxyz(1,ff)],...
            [skeleton_1(right_colour_change_begin).Dxyz(3,ff) skeleton_1(13).Dxyz(3,ff)],...
            [skeleton_1(right_colour_change_begin).Dxyz(2,ff) skeleton_1(13).Dxyz(2,ff)],'b-','LineWidth',3)
    plot3([skeleton_1(left_colour_change_begin).Dxyz(1,ff) skeleton_1(7).Dxyz(1,ff)],...
          [skeleton_1(left_colour_change_begin).Dxyz(3,ff) skeleton_1(7).Dxyz(3,ff)],...
          [skeleton_1(left_colour_change_begin).Dxyz(2,ff) skeleton_1(7).Dxyz(2,ff)],'b-','LineWidth',3)
      
    if parent2 > 0
      plot3([skeleton_2(parent2).Dxyz(1,ff) skeleton_2(nn).Dxyz(1,ff)],...
            [skeleton_2(parent2).Dxyz(3,ff) skeleton_2(nn).Dxyz(3,ff)],...
            [skeleton_2(parent2).Dxyz(2,ff) skeleton_2(nn).Dxyz(2,ff)],'k-','LineWidth',3)
        grid minor

    end
    plot3([skeleton_2(right_colour_change_begin).Dxyz(1,ff) skeleton_2(13).Dxyz(1,ff)],...
            [skeleton_2(right_colour_change_begin).Dxyz(3,ff) skeleton_2(13).Dxyz(3,ff)],...
            [skeleton_2(right_colour_change_begin).Dxyz(2,ff) skeleton_2(13).Dxyz(2,ff)],'r-','LineWidth',3)
    plot3([skeleton_2(left_colour_change_begin).Dxyz(1,ff) skeleton_2(7).Dxyz(1,ff)],...
          [skeleton_2(left_colour_change_begin).Dxyz(3,ff) skeleton_2(7).Dxyz(3,ff)],...
          [skeleton_2(left_colour_change_begin).Dxyz(2,ff) skeleton_2(7).Dxyz(2,ff)],'r-','LineWidth',3)
    
    if parent3 > 0
      plot3([skeleton_3(parent3).Dxyz(1,ff) skeleton_3(nn).Dxyz(1,ff)],...
            [skeleton_3(parent3).Dxyz(3,ff) skeleton_3(nn).Dxyz(3,ff)],...
            [skeleton_3(parent3).Dxyz(2,ff) skeleton_3(nn).Dxyz(2,ff)],'g-','LineWidth',3)
        grid minor
    end
    plot3([skeleton_3(right_colour_change_begin).Dxyz(1,ff) skeleton_3(13).Dxyz(1,ff)],...
            [skeleton_3(right_colour_change_begin).Dxyz(3,ff) skeleton_3(13).Dxyz(3,ff)],...
            [skeleton_3(right_colour_change_begin).Dxyz(2,ff) skeleton_3(13).Dxyz(2,ff)],'b-','LineWidth',3)
    plot3([skeleton_3(left_colour_change_begin).Dxyz(1,ff) skeleton_3(7).Dxyz(1,ff)],...
          [skeleton_3(left_colour_change_begin).Dxyz(3,ff) skeleton_3(7).Dxyz(3,ff)],...
          [skeleton_3(left_colour_change_begin).Dxyz(2,ff) skeleton_3(7).Dxyz(2,ff)],'b-','LineWidth',3)
      
    if parent4 > 0
      plot3([skeleton_4(parent4).Dxyz(1,ff) skeleton_4(nn).Dxyz(1,ff)],...
            [skeleton_4(parent4).Dxyz(3,ff) skeleton_4(nn).Dxyz(3,ff)],...
            [skeleton_4(parent4).Dxyz(2,ff) skeleton_4(nn).Dxyz(2,ff)],'k-','LineWidth',3)
        grid minor
    end
    plot3([skeleton_4(right_colour_change_begin).Dxyz(1,ff) skeleton_4(13).Dxyz(1,ff)],...
            [skeleton_4(right_colour_change_begin).Dxyz(3,ff) skeleton_4(13).Dxyz(3,ff)],...
            [skeleton_4(right_colour_change_begin).Dxyz(2,ff) skeleton_4(13).Dxyz(2,ff)],'r-','LineWidth',3)
    plot3([skeleton_4(left_colour_change_begin).Dxyz(1,ff) skeleton_4(7).Dxyz(1,ff)],...
          [skeleton_4(left_colour_change_begin).Dxyz(3,ff) skeleton_4(7).Dxyz(3,ff)],...
          [skeleton_4(left_colour_change_begin).Dxyz(2,ff) skeleton_4(7).Dxyz(2,ff)],'r-','LineWidth',3)
      
  end
  
  
  %view(0,0)%change view perspective
  view(-135,30)
  axis equal on % show axis meter
  
  drawnow
  
  
  
  if write_video, writeVideo(vidObj,getframe); end

end

if write_video, close(vidObj); end