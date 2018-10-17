/*
 The attached Excel file includes honors students who enrolled at RU from Fall 2011 through Fall 2014. 
 I’m hoping to learn more about their university retention and graduation.
 Would it be possible for someone in IR to get the following information for each of these students?

--Retention to the fall semester of their second year (yes/no)
--Four-year graduation (yes/no)
--Did they enroll in a ---- 488 course? This will help us identify those who graduated as Highlander Scholars.
It would be ideal if the data set could list the departmental prefix for the 488 course taken by the student.

*/

select
    honors.student_name
     ,honors.match_id
    ,max(enter_term) as enter_term-- not used in Excel doc
    ,max(grad_term) as grad_term-- not used in Excel doc
    ,min(to_number(grad_term)-to_number(enter_term)) as tim  -- not used in Excel doc
    ,max(grad_date) as grad_date-- not used in Excel doc
    ,ttd -- not used in Excel doc
    ,max(case when ttd  <=4 or to_number(grad_term)-to_number(enter_term)  <=315 then 'Yes' else 'No' end) as four_yr
    ,max(case when retention_group in ('Retained','Graduated') then 'Yes' 
      when retention_group = 'Not Retained' then 'No'
      else null end) as Retained_Fall
    , subject 
from honors
left outer join irlocal.wh_students
	on honors.match_id = wh_students.id	
left outer join irlocal.wh_timing
	on wh_students.timing_id = wh_timing.timing_id
left outer join irlocal.retention ret  
    on wh_students.id = ret.id
    and retention_type = 'FF'
left outer join irlocal.ttd ttd 
    on wh_students.id = ttd.id
left outer join irlocal.schev_ce_courses ce 
    on wh_students.id = ce.id
    and ce.course_number = '488'
left outer join irlocal.schev_dc dc 
    on wh_students.id = dc.id
where  wh_students.stu_timing in ('C','G')
    and wh_students.stu_term between '201010' and '201440' 
group by honors.student_name, subject, honors.match_id, ttd
order by honors.student_name
/

