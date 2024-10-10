{ pkgs ? import <nixpkgs> {}, lib ? pkgs.lib, captcha ? "" }:
let
	secret = "fac";
  command = builtins.substring 0 3 (builtins.hashString "md5" "man ls");

	wordle = remaining-captcha: guess: (
	  if builtins.stringLength guess == 0 then "" else
		if (builtins.substring 0 1 guess == builtins.substring 0 1 remaining-captcha) then "A" + (wordle (builtins.substring 1 ((builtins.stringLength remaining-captcha) - 1) remaining-captcha) (builtins.substring 1 ((builtins.stringLength guess) - 1) guess)) else
		if (lib.strings.hasPrefix (builtins.substring 0 1 guess) command ||
		    lib.strings.hasInfix  (builtins.substring 0 1 guess) command ||
		    lib.strings.hasSuffix (builtins.substring 0 1 guess) command) then "B" + (wordle (builtins.substring 1 ((builtins.stringLength remaining-captcha) - 1) remaining-captcha) (builtins.substring 1 ((builtins.stringLength guess) - 1) guess)) else
		"C" + (wordle (builtins.substring 1 ((builtins.stringLength remaining-captcha) - 1) remaining-captcha) (builtins.substring 1 ((builtins.stringLength guess) - 1) guess))
	);


	decoder-source = pkgs.writeTextDir "decoder-source.cpp" ''
#include <stdio.h>

int main() {
	FILE* fp = fopen("@in-path@", "r");
	FILE* out = fopen("out", "w");
	while(1) {
		int c = fgetc(fp);
		if (c == EOF) break;
		fputc(c^0x55, out); // Organization-grade encryption
	}
	fclose(fp);
	fclose(out);
	return 0;
}
	'';

	encoded-file = ./secret;

	decoder =
	pkgs.stdenv.mkDerivation {
		name = "decoder";
		src = decoder-source;

		unpackPhase = "cp $src/decoder-source.cpp .";
		patchPhase = ''
			substituteInPlace decoder-source.cpp --replace-fail "@in-path@" "${encoded-file}"
		'';
		buildPhase = "${pkgs.gcc}/bin/g++ -o decoder decoder-source.cpp";
		installPhase = ''
			mkdir -p $out/bin
			cp decoder $out/bin
		'';
	};


	empty-captcha = (pkgs.writeText "empty" ''
	  Enter CAPTCHA
		It uses only characters a-f
	'');
	too-short = (pkgs.writeText "length" "CAPTCHA has to be 3 characters long");
	wordle-failed = (pkgs.writeText "failed" ''
	Wrong answer.
	Wordle hint: ${wordle command captcha}
	A - correct character in the right position
	B - correct character in the wrong position
	C - wrong character
	'');

	my-directory =
	pkgs.stdenv.mkDerivation {
		name = "my-directory";

		unpackPhase = "true";
		installPhase = ''
			${decoder}/bin/decoder
			${pkgs.unzip}/bin/unzip -P "KurisuMyLove" -d $out out
			#${pkgs.unzip}/bin/unzip -d $out out
			#cp out $out
		'';
	};

	check = guess:
	if (guess == "") then empty-captcha else
	if (builtins.stringLength guess != 3) then too-short else
	if (guess != command) then wordle-failed else
	my-directory;
in
check captcha
