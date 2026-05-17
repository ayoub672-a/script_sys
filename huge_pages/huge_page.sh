#!/bin/bash

######################################################################
# Script pour allouer des huges pages utilisés pour la SGA de Oracle #
# Auteur: Allali Ayoub                                               #
# Creation: 02/04/2026                                               #
# Usage: ./huge_page.sh [Taille de la SGA en Go]                     #
######################################################################

if [[ $UID -ne 0 ]]; then
    echo "Script must be executed with the root user !"
    exit 1
fi

if [[ $# -ne 1 ]]; then
    echo "Usage: ./huge_page.sh [sga_size_en_Go]"
    exit 1
fi

sga_size="$1"

# Modification of memock limits
# The maximum of memory that a process can allocate
# Pam apply pam_limits.so, it's applies the limits 
# set in /etc/security/limits.conf 
memlock=$(awk '/MemTotal/ {printf "%d", $2 * 0.9}' /proc/meminfo)

sed -i '/oracle.*memlock/d' /etc/security/limits.conf
find /etc/security/limits.d/ -type f -name "*.conf" -exec sed -i '/oracle.*memlock/d' {} \;

echo "oracle   soft   memlock    $memlock" >> /etc/security/limits.d/huge_page.conf
echo "oracle   hard   memlock    $memlock" >> /etc/security/limits.d/huge_page.conf

value_memlock=$(runuser -l oracle -c 'ulimit -l')
if [[ $value_memlock -lt $memlock ]]; then
    echo "Warning: memlock pas encore pris en compte, relogin oracle nécessaire"
fi

# Huge page size are set to 2MB by default
# We check if it's set to 2MB 
size_huges=$(grep Hugepagesize /proc/meminfo | awk '{print $2}')
if [[ $size_huges -ne 2048 ]]; then
    echo "Huges pages size not equal to 2048 Kb!"
    exit 1
fi

# Allow the group oracle to use Huge Page
# 0 by default (root)
gid=$(grep oinstall /etc/group | cut -d: -f3)
if [[ -z $gid ]]; then
    echo "Groupe oinstall introuvable !"
    exit 1
fi
echo "vm.hugetlb_shm_group = "$gid"" >> /etc/sysctl.conf

# Allouer le bon nombre de Huge Page pour la SGA
# 1 page -> 2048 Ko = 2,048 Mo = 0,002048 Go
# Formule: Taille SGA / Taille d'une huge page = Nombres de huges pages 
huge_page_size=0.002048
nb_huges=$(echo "$sga_size / $huge_page_size" + 10 | bc)
echo "$nb_huges Huges Pages"
echo "vm.nr_hugepages = $nb_huges" >> /etc/sysctl.conf

# Appliquer les paramètre dans /etc/sysctl.conf
sysctl -p
