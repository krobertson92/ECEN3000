
function DigitalLab(b)
    grab=500;
    stepCounter=0;
    stepCounterch2=0;
    stepStopper=0;
    stepStopperch2=0;
    set(b,'BaudRate',115200,'InputBufferSize',2*28*grab,'OutputBufferSize',28*grab,'BytesAvailableFcnCount',28*grab,'BytesAvailableFcnMode','byte','BytesAvailableFcn',{@local_uart_callback});
    num_channels = 8;
    adc_bytes=3;
    header_bytes=3;
    num_start_bytes=1;
    %packet_size = num_channels*adc_bytes+header_bytes+num_start_bytes;
    
    sync=-1;
    global grabFirst grabFirsti f bufferA dtgraph dtgraphch2 startA dtgraphBuffer dtgraphBufferch2 H_stop H_low
    %filter setup:
    [B_stop, A_stop]=butter (8, [60/grab,80/grab],'stop');
    [D_low, C_low]=butter (8, 40/grab, 'low')
    [H_stop, f1]=freqz (B_stop, A_stop, grab);
    [H_low,f2]=freqz (D_low, C_low, grab);
    
    
    startA=0;
    grabFirst=zeros(25*grab,1);
    dtgraphBuffer=zeros(20*grab,1);
    dtgraphBufferch2=zeros(20*grab,1);
    dtgraphBufferB=zeros(5*grab,1);
    dtgraphBufferBch2=zeros(5*grab,1);
    for k=1:grab-2
        grabFirst(25*k+0)=1;
        grabFirst(25*k+1)=1;
        grabFirst(25*k+2)=1;
    end
    grabFirsti=find(grabFirst);

    bufferA=zeros(0);
    dtgraph=zeros(grab-3,1);
    dtgraphch2=zeros(grab-3,1);
    
    fopen(b);
    while(true)
        pause(0.001);
    end

    function local_uart_callback(b,event)
        pause(0.001);
        try
            disp('recieving data...');
            pause(0.001)
            %ts = get(b,'TransferStatus')
            bav=get(b, 'BytesAvailable')
            if(bav>0&&startA==0)
                fread(b);
            end
            startA=1;
%             while(bav<=500)
%                 pause(0.001)
%                 bav=get(b, 'BytesAvailable')
%             end
            %bav=get(b, 'BytesAvailable')
            if(bav>500)
                disp('bytes are available...')
                [A,~,msg] = fread(b,bav);%fread(b);%,25*grab);
                if(~strcmp(msg,''))%'The specified amount of data was not returned within the Timeout period.'))
                   error(msg);
                else
                    disp('bufferA concat stuff...');
                    bufferA=A;%vertcat(bufferA,A);
                    if(size(bufferA,1)>=28*grab)
                        disp('bufferA sufficiently large...')
                        sync=find(bufferA(1:28)==119);
                        disp('Sync Val')
                        disp(sync);
                        enndloc=(sync)+floor((size(bufferA,1)-sync)/28)*28;
                        disp(enndloc);
                        disp('picking out data...');
                        readBuf=bufferA((sync+1):enndloc);%(28*grab-(28-sync)));
                        %disp(readBuf);
                        %for i=1:3*25
                        %    disp(dec2bin(readBuf(i),8));
                        %end
                        %readBuf=readBuf(grabFirsti);%channel 1
                       % vertcat(readBuf((sync+1):end),readBuf(1:sync));
                       
                       disp('preparing plot...');
                       
                       %disp(dec2bin(readBuf(grabFirsti(4)+0),8));
                       %disp(dec2bin(readBuf(grabFirsti(1)+1),8));
                       %disp(dec2bin(readBuf(grabFirsti(2)+1),8));
                       %disp(dec2bin(readBuf(grabFirsti(3)+1),8));
                       
                       dtgraph=zeros(grab-2,1);%size(readBuf,1)/27-2,1);
                       dtgraphch2 = zeros(grab-2,1);
                       
                       disp('Looping');
                       disp(size(readBuf));
                       for i=1:size(readBuf,1)/28-1%grab-2%size(readBuf,1)/29-2%3:size(grabFirsti)-3
                        index=i;%ceil(i/3);
                        %disp('A');
%                         disp(i);
%                         disp(grabFirsti(1)+0+i*25);
%                         if(readBuf(grabFirsti(1)+0+i*25)~=119)
%                             disp('BADDDDDDDDDDDDDDDDDDDDD DATA');
%                         end
                        %disp(dec2bin(readBuf(grabFirsti(1)+0+i*25),8));
                        %disp(dec2bin(readBuf(grabFirsti(1)+1+i*25),8));
                        %disp(dec2bin(readBuf(grabFirsti(1)+2+i*25),8));
                        %disp(dec2bin(readBuf(grabFirsti(1)+3+i*25),8));
                        dtgraph(index)= 256*256*readBuf(i*28+10)+256*readBuf(i*28+11)+readBuf(i*28+12);%+readBuf(i*28+4+1);%0*2^((2)*8)*readBuf(grabFirsti(1)+1+i*25) + 0*2^((1)*8)*readBuf(grabFirsti(1)+2+i*25) + 0*2^((0)*8)*readBuf(grabFirsti(1)+3+i*25); 
                        dtgraphch2(index)= 256*256*readBuf(i*28+13)+256*readBuf(i*28+14)+readBuf(i*28+15);
                        %dtgraphch2(index)= 256*256*readBuf(i*28+7)+256*readBuf(i*28+8)+readBuf(i*28+9);%+readBuf(i*28+4+1);%0*2^((2)*8)*readBuf(grabFirsti(1)+1+i*25) + 0*2^((1)*8)*readBuf(grabFirsti(1)+2+i*25) + 0*2^((0)*8)*readBuf(grabFirsti(1)+3+i*25); 
                        %disp(dec2bin(dtgraph(index),24));
%                         if(dtgraph(index)>=2^(8*3-1))
%                             disp('Neg');
%                             dtgraph(index)=dtgraph(index)-2^(8*3-1)-2^(8*3-1);
%                         end
                        disp(dec2bin(dtgraph(index),16));
                        if(dtgraph(index)>=256*256*64)
                            disp('Neg');
                            dtgraph(index)=dtgraph(index)-2*64*256*256;
                        end
                        if(dtgraphch2(index)>=256*256*64)
                            disp('Neg ch2');
                            dtgraphch2(index)=dtgraphch2(index)-2*64*256*256;
                        end
                        disp('ABC');

                        if(dtgraph(index)>7.22*10^5)%dtgraph(index)<7.1*10^5||
                            if(stepStopper==0)
                                stepCounter=stepCounter+1;
                            end
                            stepStopper=2*20;
                            %stepStopper=stepCounter+1;
                        else
                            stepStopper=stepStopper-1;
                            if(stepStopper<0)
                                stepStopper=0;
                            end
                        end
                        
                        if(dtgraphch2(index)>2.0*10^5)%2.9*10^5)dtgraphch2(index)<1.8*10^5||
                            if(stepStopper==0)
                                stepCounterch2=stepCounterch2+1;
                            end
                            stepStopper=2*20;
                            %stepStopper=stepCounter+1;
                        else
                            stepStopper=stepStopper-1;
                            if(stepStopper<0)
                                stepStopper=0;
                            end
                        end
                        
                        %disp('Data');
                        %disp(index);
                        disp(dtgraph(index));
                        %disp(dec2bin(dtgraph(index),24))
                       end
                       %disp(dtgraph);
                       %disp(dec2bin(readBuf(1:500),8));
                       disp(stepCounter);
                       disp(stepCounterch2);
                       disp('Check Sizes');
                       disp(size(dtgraphBuffer));
                       
                       dtgraphBufferB(1:end-size(dtgraph))=dtgraphBufferB(size(dtgraph)+1:end);
                       dtgraphBufferB(end-size(dtgraph)+1:end)=dtgraph;
                       
                       dtgraphBufferBch2(1:end-size(dtgraphch2))=dtgraphBufferBch2(size(dtgraphch2)+1:end);
                       dtgraphBufferBch2(end-size(dtgraphch2)+1:end)=dtgraphch2;
                       
                       dtgraphBufferB_fft=abs(fft(dtgraphBufferB));
                       subplot(4,2,7);plt1=plot(dtgraph);%dtgraphBufferB_fft(100:end-100));
                       
                       dtgraphBufferBch2_fft=abs(fft(dtgraphBufferBch2));
                       subplot(4,2,8);plt1=plot(dtgraphch2);%dtgraphBufferB_fft(100:end-100));
                       
                       
                       
                       
                       disp('filtering...');
                       %channel 1
                        d=fft(dtgraph);
                        E=d;
                        %E(1:97)=0;
                        %E(70:78)=0;
                        E(50:end)=0;
                        %E(size(E)/2:end)=0;
                        %E(10:end)=0;%E=d.*H_stop(1:grab-2).*H_low(1:grab-2);
                        filtered_graph = real(ifft(E));
                        dtgraph=filtered_graph;
                       %channel 2
                        dch2=fft(dtgraphch2);
                        Ech2=dch2;
                        Ech2(50:end)=0;
                        filtered_graphch2 = real(ifft(Ech2));
                        dtgraphch2=filtered_graphch2;
                        
                        disp(size(dtgraph));
                        dtgraphBuffer(1:end-size(dtgraph))=dtgraphBuffer(size(dtgraph)+1:end);disp('A');
                        dtgraphBufferch2(1:end-size(dtgraphch2))=dtgraphBufferch2(size(dtgraphch2)+1:end);
                       
                        dtgraphBuffer(end-size(dtgraph)+1:end)=dtgraph;disp('B');
                        dtgraphBufferch2(end-size(dtgraphch2)+1:end)=dtgraphch2;
                       
                        dtgraphPlot=E;
                        dtgraphPlotch2=Ech2;
                        
                        %myifft=(ifft(dtgraphPlot));
                        
                        
                        %dtgraphPlotA(floor(57/(250/2*3/2)*size(dtgraphPlotA,1)):ceil(68/(250/2*3/2)*size(dtgraphPlotA,1)))=0;
                        disp('truncating');
                        %dtgraphPlot = dtgraphPlotA(1:ceil(100/(250/2*3/2)*size(dtgraphPlotA,1)));
                        disp('plotting...');
                        disp(size(dtgraph));
                        
                        
                        
                        
                        
                        stopperA_chA=0;
                        stopperA_chB=0;
                        foundCnt_chA=0;
                        foundCnt_chB=0;
                        for i=1:size(dtgraph,1)
                            if(dtgraph(i)>4.2*10^5)
                                if(stopperA_chA<=0)
                                    stopperA_chA=20;
                                    foundCnt_chA=foundCnt_chA+1;
                                end
                            else
                                stopperA_chA=stopperA_chA-1;
                                if(stopperA_chA<0)
                                    stopperA_chA=0;
                                end
                            end
                            
                            if(dtgraphch2(i)>5.2*10^5)
                                if(stopperA_chB<=0)
                                    stopperA_chB=20;
                                    foundCnt_chB=foundCnt_chB+1;
                                end
                            else
                                stopperA_chB=stopperA_chB-1;
                                if(stopperA_chB<0)
                                    stopperA_chB=0;
                                end
                            end
                        end
                        disp(foundCnt_chA);
                        disp(foundCnt_chB);
                        
                        
                        
                        
                        
                        
                        
                        %f = 250/2*3/2*linspace(0,1,size(dtgraphPlot,1));
                        tplot = abs(ifft(dtgraphPlot));
                        subplot(4,2,1);plt1=plot(dtgraphBuffer);
                        subplot(4,2,3);plt1=plot(abs(dtgraphPlot(2:end)));
                        subplot(4,2,5);plt2=plot(dtgraph);
                      
                        tplotch2 = abs(ifft(dtgraphPlotch2));
                        subplot(4,2,2);plt1=plot(dtgraphBufferch2);
                        subplot(4,2,4);plt1=plot(abs(dtgraphPlotch2(2:end)));
                        subplot(4,2,6);plt2=plot(dtgraphch2);
                        
                        disp('resetting buffer...')
                        bufferA=zeros(1);
                    end
                end
            else
                if bav==0
                    disp('no bytes available...')
                end
            end
        catch err
            disp('in catch')
            disp(err);
            disp('resetting')
            fclose(b);
            fopen(b);
            pause(0.001);
        end
    end
end