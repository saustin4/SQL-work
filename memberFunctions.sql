-- Stacy Austin member functions 


DROP TABLE ChannelGuide;

DROP TYPE BODY TimePeriod;

DROP TYPE TimePeriod;

CREATE OR REPLACE TYPE TimePeriod as OBJECT

(BeginPoint Date,

EndPoint Date,

MEMBER FUNCTION Begins(OtherTP IN TimePeriod) RETURN varchar,

MEMBER FUNCTION Ends(OtherTP IN TimePeriod) RETURN varchar,

MEMBER FUNCTION Equals(OtherTP IN TimePeriod) RETURN varchar,

MEMBER FUNCTION Overlap(OtherTP IN TimePeriod) RETURN varchar,
 
MEMBER FUNCTION Includes(OtherTP IN TimePeriod) RETURN varchar,

MEMBER FUNCTION Duration RETURN number);

/

CREATE OR REPLACE TYPE BODY TimePeriod AS

MEMBER FUNCTION Begins(OtherTP IN TimePeriod)

RETURN varchar IS

BEGIN

IF OtherTP.BeginPoint = self.BeginPoint

THEN

RETURN 'true';

ELSE

RETURN 'false';

END IF;

END;

MEMBER FUNCTION Ends(OtherTP IN TimePeriod)

RETURN varchar IS

BEGIN

IF OtherTP.EndPoint = self.EndPoint

THEN

RETURN 'true';

ELSE

RETURN 'false';

END IF;

END;

MEMBER FUNCTION Equals(OtherTP IN TimePeriod)

RETURN varchar IS

BEGIN

IF OtherTP.BeginPoint = self.BeginPoint AND

OtherTP.EndPoint = self.EndPoint

THEN

RETURN 'true';

ELSE

RETURN 'false';

END IF;

END;

 MEMBER FUNCTION Overlap(OtherTP IN TimePeriod)
  RETURN varchar IS
  BEGIN
      IF OtherTP.BeginPoint = self.BeginPoint OR OtherTP.BeginPoint > self.BeginPoint
     AND 
        OtherTP.EndPoint = self.EndPoint OR OtherTP.EndPoint < self.EndPoint
     THEN
        RETURN 'true';
     ELSE
        RETURN 'false';
     END IF;
  END;
  
  MEMBER FUNCTION Includes(OtherTP IN TimePeriod)
  RETURN varchar IS
  BEGIN
     IF self.BeginPoint BETWEEN OtherTP.BeginPoint
     AND OtherTP.EndPoint OR self.EndPoint BETWEEN OtherTP.BeginPoint
     AND OtherTP.EndPoint
     THEN
        RETURN 'true';
     ELSE
        RETURN 'false';
     END IF;
  END;

MEMBER FUNCTION Duration

RETURN number IS

BEGIN

return (self.endpoint - self.beginpoint)*24*60;

END;

END;

/

show errors

create table ChannelGuide (

Channel Number(3),

Show varchar2(25),

Episode varchar2(25),

TimeSlot TimePeriod);

Insert into ChannelGuide values('106','I Love Lucy','1',
TimePeriod(to_date('25-SEP-2016 19:00','DD-MON-YYYY HH24:MI'),
to_date('25-SEP-2016 19:30','DD-MON-YYYY HH24:MI')));

Insert into ChannelGuide values('106','I Love Lucy','2',
TimePeriod(to_date('25-SEP-2016 19:30','DD-MON-YYYY HH24:MI'),
to_date('25-SEP-2016 20:00','DD-MON-YYYY HH24:MI')));

Select cg.Channel, cg.Show, cg.episode, cg.timeslot.beginpoint,
cg.timeslot.endpoint, substr(cg.timeslot.equals(cg.timeslot),1,15)
as equalsitself, cg.timeslot.overlap(cg.timeslot)
as overlaps from ChannelGuide cg;

Select cg.Channel, cg.Show, cg.episode, cg.timeslot.beginpoint,
cg.timeslot.endpoint, cg.timeslot.duration() as minutes from Channelguide cg;


CREATE OR REPLACE TRIGGER Overlap_Err_Trig
BEFORE INSERT or UPDATE of timeslot ON ChannelGuide
FOR EACH ROW
DECLARE
v_countOverlaps NUMBER(10);
BEGIN
SELECT count(*) INTO v_countOverlaps
FROM ChannelGuide cg
WHERE substr(:new.timeslot.overlap(cg.timeslot),1,15) = 'true';
IF v_countOverlaps > 0
THEN
RAISE_APPLICATION_ERROR(-20001, 'OVERLAP ISSUE IN GUIDE');
END IF;
END Overlap_Err_Trig;
/

Insert into ChannelGuide values('106','I Love Lucy','3',
TimePeriod(to_date('25-SEP-2016 19:45','DD-MON-YYYY HH24:MI'),
to_date('25-SEP-2016 20:15','DD-MON-YYYY HH24:MI')));
