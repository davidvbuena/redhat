# HTTPD -> JWS

## OnBoarding Tasks

---

</br>

### mod_proxy

</br>

| OS Version | Product | Result |
|----------|:-------------:|------:|
| RHEL7.9 | - [x] jbcs-httpd24-httpd-2.4.6-RHEL7-x86_64.zip \[ Not Working \] </br>  httpd24 \[ Not Working \]   </br> httpd \[ Testing \]   </br> | Testing

</br>

:::mermaid
graph LR;

      A[Apache HTTPD] --> | mod_proxy | B(HTTP listener, Reverse Proxy) -->|http://localhost:8080| I(JBoss Web Server 5.6)
      A[Apache HTTPD] --> | mod_proxy | C(HTTPS listener) -->|http://localhost:9080| J(JBoss Web Server 5.6)     
:::
