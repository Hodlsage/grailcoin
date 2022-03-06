
// ----------------------------------------------------------------------------
// --- AirDrop - Vault Contract
// --- Symbol      : AirDrop
// --- Name        : AirDrop
// --- Total supply: Generated from AirDrop minter accounts
// --- @author EJS32 
// --- @title for 01101101 01111001 01101100 01101111 01110110 01100101
// --- @dev pragma solidity version:0.8.8+commit.dddeac2f
// --- (c) AirDrop - 2019. The MIT License.
// --- SPDX-License-Identifier: MIT
// ----------------------------------------------------------------------------

pragma solidity 0.8.8;

// ----------------------------------------------------------------------------
// --- Address Library
// ----------------------------------------------------------------------------

contract AirDrop is ERC721, Ownable {
    using SafeMath for uint256;
    
    string public _abi_hash = "";
    string public _provenance_hash = "";
    uint256 public _price = 0; 
    uint256 public _max_supply = 0; 
    string public _baseURI = "";
    uint256 public _airdrop_available = 0;
    uint256 public _vault_id = 0; 

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(bytes32 => bool) public airdrop_tickets;

    constructor(string memory name, string memory symbol, string memory abi_hash, string memory provenance_hash, uint256 price, uint256 max_supply, uint16 vault_id) ERC721(name, symbol) {
        _abi_hash = abi_hash;
        _provenance_hash = provenance_hash;
        _price = price;
        _max_supply = max_supply;
        _vault_id = vault_id;
        if (_vault_id == 1) {
            _baseURI = string(abi.encodePacked("https://gateway.pinata.cloud/ipfs/", _provenance_hash, "/"));
        } else {
            _baseURI = string(abi.encodePacked("https://test.defra.systems/metadata/", _provenance_hash, "/asset/"));
        }
        _setBaseURI(_baseURI);
    }

    function update(string memory provenance_hash, uint256 price, uint256 max_supply) public onlyOwner {
        _provenance_hash = provenance_hash;
        _price = price;
        _max_supply = max_supply; 

        if (_vault_id == 1) {
            _baseURI = string(abi.encodePacked("https://gateway.pinata.cloud/ipfs/", _provenance_hash, "/"));
        } else {
            _baseURI = string(abi.encodePacked("https://test.defra.systems/metadata/", _provenance_hash, "/asset/"));
        }
    }

    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        msg.sender.transfer(balance);
    }

    function updateBaseTokenURI(string memory baseURI) public onlyOwner {
        _setBaseURI(baseURI);
        _baseURI = baseURI;
    }

    function baseTokenURI() public view returns (string memory) {
        return _baseURI;
    }

    function mintToSender(uint numberOfTokens) internal {
        require(totalSupply().add(numberOfTokens).add(_airdrop_available) <= _max_supply, "Minting would exceed max supply");
        
        for(uint i = 0; i < numberOfTokens; i++) {
            uint mintIndex = totalSupply();
            _mint(msg.sender, mintIndex);
        }
    }

    function reserve(uint numberOfTokens) public onlyOwner {
        mintToSender(numberOfTokens);
    }

    function purchase(uint numberOfTokens) public payable {
        require(numberOfTokens <= 30, "Can only purchase a maximum of 30");
        require(_price.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
        mintToSender(numberOfTokens);
    }

    function redeemCodeCreate(bytes32 code_hashed) public onlyOwner {
        require(!airdrop_tickets[code_hashed], "Cannot create the same ticket twice");
        require(totalSupply().add(1) <= _max_supply, "Codes would exceed max supply");
        airdrop_tickets[code_hashed] = true;
        _airdrop_available += 1;
    }

    function redeemCodeCreateBulk(bytes32[] memory code_hashed_arr) public onlyOwner {
        require(totalSupply().add(code_hashed_arr.length) <= _max_supply, "Codes would exceed max supply");
        for (uint i = 0; i < code_hashed_arr.length; i++) {
            redeemCodeCreate(code_hashed_arr[i]);
        }
    }

    function airdrop(bytes memory code) public {
        require(_airdrop_available > 0, "No airdrop tokens available or the airdrop is over");
        require(airdrop_tickets[sha256(code)], "The given airdrop ticket does not exist");
        delete airdrop_tickets[sha256(code)];
        _airdrop_available -= 1;
        mintToSender(1);
    }

    function disableAirdrop() public onlyOwner {
        _airdrop_available = 0;
    }

    function abiHash() public view virtual  returns (string memory) {
        return _abi_hash;
    }

    function provenanceHash() public view virtual  returns (string memory) {
        return _provenance_hash;
    }

    function price() public view virtual returns (uint256) {
        return _price;
    }

    function max_supply() public view virtual returns (uint256) {
        return _max_supply;
    }
}