//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/draft-EIP712Upgradeable.sol";
import "contracts/libraries/Login.sol";



contract ImplementationInstitute is ERC721URIStorageUpgradeable, EIP712Upgradeable {

    uint degreeId;

    address public admin;

    string public collegeCode;

    struct SemesterCredential{
        uint semesterNumber;
        uint totalSubjects;
        uint[] subjectCodes;
        uint[] subjectMarks; 
        bool isPassed; 
    }

    struct DegreeDetails{
        uint programmeCode;
        address ownerIdentity;
        uint issueTime;
    }

    mapping(address=>mapping(uint=> mapping(uint=>SemesterCredential))) MarksheetCredential; // address => programmeCode => semesterNo

    mapping(uint=>string) public subjectCode;

    mapping(uint=>uint) public programmeSemestersRequired; // Programme code => Semesters required to get SBT Degree issued.

    mapping(address=>bool) public isEnrolled;

    mapping(address=>uint) public currentProgrammeCode;

    mapping(address=>uint) public currentSemester;

    mapping(uint=>DegreeDetails) public CredentialDetails;

    bool public mintingEnabled;

    error transferRestricted();

    error notAdmin(address _sender, address _admin);

    error zeroAddress();

    error courseIncomplete(uint currentSem, uint totalSem);

    error notPassed();

    error mintDisabled();

    modifier onlyAdmin() {
        if(msg.sender!=admin){
            revert notAdmin(msg.sender,admin);
        }
        _;
    }

    function init(string memory _entityName, address _portalAdmin, string memory _collegeCode) external initializer{
        if(_portalAdmin==address(0)){
            revert zeroAddress();
        }
        __ERC721_init_unchained(_entityName, _entityName);
        __EIP712_init_unchained("Colledger_Protocol", "1");
        admin = _portalAdmin;
        collegeCode = _collegeCode;
    }

    function hashUser(Login.InsLogin memory login) internal view returns(bytes32) {
        return _hashTypedDataV4(keccak256(abi.encode(keccak256(
            "InsLogin(address admin,string insReg)"
        ),
        login.admin,
        keccak256(bytes(login.insReg))
        )
        )
        );
    }

    function verifySigner(Login.InsLogin memory login) public view returns (address, bool) {
        bytes32 digest = hashUser(login);
        address user = ECDSAUpgradeable.recover(digest,login.signature);
        return (user,admin==user);
    }

    function _transfer(address from, address to, uint256 tokenId) internal virtual override{
        revert transferRestricted();     
    }

    function enrollStudent(address _identity, uint _programme) external onlyAdmin {
        isEnrolled[_identity] = true;
        currentProgrammeCode[_identity]=_programme;
        currentSemester[_identity] = 1;
    }

    function batchIssueSemesterCredential(address[] memory _identities,
    uint _semesterNumber, uint _programmeCode,
    SemesterCredential[] memory _semesterCredential) 
    external onlyAdmin returns(bool){
        uint totalIdentities  = _identities.length;
        bool success;
        for(uint i=0;i<totalIdentities;i++){
            MarksheetCredential[_identities[i]][_programmeCode][_semesterNumber] = _semesterCredential[i];
            if(_semesterCredential[i].isPassed == true){
                currentSemester[_identities[i]] = _semesterNumber + 1;
            }
            if(i==totalIdentities-1){
                success = true;
            }
        }
        return success;
    }

    function checkSemesterCredential(address _identity,uint _programmeCode, uint _semesterNumber) external view returns(SemesterCredential memory) {
        return MarksheetCredential[_identity][_programmeCode][_semesterNumber];
    }

    function mintFinalCredential(address _identity,uint _programmeCode) external {
        if(currentSemester[_identity] <= programmeSemestersRequired[currentProgrammeCode[_identity]]) {
            revert courseIncomplete(currentSemester[_identity], programmeSemestersRequired[currentProgrammeCode[_identity]]);
        }
        if(!MarksheetCredential[_identity][_programmeCode][programmeSemestersRequired[currentProgrammeCode[_identity]]].isPassed) {
            revert notPassed();
        }
        if(!mintingEnabled) {
            revert mintDisabled();
        }
        degreeId++;
        _safeMint(_identity, degreeId);
        CredentialDetails[degreeId].programmeCode = currentProgrammeCode[_identity];
        CredentialDetails[degreeId].ownerIdentity = _identity;
        CredentialDetails[degreeId].issueTime = block.timestamp;
    }

    function returnInterface() public pure returns(string memory) {
    return "Institute";
    }

}