cd C:\jenkins
java -jar agent.jar -url https://sw4jenkins01.dvms.local:8080/ -secret @secret-file -name WindowsNode2 -workDir "C:\Jenkins" -noCertificateCheck -webSocket