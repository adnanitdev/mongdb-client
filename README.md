kubectl  cp -n <ns> mongo-dump:/dump ./dump

kubectl cp ./dump mongo-restore:/dump -n <ns>

kubectl  exec -it mongo-restore  -n <ns> --   mongorestore -v --uri="mongodb://<user>:<password>@<host>:27017/?socketTimeoutMS=300000&connectTimeoutMS=300000"   --drop /dump   --batchSize=100   --numInsertionWorkersPerCollection=4   --maintainInsertionOrder
