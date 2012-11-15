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
 
 graphSize=2000;
 inputSize=2;
 graph=randi(256,inputSize*32,1);
 plt=plot(graph);
 linkdata on
 %val=randi(256,8,1);
 %val=zeros(2,inputSize);
while(true)
    %val=randi(256,inputSize,1);
    vali=1;
    while(vali<=8)
        vali
        fread(b,1,'uint8')
        fread(b,1,'uint8')
        fread(b,1,'uint8')
        %val=fread(b,1,'uint8')+256*fread(b,1,'uint8')+256*256*fread(b,1,'uint8');
        if(vali==0)
        %graph(1:end-size(val)+1,:)= graph(size(val):end,:);
        %graph(end-size(val)+1:end,:)=val;
        graph(1:end-1,:)= graph(2:end,:);
        graph(end,:)=val;
            set(plt,'ydata',graph);
        end
        vali=vali+1;
    end
    %pause(0.01)
    %plot(graph);
 end
 