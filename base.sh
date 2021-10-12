#! /bin/bash

#. ./functions.sh
select main in 'Create Database' 'List Databases' 'Connect To Databases' 'Drop Database'
do
	case $main in
	'Create Database')
		CreateDB;;
	'List Databases')
		ListDB;;
	'Connect To Databases')
		ConnectDB;;
	'Drop Database')
		DropDB;;
	*)
		echo "please choose from {1,2,3,4}"
	esac
done

function CreateDB ()
{
	echo "please Enter database name: "
	read database
	mkdir $database
	echo "$database has been created"
}
function ListDB ()
{
	ls */
}
function ConnectDB ()
{
	echo "please Enter database name to connect: "
	read database
	cd $database
	select action in 'Create Table' 'List Tables' 'Drop Table' 'Insert into Table' 'Select From Table' 'Delete From Table' 'Update Table'
	do
		case $action in
		'Create Table')
			echo 'please enter table name: '
			read
			touch $REPLY;;
		'List Tables')
			ls;;
		'Drop Table')
			echo 'please enter table name: '
			read
			rm $REPLY;; 
		'Insert into Table')
			echo 'please enter table name: '
			read
			gedit $REPLY;;
		'Select From Table')
			echo 'please enter table name: '
			read table
			echo 'please enter emp name: '
			read record
			cat $table | grep $record;;
		'Delete From Table')
			echo 'please enter table name: '
			read table
			echo 'please enter emp name: '
			read record
			echo "$record deleted from $table";;
		'Update Table')
			echo 'please enter table name: '
			read table
			echo "$table updated";;
		*)
			echo "please choose from {1,2,3,4,5,6,7}";;
		esac
done
	
}
function DropDB ()
{
	echo "DropDB is called"
}

