--All calculate attendance percentage including medical records (80%) --

CREATE VIEW All_Attendence AS
SELECT
     student_id,
     course_code,
     ROUND(COUNT(CASE WHEN att_state = 'Present' OR medical_id IS NOT NULL THEN 1 END) * 100.0 / 15,2)AS Attendance_Percentage
 FROM
     Attendence
 GROUP BY
     student_id, course_code;

SELECT * FROM All_Attendence;

--Summarize attendance and eligibility with medical  (80%) -- 

CREATE VIEW AttendanceEligibilitySummary AS
    SELECT
     student_id,
     course_code,
        ROUND(COUNT(CASE WHEN att_state = 'Present' OR medical_id IS NOT NULL THEN 1 END) * 100.0 / 15,2) AS Attendance_Percentage,
        IF(COUNT(CASE WHEN att_state = 'Present' OR medical_id IS NOT NULL THEN 1 END) * 100.0 / 15 >= 80, 'Eligible', 'Not Eligible') AS Eligibility
    FROM
        Attendence
    GROUP BY
        student_id, course_code;


SELECT * FROM AttendanceEligibilitySummary ;

--Calculate  VIEW  CA_Result_Without_Attendance --

CREATE VIEW CA_Result_Without_Attendance AS SELECT mark_id,mark.student_id,course_code,
    (((quiz_1 + quiz_2 + quiz_3) - LEAST(quiz_1, quiz_2, quiz_3)) / 2) * 0.10 AS Quiz_marks,
    (assesment * 0.05) AS Assesment_marks,
    CASE 
        WHEN mid_practical = 0 THEN (mid_theory * 0.25) 
        ELSE (((mid_theory + mid_practical) / 2) * 0.25) 
    END AS Mid_marks,

    (((((quiz_1 + quiz_2 + quiz_3) - LEAST(quiz_1, quiz_2, quiz_3)) / 2) * 0.10) + (assesment * 0.05) + 
    CASE 
            WHEN mid_practical = 0 THEN (mid_theory * 0.25) 
            ELSE (((mid_theory + mid_practical) / 2) * 0.25) 
        END) AS CA_marks,
    CASE 
        WHEN (((((quiz_1 + quiz_2 + quiz_3) - LEAST(quiz_1, quiz_2, quiz_3)) / 2) * 0.10) + (assesment * 0.05) + CASE 
                   WHEN mid_practical = 0 THEN (mid_theory * 0.25) 
                   ELSE (((mid_theory + mid_practical) / 2) * 0.25) 
               END) >= 20 THEN 'Eligible' 
        ELSE 'Not Eligible' END AS Eligibility FROM Mark
        INNER JOIN student ON mark.student_id = student.student_id WHERE state != 'suspended';

        SELECT * FROM CA_Result_Without_Attendance ;

--Calculate  VIEW  CA_Result_With_Attendance --

CREATE VIEW CA_Result_With_Attendance AS 
SELECT 
    c.course_code,
    c.student_id,
    a.Eligibility AS Attendace_Eligibility,
    c.Eligibility AS CA_Eligibility,
    IF(a.Eligibility='Eligible' AND c.Eligibility='Eligible','Eligible','Not Eligible') AS Eligibility
FROM 
    AttendanceEligibilitySummary a, CA_Result_Without_Attendance c
WHERE 
    a.student_id=c.student_id 
    AND c.course_code=a.course_code
GROUP BY 
    c.student_id, 
    c.course_code, 
    a.Eligibility,    
    c.Eligibility;   

    SELECT * FROM CA_Result_With_Attendance;