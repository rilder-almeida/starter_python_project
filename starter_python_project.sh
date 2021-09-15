#/bin/bash

blue=$'\e[34m'
yellow=$'\e[33m'
green=$'\e[32m'
red=$'\e[31m'
white=$'\e[0m'


clear
echo "${yellow}Welcome to Starter Python Project${white}"
echo "${yellow}by Rilder Almeida - ${blue}https://www.linkedin.com/in/rilder-almeida/${white}"

installed() {
    return $(dpkg-query -W -f '${Status}\n' "${1}" 2>&1|awk '/ok installed/{print 0;exit}{print 1}')
}

pkgs=(python3-pip git virtualenv)
missing_pkgs=""

for pkg in ${pkgs[@]}; do
    if ! $(installed $pkg) ; then
        missing_pkgs+=" $pkg"
    fi
done

if [ ! -z "$missing_pkgs" ]; then	
	while true; do
    read -p "${red}Missing package: $missing_pkgs, confirm to install (y/n)${white}" yn
    case $yn in
        [Yy]* ) sudo apt install $missing_pkgs && echo "${green}Installed${white}"; break || ( echo "${red}Failed${white}!" && echo "${red}Exiting${white}" && exit; );;
        [Nn]* ) exit;;
        * ) echo "${red}Please answer yes or no.${white}";;
    esac
	done
fi

read -p "${yellow}Insert a name for your new python project: ${white}" project

if [ -z "$project" ] || [ "$project" = "" ] || [ "$project" = " " ];
	then echo "${red}Project name must be not null or space${white}"; echo "${red}Exiting${white}"; exit;
elif [ -d "$project" ]; then
	echo "${red}Directory already exist.${white}"; echo "${red}Exiting${white}"; exit;
elif [ -d "starter_python_project" ]; then
	echo "${red}starter_python_project repository already exist.${white}"; echo "${red}Exiting${white}"; exit;
else
	git clone https://github.com/rilder-almeida/starter_python_project.git || { echo "${red}Failed${white}!"; rm -rf starter_python_project; echo "${red}Exiting${white}"; exit 1; }
	
	echo "${yellow}Creating project's folder${white}"
	mv starter_python_project "$project" && echo "${green}Done!${white}" || { echo "${red}Failed${white}!"; rm -rf starter_python_project; echo "${red}Exiting${white}"; exit 1; }
	
	echo "${yellow}Cleaning the repository${white}"
	cd "$project" && rm -rf .git && rm -rf README.md && rm -rf starter_python_project.sh && echo "${green}Done!${white}" || { cd ..; rm -rf "$project"; echo "${red}Exiting${white}"; exit 1; }
	
	echo "${yellow}Setting README.MD${white}"
	mv readme_template.md README.MD && echo "${green}Done!${white}" || { cd ..; rm -rf "$project"; echo "${red}Exiting${white}"; exit 1; }
	
	echo "${yellow}Initiating git, adding and commiting the repository${white}"
	git init && git add . && git commit -m "Initial configs" && echo "${green}Done!${white}" || { cd ..; rm -rf "$project"; echo "${red}Exiting${white}"; exit 1; }
	
	echo "${yellow}Initiating Virtual Environment and installing all requirements${white}"
	virtualenv -p python3 venv && . venv/bin/activate && sed -i 's/==/>=/g' requirements.txt && venv/bin/pip3 install -r requirements.txt --upgrade && pre-commit install && echo "${green}Done!${white}" || { cd ..; rm -rf "$project"; echo "${red}Exiting${white}"; exit 1; }
fi

echo "${green}All Successful!${white}"
echo "${green}Remember to associate the created virtual environment to project's interpreter!${white}"
echo "${yellow}Leave a star -> https://github.com/rilder-almeida/starter_python_project.git${white}"
