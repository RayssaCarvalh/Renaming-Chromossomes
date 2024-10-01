#!/bin/bash

#SBATCH --job-name=renamingchr
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --mem=64gb
#SBATCH --time=24:00:00
#SBATCH -e /home/rayssa/teste/out/slurm-%j.err
#SBATCH -o /home/rayssa/teste/out/slurm-%j.out

mkdir -p /home/rayssa/teste/out
mkdir -p /home/rayssa/teste/result

result=/home/rayssa/teste/result
dircov=/home/rayssa/cov
file=dataAcessionnumber.txt #use a file where the first column has the old name and the second column has the new name


qtdlines=$(< "$dircov"/"$file" wc -l)
i=1

while [ $i -le $qtdlines ]
do
  oldname=$(awk -v "i=$i" '(NR==i){print $1}' /home/rayssa/teste/dataAcessionnumber.txt)
  newname=$(awk -v "i=$i" '(NR==i){print $2}' /home/rayssa/teste/dataAcessionnumber.txt)
  (cd /home/rayssa/cov/
   gzip -d *.cov.gz
   sed -i s/$oldname/$newname/g *.cov)
  echo done while "$i"
  i=$(( $i + 1 ))
done

(cd /home/rayssa/cov/
gzip *.cov)

echo DONE
