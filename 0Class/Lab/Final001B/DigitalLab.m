%This worked on 11/24/2012 at 6:30PM
%while(true)
%    val=fread(b,215)
%end

%s = serial('COM14')
%fopen(s)
%while(true)
%    fprintf(s,'Hello World')
%    idn = fscanf(s)
%end
%fclose(s);
%http://www.mathworks.com/help/instrument/bluetooth.html
%find id using
%instrhwinfo('Bluetooth');
%connect to bluetooth
%b = Bluetooth('FireFly-B2C5')

% b = Bluetooth('FireFly-B2C5',1,'InputBufferSize',800)
 %fopen(b)
%    while(true)
%         readBuf=fread(b,24*1000,'uint8');%bitshift,1);
%         if(vali==10)
%             %readBuf(1)
%             vali=0;
% 
%             %pause(0.001)
%         end
%         vali=vali+1
%         %pause(1)
%         while(b.bytesAvailable==0)
%             fwrite(b,'a');
%         end
%     end
 function DigitalLab()
    grab=10
    b = Bluetooth('FireFly-B2C5',1,'InputBufferSize',2*25*grab);%,'BytesAvailableFcnCount',2*25*grab,'BytesAvailableFcnMode','byte');%,'BytesAvailableFcn',{@local_uart_callback});
    b.ReadAsyncMode='continuous';
    set(b,'Terminator',121);
    
%     vali=0;
    sync=-1;
    grabFirst=zeros(25*grab);
    for k=1:grab-2
        grabFirst(25*k+0)=1;
        grabFirst(25*k+1)=1;
        grabFirst(25*k+2)=1;
    end
    grabFirsti=find(grabFirst);
%     
    f = 250/2*3/2*linspace(0,1,25*(grab-2)*3/25);

    fopen(b);
    pause(0.5);
	bufferA=zeros(0,1);
    dtgraphA=zeros(grab*50,1);
    %readasync(b);
    while(true)
        %disp(vali)
        %bytsA=b.bytesAvailable
        %clrdevice(b);
        %fscanf(b)
        try
            pause(0.1);
            bav=get(b, 'BytesAvailable')
            if(bav>=0)
                [A,count,msg] = fread(b);%,min(bav,25*grab));
                disp(msg);
                if(~strcmp(msg,''))%'The specified amount of data was not returned within the Timeout period.'))
                   fclose(b)
                   fopen(b)
                  pause(0.5)

    %              if(msg=='The specified amount of data was not returned within the Timeout period.')
    %                 fclose(b)
    %                 fopen(b)
                 else

                    %bufferA=append(bufferA,A)
                   bufferA=vertcat(bufferA,A);
                    if(size(bufferA,1)>=25*grab)
                        sync=find(bufferA(1:25)==119);
                        readBuf=bufferA((sync+1):(25*grab-(25-sync)));
                        readBuf=readBuf(grabFirsti);

                        vertcat(readBuf((sync+1):end),readBuf(1:sync));
                        dtgraph=bin2num(quantizer([24,23]),dec2bin(2^((2)*8)*readBuf));
                        dtgraphA(1:end-size(dtgraph)+1)=dtgraphA(size(dtgraph):end);
                        
                        
                        disp(size(dtgraphA(end-size(dtgraph)+1:end)))
                        disp(size(dtgraph(1:end)))
                        dtgraphA(end-size(dtgraph)+1:end)=dtgraph(1:end);
                        %dtgraph(55*250/3:65*250/3)=0;
                        dtgraphPlot=abs(fft(dtgraphA));
                        f = 250/2*3/2*linspace(0,1,size(dtgraphA,1));
                        dtgraphPlot(55/(250/2*3/2)*size(dtgraphA,1):65/(250/2*3/2)*size(dtgraphA,1))=0;
                        disp(size(f))
                        disp(size(dtgraphPlot))
                        plot(f,dtgraphPlot)
                        pause(0.05);
                       bufferA=zeros(0);%bufferA(25:end);
                    end
                end
                %flushinput(b);
                %da=fscanf(b, '%c', 512);
                %real(A)
            else
                disp('reset')
                fclose(b)
                disp('openAgain')
                fopen(b)
                disp('done')
                pause(0.5)
            end
        catch err
            disp('in catch')
            disp(err)
            fclose(b)
            fopen(b)
           % pause(0.5)
        end
        %fscanf(b, '%x', 512)
        %flushinput(b);
%         if(bytsA>0)%25*grab)
%              disp(bytsA)
%              fread(b,bytsA);
%              fscanf(b,'%c',bytsA);
%             flushinput(b);
%         end
        %pause(0.5)
        %vali=vali+1;
    end
    
    
%     function local_uart_callback(b,event)
%         disp(b.BytesAvailable)
% %         if(b.BytesAvailable==0)
% %             fopen(b)
% %         end
%         %fread(b);
%         
%         %readBuf=fread(b,25*grab,'uint8');%bitshift,1);
%         %flushinput(b);
%         %fread(b);%clear rest
% %        sync=find(readBuf(1:25)==119);
% %        readBuf=readBuf((sync+1):(end-(25-sync)));
% %        readBuf=readBuf(grabFirsti);
%         %vertcat(readBuf((sync+1):end),readBuf(1:sync))
%         %dtgraph=bin2num(quantizer([24,23]),dec2bin(2^((2)*8)*readBuf));
%         %dtgraph(55*250/3:65*250/3)=0;
%         %plot(f,abs(fft(dtgraph)))
%         vali=vali+1;
%         %fread(b);
%         %clear(b)
%         %flushinput(b);
%     end
%     
%  end
% % 
%  graphSize=2000;
%  inputSize=2;
%  graph1=randi(256,inputSize*32,1);
%  graph2=randi(256,inputSize*32,1);
%  graph3=randi(256,inputSize*32,1);
%  graph4=randi(256,inputSize*32,1);
%  graph5=randi(256,inputSize*32,1);
%  graph6=randi(256,inputSize*32,1);
%  graph7=randi(256,inputSize*32,1);
%  graph8=randi(256,inputSize*32,1);
%  readBuf=randi(256,24,1);
%  hold on
%  subplot(4,2,1);plt1=plot(graph1);
%  subplot(4,2,2);plt2=plot(graph2);
%  subplot(4,2,3);plt3=plot(graph3);
%  subplot(4,2,4);plt4=plot(graph4);
%  subplot(4,2,5);plt5=plot(graph5);
%  subplot(4,2,6);plt6=plot(graph6);
%  subplot(4,2,7);plt7=plot(graph7);
%  subplot(4,2,8);plt8=plot(graph8);
%  
%  %linkdata on
%  %val=randi(256,8,1);
%  %val=zeros(2,inputSize);
%  valb=0;
% while(true)
%     %val=randi(256,inputSize,1);
%     vali=1;
%     fwrite(b,'a');
%     while(true)
%         readBuf=fread(b,24*1000,'uint8');%bitshift,1);
%         if(vali==10)
%             %readBuf(1)
%             vali=0;
%             
%             %pause(0.001)
%         end
%         vali=vali+1
%         %pause(1)
%         while(b.bytesAvailable==0)
%             1
%         end
%     end
%     
%     d  = fdesign.notch('N,F0,Q,Ap',6,60,10,1);
%     df=fft(dtgraph)
%     df(57:63)=0
%     dtgraphB=ifft(df)
%      
%     dtgraph=bin2num(quantizer([24,23]),dec2bin(2^((2)*8)*readBuf));
%     2^((23)*8)*readBuf(1:10)
%     
%     while(vali<=8)
%         %fwrite(b,'a');
%         %val=fread(b,1,'uint8')+256*fread(b,1,'uint8')+256*256*fread(b,1,'uint8');
%         aa=readBuf(3*vali+0-2);%bitand(readBuf(3*vali+0-2-1),127)+2*bitand(readBuf(3*vali+0-2),127);%fread(b,1,'uint8');
%         bb=readBuf(3*vali+1-2);%bitand(readBuf(3*vali+0-2-1),127)+2*bitand(readBuf(3*vali+1-2),127);
%         cc=readBuf(3*vali+2-2);%bitand(readBuf(3*vali+0-2-1),127)+2*bitand(readBuf(3*vali+2-2),127);%fread(b,1,'uint8');
%         %\cc=readBuf;=fread(b,1,'uint8');
%         %val=tc2dec(readBuf(3*vali+0-2:3*vali+2-2),24)%tc2dec(cc+256*bb+256*256*aa,24)
%         val=twos2decimal(cc+256*bb+256*256*aa,24);
%         %graph(1:end-size(val)+1,:)= graph(size(val):end,:);
%             %graph(end-size(val)+1:end,:)=val;
%         if(vali==1)
%             graph1(1:end-1,:)= graph1(2:end,:);
%             graph1(end,:)=val;
%         end
%         if(vali==2)
%             graph2(1:end-1,:)= graph2(2:end,:);
%             graph2(end,:)=val;
%         end
%         if(vali==3)
%             graph3(1:end-1,:)= graph3(2:end,:);
%             graph3(end,:)=val;
%         end
%         if(vali==4)
%             graph4(1:end-1,:)= graph4(2:end,:);
%             graph4(end,:)=val;
%         end
%         if(vali==5)
%             graph5(1:end-1,:)= graph5(2:end,:);
%             graph5(end,:)=val;
%         end
%         if(vali==6)
%             graph6(1:end-1,:)= graph6(2:end,:);
%             graph6(end,:)=val;
%         end
%         if(vali==7)
%             graph7(1:end-1,:)= graph7(2:end,:);
%             graph7(end,:)=val;
%         end
%         if(vali==8)
%             graph8(1:end-1,:)= graph8(2:end,:);
%             graph8(end,:)=val;
%         end
%         vali=vali+1;
%     end
% 
%     valb=valb+1;
%     %graph1(end,:)=readBuf(1);
%     %graph2(end,:)=readBuf(2);
%     %graph3(end,:)=readBuf(3);
%     %{readBuf(1),readBuf(2),readBuf(3)}
%     if(valb>=10)
%         set(plt1,'ydata',graph1);
%         set(plt2,'ydata',graph2);
%         set(plt3,'ydata',graph3);
%         set(plt4,'ydata',graph4);
%         set(plt5,'ydata',graph5);
%         set(plt6,'ydata',graph6);
%         set(plt7,'ydata',graph7);
%         set(plt8,'ydata',graph8);
%         valb=0;
%     end
%     pause(0.000001)
%     %plot(graph);
%  end
%  