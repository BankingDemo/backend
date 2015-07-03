# BankingApplication
A generic banking backend, REST interfaces using Apache Camel

#DB Schema (See src/main/resources/import.sql)
Table: Customer 
Columns: Id, FirstName, Surname, Address, Email, Username

Table: Account 
Columns: Id, CustomerId, Amount (Balance)

Table: Transactions 
Columns: Id, FromId, ToId, Amount, Payee, Details, TxDate

#REST
* createCustomer
** POST: http://localhost:8080/createcustomer / { "firstname":"joe", "surname":"bloggs", "address":"2 some road" }

* getCustomer
** GET: http://localhost:8080/getcustomer?username=joe

* getCustomers
** GET: http://localhost:8080/getcustomers

* depositMoney
** POST: http://localhost:8080/depositmoney / { fromId:1, payee:"10-223", "amount":50, "operation": "-" }
*** curl -H "Content-Type: application/json" -X POST -d '{"fromId":"-1", "toId":"2", "amount":"250", "payee":"Employer Cash Bonus"}' http://localhost:8080/depositmoney

* withdrawMoney
** POST: http://localhost:8080/withdrawmoney / { fromId:1, toId=99, payee:"Pret a Manger", "amount":3.5,  }
*** curl -H "Content-Type: application/json" -X POST -d '{"fromId":"2", "toId":"-1", "amount":"50", "payee":"ATM, Regent Street"}' http://localhost:8080/withdrawmoney

* getCurrentBalance
** GET: http://localhost:8080/getcurrentbalance?id=1

* transferMoney
** POST: http://localhost:8080/transfermoney / { "fromId":1, "toId":2, payee="Acct 10 20 30", amount:100 }

* getTransactions
** GET: http://localhost:8080/gettransactions?id=10
