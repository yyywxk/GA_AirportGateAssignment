function chroms = position(chroms,str,hangbanData,positionData,timeInter)
disp('position executing...');
[~,n] = size(chroms);
[~,m] = size(chroms{1,1}.HangbanSeNum);
[q,~] = size(positionData);
chomTemp = cell(1,1);

%���η����λ
if strcmp('first', str)
    i = 1;
    while i <= n
        %         posisionDisp = zeros(m);
      
        j = 1;
        
        while j <= m
            %����ѷ�������
            if  chroms{1,i}.unappropriated(j)==0
                j = j+1;
                continue;
            end
        
            flag1 = 1;
            
            while flag1<=2*q
                %tt = randi([1 round(q)],1,1);
                tt = randi([1 round(q-1)],1,1);
               
               
                if (((cell2mat(hangbanData(j,8))>=cell2mat(positionData(tt,7)))||strcmp(cell2mat(positionData(tt,1)),'R0'))&&...
                    ((cell2mat(hangbanData(j,7))==cell2mat(positionData(tt,6)))||(cell2mat(positionData(tt,6))==3))&&...
                        (strcmp(cell2mat(hangbanData(j,5)),cell2mat(positionData(tt,4)))||strcmp(cell2mat(positionData(tt,4)),'D, I'))&&...
                        (strcmp(cell2mat(hangbanData(j,6)),cell2mat(positionData(tt,5)))||strcmp(cell2mat(positionData(tt,5)),'D, I')))%����ƥ��
                  
                    chroms{1,i}.Position(j) = tt;
                    
                    positionData(tt,7) = num2cell(cell2mat(hangbanData(j,9)) + timeInter);
                    chroms{1,i}.unappropriated(j) = 0;
                    
                   
                    flag1 = q;
                    break;
                end
                flag1 = flag1+1;
            end
            j = j +1;
        end
        i = i+1;
        tmp = i;
        for jj=1:m
            if chroms{1,i-1}.Position(jj) == 0
                %chroms{1,i-1}.unappropriated(:) = 1;
                %i = i - 1;
                %break;
                chroms{1,i-1}.Position(jj) = 70;
                chroms{1,i-1}.unappropriated(:) = 0;
            end
        end
        if i ==tmp
            positionData(:,7)=num2cell(0);
        end
    end
    %���桢���������Է���Լ��
elseif strcmp('else', str)
    count = 0;
    i = 1;
    while i <= n
       
        j = 1;
        while j <= m
            %�����ǰ��������λ����Լ�������²�����
            if (((cell2mat(hangbanData(j,8))>=cell2mat(positionData(chroms{1,i}.Position(j),7)))||strcmp(cell2mat(positionData(chroms{1,i}.Position(j),1)),'R0'))&&...
                    ((cell2mat(hangbanData(j,7))==cell2mat(positionData(chroms{1,i}.Position(j),6)))||(cell2mat(positionData(chroms{1,i}.Position(j),6))==3))&&...
                        (strcmp(cell2mat(hangbanData(j,5)),cell2mat(positionData(chroms{1,i}.Position(j),4)))||strcmp(cell2mat(positionData(chroms{1,i}.Position(j),4)),'D, I'))&&...
                        (strcmp(cell2mat(hangbanData(j,6)),cell2mat(positionData(chroms{1,i}.Position(j),5)))||strcmp(cell2mat(positionData(chroms{1,i}.Position(j),5)),'D, I')))%����ƥ��
                if(chroms{1,i}.Position(j)<70)
                    positionData(chroms{1,i}.Position(j),7) = num2cell(cell2mat(hangbanData(j,9)) + timeInter);%���»�λ����ʱ��
                end
                j=j+1;
                continue;
            else
                %�����ǰ��������λ������Լ��
                index0 = 1;
                onuseHB = zeros(1,q);%ռ�û�λ��Ӧ����ֵ��1
                while index0 <= m
                    if ((cell2mat(hangbanData(index0,8))-timeInter<cell2mat(hangbanData(j,9))) || (cell2mat(hangbanData(index0,9))+timeInter>cell2mat(hangbanData(j,8))))
                        onuseHB(1,chroms{1,i}.Position(index0)) = 1;
                        
                    end
                    index0=index0+1;
                end
                flag1 = 1;
                onuseHB(1,70) = 0;
                while flag1 <= 2*q   %��������λ��ָ������
                    tt = randi([1 round(q)],1,1);
%                     tt = randi([1 round(q-1)],1,1);
                    
                    if(    (onuseHB(1,tt)==0)&&...%����
                            ((cell2mat(hangbanData(j,8))>=cell2mat(positionData(tt,7)))||strcmp(cell2mat(positionData(tt,1)),'R0'))&&...
                            ((cell2mat(hangbanData(j,7))==cell2mat(positionData(tt,6)))||(cell2mat(positionData(tt,6))==3))&&...
                            (strcmp(cell2mat(hangbanData(j,5)),cell2mat(positionData(tt,4)))||strcmp(cell2mat(positionData(tt,4)),'D, I'))&&...
                            (strcmp(cell2mat(hangbanData(j,6)),cell2mat(positionData(tt,5)))||strcmp(cell2mat(positionData(tt,5)),'D, I')))%����ƥ��
                        
                        
                        chroms{1,i}.Position(j) = cell2mat(positionData(tt,8));
                        positionData(tt,7) = num2cell(cell2mat(hangbanData(j,9)) + timeInter);
                        chroms{1,i}.unappropriated(j) = 0;%
                        j=j+1;
                        flag1 = q;
                        break;
                    end
                    flag1 = flag1 + 1;
                    chroms{1,i}.unappropriated(j) = 1;
                    
                end
                j = j+1;
            end
            
        end
        posisionDisp = chroms{1,i}.Position;
        posisionDisp;
        i = i+1;
        for jj=1:m
            if chroms{1,i-1}.unappropriated(jj) ~= 0
                chomTemp{1,1} = chroms{1,i-1};
                chomTemp = position(chomTemp,'first',hangbanData,positionData,timeInter);
                chroms{1,i-1} = chomTemp{1,1} ;
                count = count +1;
                break;
            end
        end
        positionData(:,7)=num2cell(0);
    end
    count
end

end