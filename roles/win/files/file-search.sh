#!/bin/bash

DATE=`date '+%Y%m%d%H%M%S'`
PATH_UPDATE_LIB="/home/andrey/emanat/update/emanat_v5/lib/"
PATH_PROG_LIB= "/home/andrey/emanat/orig/emanat_v5/lib/"
PATH_UPDATE= "/home/andrey/emanat/update/"
PATH_PROG="/home/andrey/emanat/orig/"

ls $PATH_PROG_LIB > /home/andrey/do.txt
#Cоздаем список файлов и удаляем

ls=($(ls $PATH_UPDATE_LIB | cut -d '.' -f1 | sed 's/\-[0-9]*$//'))

	for i in ${ls[@]}; do
		rm -f ${PATH_PROG_LIB}${i*}

	done

#Загружаем обновление
rsync -avzh $PATH_UPDATE $PATH_PROG

ls $PATH_PROG_LIB  > /home/andrey/posle.txt

comm  /home/andrey/do.txt /home/andrey/posle.txt >  ${PATH_PROG_LIB}result-$date.log

rm -f /home/andrey/do.txt /home/andrey/posle.txt



