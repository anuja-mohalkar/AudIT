#!/bin/bash
VERSION="2"
temp_line_count=1
echo "--------------------------------------------"

echo "ONLINE APPLICATION INSTALLATION ALERT UTILITY"

# While loop will run infinite, to moniter the application installation change 

while true

do

  # Check number of lines, if changed the last Install word will be captured 

  line_count=$(wc -l < /var/log/apt/history.log)
   
  # Check if lines in history.log has Install word  

  install_word_found=$(tail -n5  /var/log/apt/history.log | grep -oP ' install ')

  # Check if lines in history.log has Remove word  
  remove_word_found=$(tail -n5  /var/log/apt/history.log | grep -oP ' remove ')

  # Check if lines in history.log has Purge word  
  purge_word_found=$(tail -n5  /var/log/apt/history.log | grep -oP ' purge ')

  # Line difference is required as some lines are added while installing/removing

  line_diff=$(expr $line_count - $temp_line_count)
  

# If history file is changed, i.e. number of lines are changed  

  if [ $temp_line_count -ne $line_count ] && [ "$install_word_found" == " install " ] && [ $line_diff -ge 5 ]

  then

    # Extract application name which is in front of Install word 

    application_name=$(tail -n2  /var/log/apt/history.log | grep -oP 'Install: \K[^ ]+')
   
    date_and_time=$(tail -n5 /var/log/apt/history.log | grep -oP '(?<=Start-Date: ).*')
    
    Operating_System=$(hostnamectl | grep -oP '(?<=Operating System: ).*')
    
    # Print detailed message for notification 

    echo "--------------------------------------------"

    echo "OS_Type               : $Operating_System"

    echo "Date_And_Time         : $date_and_time"

    echo "Endpoint_Name         : $(hostname)"

    echo "User_Name             : $(whoami)"

    echo "Software_Name         : $application_name"
    
    echo "Activity              : installed"

    JSON_Output='{"OS_Type":"'$Operating_System'","Date_And_Time":"'$date_and_time'","Endpoint_Name":"'$(hostname)'","User_Name":"'$(whoami)'","Software_Name":"'$application_name'","Activity":"installed"}' 
 

   # echo "$JSON_Output" | jq '.'
    
#    curl -s --request POST -H "Content-Type:application/json" https://633fac78d1fcddf69ca74255.mockapi.io/Installed_Software_Details  --data "${JSON_Output}"
   
    # Make temporary variable equal to number of lines to run this extraction once 

    temp_line_count=$line_count

  fi 

  if [ $temp_line_count -ne $line_count ] && [ "$remove_word_found" == " remove " ] && [ $line_diff -ge 6 ]
  then

    # Extract application name which is in front of Remove word

    application_name=$(tail -n2  /var/log/apt/history.log | grep -oP 'Remove: \K[^ ]+')

    date_and_time=$(tail -n5 /var/log/apt/history.log | grep -oP '(?<=Start-Date: ).*')

    Operating_System=$(hostnamectl | grep -oP '(?<=Operating System: ).*')
    
    # Print detailed message for notification

    echo "--------------------------------------------"

    echo "OS_Type               : $Operating_System"

    echo "Date_And_Time         : $date_and_time"

    echo "Endpoint_Name         : $(hostname)"

    echo "User_Name             : $(whoami)"

    echo "Software_Name         : $application_name"
    
    echo "Activity              : remove"

 
    JSON_Output='{"OS_Type":"'$Operating_System'","Date_And_Time":"'$date_and_time'","Endpoint_Name":"'$(hostname)'","User_Name":"'$(whoami)'","Software_Name":"'$application_name'","Activity":"remove"}'
 
    # echo "$JSON_Output" | jq '.'
     
#     curl -s --request POST -H "Content-Type:application/json" https://633fac78d1fcddf69ca74255.mockapi.io/Installed_Software_Details  --data "${JSON_Output}"
   

    # Make temporary variable equal to number of lines to run this extraction once

    temp_line_count=$line_count

  fi

  if [ $temp_line_count -ne $line_count ] && [ "$purge_word_found" == "Purge:" ] && [ $line_diff -ge 6 ]
  then

    # Extract application name which is in front of Purge word

    application_name=$(tail -n2  /var/log/apt/history.log | grep -oP 'Purge: \K[^ ]+')

    date_and_time=$(tail -n5 /var/log/apt/history.log | grep -oP '(?<=Start-Date: ).*')

    Operating_System=$(hostnamectl | grep -oP '(?<=Operating System: ).*')
    
    # Print detailed message for notification

    echo "--------------------------------------------"

    echo "OS_Type               : $Operating_System"

    echo "Date_And_Time         : $date_and_time"

    echo "Endpoint_Name         : $(hostname)"

    echo "User_Name             : $(whoami)"

    echo "Software_Name         : $application_name"

    echo "Activity              : purge"
 
    
    JSON_Output='{"OS_Type":"'$Operating_System'","Date_And_Time":"'$date_and_time'","Endpoint_Name":"'$(hostname)'","User_Name":"'$(whoami)'","Software_Name":"'$application_name'","Activity":"purge"}'
 
    # echo "$JSON_Output" | jq '.'
     
 #    curl -s --request POST -H "Content-Type:application/json" https://633fac78d1fcddf69ca74255.mockapi.io/Installed_Software_Details  --data "${JSON_Output}"
   


    # Make temporary variable equal to number of lines to run this extraction once

    temp_line_count=$line_count

  fi
done
