//SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";

contract ImplementationEmployer is ERC721URIStorageUpgradeable{

    address public admin;

    uint256 public totalCredentials;

    string orgReg;

    struct Credential {
        uint256 employeeNumber;
        address identity;
        uint256 startTime;
        uint256 endTime;
        string post;
    }

    mapping(uint256 => Credential) public EmployeeCredential;

    mapping(address => uint256[]) public overallEmployeeCredentials;

    mapping(address => uint) employeeCurrentCredential;

    mapping(address => bool) isEmployee;

    modifier onlyAdmin {
        require(msg.sender==admin,"Caller is not the admin!");
        _;
    }

    function init(string memory _entityName, address _portalAdmin, string memory _orgReg) external initializer{
        require(_portalAdmin!=address(0),"Zero address.");
        __ERC721_init_unchained(_entityName, _entityName);
        admin = _portalAdmin;
        orgReg = _orgReg;
    }

    function _transfer(address from, address to, uint256 tokenId) internal virtual override{
        bool letTransfer = false;
        require(letTransfer,"You are not allowed to transfer a credential.");
    }

    function startTenure(address _identity, string memory _post, uint256 _employeeNumber) external onlyAdmin{
        totalCredentials++;
        Credential storage credential = EmployeeCredential[totalCredentials];
        _safeMint(_identity, totalCredentials);
        employeeCurrentCredential[_identity] = totalCredentials;
        credential.identity = _identity;
        credential.startTime = block.timestamp;
        credential.post = _post;
        credential.employeeNumber = _employeeNumber; 
        overallEmployeeCredentials[_identity].push(totalCredentials);
        isEmployee[_identity] = true;
    }

    function updateEmployeeRole(address _identity, string memory _post) external onlyAdmin{
        require(isEmployee[_identity],"Employee not registered");
        uint CurrentTokenId = employeeCurrentCredential[_identity];
        uint employeeNumber = EmployeeCredential[CurrentTokenId].employeeNumber;
        EmployeeCredential[CurrentTokenId].endTime = block.timestamp;
        totalCredentials++;
        Credential storage credential = EmployeeCredential[totalCredentials];
        _mint(_identity, totalCredentials);
        credential.identity = _identity;
        credential.startTime = block.timestamp;
        credential.post = _post;
        credential.employeeNumber = employeeNumber;
        overallEmployeeCredentials[_identity].push(totalCredentials);
        employeeCurrentCredential[_identity] = totalCredentials;
        }

    function endTenure(address _identity) external onlyAdmin{
        uint CurrentTokenId = employeeCurrentCredential[_identity];
        EmployeeCredential[CurrentTokenId].endTime = block.timestamp;
        isEmployee[_identity] = false;
    }    

    function setAdmin(address _newAdmin) external onlyAdmin {
        admin = _newAdmin;
    }

    function checkCurrentCredential(address _identity) external view returns(Credential memory) {
        return EmployeeCredential[employeeCurrentCredential[_identity]];
    }

    function returnInterface() public pure returns(string memory) {
    return "Employer";
    }

}