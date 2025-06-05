#!bin/bash

cat > index.html <<EOF
<h1>"Hello World"</h1>
<h1>DB address: ${db_address}</h1>
<h1>DB port: ${db_port}</h1>
EOF

nohup busybox httpd -f -p ${server_port} &