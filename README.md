# README

* http://railsinstaller.org/en  Windows Ruby 2.3

* created with cmd rails new

* Deployment instructions 
1. run: rake db:migrate
2. download https://www.dane.gov.pl/media/resources/20150630/Jednostki-organizacyjne-PSP2015.xls
and move to source folder  
IMPORTANT in this moment this script is not optimized so import can use all of the API limits.
To test purposes reduce in file numbers of rows to dozens of.  
3. run: rake importdb:import 

* known bugs
1. status 500 if misspelling like Bielsko-Białaa (for Bielsko-Biała works correctly)

 
