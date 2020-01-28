#! /bin/sh
######################################################
# This script is provided as is, use at your own risk
#
# For more information about issues, suggestions, 
# please refer to: https://github.com/edgarrc/MonoUbuntu
#
# You can download a Hello World application to test your installation from:
#
# https://github.com/edgarrc/MonoUbuntu/releases/download/hello/hello.zip
#
# Edgar
######################################################

#Helper function to ask for confirmation
askcs ()  {
  echo  -n " - Yes or No? (y/n) :"
  read resp

  while [ "1" = "1" ]
  do
    if [ "$resp" = '' ];
    then
      resp="y"
      break
    else
      case $resp in
        y | Y ) 
           resp="y";
           break;;
        n | N ) 
		   resp="n";
	       break;;
        *)
           echo -n 'Wrong answer, type again:';
           read resp;
	   continue;;
       esac
    fi
  done
}

#----- START

echo ""
echo "##INF: ----------------------------------------------"
echo "##INF: Mono/apache - Ubuntu install"
echo "##INF:"
echo "##INF: - Must be executed as root (sudo)"
echo "##INF:"
echo -n "##INF: PRESS ENTER TO PROCEED <ENTER>"
read d

#----- STEP 1

echo ""
echo "##INF:[02/03] Installing MONO/Mod-mono"

	#Add the last official repository
	sudo apt install gnupg ca-certificates
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
	echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list

	sudo apt-get update
	sudo apt-get -y install mono-complete
	sudo apt-get -y install mono-xsp4
	sudo apt-get -y install libapache2-mod-mono
	#apt-get -y install mono-apache-server2

#----- STEP 2

echo ""
echo "##INF:[01/03] Installing apache"

	sudo apt-get -y update
	#apt-get -y install wget
	sudo apt-get -y install apache2

	#Disable apache KeepAlive as recomended by mono-project for production use
	sudo find /etc/apache2/ -name apache2.conf -type f -exec sed -i s/"KeepAlive On"/"KeepAlive Off"/g {} \;
	
	sudo /etc/init.d/apache2 restart


#----- STEP 3
echo ""
echo "##INF:[03/03] Configuring ASP.NET application"

	#Ask for application name
	echo -n " Enter the name of your ASP.NET application : "
	sudo read appnameInput

	#Get some templates used for replacement on config files
	sudo wget https://raw.githubusercontent.com/edgarrc/MonoUbuntu/master/template-insert-sites.txt
	#wget https://raw.githubusercontent.com/edgarrc/MonoUbuntu/master/template-insert-webapp.txt

	#Update template variables	
	sudo find ./ -name template-insert-sites.txt -type f -exec sed -i s/"%APPNAME%"/"$appnameInput"/g {} \;
	#find ./ -name template-insert-webapp.txt -type f -exec sed -i s/"%APPNAME%"/"$appnameInput"/g {} \;
	
	#Apply to apache default website configuration
	sudo sed -i '/<VirtualHost/r template-insert-sites.txt' /etc/apache2/sites-enabled/000-default.conf

	#Apply to default.webapp	
	#sed -i '/<apps>/r template-insert-webapp.txt' /etc/mono-server4/debian.webapp
	
	#Remove templates
	sudo rm template-insert-sites.txt
	sudo rm template-insert-webapp.txt 
	 
	#Create directory for application
	sudo mkdir -p /var/www/html/$appnameInput
	sudo chown -R www-data:www-data /var/www

#----- DONE

	#Get the ip address
	IP=`ifconfig  | grep 'inet end.:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}'`;	
	if [ "$IP" = "" ]; then IP="127.0.0.1"; fi

	sudo /etc/init.d/apache2 restart
	
echo ""
echo "##INF: Installation completed!"
echo "##INF:"
echo "##INF: Publish your application to:"
echo "##INF:   /var/www/html/$appnameInput "
echo "##INF:"
echo "##INF: Application address:"
echo "##INF:"
echo "##INF:   http://$IP/$appnameInput "
echo "##INF:"
echo "##INF: Note1: If you have any error, try to restart apache again:"
echo "##INF: /etc/init.d/apache2 restart "
echo "##INF:"
echo "##INF: Note2: You can download a Hello World application to test your installation from:"
echo "##INF: https://github.com/edgarrc/MonoUbuntu/releases/download/hello/hello.zip "
echo ""