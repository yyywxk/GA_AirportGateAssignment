% function chroms = fitness(chroms, positionData, time, hangbanData, oilCost, w1, w2, w3, goal)
function chroms = fitness(chroms, positionData, hangbanData, peopleData, w1, w2, w3, goal)
disp('fitness executing...');
[~,t] = size(chroms);%Ⱦɫ�������
[~,m] = size(chroms{1,1}.HangbanSeNum);%�ɻ�����
[n,~] = size(positionData);%�ǻ�����������������ǻ���
chromsIndex = 1;
if goal~=1
    flightA=cell2mat(peopleData(:,7)');%��ȡ�˿͵��ﺽ��ɻ����
    flightD=cell2mat(peopleData(:,8)');%��ȡ�˿ͳ�������ɻ����
    [~,k]=size(flightA);%�˿�������
    num=cell2mat(peopleData(:,2)');%ÿ��˿͵�����
    traveler=1;
end
while chromsIndex<=t
    HangbanIndex = 1;
%     kaoqiaohbNum = 0;
%     cost = 0;
    flightSum=0;
    gateSum=zeros(1,n);
    if goal~=1
        stress=zeros(1,k);
        CirtimeSum=zeros(1,k);%����ʱ��
        CirtimeSum1=zeros(1,k);%������ʱ��
        PorttimeSum=zeros(1,k);%����ʱ��
        WalktimeSum=zeros(1,k);%����ʱ��
        timeSum=zeros(1,k);%�ÿͻ���ʱ��
        jiont_time=zeros(1,k);%��������ʱ��
    end
   while HangbanIndex<=m        
        Pos = chroms{1,chromsIndex}.Position(HangbanIndex);%�ɻ���Ӧ�ĵǻ���
        %ͣ�ڹ̶��ǻ��ڵķɻ�����
       if Pos< n
           flightSum=flightSum+1;
       end             
        %���ʹ�õĵǻ��ڵ�����
        if Pos< n
           gateSum(Pos)=1;
        end       
        HangbanIndex = HangbanIndex+1;
   end 
    
   if goal~=1
       %��������ʱ���������Ŷ�
        while traveler<=k
            PosA=chroms{1,chromsIndex}.Position(flightA(1,traveler));%����ɻ���Ӧ�ĵǻ���
            PosD=chroms{1,chromsIndex}.Position(flightD(1,traveler));%�����ɻ���Ӧ�ĵǻ���
            if strcmp(cell2mat(hangbanData(flightA(1,traveler),5)),'D')&& strcmp(cell2mat(hangbanData(flightD(1,traveler),6)),'D')
                if(( PosA<29 && PosD<29)||((28<PosA)&&(PosA<70) && (28<PosD)&&(PosD<70)))
                    CirtimeSum(1,traveler)=15;%���ں�վ¥T�����������S
                    PorttimeSum(1,traveler)=0;
                elseif((PosA<70) &&(PosD<70))%ͣ����ʱͣ���ĺ��಻����
                    CirtimeSum(1,traveler)=20;
                    PorttimeSum(1,traveler)=1*8;
                end
            elseif(strcmp(cell2mat(hangbanData(flightA(1,traveler),5)),'D')&& strcmp(cell2mat(hangbanData(flightD(1,traveler),6)),'I'))
                if(( PosA<29 && PosD<29)||((28<PosA)&&(PosA<70) && (28<PosD)&&(PosD<70)))
                    CirtimeSum(1,traveler)=35;%���ں�վ¥T�����������S
                    PorttimeSum(1,traveler)=0;
                elseif((PosA<70) &&(PosD<70))
                    CirtimeSum(1,traveler)=40;
                    PorttimeSum(1,traveler)=1*8;
                end
            elseif(strcmp(cell2mat(hangbanData(flightA(1,traveler),5)),'I')&& strcmp(cell2mat(hangbanData(flightD(1,traveler),6)),'I'))
                if(( PosA<29 && PosD<29)||((28<PosA)&&(PosA<70) && (28<PosD)&&(PosD<70)))
                    CirtimeSum(1,traveler)=20;%���ں�վ¥T�����������S
                    PorttimeSum(1,traveler)=0;
                elseif((PosA<70) &&(PosD<70))
                    CirtimeSum(1,traveler)=30;
                    PorttimeSum(1,traveler)=1*8;
                end
            elseif(strcmp(cell2mat(hangbanData(flightA(1,traveler),5)),'I')&& strcmp(cell2mat(hangbanData(flightD(1,traveler),6)),'D'))
                if(( PosA<29 && PosD<29))
                    CirtimeSum(1,traveler)=35;%���ں�վ¥T
                    PorttimeSum(1,traveler)=0;
                elseif((28<PosA)&&(PosA<70) && (28<PosD)&&(PosD<70))
                    CirtimeSum(1,traveler)=45;%����������S
                    PorttimeSum(1,traveler)=2*8;
                elseif((PosA<70) &&(PosD<70))
                    CirtimeSum(1,traveler)=40;
                    PorttimeSum(1,traveler)=1*8;
                end
            end

            if (PosA<=9&&PosD<=9)%����ʱ��
                WalktimeSum(1,traveler)=10;       
            elseif ((PosA<=9)&&(PosD>=10&&PosD<=19))||((PosD<=9)&&(PosA>=10&&PosA<=19))
                WalktimeSum(1,traveler)=15;
            elseif ((PosA<=9)&&(PosD>=20&&PosD<=28))||((PosD<=9)&&(PosA>=20&&PosA<=28))
                WalktimeSum(1,traveler)=20;
            elseif ((PosA<=9)&&(PosD>=29&&PosD<=38))||((PosD<=9)&&(PosA>=29&&PosA<=38)) 
                WalktimeSum(1,traveler)=25;
            elseif ((PosA<=9)&&(PosD>=39&&PosD<=48))||((PosD<=9)&&(PosA>=39&&PosA<=48))     
                WalktimeSum(1,traveler)=20;
            elseif ((PosA<=9)&&(PosD>=49&&PosD<=58))||((PosD<=9)&&(PosA>=49&&PosA<=58))
                WalktimeSum(1,traveler)=25;
            elseif ((PosA<=9)&&(PosD>=59&&PosD<=69))||((PosD<=9)&&(PosA>=59&&PosA<=69))    
                WalktimeSum(1,traveler)=25;
            elseif (PosA>=10&&PosA<=19)&&(PosD>=10&&PosD<=19)
                WalktimeSum(1,traveler)=10;
            elseif ((PosA>=10&&PosA<=19)&&(PosD>=20&&PosD<=28))||((PosD>=10&&PosD<=19)&&((PosA>=20&&PosA<=28)))
                WalktimeSum(1,traveler)=15;
            elseif ((PosA>=10&&PosA<=19)&&(PosD>=29&&PosD<=38))||((PosD>=10&&PosD<=19)&&((PosA>=29&&PosA<=38)))
                WalktimeSum(1,traveler)=20;
            elseif ((PosA>=10&&PosA<=19)&&(PosD>=39&&PosD<=48))||((PosD>=10&&PosD<=19)&&((PosA>=39&&PosA<=48)))
                WalktimeSum(1,traveler)=15;
            elseif ((PosA>=10&&PosA<=19)&&(PosD>=49&&PosD<=58))||((PosD>=10&&PosD<=19)&&((PosA>=49&&PosA<=58)))
                WalktimeSum(1,traveler)=20;
            elseif ((PosA>=10&&PosA<=19)&&(PosD>=59&&PosD<=69))||((PosD>=10&&PosD<=19)&&((PosA>=59&&PosA<=69)))
                WalktimeSum(1,traveler)=20;
            elseif ((PosA>=20&&PosA<=28)&&(PosD>=20&&PosD<=28))
                WalktimeSum(1,traveler)=10;
            elseif ((PosA>=20&&PosA<=28)&&(PosD>=29&&PosD<=38))||((PosD>=20&&PosD<=28)&&((PosA>=29&&PosA<=38)))
                WalktimeSum(1,traveler)=25;
            elseif ((PosA>=20&&PosA<=28)&&(PosD>=39&&PosD<=48))||((PosD>=20&&PosD<=28)&&((PosA>=39&&PosA<=48)))
                WalktimeSum(1,traveler)=20;
            elseif ((PosA>=20&&PosA<=28)&&(PosD>=49&&PosD<=58))||((PosD>=20&&PosD<=28)&&((PosA>=49&&PosA<=58)))
                WalktimeSum(1,traveler)=25;
            elseif ((PosA>=20&&PosA<=28)&&(PosD>=59&&PosD<=69))||((PosD>=20&&PosD<=28)&&((PosA>=59&&PosA<=69)))
                WalktimeSum(1,traveler)=25;
            elseif ((PosA>=29&&PosA<=38)&&(PosD>=29&&PosD<=38))
                WalktimeSum(1,traveler)=10;
            elseif ((PosA>=29&&PosA<=38)&&(PosD>=39&&PosD<=48))||((PosD>=29&&PosD<=38)&&((PosA>=39&&PosA<=48)))
                WalktimeSum(1,traveler)=15;
            elseif ((PosA>=29&&PosA<=38)&&(PosD>=49&&PosD<=58))||((PosD>=29&&PosD<=38)&&((PosA>=49&&PosA<=58)))
                WalktimeSum(1,traveler)=20;
            elseif ((PosA>=29&&PosA<=38)&&(PosD>=59&&PosD<=69))||((PosD>=29&&PosD<=38)&&((PosA>=59&&PosA<=69)))
                WalktimeSum(1,traveler)=20;
            elseif ((PosA>=39&&PosA<=48)&&(PosD>=39&&PosD<=48))
                WalktimeSum(1,traveler)=10;
            elseif ((PosA>=39&&PosA<=48)&&(PosD>=49&&PosD<=58))||((PosD>=39&&PosD<=48)&&((PosA>=49&&PosA<=58)))
                WalktimeSum(1,traveler)=15;
            elseif ((PosA>=39&&PosA<=48)&&(PosD>=59&&PosD<=69))||((PosD>=39&&PosD<=48)&&((PosA>=59&&PosA<=69)))
                WalktimeSum(1,traveler)=15;
            elseif ((PosA>=49&&PosA<=58)&&(PosD>=49&&PosD<=58))
                WalktimeSum(1,traveler)=10;
            elseif ((PosA>=49&&PosA<=58)&&(PosD>=59&&PosD<=69))||((PosD>=49&&PosD<=58)&&((PosA>=59&&PosA<=69)))
                WalktimeSum(1,traveler)=20;    
            elseif ((PosA>=59&&PosA<=69)&&(PosD>=59&&PosD<=69))
                WalktimeSum(1,traveler)=10;        
            end
            CirtimeSum1(1,traveler)=num(1,traveler)*CirtimeSum(1,traveler);%������ʱ��
            timeSum(1,traveler)=CirtimeSum(1,traveler)+PorttimeSum(1,traveler)+WalktimeSum(1,traveler);%����һ���ÿ͵Ļ���ʱ��
            jiont_time(1,traveler)=cell2mat(hangbanData(flightD(1,traveler),9))-cell2mat(hangbanData(flightA(1,traveler),8));
            stress(1,traveler)=num(1,traveler)*timeSum(1,traveler)/jiont_time(1,traveler);%����һ���ÿ͵Ļ��˽��Ŷ�
            %���ǻ���ʧ�ܵĳͷ�����
            if(stress(1,traveler)>1)
                timeSum(1,traveler)=6*60;
                stress(1,traveler)=num(1,traveler)*timeSum(1,traveler)/jiont_time(1,traveler);
            end

            traveler=traveler+1;    
        end
   end
    
    
    switch (goal)
        case 1
            %ͣ�ڹ̶��ǻ��ڵķɻ�����
            chroms{1,chromsIndex}.fitness1 = 1/flightSum;
        case 2
            %��������ʱ��
            chroms{1,chromsIndex}.fitness2 = sum(CirtimeSum1);
            %������Ŷ�
%             chroms{1,chromsIndex}.fitness2 = sum(stress);
        case 3
            %ʹ�õĵǻ��ڵ�����
            chroms{1,chromsIndex}.fitness3 = sum(gateSum);
        case 0
            %ͣ�ڹ̶��ǻ��ڵķɻ�����
            chroms{1,chromsIndex}.fitness1 = 1/flightSum;
            %��������ʱ��
            chroms{1,chromsIndex}.fitness2 = sum(CirtimeSum1);
            %������Ŷ�
            %chroms{1,chromsIndex}.fitness2 = sum(stress);
            %ʹ�õĵǻ��ڵ�����
            chroms{1,chromsIndex}.fitness3 = sum(gateSum);
            %��Ŀ��===================
            fitness1 = 1/flightSum;
            fitness2 = chroms{1,chromsIndex}.fitness2;%��󻯱���С����ȡ����
            fitness3 = sum(gateSum);
            %%��һ��=====================
            fit0 = max([fitness1, fitness2,fitness3]);  %����������ĸ
            chroms{1,chromsIndex}.fitness = w1*fitness1/fit0 + w2*fitness2/fit0+ + w3*fitness3/fit0;%��Ŀ�꺯����ʽ
        otherwise
            fprintf('ERROR������Ŀ���������\n' );
    end  
    chromsIndex = chromsIndex + 1;
end
end