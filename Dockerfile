FROM tomcat:10.1-jdk17-openjdk-slim
WORKDIR /usr/local/tomcat/webapps
COPY target/WebApp.war .
RUN rm -rf ROOT && mv WebApp.war ROOT.war
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:8080/ || exit 1
ENTRYPOINT ["catalina.sh","run"]
