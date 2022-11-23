//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract CBSEResults is Ownable {


    struct StudentInfo {
        bytes name;
        bytes motherName;
        bytes fatherName;
        uint schoolCode;
        uint dob;
    }

    struct StudentMarks {
        uint[] subjects;
        bytes[] grades;
        mapping(uint=>uint) subjectMarks;
    }

    mapping(uint=>bytes) public subjectName;

    mapping(uint=>StudentInfo) studentDetails;
    mapping(uint=>StudentMarks) studentMarksheet;

    function enterStudentDetails(uint _rollNumber, StudentInfo memory _StudentInfo) public onlyOwner{
       studentDetails[_rollNumber] = _StudentInfo;
    }

    function enterStudentSubjects(uint _rollNumber,uint[] memory _subjectCodes) public onlyOwner{
        studentMarksheet[_rollNumber].subjects = _subjectCodes;
    }

    function enterSubjectMarks(uint _rollNumber, uint[] memory _subjectMarks) public onlyOwner{
        uint totalSubjects = _subjectMarks.length;
        StudentMarks storage studentMarks = studentMarksheet[_rollNumber];
        for(uint i;i<totalSubjects;i++){
            studentMarks.subjectMarks[studentMarks.subjects[i]] = _subjectMarks[i];
            //grade condition to put here to update the grade section in the StudentMarks struct.
        }
    }

    function updateSubjectMarks(uint _rollNumber, uint _subjectCode, uint _subjectMarks) public onlyOwner{
        studentMarksheet[_rollNumber].subjectMarks[_subjectCode] = _subjectMarks;
    }







}