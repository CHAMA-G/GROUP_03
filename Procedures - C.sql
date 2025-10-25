-- Stored Procedure: Retrieve attendance summary by course code --

DELIMITER //

CREATE PROCEDURE GetAttendanceByCourse(IN courseCode CHAR(8))
    BEGIN
        SELECT
            student_id,
            course_code,
            Attendance_Percentage,
            Eligibility
        FROM
          AttendanceEligibilitySummary
        WHERE
            course_code = courseCode
        GROUP BY
            student_id, course_code;
    END // 
DELIMITER ;

CALL GetAttendanceByCourse('ICT1212');

-- Stored Procedure: Retrieve daily attendance for a specific student and course --

DELIMITER //

CREATE PROCEDURE GetDailyAttendance(IN stuID VARCHAR(6),IN cCode char(8))
BEGIN
	SELECT 
        student_id,
        course_code,
        date,
        att_state
    FROM Attendence
    WHERE student_id = stuID AND course_code = cCode;
END //

DELIMITER ;

CALL GetDailyAttendance('TG-004','ICT1212');

-- Stored Procedure: Retrieve overall attendance summary for a specific student using student id --

DELIMITER //
CREATE PROCEDURE GetAttendanceByStudent(IN stuId VARCHAR(6))
BEGIN
    SELECT
        course_code,
        Attendance_Percentage,
        Eligibility
    FROM
        AttendanceEligibilitySummary
    WHERE
        student_id = stuId; 
END //
DELIMITER ;

CALL GetAttendanceByStudent('TG-001');

-- Stored Procedure: Retrieve attendance and eligibility by student and course using course-code and student id --

DELIMITER //
CREATE PROCEDURE CheckAtt_ByStuId_CourseCode(IN stuId VARCHAR(6), IN cCode char(8))
BEGIN
    SELECT
        course_code,
        Attendance_Percentage,
        Eligibility
    FROM
        AttendanceEligibilitySummary
    WHERE
        student_id = stuId AND course_code = cCode; 
END //
DELIMITER ;

CALL CheckAtt_ByStuId_CourseCode('TG-001','ICT1212');

-- By giving Registration no as a summery----

DELIMITER //
CREATE PROCEDURE CA_Register_No(r_number VARCHAR(10))
BEGIN
SELECT mark_id,student_id,course_code,CA_marks FROM CA_Result_Without_Attendance 
WHERE Eligibility='Eligible' AND student_id=r_number;
END //
DELIMITER ;
CALL CA_Register_No('TG-001');