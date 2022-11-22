//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract UniReg is Ownable {

struct StudentDetails{
    string name;
    bytes dob;
    uint rollNumber;
    uint regNumber;
}

struct SubjectDetails {
    bytes subjectName;
    uint id;
}

struct BranchDetails {
    bytes branchName;
    uint totalStudents;
    uint totalSubjects;
    bytes HOD;
    mapping(uint=>SubjectDetails) subjectInfo;
}

struct CollegeBranchInfo {
    uint totalBranches;
    uint totalStudents;
    mapping(uint=>mapping(uint=>StudentDetails)) studentMap;// mapping from branchID=>rollnumber=>studentDetails.
    mapping(uint=>BranchDetails) branchMap;
}

// this mapping will be used to map a number of students in (CollegeID => Year => Students in different branches) format.
mapping(uint=>mapping(uint=>CollegeBranchInfo)) public collegeYearBranching; 

function studentDetail(uint _collegeId, uint _year, uint _branchId, uint _rollNumber) public view returns(StudentDetails memory){
   CollegeBranchInfo storage collegeBranchInfo = collegeYearBranching[_collegeId][_year];
   return collegeBranchInfo.studentMap[_branchId][_rollNumber];
}

function branchDetail(uint _collegeId, uint _year, uint _branchId) external view returns(uint totalStudents, uint totalSubjects, bytes memory HOD){
    CollegeBranchInfo storage collegeBranchInfo = collegeYearBranching[_collegeId][_year];
    return (collegeBranchInfo.branchMap[_branchId].totalStudents,collegeBranchInfo.branchMap[_branchId].totalSubjects,collegeBranchInfo.branchMap[_branchId].HOD);
}


}