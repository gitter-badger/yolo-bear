function []=getTopAttributes()
load('dict.mat');
SelectedAtt=[13
    14
    30
    75
    97
    123
    128
    152
    230
    232
    299
    303
    318
    362
    371
    375
    382
    388
    474
    482
    504
    519
    535
    542];
AttId=[];
for i=1:numel(SelectedAtt)
    AttId=[AttId,dict(SelectedAtt(i))];
end

    [adjs,adjids]=textread('adj.csv','%s %s','headerlines',1,'delimiter',',');
    [verbs,verbids]=textread('verb.csv','%s %s','headerlines',1,'delimiter',',');

n=numel(AttId);
keyword=cell(n,1);
for i=1:n
    flag=false;
    for j=1:numel(verbs)
        if strcmp(char(AttId(i)),char(verbids(j)))
            keyword(i)=verbs(j);
            flag=true;
            break;
        end
    end
    if flag==false
        for j=1:numel(adjs)
            if strcmp(char(AttId(i)),char(adjids(j)))
                keyword(i)=adjs(j);
                flag=true;
                break;
            end
        end
    end
    if flag==false
        %ERROR
        flag
        
    end
end
    save('Selected_Attribute_ID.mat','keyword');
end