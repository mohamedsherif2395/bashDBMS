#! /bin/bash

. ./functions.sh
select main in 'Create Database' 'List Databases' 'Connect To Databases' 'Drop Database'
do
	case $main in
	'Create Database')
		fun1;;
	'List Databases')
		fun2;;
	'Connect To Databases')
		fun3;;
	'Drop Database')
		fun4;;
	*)
		echo "please choose from {1,2,3,4}"
	esac
done

