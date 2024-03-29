// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "./Owned.sol";
import "./Logger.sol";
import "./IFaucet.sol";

contract Faucet is Owned, Logger, IFaucet {

    uint public numOfFunders;

      event FundsAdded(address indexed funder, uint amount);
    event FundsWithdrawn(address indexed requester, uint amount);

    mapping(address => bool) private funders;
    mapping(uint => address) private lutFunders;

    
    modifier limitWithdraw(uint withdrawAmount) {
        
        require(
            withdrawAmount <= 100000000000000000, 
            "Cannot withdraw more than 0.1 ether"
        );
        _;
    }

    receive() external payable {}

    function emitLog() public override pure returns(bytes32) {
        return "Hello World";
    }
    
    function addFunds() override external payable {
        address funder = msg.sender;

        test3();
        
        if (!funders[funder]) {
            uint index = numOfFunders++;
            funders[funder] = true;
            lutFunders[index] = funder;
        }

          emit FundsAdded(funder, msg.value);
    }

    function test1() external onlyOwner {
        // Some managing stuff that only the owner can access
    }

    function test2() external onlyOwner {
        // Some managing stuff that only the owner can access
    }
    

    function withdraw(uint withdrawAmount) override external limitWithdraw(withdrawAmount) {
        payable(msg.sender).transfer(withdrawAmount); 

         emit FundsWithdrawn(msg.sender, withdrawAmount);
    }

    function getAllFunders() external view returns (address[] memory) {
        address[] memory _funders = new address[](numOfFunders);

        for (uint i=0; i < numOfFunders; i++) {
            _funders[i] = lutFunders[i];
        }

        return _funders;

    }

    function getFunderAtIndex(uint index) external view returns(address) {
        return lutFunders[index];
    } 

}



// const instance = await Faucet.deployed()

// instance.addFunds({from: accounts[0], value: "2000000000000000000"})
// instance.addFunds({from: accounts[1], value: "2000000000000000000"})

// instance.withdraw("100000000000000000", {from: accounts[1]})

// instance.getFunderAtIndex(0)
// The numOfFunders iteration is changing the key value for each additional funder
// instance.getAllFunders()
