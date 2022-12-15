//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Colledger is Ownable {

    struct Subjects{
        uint[] subjectCodes;
        mapping(uint=>uint) subjectCodeIndex;
        mapping(uint=>uint) SubjectMarks;
    }

    struct StudentInfo{
        uint8 currentSemester;
        bytes name;
        bytes branch;
        mapping(uint8=>Subjects) subjectSemesters;
    }

    mapping(uint=>mapping(uint=>StudentInfo)) CollegeStudentDetails;

    function changeSubject(uint _collegeId, uint _rollNumber, uint8 _currentSemester, uint _previousSubject, uint _newSubject) external {
            StudentInfo storage studentinfo = CollegeStudentDetails[_collegeId][_rollNumber];
            Subjects storage subjects = studentinfo.subjectSemesters[_currentSemester];
            subjects.subjectCodes[subjects.subjectCodeIndex[_previousSubject]-1]= _newSubject;
            subjects.subjectCodeIndex[_newSubject]= subjects.subjectCodeIndex[_previousSubject];
            subjects.subjectCodeIndex[_previousSubject] = 0;
    }

    function changeBranch(uint _collegeId, uint _rollNumber, uint8 _currentSemester) public {}

    function recordStudentDetails(uint _collegeId, uint[] memory _rollNumbers, uint[] memory StudentInfo) external {

    }



}