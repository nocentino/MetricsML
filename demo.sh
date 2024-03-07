docker run -it  --platform=linux/amd64  ubuntu:22.04 bash 

docker build -t mssql-server-mlservices . --platform=linux/amd64


docker run \
    --env 'ACCEPT_EULA=Y' \
    --env 'ACCEPT_EULA_ML=Y' \
    --env 'MSSQL_SA_PASSWORD=S0methingS@Str0ng!' \
    --name 'sql1' \
    --publish 1433:1433 \
    --detach mssql-server-mlservices   

docker stop sql1

docker start sql1

docker rm -f sql1

EXEC sp_configure 'external scripts enabled', 1;
GO
RECONFIGURE
GO

EXEC sp_execute_external_script @script=N'import sys;print(sys.version)',@language=N'Python';
GO
