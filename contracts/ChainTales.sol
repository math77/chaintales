//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import '@openzeppelin/contracts/access/Ownable.sol';
import "@openzeppelin/contracts/utils/Counters.sol";

import { Base64 } from "./libraries/Base64.sol";

import "./ChainTalesMetadata.sol";

import "./core/CharactersTypes.sol";

import "hardhat/console.sol";


contract ChainTales is ERC721, Ownable {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIDs;

    mapping(uint256 => CharactersTypes.Character) private _characters;
    uint256 private _price = 0.002 ether;

    uint256 private constant MAX_CHARACTERS = 5446;
    uint256 private constant FOUNDER_RESERVED_AMOUNT = 10;
    uint256 private constant MAX_PUBLIC_AVAILABLE = MAX_CHARACTERS - FOUNDER_RESERVED_AMOUNT;

    uint256 private constant MAX_PER_ADDRESS = 5;

    mapping(uint256 => address) private _tokenIdToMetadataContractAddr;

    //CHANGE TO ARRAY
    mapping(uint256 => address) private _metadataAddrAvailables;

    address private DEFAULT_METADATA_CONTRACT_ADDRESS;


    address[] private metadataContractAddresses;


    string[] private origins = [
        "British",
        "American",
        "Brazilian",
        "Japanese",
        "Spanish",
        "Italian",
        "Mexican",
        "Russian",
        "Portuguese",
        "Canadian",
        "Lebanese",
        "Indian",
        "Australian",
        "German",
        "Dutch",
        "South African",
        "Austrian",
        "Egyptian",
        "French",
        "Angolan",
        "Swedish",
        "Nigerian"
    ];

    string[] private sexes = [
        "Female",
        "Male",
        "Unknown"
    ];

    string[] private lifestyles = [
        "Bohemian",
        "Hippie",
        "Frugal",
        "Nomad",
        "Rural",
        "Healthy",
        "Workaholic",
        "Punk",
        "Playboy",
        "Libertine"
    ];


    string[] private skills = [
        "Boxing",
        "Diving",
        "Knowledge of mechanical engineering",
        "Climbing",
        "Persuading people",
        "Navigating",
        "Juggling",
        "Negotiating",
        "Telling jokes",
        "Eidetic memory",
        "Polyglot",
        "Accurate observation",
        "Good with numbers",
        "Creativity",
        "Lip-reading",
        "Speed-reading",
        "Dancing",
        "Singing",
        "Swordfighting",
        "Archery",
        "Dressmaking",
        "Hacking",
        "Safecracking",
        "Airplane pilot",
        "Spying",
        "Storytelling",
        "Negotiating",
        "Masterful lying",
        "Knowledge of explosives"
    ];

    string[] private fears = [
        "Acrophobia",
        "Aerophobia",
        "Arachnophobia",
        "Autophobia",
        "Claustrophobia",
        "Hemophobia",
        "Ophidiophobia",
        "Alektorophobia",
        "Achluophobia",
        "Bacteriophobia",
        "Coulrophobia",
        "Entomophobia",
        "Thanatophobia",
        "Ornithophobia",
        "Pyrophobia",
        "Technophobia",
        "Zoophobia"

    ];

    string[] private vices = [
        "Gambling",
        "Pornography",
        "Sex",
        "Alcoholic beverages",
        "Adrenaline",
        "Video games",
        "Hallucinogenic drugs",
        "Social media",
        "Coffee",
        "Candies"
    ];

    string[] private motivations = [
        "Family",
        "Power",
        "Control",
        "Wealth",
        "Win",
        "Curiosity",
        "Outside respect",
        "Anger",
        "Desire",
        "Upward mobility"
    ];

    string[] private virtues = [
        "Honesty",
        "Courage",
        "Compassion",
        "Generosity",
        "Integrity",
        "Loyalty",
        "Benevolence",
        "Patient",
        "Faith",
        "Decency",
        "Courtesy",
        "Fairness",
        "Leadership",
        "Teamwork",
        "Persistence",
        "Enthusiasm",
        "Humility",
        "Self-control",
        "Hope",
        "Spirituality"
    ];

    string[] private hobbies = [
        "Reading",
        "Gardening",
        "Cooking",
        "Fishing",
        "Writing",
        "Chess",
        "Solve puzzles",
        "Drawing",
        "Board games",
        "Photography",
        "Golf",
        "Playing guitar",
        "Amateur astronomy",
        "Watch movies",
        "Painting",
        "Theatrical acting",
        "Beatboxing",
        "Blogging",
        "Ceramic artworks",
        "Collecting insects",
        "Collecting artwork",
        "Amateur radio",
        "Knife making",
        "Camping",
        "Listening to music",
        "Woodworking",
        "Amateur geology",
        "Rock painting",
        "Hunting",
        "Shooting",
        "Birdwatching",
        "Slacklining",
        "Car tuning",
        "Metal detecting",
        "Storm chasing",
        "Parkour",
        "Videography",
        "Collecting antique objects",
        "Aeromodelling"
    ];

    string[] private soulWords = [
        "Adventure",
        "Knowledge",
        "Happiness",
        "Craziness",
        "Simplicity",
        "Freedom",
        "Loneliness",
        "Impenitence",
        "Whatever",
        "Self-Love",
        "Grit",
        "Explore",
        "Grow",
        "Wander",
        "Talent",
        "Collaboration",
        "Determination",
        "Intensity",
        "Luck",
        "Mystery",
        "Aggressiveness",
        "Darkness",
        "Clearness",
        "Evil",
        "Weird",
        "Wild",
        "Charm"
    ];


	constructor() ERC721("ChainTales", "TALES") Ownable() {
        //init token in 1 instead of 0
        _tokenIDs.increment();
    }

    //Get components of an character.
    function getOrigin(uint256 dna) public view returns(string memory) {
        return magicCauldron(dna, origins, "ORIGINS");
    }

    function getSex(uint256 dna) public view returns(string memory) {
        return magicCauldron(dna, sexes, "SEXES");
    }

    function getLifestyle(uint256 dna) public view returns(string memory) {
        return magicCauldron(dna, lifestyles, "LIFESTYLES");
    }

    function getSkills(uint256 dna) public view returns(string memory) {
        return magicCauldron(dna, skills, "SKILLS");
    }

    // The inner self begins.
    function getFears(uint256 dna) public view returns(string memory) {
        return magicCauldron(dna, fears, "FEARS");
    }

    function getVirtues(uint256 dna) public view returns(string memory) {
        return magicCauldron(dna, virtues, "VIRTUES");
    }

    function getMotivations(uint256 dna) public view returns(string memory) {
        return magicCauldron(dna, motivations, "MOTIVATIONS");
    }

    function getVices(uint256 dna) public view returns(string memory) {
        return magicCauldron(dna, vices, "VICES");
    }

    function getHobbies(uint256 dna) public view returns(string memory) {
        return magicCauldron(dna, hobbies, "HOBBIES");
    }

    function getSoulWords(uint256 dna) public view returns(string memory) {
        return magicCauldron(dna, soulWords, "SOULWORDS");
    }

    function getName(uint256 dna) public view returns(string memory) {
        return _characters[dna].name;
    }

    function getConflict(uint256 dna) public view returns(string memory) {
        return _characters[dna].conflict;
    }

    function getExtras(uint256 dna) public view returns(string memory) {
        return _characters[dna].extras;
    }

    /*
    function getPast(uint256 dna) public view returns(string memory) {
        return magicCauldron(dna, past, "PAST");
    }
    */

    
    function magicCauldron(uint256 dna, string[] memory array, string memory prefix) internal view returns (string memory) {
        string[] memory items = new string[](3);

        //TEST
        if (keccak256(abi.encodePacked(prefix)) == keccak256(abi.encodePacked("SEXES")) || 
            keccak256(abi.encodePacked(prefix)) == keccak256(abi.encodePacked("ORIGINS")) ||
            keccak256(abi.encodePacked(prefix)) == keccak256(abi.encodePacked("LIFESTYLES"))) {
           
            return string(abi.encodePacked(array[dna % array.length]));

        }

        return string(abi.encodePacked(items[0], ';', items[1], ';', items[2]));

    }

    //Get the dna of a character by tokenID
    function getCharacterDna(uint256 tokenID) public view returns (uint256) {
        return _characters[tokenID].dna;
    }


    function claim() payable external {
        // get current tokenID
        uint256 tokenID = _tokenIDs.current();

        //require(msg.value >= _price, "Amount sended not sufficient.");
        require(tokenID < 9546, "Id Token invalid, try another!");

        CharactersTypes.Character memory character;
        character.dna = uint256(keccak256(abi.encodePacked(
            tokenID,
            msg.sender,
            block.difficulty,
            block.timestamp
            )));

        //mint token to the owner
        _safeMint(msg.sender, tokenID);
        _characters[tokenID] = character;

        //increment token's supply
        _tokenIDs.increment();
    }


    function setMetadataAddress(address addr) external onlyOwner {
        DEFAULT_METADATA_CONTRACT_ADDRESS = addr;
    }

    function addMetadataContractAddress(address addr) external onlyOwner {
        metadataContractAddresses.push(addr);
    }


    function setMetadataToTokenURI(uint256 tokenID, uint256 indexMetadata) external {
        require(tokenID < _tokenIDs.current(), "ChainTales: tokenID is not valid.");
        require(ownerOf(tokenID) == msg.sender, "You are not the owner of this token.");

        _tokenIdToMetadataContractAddr[tokenID] = metadataContractAddresses[indexMetadata];
    }

    function tokenURI(uint256 tokenID) public view override returns (string memory) {
        require(DEFAULT_METADATA_CONTRACT_ADDRESS != address(0), "No metadata yet");
        require(tokenID < _tokenIDs.current(), "Invalid tokenID");
        
        uint256 dna = getCharacterDna(tokenID);

        address currentMetadataContract = DEFAULT_METADATA_CONTRACT_ADDRESS;

        if (_tokenIdToMetadataContractAddr[tokenID] != address(0)) {
            currentMetadataContract = _tokenIdToMetadataContractAddr[tokenID];
        }

        return IChainTalesMetadata(currentMetadataContract).tokenURI(tokenID, getOrigin(dna), getSex(dna));
    }

}