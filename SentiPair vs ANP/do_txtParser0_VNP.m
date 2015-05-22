function [ output_args ] = do_txtParser0()

%Parser filelist.csv into weka format!!!!!!!


%Convert database csv to weka csv
%   some other jobs
[Sid,Annoid,verb1_id,verb1,verb2_id,verb2,verb3_id,verb3,verb4_id,verb4,adj1_id,adj1,adj2_id,adj2,adj3_id,adj3,adj4_id,adj4,filename,sentiment]=textread('filelist.csv','%d %d %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s','delimiter',',','headerlines',1);
%some of the type is double and others are cell, could not be concatenated.
%Anno=[Sid;Annoid;verb1_id;verb1;verb2_id;verb2;verb3_id;verb3;verb4_id;verb4;adj1_id;adj1;adj2_id;adj2;adj3_id;adj3;adj4_id;adj4;filename;sentiment];
[adjs,adjids]=textread('adj.csv','%s %s','headerlines',1,'delimiter',',');
[verbs,verbids]=textread('verb.csv','%s %s','headerlines',1,'delimiter',',');
Anno=[verb1_id,verb2_id,verb3_id,verb4_id,adj1_id,adj2_id,adj3_id,adj4_id];

% dict=[verbids;adjids];
dict=verbids;


dataSize=numel(Sid);
dictSize=size(dict,1);

dicFreqCount=zeros(dictSize,1);

resData=zeros(dataSize,dictSize+1);


for i=1:dataSize
    anno2=zeros(dictSize+1,1);
    
    for col=1:8
        if strcmp(char(Anno(i,col)),'NULL')~=1
          for k=1:dictSize
            if strcmp(char(Anno(i,col)),char(dict(k)))
%                 anno2(k)=anno2(k)+1;
                anno2(k)=1;
                dicFreqCount(k)=dicFreqCount(k)+1;
            end
          end
        end
    end
    
    %3 classes
    y=double(-1);
    if strcmp(char(sentiment(i)),'+')
      y=double(1);
    elseif strcmp(char(sentiment(i)),'0')
      y=double(0);
    end
    
    anno2(dictSize+1,1)=y;
    resData(i,:)=anno2;
     
end


csvwrite('SentiPair_Flow_VNP.csv',resData);

% Write weka header
fid=fopen('weka_header_VNP.arff','w');
fprintf(fid,['@','relation ','LargeScaleGIFSentiment\n']);
for i=1:dictSize
    fprintf(fid,['@','attribute']);
    fprintf(fid,' attr%d {0,1}\n',i);
end
fprintf(fid,['@','attribute class {-1,0,1}\n']);
fprintf(fid,['@','data\n']);
fclose(fid);


end

