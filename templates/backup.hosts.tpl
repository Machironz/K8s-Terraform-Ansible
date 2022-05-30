[master_hosts]
%{ for ip in masters ~}
${ip}
%{ endfor ~}
[worker_hosts]
%{ for ip in workers ~}
${ip}
%{ endfor ~}
[ha_host]
%{ for ip in ha ~}
${ip}
%{ endfor ~}
