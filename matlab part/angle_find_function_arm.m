%                        *target pt(pt)
%
%                    p1_____ p2
%                           |
%                           |
%                           |
%                           |p3
%
%
function count_length  = angel_find_function_4_3debug(all_angel)
global all_pt;

% p1 p2 and p3 are joints on a limb
global p1;
global p2;
global p3;
global p4;
pt=[0;0;0;];
all_length=0;
for i = 1:1
        
        %pt(i) holds the all_pt parameter
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
          %Show the change of the arm after before CCD

        Mx=sum(M([1 2 3 ],1)); My=sum(M([1 2 3],2));Mz=sum(M([1 2 3],3));

        % construct points matrix
         pts = [ p1' 1; p2' ,1; p3' 1]';
         % transform points with M
         ptspi = M * pts;
         %ptspi =pts;  
        end;
        
        p1x=ptspi(1,1);p1y=ptspi(2,1); p1z=ptspi(3,1);p11=[p1x;p1y;p1z];
        p2x=ptspi(1,2);p2y=ptspi(2,2); p2z=ptspi(3,2);p22=[p2x;p2y;p2z];
        p3x=ptspi(1,3);p3y=ptspi(2,3); p3z=ptspi(3,3);p33=[p3x;p3y;p3z];
        normp=cross(p33-p22,p11-p22);%plane equation
        uninormp =normp/norm(normp);%unit vector

        ppp1=AxelRot((all_angel(i,1))/ pi * 180, uninormp, p22);
        pt1pii = ppp1*[p11;1];
    
        % now rotate first joint (controlling p2-p1)
        xformPts = [ pt1pii(1:3) p22 p33];
     
        ppp1=AxelRot(all_angel(i,2) / pi * 180, uninormp, p33);
        ptspii = ppp1 * [xformPts [1; 1; 1]; 1 1 1 1 ];
   
    
        A=[pt(1)-ptspii(1,1) pt(2)-ptspii(2,1) pt(3)-ptspii(3,1)];
        length_of_lineA= sqrt(sum(A.^2));
    
        length=length_of_lineA;
        all_length=all_length+length;
        
        % if(i==3)
         %    h = plot3( ptspii(1,1:3), ptspii(2,1:3), ptspii(3,1:3), 'b-'); set(h,'linewidth',1);
        % end;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Show the change of the arm after before CCD
%h = plot3( ptspii(1,1:3), ptspii(2,1:3), ptspii(3,1:3), 'b-');
%set(h,'linewidth',2);
%h = plot3( ptspii(2,1:3), ptspii(1,1:3), ptspii(3,1:3), 'b-'); set(h,'linewidth',1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 end;
    count_length=all_length;
    disp(count_length);
    return;
end