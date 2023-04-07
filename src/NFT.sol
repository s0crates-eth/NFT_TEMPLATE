// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./DefaultOperatorFilterer.sol";

contract NFT is ERC721, Ownable, DefaultOperatorFilterer {
    using Strings for uint256;

    address public erc20contract = 0xf0f9D895aCa5c8678f706FB8216fa22957685A13; // RVLT polygon token
    uint256 public erc20Price = 186900000000000000000000000; // 186900000 ERC20 token
    uint256 public gasPrice = 1000000000000000; // 0.001 gas token
    uint256 public constant maxTokens = 3000;
    uint256 private constant tokensReserved = 20;
    uint256 public constant maxMintAmount = 10;
    uint256 public totalSupply;
    string public baseUri = "ipfs://bafybeihbg2zhxdfe2ovpiz5vlfps55vbkhzemuotkcaq34bfsicut6cj5e/";
    string public baseExtesion = ".json";
    bool public isSaleActive;
    
    mapping(address => uint256) private mintedPerWallet;

    event NewNFTMinted(address sender, uint256 tokenId);

    constructor(address[] addresses) ERC721("BoN x EthDenver", "BONxETHD") {
        for(uint256 i = 1; i <= tokensReserved; ++i) {
            _safeMint(msg.sender, i);
        }
        totalSupply = tokensReserved;

        uint256 length = addresses.length;
        for (uint256 i; i < length; ) {
            _safeMint(addresses[i], ++totalSupply);
            unchecked { ++i; }
        }
    }

    // Public Functions
    function mint(uint256 _numTokens) external payable {
        require(isSaleActive, "The sale is paused.");
        require(_numTokens <= maxMintAmount, "You cannot mint that many in one transaction.");
        require(mintedPerWallet[msg.sender] + _numTokens <= maxMintAmount, "You cannot mint that many total.");
        uint256 curTotalSupply = totalSupply;
        require(curTotalSupply + _numTokens <= maxTokens, "Exceeds total supply.");
        require(_numTokens * gasPrice <= msg.value, "Insufficient funds.");
        uint256 erc20Cost = erc20Price * _numTokens;
        // users must APPROVE staking contract to use their erc20 before v-this-v can work
        bool success = IERC20(erc20contract).transferFrom(msg.sender, address(this), erc20Cost);
        require(success == true, "transfer failed!");

        for(uint256 i = 1; i <= _numTokens; ++i) {
            _safeMint(msg.sender, curTotalSupply + i);
        }
        mintedPerWallet[msg.sender] += _numTokens;
        totalSupply += _numTokens;

        emit NewNFTMinted(msg.sender, totalSupply);
    }

    // Owner-only functions
    function flipSaleState() external onlyOwner {
        isSaleActive = !isSaleActive;
    }

    function setGasPrice(uint256 _price) external onlyOwner {
        gasPrice = _price;
    }

    function setERC20Price(uint256 _price) external onlyOwner {
        erc20Price = _price;
    }

    function setBaseUri(string memory _baseUri) external onlyOwner {
        baseUri = _baseUri;
    }

	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
 
        string memory currentBaseURI = _baseURI();
        return bytes(currentBaseURI).length > 0
            ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
            : "";
    }
 
    function _baseURI() internal view virtual override returns (string memory) {
        return baseUri;
    }

    function withdrawAll(address address_70, address address_20, address address_10) external payable onlyOwner {
        uint256 erc20Balance = IERC20(erc20contract).balanceOf(address(this));
        uint256 gasBalance = address(this).balance;
        if(erc20Balance > 0){
            uint256 seventy_percent = erc20Balance * 70 / 100;
            uint256 twenty_percent = erc20Balance * 20 / 100;
            uint256 ten_percent = erc20Balance * 10 / 100;
            bool transferOne = IERC20(erc20contract).transfer(address_70, seventy_percent);
            bool transferTwo = IERC20(erc20contract).transfer(address_20, twenty_percent);
            bool transferThree = IERC20(erc20contract).transfer(address_10, ten_percent);
            require(transferOne && transferTwo && transferThree, "transfer failed!");
        }
        if(gasBalance > 0){
            uint256 seventy_percent = gasBalance * 70 / 100;
            uint256 twenty_percent = gasBalance * 20 / 100;
            uint256 ten_percent = gasBalance * 10 / 100;
            ( bool transferOne, ) = payable(address_70).call{value: seventy_percent}("");
            ( bool transferTwo, ) = payable(address_20).call{value: twenty_percent}("");
            ( bool transferThree, ) = payable(address_10).call{value: ten_percent}("");
            require(transferOne && transferTwo && transferThree, "Transfer failed.");
        }
    }
 
    // OpenSea Enforcer functions
    function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator {
        super.transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator {
        super.safeTransferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override onlyAllowedOperator {
        super.safeTransferFrom(from, to, tokenId, data);
    }
}