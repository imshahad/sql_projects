CREATE DATABASE students;
USE students;

CREATE TABLE student_list(
roll_number INT,
student_name VARCHAR(50),
class INT,
section VARCHAR(10),
school_name VARCHAR(100)
);

CREATE TABLE question_paper_code(
paper_code INT,
class INT,
subject VARCHAR(35)
);

CREATE TABLE correct_answer(
paper_code INT,
question_number INT,
correct_option VARCHAR(1)
);

CREATE TABLE student_response(
roll_number INT,
paper_code INT,
question_number INT,
option_marked VARCHAR(1)
);

CREATE VIEW grades AS
SELECT student_list.roll_number, student_list.student_name, student_list.class, student_list.section, student_list.school_name,
SUM(CASE
WHEN student_response.option_marked = correct_answer.correct_option AND question_paper_code.subject = 'Math' AND student_response.option_marked != 'e'
THEN 1
ELSE 0
END) AS math_correct,
SUM(CASE
WHEN student_response.option_marked != correct_answer.correct_option AND question_paper_code.subject = 'Math' AND student_response.option_marked != 'e'
THEN 1
ELSE 0
END) AS math_wrong,
SUM(CASE
WHEN student_response.option_marked = 'e' AND question_paper_code.subject = 'Math'
THEN 1
ELSE 0
END) AS math_yet_to_learn,
SUM(CASE
WHEN question_paper_code.subject = 'Math'
THEN 1
ELSE 0
END) AS total_math_questions,
SUM(CASE
WHEN student_response.option_marked = correct_answer.correct_option AND question_paper_code.subject = 'Science' AND student_response.option_marked != 'e'
THEN 1
ELSE 0
END) AS science_correct,
SUM(CASE
WHEN student_response.option_marked != correct_answer.correct_option AND question_paper_code.subject = 'Science' AND student_response.option_marked != 'e'
THEN 1
ELSE 0
END) AS science_wrong,
SUM(CASE
WHEN student_response.option_marked = 'e' AND question_paper_code.subject = 'Science'
THEN 1
ELSE 0
END) AS science_yet_to_learn,
SUM(CASE
WHEN question_paper_code.subject = 'Science'
THEN 1
ELSE 0
END) AS total_science_questions
FROM student_list
JOIN student_response
ON student_response.roll_number = student_list.roll_number
JOIN correct_answer
ON correct_answer.paper_code = student_response.paper_code AND correct_answer.question_number = student_response.question_number
JOIN question_paper_code
ON question_paper_code.paper_code = student_response.paper_code
GROUP BY student_list.roll_number, student_list.student_name, student_list.class, student_list.section, student_list.school_name;

SELECT 
    roll_number,
    student_name,
    class,
    section,
    school_name,
    math_correct,
    math_wrong,
    math_yet_to_learn,
    math_correct AS math_score,
    ROUND((math_correct / total_math_questions) * 100,
            2) AS math_percentage,
    science_correct,
    science_wrong,
    science_yet_to_learn,
    science_correct AS science_score,
    ROUND((science_correct / total_science_questions) * 100,
            2) AS science_percentage
FROM
    grades;