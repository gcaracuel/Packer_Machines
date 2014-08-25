# Packer + Vagrant collection 

* With packer you could create a base vagrant box and then just get it up with Vagrant on Virtualbox or VMware!*

---

###Linux
 - Install Virtualbox
   Just download from [here](https://www.virtualbox.org/wiki/Downloads)

 - Install Vagrant
   Download and install from [here](http://www.vagrantup.com/downloads.html)

 - Install Packer
   Download and unzip [Packer](http://www.packer.io/downloads.html)

  Let's make Packer to work! Move to folder you downloaded this project and start

    ```packer build -force packer_{system OS}.json``` or use ```packer build --only=virtualbox-iso  packer_{system OS}.json```
    
  Packer will start to build a MV and then will export it to convert it to a Vagrant box, take seat....
  
  You could modify bash script in 'scripts' folder to install/configure your template Vagrant box.
  
  When Packer job finish you could find a "{system OS}.box" inside the packer_output folder so move to the desired OS vagrant dir and get it up! Feel free of copy this folder where you are more confortable.
  
  Then just ```vagrant up```  it and you could connect trough SSH: ```ssh vagrant@localhost:2222``` / ```vagrant ssh``` for Linux guests or ```vagrant rdp``` for Windows guests
  
  #####Other vagrant commands: 
       
  ```vagrant destroy``` and  ```vagrant reload```
  
  ```vagrant halt``` ,```vagrant suspend ``` and ```vagrant resume```
  
  ```vagrant ssh```, ```vagrant rdp```, etc  


---


###Windows
 - Install Virtualbox
   Just download from [here](https://www.virtualbox.org/wiki/Downloads)

 - Install Vagrant
   Download and install from [here](http://www.vagrantup.com/downloads.html)

 - Install Packer
   Download and unzip [Packer](http://www.packer.io/downloads.html) in a folder of your choose and add it to your PATH executing:

    ```setx PATH "%PATH%;<path where you unzipped Packer>"```

  Let's make Packer to work! Move to folder you downloaded this project and start

    ```packer.exe build -force packer_{system OS}.json``` or use ```packer.exe build --only=virtualbox-iso  packer_{system OS}.json```
    
  Packer will start to build a MV and then will export it to convert it to a Vagrant box, take seat....
  
  You could tune bash script in 'scripts' folder to install/configure your template Vagrant box.
   
  When Packer job finish you could find a "{system OS}.box" inside the packer_output folder so move to the desired OS vagrant dir and get it up! Feel free of copy this folder where you are more confortable.
  
  Then just ```vagrant up```  it and you could connect trough SSH: ```ssh vagrant@localhost:2222``` / ```vagrant ssh``` for Linux guests or ```vagrant rdp``` for Windows guests
  
  #####Other vagrant commands: 
       
  ```vagrant destroy``` and  ```vagrant reload```
  
  ```vagrant halt``` ,```vagrant suspend ``` and ```vagrant resume```
  
  ```vagrant ssh```, ```vagrant rdp```, etc  


---

OK, so you need multiple VMs? No problem, just clone the vagrant/{OS} dir, change the port forwarding to avoid used ports a vagrant up another instance!

---


###### Note: Username: vagrant  Password: vagrant

###### Note2: Modify Autounattend.xml to configure Windows updates before you create your box.

###### Note3: Vagrantfile are configured for Virtualbox Boxes, change it to desired

###### Bug 1: Centos7 image uses "Base" packages group untill Vagrant stop using 'ipconfig' and 'service' command to configure network interfaces. [This ticket] is not solving the problem (https://github.com/mitchellh/vagrant/pull/4195)
  


