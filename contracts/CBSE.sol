//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract CBSEResults is Ownable, ERC721URIStorage {

    uint tokenId;

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
    mapping(uint=>uint) mintedMarksheet; // mapping from roll number to tokenId.
    mapping(uint=>uint) verifyNFT;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol){
    }

    function enterStudentDetails(uint _rollNumber, StudentInfo memory _StudentInfo) external onlyOwner{
       studentDetails[_rollNumber] = _StudentInfo;
    }

    function enterStudentSubjects(uint _rollNumber,uint[] memory _subjectCodes) external onlyOwner{
        studentMarksheet[_rollNumber].subjects = _subjectCodes;
    }

    function enterSubjectMarks(uint _rollNumber, uint[] memory _subjectMarks) external onlyOwner{
        uint totalSubjects = _subjectMarks.length;
        StudentMarks storage studentMarks = studentMarksheet[_rollNumber];
        for(uint i;i<totalSubjects;i++){
            studentMarks.subjectMarks[studentMarks.subjects[i]] = _subjectMarks[i];
            //grade condition to put here to update the grade section in the StudentMarks struct.
        }
    }

    function updateSubjectMarks(uint _rollNumber, uint _subjectCode, uint _subjectMarks) external onlyOwner{
        studentMarksheet[_rollNumber].subjectMarks[_subjectCode] = _subjectMarks;
    }

    function mintMarksheet(uint _rollNumber, uint _dob) external {
        require(_dob==studentDetails[_rollNumber].dob,"DOB doesnot match!!");
        if(mintedMarksheet[_rollNumber]!=0){
        verifyNFT[mintedMarksheet[_rollNumber]]=0;
        _burn(mintedMarksheet[_rollNumber]);}
        tokenId++;
        _safeMint(msg.sender,tokenId);
        mintedMarksheet[_rollNumber]=tokenId;
        verifyNFT[tokenId]=_rollNumber;
    }

    function verifyNFTMarksheet(uint _tokenId) external view returns(bytes[] memory subjects, uint[] memory marks){
        uint rollNumber = verifyNFT[_tokenId];
        StudentMarks storage studentSubject = studentMarksheet[rollNumber];
        uint totalSubjects =studentSubject.subjects.length;
        uint[] memory marks;
        for(uint i=0;i<totalSubjects;i++){
           uint mark = studentSubject.subjectMarks[studentSubject.subjects[i]];
           marks[i]=mark;
        }


    }







}