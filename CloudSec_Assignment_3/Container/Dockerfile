FROM php:7.3-apache

COPY Hello.html /var/www/html/index.html

EXPOSE 80
RUN echo 'apache2ctl start && /bin/sh' > /s.sh
RUN chmod +x /s.sh
CMD ["/bin/sh", "/s.sh"]
