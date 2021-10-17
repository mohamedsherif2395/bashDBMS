#! /bin/bash
#this is a free software simulating a DBMS using shell scripting
 
function mainMenu {
clear
echo $'\n							 **Welcome to QuickBase**\n
			     a lightweight, simple and quick DBMS for simple CLI database management tasks\n
					       Authors: Mohamed Sherif & Micheal Adel
				     Find us on Github at:  @mohamedsherif2395 & @Micheal-adel98\n\n\n'

echo $'Please choose an option: \n'
select main in 'Create Database' 'List Databases' 'Connect To Databases' 'Drop Database' 'Exit'
do
	case $main in
	'Create Database')
		echo $'\n'
		createD;;
	'List Databases')
		echo $'\n'
		listD;;
	'Connect To Databases')
		echo $'\n'
		connectD;;
	'Drop Database')
		echo $'\n'
		dropD;;
	'Exit')
		exitApp;;
	*)
		echo $'\n'
		echo "Please choose from {1..5}"
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
	      echo "Do you want to connect it? [y/n]"
	      read answer
	      case $answer in
			y)
			connectD;;
			n)
			createD;;
			*)
			echo "Incorect answer, Redirecting to main menu.." ;
			sleep 2;
			mainMenu;;	
		esac
	fi
	sleep 2
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
				cd ../..
				mainMenu;;
			'Exit')
				exitApp;;
			*)
				echo "Incorect answer, Redirecting to main menu.." ;
				cd ../..;
				sleep 2;
				mainMenu;;
			esac
		done
	else 
		echo "no database with $database name"
		echo $'\nDo you want to create it? [y/n]\n'
		read answer
		case $answer in
			y)
			createD;;
			n)
			connectD;;
			*)
			echo "Incorect answer, Redirecting to main menu.." ;
			sleep 2
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
	      echo "do you want to list the database names? [y/n]"
	      read answer
	      case $answer in
			y)
			listD;;
			n)
			dropD;;
			*)
			echo "Incorrect answer. Redirecting to main menu.." ;
			sleep 2;
			mainMenu;;	
		esac
	fi	
	      
}
function createT {
	echo "Please enter table name to create it: "
	read table
	if [[ -f $table ]]
	then 
		echo "table already exists!"
		cd ../..
		connectD
	else
		touch $table
		echo "table created succesfully!"
	fi
	
	echo "Please enter Number of fields: "
	read fields
	num='^[0-9]+$'
	if  [[ $fields =~ $num ]]
	then 
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
		cd ../..
		connectD
	else
		echo "$fields is not a number"
		sleep 2
		createT
	fi	
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
	echo "$drop is deleted!"	
else
	echo "Table was not found"
	dropT
fi
}
function insertT {
echo "Please enter table name to insert data: "
read table
if [[ -f $table ]]
	then
	           
	        x=`grep 'PK' $table | wc -w`
	        
	        awk '{if (NR==1) {for(i=1;i<=NF;i++){printf "    |    "$i}{print "    |"}}}' $table
	        for((i=1;i <= x;i++)) 
	        do      
	        	columnName=`grep PK $table | cut -f$i -d" "`
	        	echo $'\n'
	        	echo $"Please enter data for field no.$i [$columnName]"
	        	read data 
			checkType $i $data
	        	if [[ $? != 0 ]]
	        	then
	        		(( i = $i - 1 ))
	        	else	
	        		echo -n $data" " >> $table
			fi
	        done	
	        echo $'\n' >> $table
		echo "insert done into $table"
	else
		echo "Table doesn't exist"
		echo "Do you want to create it? [y/n]"
		read answer
		case $answer in
			y)
			createT;;
			n)
			insertT;;
			*)
			echo "Incorrect answer. Redirecting to main menu.." ;
			sleep 2;
			cd ../..;
			mainMenu;;	
		esac
        
	fi
}
function selectT {
echo "Please enter table name to select data: "
read table
if [[ -f $table ]]
then
	echo $'\n'
        awk '{if (NR==1) {for(i=1;i<=NF;i++){printf "    |    "$i}{print "    |"}}}' $table
        echo $'\nWould you like to print all records? [y/n]'
        read printall
        if [[ $printall == "Y" || $printall == "y" || $printall == "yes" ]]
        then
        	echo $'\nWould you like to print a specific field? [y/n]'
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
		echo $'\nWould you like to print a specific field? [y/n]'
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
	fi
	echo $'\nWould you like to make another query? [y/n]'
	read answer
	if [[ $answer == "Y" || $answer == "y" || $answer == "yes" ]]
	then
		clear
		selectT
	elif [[ $answer == "N" || $answer == "n" || $answer == "no" ]]
	then	
		clear
		cd ../..
		connectD
	else
		echo "Redirecting to main menu.."
		cd ../..
		sleep 2
		mainMenu
	fi
else
	echo "Table doesn't exist"
	echo "Do you want to create it? [y/n]"
	read answer
	case $answer in
		y)
		createT;;
		n)
		selectT;;
		*)
		echo "Incorrect answer. Redirecting to main menu.." ;
		sleep 2;
		cd ../..;
		mainMenu;;
	esac
fi
}
function deleteT {
echo "Please enter table name to delete from: "
read table
if [[ -f $table ]]
then
	echo $'\n'
	awk '{if (NR==1) {for(i=1;i<=NF;i++){printf "    |    "$i}{print "    |"}}}' $table
	echo $'\n'
	echo "Please enter field number to find value: "
	read field
	echo $'\n'
	echo "Please enter field value to delete record(s): "
	read value
	echo $'\n'
	if cut -f$field -d" " $table | grep -w -q ${value} 
	then
		gawk -v gValue=$value -v gField=$field -i inplace '{ gsub(gValue, "deleteThis", $gField) }; { print }' $table
		sed -i '/deleteThis/d' $table
		echo $'Record(s) deleted successfully!\n'
	else
		echo $'No such entry in that column!\n'
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
		echo "Incorrect answer. Redirecting to main menu.." ;
		sleep 2;
		cd ../..;
		mainMenu;;			
	esac
	fi
}

function updateT {
echo "Please enter table name to update data: "
read table
if [[ -f $table ]]
then
	echo $'\n'
	awk '{if (NR==1) {for(i=1;i<=NF;i++){printf "    |    "$i}{print "    |"}}}' $table
	echo $'\n'
	echo "Please enter field number to update: "
	read fieldnum
	fields=`awk '{print NF}' $table | head -1`
	if [[ $fieldnum -gt $fields || $fieldnum -lt 1 ]]
	then
		echo "Incorrect field number. Redirecting.."
		sleep 2
		updateT
	else
		echo "Please enter old value: "
		read old
		echo ""
		if grep "${old}" $table >> /dev/null
		then
			echo "Please enter new value: "
			read new
			checkType $fieldnum $new
			if [[ $? != 0 ]]
				then
					echo "Incorrect data type entry. Redirecting.."
					sleep 2
					updateT
				else	
					 gawk -v oldval=$old -v newval=$new -v colnum=$fieldnum -i inplace '{ gsub(oldval, newval, $colnum) }; { print }' $table
					echo $'Record(s) updated successfully!'
				fi
		else
			echo $'No such value in the table!'
			updateT
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
		updateT;;
		*)
		echo "Incorrect answer. Redirecting to main menu.." ;
		sleep 2;
		cd ../..;
		mainMenu;;			
	esac
	fi
}
function checkType {
datatype=`grep PK $table | cut -f$1 -d" "`
if [[ "$datatype" == *"int"* ]]
then
	num='^[0-9]+$'
	if ! [[ $2 =~ $num ]]
	then
		echo "False input: Not a number!"
		return 1
	else
		checkPK $1 $2
	fi
elif [[ "$datatype" == *"string"* ]]
then
	str='^[a-zA-Z]+$'
	if ! [[ $2 =~ $str ]]
	then
		echo "False input: Not a valid string!"
		return 1
	else
		checkPK $1 $2
	fi
fi
}
function checkPK {
header=`grep PK $table | cut -f$1 -d" "`
if [[ "$header" == *"PK"* ]]; then if [[ `cut -f$1 -d" " $table | grep -w $2` ]]
then
	echo $'\nPrimary Key already exists. no duplicates allowed!' 
	return 1
fi
fi
}
function exitApp {
	clear;
	echo $'\n\n\n\n\n\n\n
						================================
						| Thank you for using QuickBase |
						================================ '
	sleep 2
	clear
	exit
}
mainMenu
