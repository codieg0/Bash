#!/bin/bash

###########################
# Created by Diego Castro #
#     and Ryan Curran     #
###########################

<<'Tip'

Tip: instead of running the script like this: ./swaks..., you can do the following

Instead of running the script like this: ./swaks..., you can do the following:

1. vi ~/.bashrc
2. Add this line at the bottom: alias swaks='~/./swaks-core-lab1.sh' <- The directory changes depending on the folder you are saving the script.
3. Save changes - :x
4. source ~/.bashrc

Tip

# This script will just use the server to get the email in the lab for CORE - lab1

# You need to add your private IP
server= # Sender IP address - lab core-pps01

#You would need to add the field below
ehlo=

at="--attach"

read -p "Recipient: " recipient

read -p "Any attachments [Y/n]: " name

        if [[ ${name} == "y" ]]
        then
                read -p "Attachment location [Documents | Downloads | etc]: " location

                        if [[ ${location} == "Documents" ]]
                        then
                                read -p "Name of the file: " fileDocument
			    	docLoc="/mnt/c/Users/$USER/Documents/"
                                fileDoc=${docLoc}${fileDocument}
                                swaks -t ${recipient} -s ${server} -h ${ehlo} ${at} ${fileDoc}

                        elif [[ ${location} == "Downloads" ]]
                        then
                                read -p "Name of the file: " fileDownloads
				downLoc="/mnt/c/Users/$USER/Downloads/"
                                fileDown=${downLoc}${fileDownloads}
                                swaks -t ${recipient} -s ${server} -h ${ehlo} ${at} ${fileDown}

                        else
                                read -p "Location of the file: " fileDir
                                read -p "Name of the file: " fileName
                                otherLoc="/mnt/c/Users/$USER/"
				slash="/"
                                fileElse="${otherLoc}${fileDir}${slash}${fileName}"
                                swaks -t ${recipient} -s ${server} -h ${ehlo} ${at} ${fileElse}
                        fi

        elif [[ ${name} == "n" ]]
        then
                swaks -t ${recipient} -s ${server} -h ${ehlo}

        else
                echo "Error. Closing the program now."
                exit 1
        fi
