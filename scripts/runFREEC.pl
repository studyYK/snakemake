#!/usr/bin/perl
# run with <cfg file>  <out dir>
# <cfg file> as: sample_id	normal_bam	tumor_bam

($cfg, $out)=@ARGV;
mkdir "$out/shell";
mkdir "$out/result";


$chrLenFile="/mnt/isilon/cbttc/database/GRCm38/GRCm38.chr.length";
$chiFiles="/mnt/isilon/cbttc/database/GRCm38/";
$samtools="/mnt/isilon/cbttc/tools/samtools-1.2/samtools";

open IN, $cfg;
while(<IN>){
	chomp;
	($smp, $nbam, $tbam)=split;
	mkdir "$out/result/$smp";
	$config=<<"FILE";
[general]
chrLenFile = $chrLenFile
ploidy = 2
chrFiles = $chiFiles
maxThreads = 48
outputDir = $out/result/$smp
samtools = $samtools
coefficientOfVariation = 0.062

[sample]
mateFile = $tbam
inputFormat = BAM
mateOrientation = FR

[control]
mateFile = $nbam
inputFormat = BAM
mateOrientation = FR
FILE
	open CFG, ">$out/result/$smp/$smp.cfg";
	print CFG $config;
	close CFG;

	open SHELL, ">$out/shell/freec.$smp.sh";
	print SHELL "/home/zhuy/bin/freec -conf $out/result/$smp/$smp.cfg\n";
	close SHELL;

}close IN;
