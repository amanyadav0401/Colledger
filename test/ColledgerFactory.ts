import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers"
import { ethers } from "hardhat";
import { ImplementationEmployer, ImplementationEmployer__factory } from "../typechain";
import { Factory__factory } from "../typechain/factories/Factory__factory";
import { Factory } from "../typechain/Factory";

describe("Colledger Factory", ()=>{

    let owner : SignerWithAddress;
    let signers : SignerWithAddress[];
    let factory : Factory;
    let employer : ImplementationEmployer;

    beforeEach(async()=>{
        signers = await ethers.getSigners();
        owner = signers[0];
        factory = await new Factory__factory(owner).deploy();
        await factory.connect(owner).init();    
    })

    it("Creating Employer Certificate", async()=>{
          let a = await factory.connect(owner).createEmployerCertificate(signers[1].address,"Web Meta Mines",signers[1].address);
          console.log("New Entity Registered", await factory.entityRegistered(1));
          let address = await factory.getEntityAddress(1);
          let instance = await new ImplementationEmployer__factory(owner).attach(address);
          console.log("Employer Name: ",await instance.name());
    })

    
})