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
        AttId=[AttId,dict(i+1)];
    end
    save('Selected_Attribute_ID.mat','AttId');
end