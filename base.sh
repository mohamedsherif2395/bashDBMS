#! /bin/bash
#this is a free software simulating a DBMS using shell scripting
 
function mainMenu {
clear
echo "							Welcome to QuickBase
	
			     a lightweight, simple and quick DBMS for simple CLI database management tasks
				
					       Authors: Mohamed Sherif & Micheal Adel
				     Find us on Github at:  @mohamedsherif2395 & @Micheal-adel98
				
				"

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
		echo "Please choose from {1..4}"
	esac
done
}

function createD {
	echo "Please enter database name: "
	read database
	mkdir -p ./quickbase/$database
	echo "$database has been created"
}
function listD {
	ls ./quickbase 
}
function connectD {

	echo "Please Enter database name: "
	read database
	cd ./quickbase/$database 2> /dev/null
	select action in 'Create Table' 'List Tables' 'Drop Table' 'Insert into Table' 'Select From Table' 'Delete From Table' 'Update Table'
	do
		case $action in
		'Create Table')
			createT;;
		'List Tables')
			listT;;
		'Drop Table')
			dropT;;
		'Insert into Table')
			insertT;;
		'Select From Table')
			selectT;;
		'Delete From Table')
			deleteT;;
		'Update Table')
			updateT;;
		*)
			echo "Back to main menu? [Y/N]"
			read back
			if [[ $back == "Y" || $back == "y" || $back == "yes" ]]
			then
				mainMenu
			else
				echo "Usage: select a database then choose an option from {1..7}"
				sleep 4
				clear
				connectD
			fi
		esac
done	
}
function dropD {
	echo "Please Enter database name: "
	read database
	rm -r ./quickbase/$database
	echo "$database has been removed successfully"
}
function createT {
	echo "Please enter table name: "
	read table
	if [[ -f $table ]]
	then 
		echo "table already exists!"
		connectD
	else
		touch $table
		echo "table created succesfully!"
	fi
	
	echo "Please enter Number of fields: "
	read fields
#	if  [[ $fields =~ '[0-9]' ]]
#	then 
		flag="true"
		for (( i=1; i<=$fields; i++ ))
		do
			echo "Please enter name for filed no.$i: "
			read colname
			while [ $flag == "true" ]
			do
				echo "Is this a PK? [Y/N]"
				read pk
				if [[ $pk == "Y" || $pk == "y" || $pk == "yes" ]]
				then
					flag="false"
					echo -n "(PK)" >> $table
				else
					break
				fi
			done
			echo "Choose data type from (int , string)"
			read datatype
			case $datatype in
				int)
				echo -n $colname"($datatype) " >> $table;;
				string)
				echo -n $colname"($datatype) " >> $table;;
				*)
				echo "Data type incorrect!";
				(( i = $i - 1 ));;
				
			esac
		done
		clear
		echo "Your table $table created"
		connectD
#	else
#		echo "$fields is not a number"
#	fi	
}
function listT {
	ls
}
function dropT {
echo "Please select table: "
read drop
if [[ -f $drop ]]
	then 
	rm $drop
	echo "$drop deleted!"	
	else
	echo "Table not found"
	dropT
	fi
}
function insertT {
echo "Please select table: "
read table
if [[ -f $table ]]
	then 
	        x=`grep 'PK' $table | wc -w`
	        echo " " >> $table
	        awk '{if (NR==1) print $0}' $table
	        for((i=1;i <= x;i++)) 
	        do            
	        	echo "Please enter data for field no. $i"
	        	read data 
	        	echo -n $data" " >> $table
	        done	
	else
		echo "Table doesn't exist"
		echo "Do you want to create it? [Y/N]"
		read answer
		case $answer in
			Y)
			createT;;
			N)
			insertT;;
			*)
			echo "Please enter correct answer" ;
			insertT;;	
		esac
	fi
}
function selectT {
echo "Please select table: "
read table
if [[ -f $table ]]
	then
		echo ""
	        awk '{if (NR==1) {for(i=1;i<=NF;i++){printf "    |    "$i}{print "    |"}}}' $table
	        echo ""
	        echo "Please enter field value to select record(s): "
	        read field
	        echo ""
	        awk -v pat=$field '$0~pat{for(i=1;i<=NF;i++){printf "    |    "$i}{print "    |"}}' $table	
	        echo "Do you want to make another query? [Y/N]"
	        read answer
	        if [[ $answer == "Y" || $answer == "y" || $answer == "yes" ]]
		then
			clear
			selectT
		else
			echo "Returning to main menu.."
			sleep 3
			mainMenu
		fi
	else
		echo "Table doesn't exist"
		echo "Do you want to create it? [Y/N]"
		read answer
		case $answer in
				Y)
				createT;;
				N)
				selectT;;
				*)
				echo "Incorrect answer" ;
				selectT;;
				
				
			esac
	fi
}
function deleteT {
echo "Please select table: "
read table
if [[ -f $table ]]
then
	echo ""
	awk '{if (NR==1) {for(i=1;i<=NF;i++){printf "    |    "$i}{print "    |"}}}' $table
	echo ""
	echo "Please enter field value to delete record(s): "
	read field
	echo ""
	if grep -q ${field} $table 
	then
		sed -i /"${field}/"d $table
		echo "Record(s) deleted successfully!
		"
	else
		echo "No such entry in the table!
		"
		deleteT
	fi
else
	echo "Table doesn't exist"
	echo "Do you want to create it? [Y/N]"
	read answer
	case $answer in
		Y)
		createT;;
		N)
		deleteT;;
		*)
		echo "Incorrect answer" ;
		deleteT;;			
	esac
	fi
}

function updateT {
echo "Please select table: "
read table
if [[ -f $table ]]
then
	echo ""
	awk '{if (NR==1) {for(i=1;i<=NF;i++){printf "    |    "$i}{print "    |"}}}' $table
	echo ""
	echo "Please enter field value to update: "
	read old
	echo ""
	if grep -q ${old} $table 
	then
		echo "Please enter new value: "
		read new
		sed -i s/$old/$new/g $table
		echo "Record(s) updated successfully!
		"
	else
		echo "No such value in the table!
		"
		updateT
	fi
else
	echo "Table doesn't exist"
	echo "Do you want to create it? [Y/N]"
	read answer
	case $answer in
		Y)
		createT;;
		N)
		updateT;;
		*)
		echo "Incorrect answer" ;
		updateT;;			
	esac
	fi
}
mainMenu
