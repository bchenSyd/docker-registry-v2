#syd-linux-01:443/onboarding is pushed by bamboo during build
FROM syd-linux-01:443/onboarding
#now we need to replace the configuration to a environemtn specific one
RUN  rm -rf /public/config_env.json
COPY ./config_env.json  /public/
#keep the bootstrap command the same
CMD ["nginx","-g","daemon off;"]



