function correctedV = fillGaps(V,oldV,Fs)

correctedV = V;
for i = 1:size(V,2)
        
    % indices of good data points; add 0 at begin and end to detect NaN
    % at first and last point
    goodPoints = find(~isnan([0; correctedV(:,i);0]));
        
    % do we need to do anything?
    if (length(goodPoints)-2) == length(correctedV(:,i))  % -2 because 0 was added twice above
       continue
    end
        
    % length of NaN parts
    d = diff(goodPoints);
    d = d - 1;
    lengthGaps = d(d > 0);
    idGaps(:,1) = goodPoints(d > 0); % not +1 because 0 was added above before correctedV;
    idGaps(:,2) = idGaps(:,1) + lengthGaps - 1;
    for gap = 1:length(lengthGaps)
            
        if idGaps(gap,1) == 1 || idGaps(gap,2) == length(correctedV(:,i)) || lengthGaps(gap) >= Fs

            % apply one second running mean
            Fr = round(Fs/2);
            Fc = 0;
            IND = idGaps(gap,1):idGaps(gap,2);
            dummy = smooth_maverage(oldV(:,i),Fr,Fc,IND);
            correctedV(IND,i) = dummy(IND);
            
         else
    
            % apply linear interpolation 
            IND = idGaps(gap,1):idGaps(gap,2);
            dummy = interp1([IND(1)-1 IND(end)+1],[V(IND(1)-1,i) V(IND(end)+1,i)],IND,'linear');
            correctedV(IND,i) = dummy(:);
                
        end
            
         clear dummy
            
    end % gap
        
     clear idGaps
        
end % for
    
