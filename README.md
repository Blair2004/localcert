# Local Cert
this bash script will help generating certificate for virtual domain. If you plan to use Docker with a virutal domain, you might need to create
certificate that you'll later add on Trusted Root Certificate Authority (Windows certmgr.msc).

# How It Works
You just simply have to make this file executable using `chmod +x`. Make sure to store it to a path like `/usr/local/bin/localcert` (you might change the name to what you want).
Note that the file will generate certificate a the pwd (Working Directory). Therefore, you'll consider moving those certificate to a directory where you store your certificates.
