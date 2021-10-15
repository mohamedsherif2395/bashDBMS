#! /bin/bash
#this is a free software simulating a DBMS using shell scripting
 
function mainMenu {
clear
echo $'\n							 **Welcome to QuickBase**\n
			     a lightweight, simple and quick DBMS for simple CLI database management tasks\n
					       Authors: Mohamed Sherif & Micheal Adel
				     Find us on Github at:  @mohamedsherif2395 & @Micheal-adel98\n\n\n'

echo "Please choose an option: 
"
select main in 'Create Database' 'List Databases' 'Connect To Databases' 'Drop Database' 'Exit'
do
	case $main in
	'Create Database')
		echo ""
		createD;;
	'List Databases')
		echo ""
		listD;;
	'Connect To Databases')
		echo ""
		connectD;;
	'Drop Database')
		echo ""
		dropD;;
	'Exit')
		exitApp;;
	*)
		echo ""
		echo "Please choose from {1..4}"
	esac
done
}

function createD {

      echo "Please enter database name to create it: "
      read database
      if ! [[ -d ./quickbase/$database ]]
      then
	      mkdir -p ./quickbase/$database
	      echo "$database has been created"
	else
	      echo "the $database is already created"
	      echo "Do you want to connect it? [Y/N]"
	      read answer
	      case $answer in
			Y)
			connectD;;
			N)
			createD;;
			*)
			echo "Please enter correct answer" ;
			createD;;	
		esac
	fi
	sleep 3
	mainMenu
}
function listD {
	ls ./quickbase
	echo '' 
}
function connectD {

	echo "Please Enter database name to connect it: "
	read database
	if [[ -d ./quickbase/$database ]]
	then 
	       cd ./quickbase/$database 2> /dev/null
	       clear
	       echo $'\nConnected to '${database}$' , Please choose an option: \n' 
	       select action in 'Create Table' 'List Tables' 'Drop Table' 'Insert into Table' 'Select From Table' 'Delete From Table' 		'Update Table' 'Main Menu' 'Exit'
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
			'Main Menu')
				mainMenu;;
			'Exit')
				exitApp;;
			*)
				echo "Back to main menu? [Y/N]"
				read back
				if [[ $back == "Y" || $back == "y" || $back == "yes" ]]
				then
					mainMenu
				else
					echo $'\nUsage: select a database then choose an option from {1..7}'
					cd ../..
					sleep 4
					clear
					connectD
				fi
			esac
		done
	else 
		echo "no database with $database name"
		echo $'\nDo you want to create it? [Y/N]\n'
		read answer
		case $answer in
			Y)
			createD;;
			N)
			cd ..
			connectD;;
			*)
			echo "Incorect answer, Redirecting.." ;
			sleep 3
			mainMenu;;	
		esac
	fi	
}
function dropD {
	echo "Please Enter database name to delete: "
	read database
	if [[ -d ./quickbase/$database ]]
        then
	      rm -r ./quickbase/$database
	      echo "$database has been removed successfully"
	else 
	      echo "no database match this name!"
	      echo "do you want to list the database names? [Y/N]"
	      read answer
	      case $answer in
			Y)
			listD;;
			N)
			dropD;;
			*)
			echo "Please enter correct answer" ;
			dropD;;	
		esac
	fi	
	      
}
function createT {
	echo "Please enter table name to create it: "
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
echo "Please select table to delete it: "
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
echo "Please enter table name to insert data: "
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
	echo "insert done into $table"
}
function selectT {
echo "Please enter table name to select data: "
read table
if [[ -f $table ]]
then
	echo $'\n'
        awk '{if (NR==1) {for(i=1;i<=NF;i++){printf "    |    "$i}{print "    |"}}}' $table
        echo $'\nWould you like to print all records? [Y/N]'
        read printall
        if [[ $printall == "Y" || $printall == "y" || $printall == "yes" ]]
        then
        	echo $'\nWould you like to print a specific field? [Y/N]'
		read cut1
		if [[ $cut1 == "Y" || $cut1 == "y" || $cut1 == "yes" ]]
		then
			echo $'\nPlease specify field number: '
			read field1
			echo $'========================================================================='
			awk $'{print $0\n}' $table | cut -f$field1 -d" "

			echo $'========================================================================='
		else
			echo $'\n'
			echo $'========================================================================='
			column -t -s ' ' $table
			echo $'=========================================================================\n'	
		fi
        else
		echo $'\nPlease enter a search value to select record(s): '
		read value
		echo $'\nWould you like to print a specific field? [Y/N]'
		read cut
		if [[ $cut == "Y" || $cut == "y" || $cut == "yes" ]]
		then
			echo $'\nPlease specify field number: '
			read field
			echo $'========================================================================='
			awk -v pat=$value $'$0~pat{print $0\n}' $table | cut -f$field -d" "
			echo $'========================================================================='
		else
			echo $'========================================================================='
			awk -v pat=$value '$0~pat{print $0}' $table | column -t -s ' '
			echo $'========================================================================='	
		fi
		echo $'\nWould you like to make another query? [Y/N]'
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
		select back in 'Back to Main Menu' 'Connect to database' 'Exit'
		do
			case $back in
			'Back to Main Menu')
				echo ""
				mainMenu;;
			'Connect to database')
				echo ""
				connectD;;
			'Exit')
				echo ""
				exitApp;;
			esac
		done
	esac
fi
}
function deleteT {
echo "Please enter table name to delete it: "
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
echo "Please enter table name to update data: "
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
function exitApp {
	clear;
	echo $'\n\n\n\n\n\n\n
						================================
						| Thank you for using QuickBase |
						================================ '
	sleep 3
	clear
	exit
}
mainMenu
