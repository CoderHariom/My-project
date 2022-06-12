// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <=0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract mintContract is ERC721, Ownable
{
    uint256 public mintprice = 1 ether;
    uint256 public totalSupply;
    uint256 public maxSupply;
    bool public isMintEnabled;
    mapping(address=>uint256) public mintWallets;
    
    constructor() payable ERC721 ('simpleMint','SMT')
    {
        maxSupply =2;
    }

    function toggleisMintEnabled() external onlyOwner{
        isMintEnabled = !isMintEnabled;
    }

    function setmaxsupply(uint256 _maxsupply) external onlyOwner{
        maxSupply = _maxsupply;
    }

    function mint() external payable{
        require(isMintEnabled,'minting is not enabled');
        require(mintWallets[msg.sender]<1,"exceeds max per wallet");
        require(msg.value== mintprice,"wrong value");
        require(maxSupply > totalSupply,"sold out");

        mintWallets[msg.sender]++ ;
        totalSupply ++;
        uint256 tokenId =totalSupply;
        _safeMint(msg.sender,tokenId);
    }

}

