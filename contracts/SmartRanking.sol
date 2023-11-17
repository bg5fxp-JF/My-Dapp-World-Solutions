// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract SmartRanking {
    mapping(uint => uint) private marks; // Stores marks with roll number as key
    uint private highestMarks = 0; // Highest marks obtained
    uint private rollNumberOfTopper = 0; // Roll number of the student with the highest marks
    uint private studentCount = 0; // Counter for the number of students

    // This function is used to insert the marks
    function insertMarks(uint _rollNumber, uint _marks) public {
        uint checkNum = 2**255;
        require(_rollNumber < checkNum + 1, "Roll number is too large");
        require(_marks < checkNum + 1, "Marks are too large");

        marks[_rollNumber] = _marks;
        studentCount++; // Increment the number of students who have taken the exam

        // Check if the inserted marks are higher than the current highest marks
        if (_marks > highestMarks) {
            highestMarks = _marks;
            rollNumberOfTopper = _rollNumber;
        }
    }

    // This function returns the highest marks obtained by a student
    function topperMarks() public view returns(uint) {
        require(studentCount > 0, "No students have taken the exam yet");
        return highestMarks;
    }

    // This function returns the roll number of the student having highest marks
    function topperRollNumber() public view returns(uint) {
        require(studentCount > 0, "No students have taken the exam yet");
        return rollNumberOfTopper;
    }

    // This function returns the number of students who have submitted their exam
    function numberOfStudents() public view returns(uint) {
        return studentCount;
    }
}
