// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract SmartRanking {

    struct Student {
        uint256 rollNumber;
        uint256 marks;
    }

    Student[] private students;
    
    // This function is used to insert the marks
    function insertMarks(uint _rollNumber, uint _marks) public {
        uint checkNum = 2**255;
        require(_rollNumber < checkNum + 1, "Roll number is too large");
        require(_marks < checkNum + 1, "Marks are too large");
        Student memory newStudent = Student({rollNumber:_rollNumber,marks:_marks});
        
        students.push(newStudent);
       
        if (students.length > 1 && students.length <= 2) {
            if (students[0].marks < students[1].marks) {
                Student memory temp = students[0];
                students[0] = students[1];
                students[1] = temp;
            }
        } 

        if (students.length > 2) {

            for (uint i; i < students.length; i++) {
                if(students[i].marks < students[students.length - 1].marks) {
                    Student memory temp = students[i];
                    students[i] = students[students.length - 1];
                   students[students.length - 1] = temp;
                }
            }
        }
        

    }

    //this function returnsthe marks obtained by the student as per the rank
    function scoreByRank(uint rank) public view returns(uint) {
        if(rank < 0 || rank > students.length) revert();
        return students[rank-1].marks;
    }

    //this function returns the roll number of a student as per the rank
    function rollNumberByRank(uint rank) public view returns(uint) {
        if(rank < 0 || rank > students.length) revert();
        return students[rank-1].rollNumber;
    }

}
