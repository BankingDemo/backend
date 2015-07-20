# BankingDemo / backend
REST interfaces implementing using JBoss Fuse 6.2 (Apache Camel).

# Database schema
(See src/main/resources/import.sql)

## Table: customer
Columns: id, firstname, surname, address, email, username, balance

## Table: transactions
Columns: id, fromid, payee, amount, details, txdate

# REST API

## getCustomer
POST /getCustomer?username=\<username\>

## updateCustomer
POST /updateCustomer?id=\<id\> / { "firstname": "Joe", "surname": "Bloggs", "address": "London", "email": "joe@bloggs.com" }
```
curl -H "Content-Type: application/json" -X POST -d '{ "firstname": "Joe", "surname": "Bloggs", "address": "London", "email": "joe@bloggs.com" }' http://localhost:8080/updateCustomer?id=1
```

## getCurrentBalance
GET /getCurrentBalance?id=\<id\>

## getTransactions
GET /getTransactions?id=\<id\>

## transferMoney
POST /transferMoney / { "fromid": 1, "payee": 2, "amount": 10 }
```
curl -H "Content-Type: application/json" -X POST -d '{ "fromid": 1, "payee": 2, "amount": 10 }' http://localhost:8080/transferMoney
```
