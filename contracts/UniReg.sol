//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";


contract UniReg is Ownable, ReentrancyGuard {

IERC20 colledgerToken;

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
    mapping(uint=>StudentDetails) studentInfo;
}

struct CollegeBranchInfo {
    uint totalBranches;
    uint totalStudents;
    mapping(uint=>BranchDetails) branchMap;
}

// this mapping will be used to map a number of students in (CollegeID => Year => Students in different branches) format.
mapping(uint=>mapping(uint=>CollegeBranchInfo)) public collegeYearBranching; 

constructor(IERC20 _colledgerToken){
     colledgerToken = _colledgerToken;
}

function studentDetail(uint _collegeId, uint _year, uint _branchId, uint _rollNumber) public view returns(StudentDetails memory){
   CollegeBranchInfo storage collegeBranchInfo = collegeYearBranching[_collegeId][_year];
   return collegeBranchInfo.branchMap[_branchId].studentInfo[_rollNumber];
}

function branchDetail(uint _collegeId, uint _year, uint _branchId) external view returns(uint totalStudents, uint totalSubjects, bytes memory HOD){
    CollegeBranchInfo storage collegeBranchInfo = collegeYearBranching[_collegeId][_year];
    return (collegeBranchInfo.branchMap[_branchId].totalStudents,collegeBranchInfo.branchMap[_branchId].totalSubjects,collegeBranchInfo.branchMap[_branchId].HOD);
}

 function registerNewStudent(uint _collegeId, uint _branchId, uint _year, uint _noOfStudents, StudentDetails[] memory _studentDetails) public nonReentrant {
         colledgerToken.transferFrom(msg.sender, address(this), _noOfStudents*10**18);
         CollegeBranchInfo storage collegeInfo = collegeYearBranching[_collegeId][_year];
         BranchDetails storage branchInfo = collegeInfo.branchMap[_branchId];
         
         for(uint i=1; i<=_noOfStudents; i++){
         branchInfo.totalStudents++;
         branchInfo.studentInfo[branchInfo.totalStudents]= _studentDetails[i];
         }
    
 } 

}