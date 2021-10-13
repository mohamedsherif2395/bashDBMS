#! /bin/bash
#this is a free software simulating a DBMS using shell scripting
 
clear
echo "							Welcome to QuickBase
	
			     a lightweight, simple and quick DBMS for simple CLI database management tasks
				
					       Authors: Mohamed Sherif & Micheal Adel
				     Find us on Github at:  @mohamedsherif2395 & @Micheal-adel98
				
				"

function mainMenu {
select main in 'Create Database' 'List Databases' 'Connect To Databases' 'Drop Database'
do
	case $main in
	'Create Database')
		createD;;
	'List Databases')
		listD;;
	'Connect To Databases')
		connectD;;
	'Drop Database')
		dropD;;
	*)
		echo "please choose from {1..4}"
	esac
done
}

function createD {
	echo "please Enter database name: "
	read database
	mkdir -p ./quickbase/$database
	echo "$database has been created"
}
function listD {
	ls ./quickbase 
}
function connectD {
	echo "please Enter database name to connect: "
	read database
	cd ./quickbase/$database
	select action in 'Create Table' 'List Tables' 'Drop Table' 'Insert into Table' 'Select From Table' 'Delete From Table' 'Update Table'
	do
		case $action in
		'Create Table')
			createT;;
#			echo 'please enter table name: '
#			read
#			touch $REPLY;;
		'List Tables')
			listT;;
#			ls;;
		'Drop Table')
			dropT;;
#			echo 'please enter table name: '
#			read
#			rm $REPLY;; 
		'Insert into Table')
			insertT;;
#			echo 'please enter table name: '
#			read
#			gedit $REPLY;;
		'Select From Table')
			selectT;;
#			echo 'please enter table name: '
#			read table
#			echo 'please enter emp name: '
#			read record
#			cat $table | grep $record;;
		'Delete From Table')
			deleteT;;
#			echo 'please enter table name: '
#			read table
#			echo 'please enter emp name: '
#			read record
#			echo "$record deleted from $table";;
		'Update Table')
			updateT;;
#			echo 'please enter table name: '
#			read table
#			echo "$table updated";;
		*)
			echo "please choose from {1..7}";;
		esac
done
	
}
function dropD {
	echo "please Enter database name: "
	read database
	rm -r ./quickbase/$database
	echo "$database has been removed successfully"
}

function createT {
echo "table func"
}

function listT {
echo "table func"
}

function dropT {
echo "table func"
}

function insertT {
echo "table func"
}

function selectT {
echo "table func"
}

function deleteT {
echo "table func"
}

function updateT {
echo "table func"
}
mainMenu
