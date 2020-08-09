{ pkgs ? import <nixpkgs> {} }:                                                   
                                                                                   
let
   self = {
      strongdm = pkgs.callPackage ./pkgs/sdm {};
      dmenu-afreak = pkgs.callPackage ./pkgs/dmenu {};
      dmenuhist = pkgs.callPackage ./pkgs/dmenuhist {};
      grobi-afreak = pkgs.callPackage ./pkgs/grobi-afreak {};
      sidequest = pkgs.callPackage ./pkgs/sidequest {};
      nix-doc = pkgs.callPackage ./pkgs/nix-doc {};
      modules = {
         strongdm = import ./modules/sdm;
      };
   };                                                                                   
   in self 

