# OnBoarding Tasks (HTTPD -> JWS)

## mod_proxy

###

| OS Version | Product | Result |
|----------|:-------------:|------:|
| RHEL7.9 | [X] jbcs-httpd24-httpd-2.4.6-RHEL7-x86_64.zip \[Not Working \]</br> httpd24 \[Not Working \]</br> httpd \[Testing \]</br> | Testing
||||

</br>



[Apache HTTPD http://locahost:80] --> | mod_proxy | --> (JWS 5.6 | HTTP listener http://localhost:8080)

[Apache HTTPD https://locahost:443] --> | mod_proxy | --> (JWS 5.6 | HTTP listener http://localhost:8080)

[Apache HTTPD https://locahost:443] --> | mod_proxy | --> (JWS 5.6 | HTTPS listener https://localhost:8443)