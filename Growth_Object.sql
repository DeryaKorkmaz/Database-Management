CREATE OR REPLACE FUNCTION DATADK.Genel_Buyume(tbs_name varchar2)
return varchar2
IS
deger varchar2(100);
cursor cursor_tbs IS                
            select thedate, mbsize - prev_mbsize
            from (select thedate, mbsize, lag(mbsize, 1) over(order by r) prev_mbsize
                from (select rownum r, thedate, mbsize
                  from (select trunc(thedate) thedate, max(mbsize) mbsize
                    from (select to_date(to_char(snapshot.begin_interval_time,'YYYY-MON-DD HH24:MI:SS'),'YYYY-MON-DD HH24:MI:SS') thedate,
                        round((usage.tablespace_usedsize * block_size.value) / 1024 / 1024 ,2) mbsize
                            from dba_hist_tbspc_space_usage usage,v$tablespace tablespace,dba_hist_snapshot snapshot,v$parameter block_size
                                 where usage.snap_id = snapshot.snap_id
                                   and usage.tablespace_id = tablespace.ts#
                                   and tablespace.name =tbs_name
                                   and block_size.name = 'db_block_size')
                                   group by trunc(thedate)
                                   order by trunc(thedate))));

    BEGIN         
              for i in cursor_tbs
                 loop
                deger:='Tarih' || i.thedate || 'Boyut' || i.mbsize-prev_mbsize
        
                return deger;  
                 end loop;               
   END Genel_Buyume;
/

