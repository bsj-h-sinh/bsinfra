install_java()
{
    sudo yum update -y
    sudo yum -y install wget
    sudo yum -y install java-1.8.0-openjdk.x86_64 java-1.8.0-openjdk-devel.x86_64
    java -version   
}

install_jmeter()
{
    wget https://ftp.tsukuba.wide.ad.jp/software/apache//jmeter/binaries/apache-jmeter-5.3.tgz
    tar xvzf apache-jmeter-5.3.tgz
    mv  apache-jmeter-5.3 ~/jmeter
    wget http://search.maven.org/remotecontent?filepath=kg/apc/cmdrunner/2.2/cmdrunner-2.2.jar -O ~/jmeter/lib/cmdrunner-2.2.jar
    wget http://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-manager/1.3/jmeter-plugins-manager-1.3.jar -O ~/jmeter/lib/ext/jmeter-plugins-manager-1.3.jar
    java -cp ~/jmeter/lib/ext/jmeter-plugins-manager-1.3.jar org.jmeterplugins.repository.PluginManagerCMDInstaller
    ~/jmeter/bin/PluginsManagerCMD.sh install jpgc-standard
    sed -i '533s/#jmeter.save/jmeter.save/' ~/jmeter/bin/jmeter.properties
    LANG=C ~/jmeter/bin/create-rmi-keystore.sh
    sudo cp ~/rmi_keystore.jks /
    ~/jmeter/bin/jmeter -v
}

install_jmeter_service()
{
    sudo echo /home/centos/jmeter/bin/jmeter-server & >> /etc/rc.d/rc.local
    sudo chmod +x /etc/rc.d/rc.local
    sudo awk 'NR==16{print "LimitNOFILE=20480}1' /usr/lib/systemd/system/rc-local.service
    sudo echo * soft nofile 20480 >> /etc/security/limits.conf
    sudo echo * hard nofile 20480 >> /etc/security/limits.conf
    sudo echo net.ipv4.tcp_tw_reuse=1 >> /etc/sysctl.conf
    sudo echo net.ipv4.tcp_fin_timeout=5 >>/etc/sysctl.conf
    sudo sysctl -p
    ps -ax | grep jmeter
}
install_java
install_jmeter
install_jmeter_service