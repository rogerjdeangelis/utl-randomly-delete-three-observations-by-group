Randomly delete three observations by group                                                    
                                                                                               
  Two Solutions                                                                                
                                                                                               
    1. SurveySelect Solution by                                                                
        Surya Kiran                                                                            
        https://communities.sas.com/t5/user/viewprofilepage/user-id/83078                      
                                                                                               
    2. Sort and view method                                                                    
                                                                                               
        1. Add random number(sas view),                                                        
        2. Sort on random number                                                               
        3. Select first three in group(sas view)                                               
        4. Resort if needed                                                                    
                                                                                               
INPUT                                                                                          
=====                                                                                          
                                                                                               
WORK.HAVE total obs=18                                                                         
                                                                                               
 ID    YEAR    PREP                                                                            
                                                                                               
  1    2000     550                                                                            
  1    2001     600                                                                            
  1    2002     650                                                                            
  1    2003     700                                                                            
  1    2004     750                                                                            
  1    2005     800                                                                            
                                                                                               
  2    2000     850                                                                            
  2    2001     900                                                                            
  2    2002     950                                                                            
  2    2003    1000                                                                            
  2    2004    1050                                                                            
  2    2005    1100                                                                            
                                                                                               
  3    2000    1150                                                                            
  3    2001    1200                                                                            
  3    2002    1250                                                                            
  3    2003    1300                                                                            
  3    2004    1350                                                                            
  3    2005    1400                                                                            
                                                                                               
                                                                                               
EXAMPLE OUTPUT                                                                                 
==============                                                                                 
                                                                                               
WORK.WANT total obs=18                                                                         
                                                                                               
                     +  RULES                                                                  
                     |                                                                         
 ID    YEAR    PREP  |  NEW_PREP                                                               
                     |                                                                         
  1    2000     550  |       .   Create 3 random missings                                      
  1    2001     600  |     600                                                                 
  1    2002     650  |     650                                                                 
  1    2003     700  |     700                                                                 
  1    2004     750  |       .                                                                 
  1    2005     800  +       .                                                                 
                                                                                               
  2    2000     850  +       .   Create 3 random missings                                      
  2    2001     900  |       .                                                                 
  2    2002     950  |       .                                                                 
  2    2003    1000  |    1000                                                                 
  2    2004    1050  |    1050                                                                 
  2    2005    1100  +    1100                                                                 
                                                                                               
  3    2000    1150  +       .  Create 3 random missings                                       
  3    2001    1200  |    1200                                                                 
  3    2002    1250  |    1250                                                                 
  3    2003    1300  |    1300                                                                 
  3    2004    1350  |       .                                                                 
  3    2005    1400  +       .                                                                 
                                                                                               
                                                                                               
PROCESS                                                                                        
=======                                                                                        
                                                                                               
 1. SurveySelect                                                                               
                                                                                               
    proc surveyselect data=have                                                                
          method=srs n=3                                                                       
          seed=%SYSFUNC(round(%Sysfunc(time())))                                               
          out=test (Keep=id year prep) noprint ;                                               
    strata id ;                                                                                
    run;                                                                                       
                                                                                               
    proc sql;                                                                                  
        create                                                                                 
           table want as                                                                       
        select                                                                                 
           a.*                                                                                 
          ,case                                                                                
             when b.prep is null then a.prep                                                   
             else .                                                                            
          end as new_prep                                                                      
       from                                                                                    
          have a left join test b                                                              
       on                                                                                      
          a.id   = b.id    and                                                                 
          a.year = b.year                                                                      
    ;quit;                                                                                     
                                                                                               
                                                                                               
 2. Sort and view method                                                                       
                                                                                               
    data havRnd/view=havRnd;                                                                   
      set have;                                                                                
      rnd=uniform(123);                                                                        
    run;quit;                                                                                  
                                                                                               
    proc sort data=havRnd out=havRndSrt noequals;                                              
    by id rnd;                                                                                 
    run;quit;                                                                                  
                                                                                               
    data havFlg/view=havFlg;                                                                   
      retain cnt 0;                                                                            
      set havRndSrt;                                                                           
      by id;                                                                                   
      if first.id then cnt=0;                                                                  
      cnt=cnt+1;                                                                               
      new_prep=prep;                                                                           
      if cnt < 4  then new_prep=.;                                                             
    run;quit;                                                                                  
                                                                                               
    proc sort data=havFlg out=want noequals;                                                   
    by id year;                                                                                
    run;quit;                                                                                  
                                                                                               
*                _              _       _                                                      
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _                                               
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |                                              
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |                                              
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|                                              
                                                                                               
;                                                                                              
                                                                                               
data have;                                                                                     
retain id year prep;                                                                           
prep=500;                                                                                      
do id=1 to 3;                                                                                  
      do year=2000 to 2005;                                                                    
      prep+50;                                                                                 
      output;                                                                                  
      end;                                                                                     
end;                                                                                           
run;                                                                                           
                                                                                               
