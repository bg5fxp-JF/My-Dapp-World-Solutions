// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IGamingEcosystemNFT {
    function mintNFT(address to) external;
    function burnNFT(uint256 tokenId) external;
    function transferNFT(uint256 tokenId, address from, address to) external;
    function ownerOf(uint256 tokenId) external view returns (address);
}

error NotOwner();
error NotOwnerOfToken();
error NotAccessible();
error OwnerCannotDo();
error PlayerAlreadyExists();
error NotUniqueName();
error NotUniqueId();
error NameTooShort();
error NotExsistingGame();
error NotExsistingPlayer();
error NotExsistingToken();
error NotEnoughCredits();

contract BlockchainGamingEcosystem  {

    struct Player {
        string playerName;
        uint256 credits;
        uint256 numNfts;
    }

    address private immutable i_owner;
    IGamingEcosystemNFT private immutable nft;
    uint256 private tokenCounter;
    mapping(address => Player) players;
    mapping(bytes32 => bool) isUserNameTaken;
    mapping(bytes32 => bool) isGameNameTaken;
    mapping(uint256 => string) gameIdToName;
    mapping(uint256 => uint256) gameIdToCurrentPrice;
    mapping(uint256 => uint256) tokenIdToCostOfToken;
    mapping(uint256 => uint256) tokenIdTGameId;


    constructor(address _nftAddress) {
        i_owner = msg.sender;
        nft = IGamingEcosystemNFT(_nftAddress);
        tokenCounter = 0;
    }

    modifier onlyOwner {
        if (msg.sender != i_owner) revert NotOwner();
        _;
    }

   

    // Function to register as a player
    function registerPlayer(string memory userName) public {
        if (msg.sender == i_owner) revert OwnerCannotDo();
        if (bytes(userName).length < 3) revert NameTooShort();
        Player storage player = players[msg.sender];
        if (bytes(player.playerName).length != 0) revert PlayerAlreadyExists();
        bytes32 hashName = keccak256(bytes(userName));
        if (isUserNameTaken[hashName]) revert NotUniqueName();

        isUserNameTaken[hashName] = true;
        player.playerName = userName;
        player.credits = 1000;
    }

    // Function to create a new game
    function createGame(string memory gameName, uint256 gameID) public onlyOwner {
        
        if (bytes(gameIdToName[gameID]).length != 0) revert NotUniqueId();
        bytes32 hashName = keccak256(bytes(gameName));
        if (isGameNameTaken[hashName]) revert NotUniqueName();

        gameIdToName[gameID] = gameName;
        isGameNameTaken[hashName] = true;
        gameIdToCurrentPrice[gameID] = 250;

    }
    
    // Function to remove a game from the ecosystem
    function removeGame(uint256 gameID) public onlyOwner {
        if (bytes(gameIdToName[gameID]).length == 0) revert NotExsistingGame();
        
        unchecked {
            for (uint i; i < tokenCounter; i++) 
            {
                if(tokenIdTGameId[i] == gameID){
                    address ownerOfToken = nft.ownerOf(i);
                    players[ownerOfToken].credits += tokenIdToCostOfToken[i];
                    players[ownerOfToken].numNfts--;
                    nft.burnNFT(i);
                }
            }
        }
        delete gameIdToName[gameID];
        delete isGameNameTaken[keccak256(bytes(gameIdToName[gameID]))];
    }
    
    // Function to allow players to buy an NFT asset
    function buyAsset(uint256 gameID) public {
        if (bytes(gameIdToName[gameID]).length == 0) revert NotExsistingGame();
        if (bytes(players[msg.sender].playerName).length == 0) revert NotExsistingPlayer();
        if(players[msg.sender].credits < gameIdToCurrentPrice[gameID]) revert NotEnoughCredits();

        nft.mintNFT(msg.sender);
        players[msg.sender].credits -= gameIdToCurrentPrice[gameID];
        players[msg.sender].numNfts++;
        tokenIdToCostOfToken[tokenCounter] = gameIdToCurrentPrice[gameID];
        tokenIdTGameId[tokenCounter] = gameID;
        tokenCounter++;
        gameIdToCurrentPrice[gameID] += (gameIdToCurrentPrice[gameID]/10);

    }

	// Function to allow players to sell owned assets
    function sellAsset(uint256 tokenID) public {
        if (msg.sender != nft.ownerOf(tokenID)) revert NotOwnerOfToken();
        if (tokenIdToCostOfToken[tokenID] == 0) revert NotExsistingToken();
        uint _gameId = tokenIdTGameId[tokenID];
        players[msg.sender].credits += gameIdToCurrentPrice[_gameId];
        players[msg.sender].numNfts--;
        delete tokenIdTGameId[tokenID];
        nft.burnNFT(tokenID);
    }

    // Function to transfer asset to a different player
    function transferAsset(uint256 tokenID, address to) public {
        if (msg.sender != nft.ownerOf(tokenID)) revert NotOwnerOfToken();
        if (tokenIdToCostOfToken[tokenID] == 0) revert NotExsistingToken();
        if (bytes(players[to].playerName).length == 0) revert NotExsistingPlayer();
        if (msg.sender == to) revert();
        nft.transferNFT(tokenID,msg.sender,to);
        players[msg.sender].numNfts--;
        players[to].numNfts++;
    }

    // Function to view a player's profile
    function viewProfile(address playerAddress) public view returns (string memory userName, uint256 balance, uint256 numberOfNFTs) {
        if (!((bytes(players[msg.sender].playerName).length > 0) || (msg.sender == i_owner))) revert NotAccessible();
        if (bytes(players[playerAddress].playerName).length == 0) revert NotExsistingPlayer();
        userName = players[playerAddress].playerName;
        balance = players[playerAddress].credits;
        numberOfNFTs = players[playerAddress].numNfts;
    }

    // Function to view Asset owner and the associated game
    function viewAsset(uint256 tokenID) public view returns (address owner, string memory gameName, uint price) {
        if (!((bytes(players[msg.sender].playerName).length > 0) || (msg.sender == i_owner))) revert NotAccessible();
        owner = nft.ownerOf(tokenID);
        uint _gameId = tokenIdTGameId[tokenID];
        gameName = gameIdToName[_gameId];
        price = tokenIdToCostOfToken[tokenID];
    }
}