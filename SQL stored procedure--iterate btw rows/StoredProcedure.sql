CREATE DEFINER=`root`@`localhost` PROCEDURE `getWordFromAnno`()
BEGIN
/*
	本存储过程用于从Anno表中获得每一个标注信息对应的动词，形容词。   
    存储到一个临时表中，表的行数就是有效标注的数目。
    
    
*/

	
	DECLARE Done INT DEFAULT 0;
    
    declare annoid int;
    declare fn varchar(45);
    
    
    declare anp1 int;
    declare anp2 int;
    declare anp3 int;
    declare anp4 int;
    declare anp5 int;
    declare anp6 int;
    declare anp7 int;
    declare anp8 int;
    
    declare vnp1 int;
    declare vnp2 int;
    declare vnp3 int;
    declare vnp4 int;
    declare vnp5 int;
    declare vnp6 int;
    declare vnp7 int;
    declare vnp8 int;
    
    declare adj1 varchar(45);
    declare adj1id varchar(45);
	declare adj2 varchar(45);
    declare adj2id varchar(45);
	declare adj3 varchar(45);
    declare adj3id varchar(45);
    declare adj4 varchar(45);
    declare adj4id varchar(45);
    declare adj5 varchar(45);
    declare adj5id varchar(45);
    declare adj6 varchar(45);
    declare adj6id varchar(45);
    declare adj7 varchar(45);
    declare adj7id varchar(45);
    declare adj8 varchar(45);
    declare adj8id varchar(45);
    
    declare verb1 varchar(45);
    declare verb1id varchar(45);
    declare verb2 varchar(45);
    declare verb2id varchar(45);
    declare verb3 varchar(45);
    declare verb3id varchar(45);
    declare verb4 varchar(45);
    declare verb4id varchar(45);
    declare verb5 varchar(45);
    declare verb5id varchar(45);
    declare verb6 varchar(45);
    declare verb6id varchar(45);
    declare verb7 varchar(45);
    declare verb7id varchar(45);
    declare verb8 varchar(45);
    declare verb8id varchar(45);
    


    
    DECLARE rs CURSOR FOR SELECT AnnotaId,FileName from useful_data;
    
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET Done = 1;
    
    
    
	/*删除现有的所有行*/
	delete from t_word_from_anno where id >0;
    delete from t_verbs where 1>0;
    delete from t_adjs where 1>0;
    
    open rs;
    
    fetch rs into annoid,fn;
    repeat
		
        if annoid is not null then
        
			set adj1=null;
            set adj2=null;
            set adj3=null;
            set adj4=null;
            
            set verb1=null;
            set verb2=null;
			set verb3=null;
            set verb4=null;
            
            set adj1id=null;
            set adj2id=null;
            set adj3id=null;
            set adj4id=null;
            
            set verb1id=null;
            set verb2id=null;
            set verb3id=null;
            set verb4id=null;
            
        
			select AnpId1,AnpId2,AnpId3,AnpId4,VnpIdA,VnpIdB,VnpIdC,VnpIdD from d_annotation where AnnotaId=annoid into anp1,anp2,anp3,anp4,vnp1,vnp2,vnp3,vnp4;
            if anp1 is null and anp2 is not null then
				set anp1=anp2;
                set anp2=anp3;
                set anp3=anp4;
                set anp4=null;
            end if;
            
            if vnp1 is null and vnp2 is not null then
				set vnp1=vnp2;
                set vnp2=vnp3;
                set vnp3=vnp4;
                set vnp4=null;
            end if;
            
            
            select AdjId from c_anp where AnpId = anp1 into adj1id;
            select Keyword from b_adj where SynId=adj1id into adj1;
            select AdjId from c_anp where AnpId = anp2 into adj2id;
            select Keyword from b_adj where SynId=adj2id into adj2;
            select AdjId from c_anp where AnpId = anp3 into adj3id;
            select Keyword from b_adj where SynId=adj3id into adj3;
            select AdjId from c_anp where AnpId = anp4 into adj4id;
            select Keyword from b_adj where SynId=adj4id into adj4;
            
            select VerbId from c_vnp where VnpId=vnp1 into verb1id; 
            select Keyword from b_verb where SynId=verb1id into verb1;
            select VerbId from c_vnp where VnpId=vnp2 into verb2id; 
            select Keyword from b_verb where SynId=verb2id into verb2;
            select VerbId from c_vnp where VnpId=vnp3 into verb3id; 
            select Keyword from b_verb where SynId=verb3id into verb3;
            select VerbId from c_vnp where VnpId=vnp4 into verb4id;
            select Keyword from b_verb where SynId=verb4id into verb4;
            
            if verb1 is null and verb1id is not null then
				set verb1id=null;
            end if;
            if verb2 is null and verb2id is not null then
				set verb2id=null;
            end if;
            if verb3 is null and verb3id is not null then
				set verb3id=null;
            end if;
            if verb4 is null and verb4id is not null then
				set verb4id=null;
            end if;
            
            
            if adj1 is null and adj1id is not null then
				set adj1id=null;
            end if;
            if adj2 is null and adj2id is not null then
				set adj2id=null;
            end if;
            if adj3 is null and adj3id is not null then
				set adj3id=null;
            end if;
            if adj4 is null and adj4id is not null then
				set adj4id=null;
            end if;
            
            insert into t_word_from_anno(AnnotaId,verb1_id,verb1,verb2_id,verb2,verb3_id,verb3,verb4_id,verb4,adj1_id,adj1,adj2_id,adj2,adj3_id,adj3,adj4_id,adj4,FileName) values(annoid,verb1id,verb1,verb2id,verb2,verb3id,verb3,verb4id,verb4,adj1id,adj1,adj2id,adj2,adj3id,adj3,adj4id,adj4,fn);
            
            insert ignore into t_adjs(adj,adjid) values(adj1,adj1id);
            insert ignore into t_adjs(adj,adjid) values(adj2,adj2id);
            insert ignore into t_adjs(adj,adjid) values(adj3,adj3id);
            insert ignore into t_adjs(adj,adjid) values(adj4,adj4id);
            
            insert ignore into t_verbs(verb,verbid) values(verb1,verb1id);
            insert ignore into t_verbs(verb,verbid) values(verb2,verb2id);
            insert ignore into t_verbs(verb,verbid) values(verb3,verb3id);
            insert ignore into t_verbs(verb,verbid) values(verb4,verb4id);
            
            
		end if;
        
        set Done=0;
		fetch rs into annoid,fn;

        
    until Done end repeat;
    
	/*select adj1,adj2,adj3,adj4,verb1,verb2,verb3,verb4;*/

    
    close rs;


END