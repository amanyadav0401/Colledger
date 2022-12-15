import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { ethers, network } from "hardhat";
import {
  expandTo18Decimals,
  expandTo6Decimals,
} from "../test/utilities/utilities";
import { SwapToken, SwapToken__factory } from "../typechain";

function sleep(ms: any) {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }

async function main() {
    const swap = await ethers.getContractFactory("SwapToken");
    const Swap = await swap.deploy("0x69015912AA33720b842dCD6aC059Ed623F28d9f7");
    await sleep(2000);
    console.log("Swap Address- "+Swap.address);
}  

main()
.then(()=>process.exit(0))
.catch((error)=>{
    console.error(error);
    process.exit(1);
}) ;
