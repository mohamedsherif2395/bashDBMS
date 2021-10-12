#! /bin/bash

function fun1 ()
{
	echo "please Enter database name: "
	read database
	mkdir $database
	echo "$database has been created"
}
function fun2 ()
{
	ls */
}
function fun3 ()
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
function fun4 ()
{
	echo "fun4 is called"
}

