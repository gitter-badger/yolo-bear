function [ output_args ] = do_txtParser0()

addpath('libsvm');
%Convert database csv to weka csv
%   some other jobs
[Sid,Annoid,verb1_id,verb1,verb2_id,verb2,verb3_id,verb3,verb4_id,verb4,adj1_id,adj1,adj2_id,adj2,adj3_id,adj3,adj4_id,adj4,filename,sentiment]=textread('filelist.csv','%d %d %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s','delimiter',',','headerlines',1);
%some of the type is double and others are cell, could not be concatenated.
%Anno=[Sid;Annoid;verb1_id;verb1;verb2_id;verb2;verb3_id;verb3;verb4_id;verb4;adj1_id;adj1;adj2_id;adj2;adj3_id;adj3;adj4_id;adj4;filename;sentiment];
[adjs,adjids]=textread('adj.csv','%s %s','headerlines',1,'delimiter',',');
[verbs,verbids]=textread('verb.csv','%s %s','headerlines',1,'delimiter',',');
Anno=[verb1_id,verb2_id,verb3_id,verb4_id,adj1_id,adj2_id,adj3_id,adj4_id];

verbSize=numel(verbids);
verbDict=cell(verbSize*(verbSize-1),2);
for i=1:verbSize
    %Leave-One-Out Verbs
    LooVerbs=cell(verbSize-1,1);
    if i==1
        LooVerbs=verbids(2:verbSize);
    elseif i==verbSize
        LooVerbs=verbids(1:verbSize-1);
    else
        LooVerbs=[verbids(1:i-1);verbids(i+1:verbSize)];
    end
    %iterate from LooVerbs
    for k=1:verbSize-1
        %combination
        verbDict((i-1)*(verbSize-1)+k,1)=verbids(i);
        verbDict((i-1)*(verbSize-1)+k,2)=LooVerbs(k);
    end
end

adjSize=numel(adjids);
adjDict=cell(adjSize*(adjSize-1),2);
for i=1:adjSize
    LooAdjs=cell(adjSize-1,1);
    if i==1
        LooAdjs=adjids(2:adjSize);
    elseif i==adjSize
        LooAdjs=adjids(1:adjSize-1);
    else
        LooAdjs=[adjids(1:i-1);adjids(i+1:adjSize)];
    end
    for k=1:adjSize-1
        adjDict((i-1)*(adjSize-1)+k,1)=adjids(i);
        adjDict((i-1)*(adjSize-1)+k,2)=LooAdjs(k);
    end
end

dict=[verbDict;adjDict];

dataSize=numel(Sid);
dictSize=size(dict,1);

% dicFreqCount=zeros(dictSize,1);

resData=[];

%For every element from dataset, get its anno2 value

for i=1:dataSize
    flag=false;
    anno2=sparse(zeros(dictSize+1,1));
    array=[];
    for col=1:4
        if strcmp(char(Anno(i,col)),'NULL')~=1
            array=[array;Anno(i,col)];
        end
        %verb
        if numel(array)>1
            for index=1:numel(array)-1
                pair(1)=array(index);
                pair(2)=array(index+1);
                
                for ii=1:verbSize
                    if strcmp(char(verbids(ii)),char(pair(1)))
                        for jj=1:verbSize-1
                            if strcmp(char(verbDict((ii-1)*(verbSize-1)+jj,2)),char(pair(2)))
                                anno2((ii-1)*(verbSize-1)+jj)=1;
                                flag=true;
                                break;
                            end
                        end
                        break;
                    end
                end
            end
        end
    end
    array=[];
    for col=5:8
        if strcmp(char(Anno(i,col)),'NULL')~=1
            array=[array;Anno(i,col)];
        end
        %adj
        if numel(array)>1
            for index=1:numel(array)-1
                pair(1)=array(index);
                pair(2)=array(index+1);
                
                for ii=1:adjSize
                    if strcmp(char(adjids(ii)),char(pair(1)))
                        for jj=1:adjSize-1
                            if strcmp(char(adjDict((ii-1)*(adjSize-1)+jj,2)),char(pair(2)))
                                anno2((ii-1)*(adjSize-1)+jj+size(verbDict,1))=1;
                                flag=true;
                                break;
                            end
                        end
                        break;
                    end
                end
            end
            
        end
    end
    
    
    
    if flag==true
        if strcmp(char(sentiment(i)),'+')
            y=1;
        elseif strcmp(char(sentiment(i)),'0')
            y=0;
        elseif strcmp(char(sentiment(i)),'-')
            y=-1;
        end
        anno2(dictSize+1,1)=y;
        resData=sparse([resData;anno2']);
        size(resData,1)
    end
end
%
% for i=1:dataSize
%     anno2=zeros(dictSize+1,1);
%
%     for col=1:8
%         if strcmp(char(Anno(i,col)),'NULL')~=1
%           for k=1:dictSize
%             if strcmp(char(Anno(i,col)),char(dict(k)))
% %                 anno2(k)=anno2(k)+1;
%                 anno2(k)=1;
%                 dicFreqCount(k)=dicFreqCount(k)+1;
%             end
%           end
%         end
%     end
%
%     %Is positive or not positive
%     y=double(-1);
%     if strcmp(char(sentiment(i)),'+')
%       y=double(1);
%     end
%
%     anno2(dictSize+1,1)=y;
%     resData(i,:)=anno2;

% end

%resData is the training set, should be convert into libsvm format later!

% svmwrite('exp1.txt',resData(:,dictSize+1),sparse(resData(:,1:dictSize)));




fid=fopen('exp2_header.arff','w');
fprintf(fid,['@','relationship','LargeScaleGIFSentiment\n']);
for i=1:dictSize
    fprintf(fid,['@','attribute']);
    fprintf(fid,' attr%d {0,1}\n',i);
end
fprintf(fid,['@','attribute class {-1,0,1}\n']);
fprintf(fid,['@','data\n']);
fclose(fid);

csvwrite('exp2.arff',full(resData));
save('onlyverb.mat');

end

