// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface CharactersTypes {
  struct Character {
    uint256 dna;
    string name;
    string conflict;
    string extras;
  }
}