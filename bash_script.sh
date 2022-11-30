#!/bin/bash 

#touch check.txt

flag_d=0;

flag_k=0;

c_docker="docker"
c_kubectl="kubectl"

flag_t1610=0;


check_doc_prerequisite () {
#which docker > check.txt
# check_string= $(command -v docker) 
check_res=$(command -v docker)
#echo $ls
#if [$check_string =~ .*"$c_docker"*] ]; then
if [[ "$check_res" =~ .*"$c_docker".* ]]; then
 #echo "It's there."
  flag_d=1;
  echo "docker is present"  
else 
  echo "docker is not present"
fi
}


cleanup_func () {
docker stop $(docker ps -a -q)
docker rmi -f t1610
}

check_kub_prerequisite (){
check_res_kub=$(command -v kubectl)
#echo $check_res_kub
if [[ "$check_res_kub" =~ .*"kubectl".* ]]; then 
  flag_k=1;
  echo "kubectl is present"
else
  echo "kubectl is not present"
fi
}


t1610_attack (){
docker build -t t1610  /home/kali/bash_script/T1610/
docker run --name t1610_container --rm -itd t1610 bash /tmp/script.sh
docker exec -it t1610_container cat /tmp/output.txt > test_attack 

echo "Attack Performed \n"
}

t1610_check (){
t1610_grep=$(docker images | grep -i t1610)
t1610_grep_1=$(docker ps -a | grep t1610)
echo $t1610_grep_1
if [[ "$t1610_grep_1" =~ .*"_".* ]] ; then
  flag_t1610=1;
  echo "Exploitation Successfull"
else
  echo "Exploitation Unsuccessfull"
fi
}


echo "Welcome to Container Exploitation "

echo "Choose techstack "

echo "Press 1 for docker and 2 for kubernetes" 

read tech_input 
echo $tech_input

if [[ "$tech_input" = "1" ]]; then 
  echo "You have selected docker"
  echo "Checking docker prerequisite"
  check_doc_prerequisite
  if [[ "$flag_d" = "1" ]]; then 
    echo "Do you want to run test for vulnerabilites \n"
    echo "Enter true for yes & false for no \n"
    read vuln_input 
    if ("$vuln_input" == "true"); then
	t1610_attack 
	t1610_check
	echo "Do you want to run clean up function [Y|N]"
	read clean_input
	if [[ "$clean_input" == "Y" ]]; then
	  echo "Cleaning in Process"
	  cleanup_func
	  echo "Cleaning Completed"
	elif [[ "$clean_input" == "N" ]]  
	then
	  echo "Cleanup function not selected"
	else
	  echo "Wrong input selected"
	fi
    elif ("$vuln_input" == "false"); then
	echo "Exiting"
    else 
	echo "Wrong input"
    fi
  fi
elif [["$tech_input" = "2"]];
then 
  echo "you have selected kubernetes"
else
  echo "Wrong input"
fi
 
