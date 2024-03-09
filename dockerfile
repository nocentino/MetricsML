FROM ubuntu:22.04 

# copy in supervisord configuration file TODO: CHANGE TO NON ROOT
COPY ./supervisord.conf /usr/local/etc/supervisord.conf


# Create file layout for SQL and set permissions
RUN useradd -M -s /bin/bash -u 10001 -g 0 mssql
RUN mkdir -p -m 770 /var/opt/mssql/security/ca-certificates && chgrp -R 0 /var/opt/mssql/security/ca-certificates


# Installing system utilities
RUN apt-get update && \
    apt-get install -y supervisor apt-transport-https curl gnupg2 python3 libpython3.10 python3-pip libssl-dev locales && \
    pip install dill numpy==1.22.0 pandas patsy python-dateutil scikit-learn scipy matplotlib prophet==1.1.4 && \
    pip install https://aka.ms/sqlml/python3.10/linux/revoscalepy-10.0.1-py3-none-any.whl --target=/usr/lib/python3.10/dist-packages && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/22.04/mssql-server-2022.list  > /etc/apt/sources.list.d/msprod.list 


# Installing SQL Server drivers and tools
ARG DEBIAN_FRONTEND=noninteractive 
ENV TZ=Etc/UTC 
RUN apt-get update && \
    apt-get install -y mssql-server-extensibility  && \
    /opt/mssql/bin/mssql-conf set extensibility pythonbinpath /usr/bin/python3.10 && \
    /opt/mssql/bin/mssql-conf set extensibility datadirectories /usr/lib:/usr/lib/python3.10/dist-packages && \
    apt-get clean && \
    rm -rf /var/apt/cache/* /tmp/* /var/tmp/* /var/lib/apt/lists


# set/fix directory permissions and create default directories and locale-gen
RUN chown -R root:root /opt/mssql/bin/launchpadd && \
    chown -R root:root /opt/mssql/bin/setnetbr && \
    chmod +x /opt/mssql/bin/launchpadd && \
    chmod +x /opt/mssql/bin/setnetbr && \
    mkdir -p /var/opt/mssql-extensibility/data && \
    mkdir -p /var/opt/mssql-extensibility/log && \
    locale-gen en_US.UTF-8


#TODO FIND OUT WHO THIS SHOULD RUN AS
CMD /usr/bin/supervisord -n -c /usr/local/etc/supervisord.conf