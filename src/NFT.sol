// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./DefaultOperatorFilterer.sol";

contract NFT is ERC721, Ownable, DefaultOperatorFilterer {
    using Strings for uint256;

    uint public constant MAX_TOKENS = 2420;
    uint private constant TOKENS_RESERVED = 20;
    uint public price = 1000000000000000; // 0.001
    uint256 public constant MAX_MINT_PER_TX = 1;

    bool public isSaleActive;
    uint256 public totalSupply;
    mapping(address => uint256) private mintedPerWallet;

    string public baseUri;
    string public baseExtesion = ".json";

    event NewNFTMinted(address sender, uint256 tokenId);

    constructor(address[] addresses) ERC721("BoN x EthDenver", "BONxETHD") {
        baseUri = "ipfs://bafybeibc5jwvpzixjrafqx5jofcui26pfmaeajzdndqswcrxyhan5njvdi/";
        
        for(uint256 i = 1; i <= TOKENS_RESERVED; ++i) {
            _safeMint(msg.sender, i);
        }
        totalSupply = TOKENS_RESERVED;

        uint length = addresses.length;
        for (uint i; i < length; ) {
            _safeMint(addresses[i], ++totalSupply);
            unchecked { ++i; }
        }
    }

    // Public Functions
    function mint(uint256 _numTokens) external payable {
        require(isSaleActive, "The sale is paused.");
        require(_numTokens <= MAX_MINT_PER_TX, "You cannot mint that many in one transaction.");
        require(mintedPerWallet[msg.sender] + _numTokens <= MAX_MINT_PER_TX, "You cannot mint that many total.");
        uint256 curTotalSupply = totalSupply;
        require(curTotalSupply + _numTokens <= MAX_TOKENS, "Exceeds total supply.");
        require(_numTokens * price <= msg.value, "Insufficient funds.");

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

    function setBaseUri(string memory _baseUri) external onlyOwner {
        baseUri = _baseUri;
    }

    function setPrice(uint256 _price) external onlyOwner {
        price = _price;
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

    function withdrawAll() external payable onlyOwner {
        uint256 balance = address(this).balance;
        uint256 bonTreasury = balance * 70 / 100;
        uint256 bonStakers = balance * 20 / 100;
        uint256 bonDevs = balance * 10 / 100;
        ( bool transferOne, ) = payable(0xd02b97b0B3439bf032a237f712a5fa5B161D89d3).call{value: bonTreasury}("");
        ( bool transferTwo, ) = payable(0xad87F2c6934e6C777D95aF2204653B2082c453de).call{value: bonStakers}("");
        ( bool transferThree, ) = payable(0xb1a23cD1dcB4F07C9d766f2776CAa81d33fa0Ede).call{value: bonDevs}("");
        require(transferOne && transferTwo && transferThree, "Transfer failed.");
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