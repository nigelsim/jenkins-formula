include:
  - nginx
{% if grains['os'] == 'RedHat' or grains['os'] == 'Fedora' or grains['os'] == 'CentOS'%}

/etc/nginx/conf.d/jenkins.conf:
  file:
    - managed
    - template: jinja
    - source: salt://jenkins/files/nginx.conf
    - user: nginx
    - group: nginx
    - mode: 440
    - require:
      - pkg: jenkins

extend:
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/jenkins.conf
{% else %}
/etc/nginx/sites-available/jenkins.conf:
  file:
    - managed
    - template: jinja
    - source: salt://jenkins/files/nginx.conf
    - user: www-data
    - group: www-data
    - mode: 440
    - require:
      - pkg: jenkins

/etc/nginx/sites-enabled/jenkins.conf:
  file.symlink:
    - target: /etc/nginx/sites-available/jenkins.conf
    - user: www-data
    - group: www-data

extend:    
  nginx:
    service:
      - watch:
        - file: /etc/nginx/sites-available/jenkins.conf
{% endif %}
