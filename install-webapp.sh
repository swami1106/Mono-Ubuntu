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
#----- STEP 1
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