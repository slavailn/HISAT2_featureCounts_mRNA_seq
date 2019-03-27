#! /bin/bash

echo -e "SampleID\ttotal\tmapped\tpercent_mapped"

for file in ./*.bam
do
    filename=`basename $file`
    samplename=${filename%.bam}
    samtools flagstat $file > stat.tmp
    total=`awk 'NR==1 {print}' stat.tmp | awk '{print $1}'`
    mapped=`awk 'NR==5 {print}' stat.tmp | awk '{print $1}'`
    percent_mapped=`bc <<< "scale=3; 100-($mapped/$total)*100"`
    echo -e "$samplename\t$total\t$mapped\t$percent_mapped"
    rm stat.tmp
done



        



