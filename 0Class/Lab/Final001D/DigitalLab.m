function DigitalLab(b)
    grab=400
    set(b,'BaudRate',115200,'InputBufferSize',2*28*grab,'OutputBufferSize',28*grab,'BytesAvailableFcnCount',28*grab,'BytesAvailableFcnMode','byte','BytesAvailableFcn',{@local_uart_callback});
    num_channels = 8;
    adc_bytes=3;
    header_bits=3;
    num_start_bytes=1;
    %packet_size = num_channels*adc_bytes+header_
    
    sync=-1;
    global grabFirst grabFirsti f bufferA dtgraph startA dtgraphBuffer
    startA=0;
    grabFirst=zeros(25*grab,1);
    dtgraphBuffer=zeros(20*grab,1);
    for k=1:grab-2
        grabFirst(25*k+0)=1;
        grabFirst(25*k+1)=1;
        grabFirst(25*k+2)=1;
    end
    grabFirsti=find(grabFirst);

    bufferA=zeros(0);
    dtgraph=zeros(grab-3,1);
    
    fopen(b);
    while(true)
        pause(0.001);
    end

    function local_uart_callback(b,event)
        pause(0.001);
        try
            disp('recieving data...');
            pause(0.001)
            ts = get(b,'TransferStatus')
            bav=get(b, 'BytesAvailable')
            if(bav>0&&startA==0)
                fread(b);
            end
            startA=1;
            while(bav<=500)
                pause(0.001)
                bav=get(b, 'BytesAvailable')
            end
            bav=get(b, 'BytesAvailable')
            if(bav>500)
                disp('bytes are available...')
                [A,~,msg] = fread(b,bav);%fread(b);%,25*grab);
                if(~strcmp(msg,''))%'The specified amount of data was not returned within the Timeout period.'))
                   error(msg);
                else
                    %bufferA=append(bufferA,A)
                    disp('bufferA concat stuff...');
                    bufferA=A;%vertcat(bufferA,A);
                    if(size(bufferA,1)>=28*grab)
                        disp('bufferA sufficiently large...')
                        sync=find(bufferA(1:28)==119);
                        disp('Sync Val')
                        disp(sync);
                        disp('picking out data...');
                        disp(sync);
                        readBuf=bufferA((sync+1):(28*grab-(28-sync)));
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
                       
                       disp('Looping');
                       disp(size(readBuf));
                       for i=1:grab-2%size(readBuf,1)/29-2%3:size(grabFirsti)-3
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
                        dtgraph(index)= readBuf(i*28+4);%+readBuf(i*28+4+1);%0*2^((2)*8)*readBuf(grabFirsti(1)+1+i*25) + 0*2^((1)*8)*readBuf(grabFirsti(1)+2+i*25) + 0*2^((0)*8)*readBuf(grabFirsti(1)+3+i*25); 
                        %disp(dec2bin(dtgraph(index),24));
%                         if(dtgraph(index)>=2^(8*3-1))
%                             disp('Neg');
%                             dtgraph(index)=dtgraph(index)-2^(8*3-1)-2^(8*3-1);
%                         end
                        %disp('Data');
                        %disp(index);
                        disp(dec2bin(dtgraph(index),8));
                        disp(dtgraph(index));
                        %disp(dec2bin(dtgraph(index),24))
                       end
                       %disp(dtgraph);
                       disp(dec2bin(readBuf(1:500),8));
                       disp('Check Sizes');
                       disp(size(dtgraphBuffer));
                       disp(size(dtgraph));
                       dtgraphBuffer(1:end-size(dtgraph))=dtgraphBuffer(size(dtgraph)+1:end);disp('A');
                       
                       dtgraphBuffer(end-size(dtgraph)+1:end)=dtgraph;disp('B');
                       
                        dtgraphPlot=fft(dtgraphBuffer(end*8/10:end));
                        dtgraphPlot(1:3)=0;
                        dtgraphPlot(200:250)=0;
                        dtgraphPlot(5:end)=0;
                        myifft=(ifft(dtgraphPlot));
                        disp('filtering...');
                        %dtgraphPlotA(floor(57/(250/2*3/2)*size(dtgraphPlotA,1)):ceil(68/(250/2*3/2)*size(dtgraphPlotA,1)))=0;
                        disp('truncating');
                        %dtgraphPlot = dtgraphPlotA(1:ceil(100/(250/2*3/2)*size(dtgraphPlotA,1)));
                        disp('plotting...');
                        disp(size(dtgraph));
                        
                        %f = 250/2*3/2*linspace(0,1,size(dtgraphPlot,1));
                        tplot = abs(ifft(dtgraphPlot));
                        subplot(3,1,1);plt1=plot(dtgraphBuffer);
                        subplot(3,1,2);plt1=plot(abs(dtgraphPlot(2:500)));
                        subplot(3,1,3);plt2=plot(myifft(2:end-1));
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