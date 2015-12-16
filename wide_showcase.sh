--Create Database
use ws
--To check your currently selected database use the command db
db
--If you want to check your databases list, then use the command show dbs.
show dbs

--INSERT. status: "A" = AUTO_INCREMENT
--Date datatype:
-- Z = +00 - UTC формат
-- +03 - Russia, Moscow
db.addr.insert({
    _id: "userid",
    "name": "Yury",
    "sex": "M",
    "age": 36,
    "addr": [
        {"location": "Москва", "street": "новая", "date_from": ISODate("2014-02-10T10:50:42.389+03"), "date_to": ISODate("2015-02-01T09:15:15.149+03")}
    ]
})

--db.order.aggregate({$project:{date:{$dateToString:{format:"%Y-%m-%d",date:"$CreatedDate"}}}})
--{ "_id" : ObjectId("54de670484fec29e87965927"), "date" : "2015-01-18" }

db.addr.find()
db.addr.find({},{_id: 0, name: 1, "addr.date_from": 1})
--$slice = TOP
db.addr.find({},{_id: 0, name: 1, "addr": { $slice: 5 }})
db.addr.aggregate({$project: {_id: 0, name: 1, "addr.date_from": 1}})
db.addr.aggregate({$project: {_id: 0, name: 1, addr: {date_from.$: 1}}})

db.addr.find({
{ "$elemMatch" : { "addr.date_from": { $gte: ISODate("2014-02-10T10:50:42.389+03")} } }
}
,{_id: 0, name: 1, "addr.date_from": 1})

db.addr.find(
{addr: { "$elemMatch" : { location: "Москва" } }}
,{_id: 0, name: 1, "addr.date_from": 1}
)

db.addr.find(
{addr: { "$elemMatch" : { date_from: { $gte: ISODate("2014-02-10+03")} } }}
,{_id: 0, name: 1, "addr.date_from": 1}
)
