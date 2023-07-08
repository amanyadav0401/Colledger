//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./ImplementationEmployer.sol";
import "./ImplementationInstitute.sol";
// import "hardhat/console.sol";

contract Factory {

    address public admin;
    uint public totalEntities;

    struct EntityDetails {
        string entityType;
        uint entityIdentity;
        address entityAddress;
    }

    mapping(uint => EntityDetails) public entityRegistrationDetails;

    mapping(uint => bool) public identityUsed;

    

    modifier onlyAdmin  {
       require(msg.sender==admin, "Caller is not the admin");
       _;
    }

    function init() external {
        admin = msg.sender;
    }

    event CertificateCreated(string entityType, string entityName, address entityAddress);

    function createEmployerCertificate(
        uint _identity,
        string memory _entityName,
        address _portalAdmin,
        uint _countryCode
    ) external onlyAdmin returns(address certificateAddress){

        require(!identityUsed[_identity],"Certificate already created!");
        
        bytes memory bytecode = type(ImplementationEmployer).creationCode;

        bytes32 salt = keccak256(abi.encodePacked(_identity,_entityName,_countryCode));

        assembly {
            certificateAddress := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }

        ImplementationEmployer(certificateAddress).init(_entityName, _portalAdmin);

        emit CertificateCreated("Employer", _entityName, certificateAddress);

        totalEntities++;

        EntityDetails storage entity = entityRegistrationDetails[totalEntities];

        entity.entityAddress = certificateAddress;
        entity.entityIdentity = _identity;
        entity.entityType = "Employer";   
        identityUsed[_identity] = true;   
    }

    function createInstituteCertificate(
        uint _identity,
        string memory _entityName,
        address _portalAdmin,
        string memory _collegeCode,
        uint _countryCode
    ) external onlyAdmin returns(address certificateAddress){
        require(!identityUsed[_identity],"Certificate already created!");

        bytes memory bytecode = type(ImplementationInstitute).creationCode;

        bytes32 salt = keccak256(abi.encodePacked(_collegeCode,_entityName,_countryCode));

        assembly {
            certificateAddress := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }

        ImplementationInstitute(certificateAddress).init(_entityName, _portalAdmin, _collegeCode);

        emit CertificateCreated("Institute", _entityName, certificateAddress);

        totalEntities++;

        EntityDetails storage entity = entityRegistrationDetails[totalEntities];

        entity.entityAddress = certificateAddress;
        entity.entityIdentity = _identity;
        entity.entityType = "Institute";   
        identityUsed[_identity] = true; 
    }

    function getEntityAddress(uint entityNumber) external view returns(address) {
        return entityRegistrationDetails[entityNumber].entityAddress;
    }

    


}